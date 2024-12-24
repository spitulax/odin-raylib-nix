<h1 align="center">Odin Raylib Template for Nix</h1>

Easily setup your Odin raylib projects using Nix flake.

## Usage

1. Modify `description` in [`flake.nix`](./flake.nix)
2. Replace all occurences of `foobar` with your project name
3. Build with `nix build` or enter devshell with `nix develop`

- `make debug` builds the program with debug info
- `make release` builds the program with optimisation
- To modify the program version, change [`VERSION`](./VERSION)
- To add more packages, see [`nix/overlays.nix`](./nix/overlays.nix)
