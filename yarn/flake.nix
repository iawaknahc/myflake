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
        yarn = pkgs.yarn.overrideAttrs rec {
          version = "1.22.0";
          src = pkgs.fetchzip {
            url = "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
            sha256 = "sha256-nZzkhe+VWmjXuyKxyKxbX/IeyhYGzRhOyLCXjvNqekE=";
          };
        };
      in {
        default = pkgs.mkShellNoCC {
          packages = [yarn];
        };
      }
    );
  };
}
