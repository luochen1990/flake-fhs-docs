{ pkgs, ... }:

pkgs.runCommand "flake-fhs-docs-build-test" {
  buildCommand = ''
    # Simply check that the package exists
    if ! test -e ${pkgs.flake-fhs-docs}; then
      echo "ERROR: flake-fhs-docs package does not exist"
      exit 1
    fi

    echo "Build test passed!"
    touch $out
  '';

  meta = {
    description = "Test that flake-fhs-docs package exists and is accessible";
  };
}
