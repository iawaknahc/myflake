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
        kubectl = pkgs.kubectl.overrideAttrs rec {
          version = "1.31.0";
          src = pkgs.fetchFromGitHub {
            owner = "kubernetes";
            repo = "kubernetes";
            rev = "v${version}";
            hash = "sha256-Oy638nIuz2xWVvMGWHUeI4T7eycXIfT+XHp0U7h8G9w=";
          };
        };
      in {
        default = pkgs.mkShellNoCC {
          packages = [kubectl];
        };
      }
    );
  };
}
