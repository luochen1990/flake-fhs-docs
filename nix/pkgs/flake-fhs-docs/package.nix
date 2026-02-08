{
  lib,
  stdenv,
  nodejs_20,
  pnpm_9,
  python3,
}:

let
  version = "0.0.1";
in
stdenv.mkDerivation {
  pname = "flake-fhs-docs";
  inherit version;

  # Use full source path - don't filter anything, let Nix handle it
  src = ./.;

  nativeBuildInputs = [
    nodejs_20
    pnpm_9
    python3
  ];

  buildInputs = [ nodejs_20 ];

  env = {
    PYTHON = "${python3}/bin/python";
    NODE_ENV = "production";
    # Ensure pnpm can install without network
    CI = "true";
  };

  buildPhase = ''
    runHook preBuild

    echo "=== Build starting ==="
    echo "Current directory: $(pwd)"
    echo "Contents:"
    ls -la
    echo "===================="

    # Create pnpm config to disable network requests
    cat > .npmrc <<'EOF'
    fetch-retries=5
    fetch-timeout=60000
    EOF

    # Set HOME for pnpm
    export HOME=$TMPDIR
    mkdir -p $HOME/.local/share/pnpm/store/v3

    # Install dependencies with frozen lockfile
    pnpm install --frozen-lockfile --no-verify-ssl

    # Build the project
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
