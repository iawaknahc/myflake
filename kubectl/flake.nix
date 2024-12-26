{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-util.url = "github:numtide/flake-utils";
  };
  outputs =
    { nixpkgs, flake-util, ... }:
    flake-util.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        kubectl = pkgs.kubectl.overrideAttrs rec {
          version = "1.31.0";
          src = pkgs.fetchFromGitHub {
            owner = "kubernetes";
            repo = "kubernetes";
            rev = "v${version}";
            hash = "sha256-Oy638nIuz2xWVvMGWHUeI4T7eycXIfT+XHp0U7h8G9w=";
          };
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [ kubectl ];
        };
      }
    );
}
