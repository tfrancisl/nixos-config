{
  lib,
  writeShellApplication,
  nix,
  rom,
}:
# `nix` front-end that renders build progress with ROM when a human is watching.
# Calls the real nix by store path (ROM itself shells out to `nix` on PATH, so
# it must never be the one wrapping it), and pipes internal-json into
# `rom --json` so arbitrary flags keep working and stdout/exit codes survive.
writeShellApplication {
  name = "nix";
  text = ''
    real=${lib.getExe' nix "nix"}
    rom=${lib.getExe rom}

    passthrough() { exec "$real" "$@"; }

    # monitor <nix args...>: run nix with its log stream rendered by ROM
    # nix stdout goes straight to the original stdout (fd 3), stderr to ROM, and
    # ROM draws on stderr; its own failure trace is dropped since nix already
    # reported the error through the stream
    monitor() {
      local rc
      exec 3>&1
      set +e
      "$real" -v --log-format internal-json "$@" 2>&1 1>&3 3>&- | "$rom" --json >&2 2>/dev/null
      rc=''${PIPESTATUS[0]}
      set -e
      exec 3>&-
      return "$rc"
    }

    # scripts, pipes and editors keep raw nix output; NIX_NO_ROM=1 opts out
    [ -t 2 ] || passthrough "$@"
    [ -z "''${NIX_NO_ROM:-}" ] || passthrough "$@"

    for arg in "$@"; do
      case $arg in
        --log-format | --log-format=* | --help | -h | --version) passthrough "$@" ;;
      esac
    done

    # first two positionals (subcommand, sub-subcommand), skipping the values of
    # global flags like `--extra-experimental-features "nix-command flakes"`
    sub="" sub2="" skip=0
    for arg in "$@"; do
      if [ "$skip" -gt 0 ]; then
        skip=$((skip - 1))
        continue
      fi
      case $arg in
        --*=*) ;;
        --option) skip=2 ;;
        --extra-* | --experimental-features | --max-jobs | -j | --cores | --store | --eval-store | --system | --substituters | --builders) skip=1 ;;
        -*) ;;
        *)
          if [ -z "$sub" ]; then
            sub=$arg
          else
            sub2=$arg
            break
          fi
          ;;
      esac
    done

    case $sub in
      build | print-dev-env)
        monitor "$@"
        exit
        ;;
      flake)
        case $sub2 in
          check | update | lock | archive | prefetch)
            monitor "$@"
            exit
            ;;
        esac
        ;;
      develop | shell)
        # a user-supplied command swallows trailing args, so we can't append ours
        for arg in "$@"; do
          case $arg in
            --command | -c | --run | --) passthrough "$@" ;;
          esac
        done
        # monitored build pass, then the real interactive session off a warm cache
        monitor "$@" --command true || exit
        ;;
    esac

    passthrough "$@"
  '';
}
