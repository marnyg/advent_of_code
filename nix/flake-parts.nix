{ ... }:
{

  perSystem =
    {
      # config,
      # self',
      # inputs',
      pkgs,
      # system,
      ...
    }:
    {

      treefmt = {
        package = pkgs.treefmt2;
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.yamlfmt.enable = true;
      };
    };
}
