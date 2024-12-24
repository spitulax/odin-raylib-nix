{ stdenv
, lib
, odin
, libX11
, libGL
, raylib

, debug ? false
}:
let
  version = lib.trim (lib.readFile ../VERSION);
in
stdenv.mkDerivation {
  pname = "foobar";
  inherit version;
  src = lib.cleanSource ./..;

  nativeBuildInputs = [
    odin
  ];

  buildInputs = [
    libX11
    libGL
    raylib
  ];

  makeFlags = [
    (if debug then "debug" else "release")
  ];

  installFlags = [
    "install"
    "PREFIX=$(out)"
  ];
}
