# Use the following command to get the hash.
# nix store prefetch-file https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tar.xz
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
  outputs = { self, nixpkgs }:
  let
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  in {
    devShells = nixpkgs.lib.attrsets.genAttrs systems (system:
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
      in {
        default = pkgs.mkShellNoCC {
          packages = [python];
        };
      }
    );
  };
}
