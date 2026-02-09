{
  lib,
  buildNpmPackage,
}:
buildNpmPackage {
  pname = "flake-fhs-docs";
  version = "0.0.1";

  src = ../../../.;

  npmDepsHash = "sha256-0E2EYEf0sK91KbhFQ2ORFaEeltfuM1JEAoNCn7mr0Kk=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/www
    cp -r dist/* $out/share/www/
    runHook postInstall
  '';

  meta = {
    description = "Official documentation site for Flake FHS framework";
    homepage = "https://github.com/luochen1990/flake-fhs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luochen1990 ];
  };
}
