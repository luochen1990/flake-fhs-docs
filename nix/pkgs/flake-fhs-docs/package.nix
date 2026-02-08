{
  lib,
  stdenv,
  nodejs_20,
  python3,
  pnpm,
}:

let
  version = "0.0.1";
in
stdenv.mkDerivation {
  pname = "flake-fhs-docs";
  inherit version;

  src = ./.;

  nativeBuildInputs = [
    nodejs_20
    pnpm
    python3
  ];

  buildInputs = [ nodejs_20 ];

  env = {
    PYTHON = "${python3}/bin/python";
    NODE_ENV = "production";
    CI = "true";
  };

  buildPhase = ''
    runHook preBuild

    echo "=== Build starting ==="

    # Setup HOME
    export HOME=$TMPDIR

    # Configure pnpm
    pnpm config set manage-package-manager-versions false
    pnpm config set side-effects-cache false

    # Install dependencies with frozen lockfile
    pnpm install --frozen-lockfile --force --ignore-scripts

    # Build project
    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/www

    # Copy built files
    if [ -d dist ]; then
      echo "Copying dist/ to $out/share/www/"
      cp -r dist/* $out/share/www/
    else
      echo "ERROR: dist/ directory not found"
      exit 1
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Official documentation site for Flake FHS framework";
    homepage = "https://github.com/luochen1990/flake-fhs";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
