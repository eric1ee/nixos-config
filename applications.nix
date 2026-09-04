# applications modules
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # unstable software
    flclash unstable.gopeed

    # stable software
    vim protonplus git keepassxc wget  vlc ffmpeg-full  unrar nil fastfetch appimage-run
    xwayland-satellite  wf-recorder zenity# 使用niri需要
    kdePackages.skanpage gimp
    (tesseract.override { enableLanguages = [ "chi_sim" "eng" ]; })
    (kdePackages.spectacle.override {
      tesseractLanguages = [ "all" ];  # 或 null
      })
    ];

  services.sunshine = {
    enable = true;
    openFirewall = true;
    autoStart = false;
  };

}
