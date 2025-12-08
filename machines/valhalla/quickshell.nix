{pkgs, ...}: {
  environment.systemPackages = with pkgs; [quickshell kdePackages.qtdeclarative];
}
