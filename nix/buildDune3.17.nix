{
  config,
  pkgs,
  lib,
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
      # Per-system attributes can be defined here. The self' and inputs'
      # module parameters provide easy access to attributes of the same
      # system.

      # Custom dune package
      packages.dune_3_17 = pkgs.stdenv.mkDerivation rec {
        pname = "dune";
        version = "3.17.0";

        src = pkgs.fetchurl {
          url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
          hash = "sha256-LDqmxB7Tnj1sGiktdfSAa9gDEIQa/FFnOqWc6cgWUHw=";

        };

        nativeBuildInputs = [
          pkgs.ocaml
          pkgs.ocamlPackages.findlib
        ];

        buildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          pkgs.darwin.apple_sdk.frameworks.CoreServices
        ];

        strictDeps = true;

        buildFlags = [ "release" ];

        dontAddPrefix = true;
        dontAddStaticConfigureFlags = true;
        configurePlatforms = [ ];

        installFlags = [
          "PREFIX=${placeholder "out"}"
          "LIBDIR=$(OCAMLFIND_DESTDIR)"
        ];

        meta = {
          homepage = "https://dune.build/";
          description = "Composable build system for OCaml";
          mainProgram = "dune";
          changelog = "https://github.com/ocaml/dune/raw/${version}/CHANGES.md";
          license = pkgs.lib.licenses.mit;
          platforms = pkgs.ocaml.meta.platforms;
        };
      };
    };
}
