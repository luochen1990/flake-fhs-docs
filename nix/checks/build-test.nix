{ runCommand, pkgs, ... }:

runCommand "flake-fhs-docs-build-test" { } ''
  # Simply check that the package exists
  if ! test -e ${pkgs.flake-fhs-docs}; then
    echo "ERROR: flake-fhs-docs package does not exist"
    exit 1
  fi

  echo "Build test passed!"
  touch $out
''
