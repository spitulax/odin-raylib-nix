{ self, lib, inputs }: {
  default = final: prev: {
    # Add packages here
    foobar = final.callPackage ./default.nix { };
    foobar-debug = final.callPackage ./default.nix { debug = true; };
  };

  deps = final: prev: {
    # TODO: Wait for https://github.com/odin-lang/Odin/pull/4619 to be merged
    odin = prev.odin.overrideAttrs {
      patches = [
        ./odin.patch
      ];
    };

    # TODO: Wait for https://github.com/NixOS/nixpkgs/pull/357729 to be merged
    raylib = final.callPackage ./raylib.nix { };
  };
}
