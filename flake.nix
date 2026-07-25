{
  description = "Flake FHS Documentation Site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #flake-fhs.url = "github:luochen1990/flake-fhs";
    flake-fhs.url = "git+file:/home/lc/ws/flake-fhs?ref=master&shallow=1";
    flake-fhs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-fhs.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      layout.roots = [ "nix/" ];
    };
}
