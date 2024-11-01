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
        go = pkgs.go_1_22.overrideAttrs {
          version = "1.22.0";
          src = pkgs.fetchurl {
            url = "https://go.dev/dl/go1.22.0.src.tar.gz";
            hash = "sha256-TRlsPUGg1sHfxk0E48wfYIsMQ2vYe3Bgzj4jI04fTVw=";
          };
        };
      in {
        default = pkgs.mkShellNoCC {
          packages = [go];
        };
      }
    );
  };
}
