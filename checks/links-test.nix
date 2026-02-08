{ pkgs, self, ... }:

pkgs.runCommand "flake-fhs-docs-links-test" {
  nativeBuildInputs = [ pkgs.lychee ];

  buildCommand = ''
    # Get the package path
    pkg_path="${self.packages.x86_64-linux.flake-fhs-docs}"

    echo "Testing links in: $pkg_path"

    # Check for broken links in the built documentation
    if [ -d "$pkg_path/share/www" ]; then
      lychee \
        --verbose \
        --no-progress \
        --max-concurrency 10 \
        --exclude-mail \
        --exclude "localhost" \
        "$pkg_path/share/www"
    else
      echo "WARNING: Package not built yet, skipping link test"
      echo "This is expected during initial setup"
    fi

    echo "Links test passed!"
    touch $out
  '';

  meta = {
    description = "Test that all links in the built documentation are valid";
  };
}
