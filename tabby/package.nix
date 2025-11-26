{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, makeWrapper
, atk
, at-spi2-atk
, cups
, libdrm
, gtk3
, pango
, cairo
, libX11
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXrandr
, libgbm
, expat
, libxcb
, alsa-lib
, nss
, nspr
, udev
, libGL
, libsecret
, vulkan-loader
}:

stdenv.mkDerivation rec {
  pname = "tabby";
  version = "1.0.229";

  src = fetchurl {
    url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.deb";
    hash = "sha256-ZBS2hgsc8IRV4MWEoRYEmNFHHCzuYtYPWsms6Kya6Ys=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    atk
    at-spi2-atk
    cups
    libdrm
    gtk3
    pango
    cairo
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libgbm
    expat
    libxcb
    alsa-lib
    nss
    nspr
    libsecret
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/app
    cp -r opt/Tabby $out/app/tabby
    cp -r usr/share $out/share

    substituteInPlace $out/share/applications/tabby.desktop \
      --replace-fail "/opt/Tabby/tabby" "$out/bin/tabby"

    ln -s $out/app/tabby/tabby $out/bin/tabby

    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libGL.so.1 \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          udev
          libsecret
          vulkan-loader
        ]
      } $out/app/tabby/tabby
  '';

  postFixup = ''
    wrapProgram $out/bin/tabby \
      --run "rm -rf ~/.config/tabby/GPUCache" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libsecret libGL vulkan-loader ]}" \
      --add-flags "--no-sandbox --disable-gpu-compositing --disable-gpu"
  '';

  meta = with lib; {
    description = "A terminal for a more modern age";
    homepage = "https://tabby.sh";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    mainProgram = "tabby";
  };
}
