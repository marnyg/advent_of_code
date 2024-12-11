{
  description = "Description for the project";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs@{ flake-parts, devenv-root, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = pkgs.hello;

        # Custom dune package
        packages.dune_3_17 = pkgs.stdenv.mkDerivation rec {
          pname = "dune";
          version = "3.17.0";

          src = pkgs.fetchurl {
            url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
            hash = "sha256-LDqmxB7Tnj1sGiktdfSAa9gDEIQa/FFnOqWc6cgWUHw=";

          };

          nativeBuildInputs = [ pkgs.ocaml pkgs.ocamlPackages.findlib ];

          buildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
            pkgs.darwin.apple_sdk.frameworks.CoreServices
          ];

          strictDeps = true;

          buildFlags = [ "release" ];

          dontAddPrefix = true;
          dontAddStaticConfigureFlags = true;
          configurePlatforms = [ ];

          installFlags = [ "PREFIX=${placeholder "out"}" "LIBDIR=$(OCAMLFIND_DESTDIR)" ];

          meta = {
            homepage = "https://dune.build/";
            description = "Composable build system for OCaml";
            mainProgram = "dune";
            changelog = "https://github.com/ocaml/dune/raw/${version}/CHANGES.md";
            license = pkgs.lib.licenses.mit;
            platforms = pkgs.ocaml.meta.platforms;
          };
        };

        devenv.shells.default = {
          devenv.root =
            let
              devenvRootFileContent = builtins.readFile devenv-root.outPath;
            in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          name = "my-project";

          imports = [
            # ./nix/devenv-scripts.nix
          ];

          # https://devenv.sh/reference/options/
          packages = [
            config.packages.default
          ];

          env.GREET = "hello";
          enterShell = ''
            h
            hello
          '';

          languages.ocaml.enable = true;
          languages.ocaml.packages = pkgs.ocaml-ng.ocamlPackages_4_12 // { dune_3 = self'.packages.dune_3_17; };
          difftastic.enable = true;
          git-hooks.hooks.commitizen.enable = true;
          git-hooks.hooks.nixpkgs-fmt.enable = true;

        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}

