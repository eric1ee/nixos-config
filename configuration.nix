# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "clearcpuid=514" ]; # 关闭umip功能
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://192.168.8.115:7890/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;  # 让系统能解析 .local 域名
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";


  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-rime
      qt6Packages.fcitx5-configtool
      fcitx5-lua
    ];
    fcitx5.waylandFrontend = true;
  };
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };



  fonts = {
    # 1. 安装系统中其他的常用字体
    packages = with pkgs; [
      # Nerd Font - Arimo
      nerd-fonts.arimo

      # 中文字体 - 霞鹜文楷 (美观的开源字体)
      lxgw-wenkai
      wqy_zenhei

      # 英文字体 - Liberation 系列 (可靠的系统字体)
      liberation_ttf
    ];

    # 2. 配置字体回退顺序
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Arimo" "wqy_zenhei" ];
        serif = [ "Liberation Serif" "wqy_zenhei" ];
        monospace = [ "Arimo" "wqy_zenhei" ];
      };

      # 3. 如果你想把方正字体也纳入系统的回退列表，可以在这里添加
      # 这里的 "方正小标宋_GBK" 需要和你字体文件里的实际名称完全一致
      # defaultFonts.sansSerif = [ "Arimo" "LXGW WenKai" "方正小标宋_GBK" ];
    };
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.sunshine = {
    enable = true;
    openFirewall = true;
    autoStart = true;
  };
  services.tailscale.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #enable onedrive
  services.onedrive = {
    enable = true;
    package = pkgs.unstable.onedrive;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.flatpak.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."kang" = {
    isNormalUser = true;
    description = "kang";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs = {
    steam = {
      enable = true;
      protontricks.enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          LD_AUDIT = "${
            inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam}/library-inject.so:${inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam}/SLSsteam.so";
      };
        };
    };
    fish = {
    enable = true;
    shellInit = ''
      set -g fish_greeting "欢迎您回来，康康大人！！！!"
      '';
    };
};
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # 开启flake特性
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  # 设置中国源 中科大排第一
  nix.settings.substituters = lib.mkForce [ "https://mirrors.ustc.edu.cn/nix-channels/store" "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" "https://mirrors.nju.edu.cn/nix-channels/store" "https://cache.nixos.org"];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # unstable software
  unstable.flclash

  # stable software microsoft-edge
  vim protonplus git keepassxc wget sing-box  fcitx5-mellow-themes vlc ffmpeg-full papirus-icon-theme unrar blender libreoffice-fresh vscode gopeed nil ghostty fastfetch
xwayland-satellite  wf-recorder zenity# 使用niri需要
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
