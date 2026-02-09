{
  description = "Flake FHS Documentation Site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-fhs.url = "github:luochen1990/flake-fhs";
    flake-fhs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-fhs.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      layout.roots = [ "nix/" ];
    };
}
