# Use the following command to get the hash.
# nix store prefetch-file https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.4.tar.gz
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
        rubyVersion = pkgs.mkRubyVersion "3" "3" "4" "";
        ruby =
          (pkgs.mkRuby {
            version = rubyVersion;
            hash = "sha256-/mow+X1U4Cl2jy3fSSNpnEFs28Om6W2z4tVxbH25ajQ=";
          }).override
            {
              yjitSupport = false;
            };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [ ruby ];
        };
      }
    );
}
