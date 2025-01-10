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
        pkgs = (
          import nixpkgs {
            inherit system;
            config.permittedInsecurePackages = [
              "openssl-1.1.1w"
            ];
          }
        );
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            # In case the target version of ruby is available in nixpkgs,
            # you should use the latest version.
            # pkgs.ruby_3_4

            # Depend on the version of nixpkgs, the following may also be available.
            # pkgs.ruby_3_3
            # pkgs.ruby_3_2
            # pkgs.ruby_3_1

            # In case the target version is too old, you have to build it yourselves.
            (
              let
                rubyVersion = pkgs.mkRubyVersion "3" "0" "7" "";
                ruby = pkgs.mkRuby {
                  version = rubyVersion;
                  # nix store prefetch-file https://cache.ruby-lang.org/pub/ruby/3.0/ruby-3.0.7.tar.gz
                  hash = "sha256-KjQRl38oUEMRNrD6uK1Trwn7dN8u4vT7fxGzeP4DQ4g=";
                };
              in
              (ruby.override {
                # openssl 1 requires permittedInsecurePackages.
                openssl = pkgs.openssl_1_1;
                yjitSupport = false;
              }).overrideAttrs
                (prev: {
                  patches = (prev.patches or [ ]) ++ [
                    # https://bugs.ruby-lang.org/issues/20760
                    (pkgs.fetchurl {
                      url = "https://github.com/ruby/ruby/commit/1dfe75b0beb7171b8154ff0856d5149be0207724.patch";
                      hash = "sha256-1sWbV9SumPTeul7+kCiPzsdkQI4KeGd13xEIysH+nnM=";
                    })
                  ];
                })
            )
          ];
        };
      }
    );
}
