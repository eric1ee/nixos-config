# /etc/nixos/ftp-scanner.nix
{ config, pkgs, ... }:

{
  services.vsftpd = {
    enable = true;
    writeEnable = true;
    extraConfig = ''
      # 允许匿名登录
      anonymous_enable=YES
      # 允许匿名用户上传文件
      anon_upload_enable=YES
      # 允许匿名用户创建目录
      anon_mkdir_write_enable=YES
      # 设置匿名用户根目录
      anon_root=/home/kang/ftp
      # 设定上传文件的权限掩码
      anon_umask=022
      # 不允许本地用户登录
      local_enable=NO
      # 指定匿名用户映射为 kang
      ftp_username=kang
      # 设置 vsftpd 以 kang 用户身份运行
      nopriv_user=kang
      # 允许匿名用户不输入密码直接登录
      no_anon_password=YES
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 21 ];
    allowedTCPPortRanges = [ { from = 40000; to = 40100; } ];
  };
}
