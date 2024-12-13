{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{

  perSystem =
    {
      config,
      self',
      inputs',
      pkgs,
      system,
      ...
    }:
    {

      devenv.shells.default = {
        devenv.root =
          let
            devenvRootFileContent = builtins.readFile inputs.devenv-root.outPath;
          in
          pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

        name = "my-project";

        # imports = [ ./nix/devenv-scripts.nix ];

        # https://devenv.sh/reference/options/
        packages = [
          config.packages.default
          config.treefmt.build.wrapper
          pkgs.ocamlPackages.core
          pkgs.ocamlPackages.base
        ];
        # buildInputs = [ pkgs.ocamlPackages.core ];

        env.GREET = "hello";
        enterShell = ''
          hello
        '';

        languages.ocaml.enable = true;
        languages.ocaml.packages = pkgs.ocaml-ng.ocamlPackages_5_2 // {
          dune_3 = self'.packages.dune_3_17;
          ocaml-lsp = pkgs.ocamlPackages.ocaml-lsp;
          utop = pkgs.ocamlPackages.utop.overrideAttrs (oldAttrs: {
            propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
              pkgs.ocamlPackages.core
              pkgs.ocamlPackages.base
            ];
          });
        };
        difftastic.enable = true;
        git-hooks.hooks.commitizen.enable = true;
        git-hooks.hooks.treefmt.enable = true;
        git-hooks.hooks.treefmt.package = config.treefmt.build.wrapper;

      };
    };
}
