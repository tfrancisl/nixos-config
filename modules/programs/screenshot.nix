{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [grim slurp wl-clipboard wayfreeze dunst];
    environment.shellAliases = {
      screenshot = pkgs.writeShellScript "screenshot-bin" ''


        fileName="screenshot_$(date '+%Y-%m-%d_%H:%M:%S').png"
        screenshotDir="$HOME/screenshots"
        path="$screenshotDir/$fileName"

        grimCmd="grim -t png -l 3"

        if [ ! -d "$screenshotDir" ]; then
          mkdir -p "$screenshotDir"
        fi


        wayfreeze --hide-cursor &
        PID=$!
        sleep .05
        # don't allow multiple slurps at once
        # nicer colours on slurp too
        pidof slurp || ($grimCmd -g "$(slurp -b '#0a0a0a77' -c '#FFFFFF' -s '#FFFFFF17' -w 2)" "$path" || echo "selection cancelled")
        kill $PID


        if [ -f "$path" ]; then
          dunstify -i "$path" -a "screenshot" "Screenshot" "Copied to clipboard" -r 9998 &
          wl-copy < "$path" # copy to clipboard
          exit 0
        fi

        echo "Screenshot cancelled."
        exit 1
      '';
    };
  };
}
