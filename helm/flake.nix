# https://github.com/NixOS/nixpkgs/issues/86349
# https://github.com/NixOS/nixpkgs/pull/225051
#
# The bug I observed is a weird error message from go, saying that
# vendor/modules.txt is not consistent with go.mod.
# I verify they are really consistent by downloading helm-3.16.1.zip,
# and run `go mod download` and `go mod vendor`.
# Finally I run `nix --debug develop ./helm`.
# And I notice helm-go-modules-3.15.0 instead of helm-go-modules-3.16.1.
# Hence, in the buggy buildGoModule, src is not overridden in the inner derivation.
#
# "github:nixos/nixpkgs/nixpkgs-24.05-darwin" does not contain the fix yet :(
# See https://github.com/NixOS/nixpkgs/blob/nixpkgs-24.05-darwin/pkgs/build-support/go/module.nix
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
        helm = pkgs.kubernetes-helm.overrideAttrs rec {
          version = "3.16.1";
          src = pkgs.fetchFromGitHub {
            owner = "helm";
            repo = "helm";
            rev = "v${version}";
            hash = "sha256-OTG4xPgK1WT/HUWjQZ1a7X126+PUo02yFnEAnd6MTU8=";
          };
          vendorHash = "sha256-rNp2aah6lAMZd07HXF2w0h7wfPc+TuRHl/jQpgqY5Sk=";
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [ helm ];
        };
      }
    );
}
