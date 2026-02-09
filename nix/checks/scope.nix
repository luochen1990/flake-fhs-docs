{
  pkgs,
  self,
  lib,
  system,
  ...
}:
{
  scope = lib.mkScope (
    pkgs
    // {
      inherit self lib system;
      pkgs = self.packages.${system};
    }
  );
}
