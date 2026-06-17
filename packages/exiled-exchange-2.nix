{
  lib,
  fetchurl,
  stdenv,
  appimageTools,
  makeWrapper,
  electron,
  libxtst,
  libxt,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exiled-exchange-2";
  version = "0.15.5";
  src = fetchurl {
    url = "https://github.com/Kvan7/exiled-exchange-2/releases/download/v${finalAttrs.version}/Exiled-Exchange-2-${finalAttrs.version}.AppImage";
    hash = "sha256-Wt9I56yHLQ5XDnlo+OMdzTxfqq7/rkq4BGG9bxEbzOY=";
  };

  passthru = {
    appImageContents = appimageTools.extractType2 {
      inherit (finalAttrs) pname src version;
    };

    updateScript = nix-update-script { };
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/exiled-exchange-2 $out/share/applications

    cp -a ${finalAttrs.passthru.appImageContents}/{locales,resources} $out/share/exiled-exchange-2

    echo "
    [Desktop Entry]
    Name=Exiled Exchange 2
    Exec=exiled-exchange-2 --sandbox %U --ozone-platform=x11
    Terminal=false
    Type=Application
    Icon=exiled-exchange-2
    StartupWMClass=Exiled Exchange 2
    X-AppImage-Version=0.15.5
    Categories=Utility;
    " > $out/share/applications/exiled-exchange-2.desktop


    cp -a ${finalAttrs.passthru.appImageContents}/usr/share/icons $out/share


    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/exiled-exchange-2 \
    --add-flags $out/share/exiled-exchange-2/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxtst
          libxt
        ]
      }"
  '';

  meta = {
    description = "Path of Exile trading app for price checking";
    homepage = "https://github.com/SnosMe/exiled-exchange-2";
    changelog = "https://github.com/SnosMe/exiled-exchange-2/releases/tag/v${finalAttrs.version}";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
    mainProgram = "awakened-poe-trade";
  };
})
