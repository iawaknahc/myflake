# Use the following command to get the hash.
# nix store prefetch-file https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tar.xz
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
        python = pkgs.python3.override {
          sourceVersion = {
            major = "3";
            minor = "10";
            patch = "0";
            suffix = "";
          };
          hash = "sha256-Wpn456ahGnuYtOdeDRMD04MsraVTQGj2nHtiIqexsAI=";
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [ python ];
        };
      }
    );
}
