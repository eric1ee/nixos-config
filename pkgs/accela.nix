{ lib, appimageTools, pkgs, ... }:

appimageTools.wrapType2 {
  pname = "assella";
  version = "latest";

  src = /home/kang/.local/share/ACCELA/ASSella.AppImage;

  extraPkgs = pkgs: with pkgs; [
    zstd
    xcb-util-cursor
    libglvnd
    alsa-lib
    libxkbcommon
    qt6.qtbase
    fuse2
  ];

  # 可选：ACCELA 有 32 位 so，补上
  extraPkgs32 = pkgs: with pkgs; [
    zstd
  ];
}
