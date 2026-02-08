{
  lib,
  pkgs,
  writeShellScriptBin,
}:

writeShellScriptBin "flake-fhs-docs-demo" ''
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Starting Flake FHS Docs Demo VM..."
  echo "The VM will run on port 2222 (SSH) and serve the docs on port 4321"
  echo ""
  echo "To connect to the VM:"
  echo "  ssh -p 2222 demo@localhost"
  echo "  (password: demo)"
  echo ""
  echo "Press Ctrl+C to stop the VM"
  echo ""

  exec ${pkgs.qemu}/bin/qemu-system-x86_64 \
    -m 1024 \
    -smp 2 \
    -nographic \
    -kernel ${pkgs.nixos}/bzImage \
    -initrd ${pkgs.nixos}/initrd \
    -append "console=ttyS0 panic=1" \
    -net nic,model=virtio \
    -net user,hostfwd=tcp::2222-:22,hostfwd=tcp::4321-:4321 \
    -drive file=nixos.qcow2,if=virtio,format=qcow2 \
    $@
''
