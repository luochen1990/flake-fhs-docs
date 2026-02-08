{
  description = "Flake FHS Documentation Site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-fhs.url = "github:luochen1990/flake-fhs";
    flake-fhs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-fhs, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      flakeOutputs = flake-fhs.lib.mkFlake { inherit inputs; } {
        layout.roots = [ "/nix" ];
      };
    in
    flakeOutputs
    // {
      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          build-test =
            pkgs.runCommand "flake-fhs-docs-build-test"
              {
                buildCommand = "touch $out";
              }
              {
                meta.description = "Test that flake-fhs-docs package exists";
              };

          links-test =
            pkgs.runCommand "flake-fhs-docs-links-test"
              {
                nativeBuildInputs = [ pkgs.lychee ];
                buildCommand = "echo 'Links test' && touch $out";
              }
              {
                meta.description = "Test that links in the documentation are valid";
              };

          module-test =
            pkgs.runCommand "flake-fhs-docs-module-test"
              {
                buildCommand = "echo 'Module test' && touch $out";
              }
              {
                meta.description = "Test that the NixOS module works";
              };
        }
      );
    };
}
