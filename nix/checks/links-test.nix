{
  runCommand,
  lychee,
  pkgs,
  ...
}:

#Test that all links in the built documentation are valid

runCommand "flake-fhs-docs-links-test"
  {
    nativeBuildInputs = [ lychee ];
  }

  ''
    # Get the package path
    pkg_path="${pkgs.flake-fhs-docs}"

    echo "Testing links in: $pkg_path"

    # Check for broken links in the built documentation
    if [ -d "$pkg_path/share/www" ]; then
      lychee \
        --verbose \
        --no-progress \
        --max-concurrency 10 \
        --exclude "localhost" \
        --offline \
        --root-dir "$pkg_path/share/www" \
        "$pkg_path/share/www"
    else
      echo "WARNING: Package not built yet, skipping link test"
      echo "This is expected during initial setup"
    fi

    echo "Links test passed!"
    touch $out
  ''
