{ pkgs, ... }:
pkgs.mkShell {

  packages = with pkgs; [
    git
    nodejs
    nodePackages.pnpm
  ];

  shellHook = ''
    echo "Flake FHS Docs Environment"
    echo "Run 'pnpm install' to initialize dependencies"
    echo "Run 'pnpm dev' to start the dev server"
  '';
}
