{
  description = "NixOS configuration with two or more channels";

  inputs = {
    nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-26.05&shallow=1";
    nixpkgs-unstable.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
    sls-steam = {
      url = "github:AceSLS/SLSsteam";
      inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs =
    { nixpkgs, nixpkgs-unstable, sls-steam, ... }@inputs:
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable {
                   inherit (final) config;
                   inherit (final.stdenv.hostPlatform) system;
                };
                # kdePackages = final.unstable.kdePackages; #kde最新版本
              })
            ];
          }
          ./configuration.nix
        ];
      };
    };
}
