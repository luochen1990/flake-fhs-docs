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

  src = ../../../.;

  nativeBuildInputs = [
    nodejs_20
    pnpm_9
    python3
  ];

  buildInputs = [ nodejs_20 ];

  env = {
    PYTHON = "${python3}/bin/python";
    NODE_ENV = "production";
  };

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR
    pnpm install --frozen-lockfile
    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/www
    cp -r dist/* $out/share/www/

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
