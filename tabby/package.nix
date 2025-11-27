{ lib
, buildFHSEnv
, fetchurl
, stdenv
, dpkg
}:

let
  version = "1.0.229";
  pname = "tabby";
  
  src = fetchurl {
    url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.deb";
    hash = "sha256-ZBS2hgsc8IRV4MWEoRYEmNFHHCzuYtYPWsms6Kya6Ys=";
  };

  # Распаковываем deb, чтобы достать контент
  tabby-pkg = stdenv.mkDerivation {
    name = "${pname}-pkg-${version}";
    inherit src;
    nativeBuildInputs = [ dpkg ];
    installPhase = ''
      mkdir -p $out
      dpkg -x $src $out
      mv $out/usr/share $out/share
      mv $out/opt/Tabby $out/lib
    '';
  };

in buildFHSEnv {
  name = pname;
  targetPkgs = pkgs: with pkgs; [
    # Базовые либы для Electron
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libnotify
    libsecret
    libuuid
    libxcb
    libxkbcommon
    mesa
    nss
    nspr
    pango
    systemd
    udev
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    # Дополнительно для EGL/Vulkan
    libGL
    libglvnd
    vulkan-loader
    libxshmfence
    # Для node-pty и утилит
    util-linux
  ];

  # Запуск через bash для очистки кэша
  runScript = "bash -c 'rm -rf ~/.config/tabby/GPUCache || true; exec ${tabby-pkg}/lib/tabby --no-sandbox \"$@\"'";

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${tabby-pkg}/share/icons $out/share/icons
    
    mkdir -p $out/share/applications
    cp ${tabby-pkg}/share/applications/tabby.desktop $out/share/applications/tabby.desktop
    chmod +w $out/share/applications/tabby.desktop
    
    # Фиксим .desktop файл
    # Нужно заменить путь к бинарнику и убрать лишние флаги, если есть
    substituteInPlace $out/share/applications/tabby.desktop \
      --replace "/opt/Tabby/tabby" "$out/bin/tabby"
  '';

  meta = with lib; {
    description = "A terminal for a more modern age";
    homepage = "https://tabby.sh";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
