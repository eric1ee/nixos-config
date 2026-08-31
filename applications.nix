# applications modules
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # unstable software
    unstable.flclash unstable.gopeed

    # stable software microsoft-edge
    vim protonplus git keepassxc wget fcitx5-mellow-themes vlc ffmpeg-full papirus-icon-theme unrar blender libreoffice-fresh vscode nil fastfetch appimage-run microsoft-edge
    xwayland-satellite  wf-recorder zenity# 使用niri需要
    kdePackages.skanpage  gimp ];

  services.sunshine = {
    enable = true;
    openFirewall = true;
    autoStart = false;
  };

}
