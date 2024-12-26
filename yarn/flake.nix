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
      in
      {
        devShells.default = pkgs.mkShell {

          packages = [
            # yarn refers to Yarn Classic.
            # Yarn Classic receives no feature updates.
            # So we should always use the latest version (with security patches).
            pkgs.yarn
          ];
        };
      }
    );
}
