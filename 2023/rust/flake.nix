{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?rev=e4ad989506ec7d71f7302cc3067abd82730a4beb";
  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          cargo
          rustc
          rustfmt
          rustPackages.clippy
          rust-analyzer
          curl
        ];
      };
    });
  };
}
