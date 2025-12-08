{pkgs, ...}: {
  environment.systemPackages = with pkgs; [quickshell kdePackages.qtdeclarative];
  environment.sessionVariables = {
    # Makes QtQuick and Quickshell libs available to qmlls
    QMLLS_BUILD_DIRS = "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/";
  };
}
