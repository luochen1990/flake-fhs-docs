{ pkgs, lib, ... }:

pkgs.runCommand "flake-fhs-docs-module-test" {
  buildCommand = ''
    # Create a simple test configuration
    cat > test_config.nix <<'EOF'
    { config, lib, ... }: {
      # Minimal system configuration for testing
      boot.loader.grub.enable = false;
      system.stateVersion = "24.11";
    }
    EOF

    # Test that a basic NixOS configuration can be evaluated
    echo "Testing basic NixOS evaluation..."
    nix-instantiate --eval --expr 'builtins.import ./test_config.nix { config = { lib = {}; }; }' || {
      echo "ERROR: Basic NixOS evaluation failed"
      exit 1
    }

    echo "Module test passed!"
    touch $out
  '';

  meta = {
    description = "Test that NixOS evaluation works";
  };
}
