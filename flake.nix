{
  description = "An Odin Raylib project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Pull Odin compiler from mypkgs
    mypkgs.url = "github:spitulax/mypkgs";
  };

  outputs = { self, nixpkgs, mypkgs, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      # List of supported systems
      systems = [ "x86_64-linux" "aarch64-linux" ];

      eachSystem = f: lib.genAttrs systems f;
      pkgsFor = eachSystem (system:
        import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.deps
            self.overlays.default
          ];
        });
    in
    {
      # Add/modify packages with this overlay
      overlays = import ./nix/overlays.nix { inherit self lib inputs; };

      packages = eachSystem (system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          # This flake's default package
          default = self.packages.${system}.foobar;
          # Expose packages from the overlay to flake
          inherit (pkgs) foobar foobar-debug;
        });

      devShells = eachSystem (system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            name = lib.getName self.packages.${system}.default + "-shell";
            # Default inputs based on the flake's default package
            inputsFrom = [
              self.packages.${system}.default
            ];
          };
        }
      );
    };

  nixConfig = {
    extra-substituters = [
      "spitulax.cachix.org"
    ];
    extra-trusted-public-keys = [
      "spitulax.cachix.org-1:GQRdtUgc9vwHTkfukneFHFXLPOo0G/2lj2nRw66ENmU="
    ];
  };
}
