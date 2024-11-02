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
        # nodejs takes ages to build, life is short too to compile it from source.
        #
        # To install a particular version of nodejs, you need to find a branch that contains the non-EOL version.
        #
        # For example, on nixpkgs-24.05-darwin, nodejs_14 and nodejs_16 exist, but they are just placeholder
        # to tell you they are EOL.
        #
        # On nixpkgs-24.05-darwin, the following packages are available in the binary cache.
        # nodejs_18
        # nodejs_20
        # nodejs_22
      in {
        default = pkgs.mkShellNoCC {
          packages = [pkgs.nodejs_22];
        };
      }
    );
  };
}
