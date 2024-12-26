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
        go = pkgs.go_1_22.overrideAttrs {
          version = "1.22.0";
          src = pkgs.fetchurl {
            url = "https://go.dev/dl/go1.22.0.src.tar.gz";
            hash = "sha256-TRlsPUGg1sHfxk0E48wfYIsMQ2vYe3Bgzj4jI04fTVw=";
          };
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [ go ];
        };
      }
    );
}
