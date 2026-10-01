# Evaluates the shared modules for the work MacBook and lays the result out for
# install.sh: generated files under files/, repo files under repo/, and links.tsv
# mapping each to its target in $HOME.
{
  lib,
  pkgs,
  hjem,
}:
let
  inherit (lib)
    attrValues
    concatMap
    concatMapStrings
    concatStrings
    filter
    hasPrefix
    mapAttrsToList
    removePrefix
    unique
    ;

  repoRoot = toString ../..;

  eval = lib.evalModules {
    specialArgs = {
      inherit pkgs hjem;
      hjem-lib = import "${hjem}/lib.nix" { inherit lib pkgs; };
    };
    modules = [
      ./stub.nix
      ./options.nix
      ../../modules/common/basics.nix
      ../../modules/common/direnv.nix
      ../../modules/common/fish.nix
      ../../modules/common/git.nix
      ../../modules/common/platform.nix
      ../../modules/common/xdg.nix
      ../../modules/common/zed
    ];
  };

  inherit (eval) config;
  user = config.hjem.users.${config.acme.core.username};

  hjemFiles = filter (f: f.enable) (
    concatMap attrValues [
      user.files
      user.xdg.config.files
      user.xdg.data.files
      user.xdg.state.files
      user.xdg.cache.files
    ]
  );

  toEntry =
    f:
    let
      target = removePrefix "${user.directory}/" f.target;
      source = toString f.source;
      fromRepo = hasPrefix "${repoRoot}/" source;
    in
    assert lib.assertMsg (
      f.type == "symlink"
    ) "darwin export only supports symlinked files, but ${target} is '${f.type}'";
    if fromRepo then
      {
        kind = "repo";
        inherit target;
        path = removePrefix "${repoRoot}/" source;
        store = /. + source;
      }
    else
      {
        kind = "gen";
        inherit target;
        path = target;
        store = f.source;
      };

  entries = map toEntry hjemFiles;

  # NixOS sets these through environment.variables and programs.direnv.
  envFish = pkgs.writeText "acme-env.fish" ''
    ${concatStrings (mapAttrsToList (k: v: "set -gx ${k} \"${v}\"\n") config.environment.variables)}
    if command -q direnv
        direnv hook fish | source
    end
  '';

  allEntries = entries ++ [
    {
      kind = "gen";
      target = ".config/fish/conf.d/acme-env.fish";
      path = ".config/fish/conf.d/acme-env.fish";
      store = envFish;
    }
  ];

  brewfile = pkgs.writeText "Brewfile" (
    concatMapStrings (b: "brew \"${b}\"\n") (unique config.acme.brews)
  );
in
pkgs.runCommand "darwin-dots" { } ''
  mkdir -p $out/files $out/repo
  ${concatMapStrings (e: ''
    mkdir -p "$(dirname "$out/${if e.kind == "gen" then "files" else "repo"}/${e.path}")"
    cp -rL ${e.store} "$out/${if e.kind == "gen" then "files" else "repo"}/${e.path}"
    printf '%s\t%s\t%s\n' ${e.kind} "${e.target}" "${e.path}" >> $out/links.tsv
  '') allEntries}
  cp ${brewfile} $out/Brewfile
  install -Dm755 ${./install.sh} $out/install.sh
''
