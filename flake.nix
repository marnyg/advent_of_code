{
  description = "My OCaml project";

  inputs.nixpkgs.url = "github:nix-ocaml/nix-overlays";
  inputs.opam-nix.url = "github:tweag/opam-nix";

  outputs = { self, nixpkgs, opam-nix }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      myPro = (opam-nix.lib.x86_64-linux.buildDuneProject { } "myPro" ./. { ocaml-base-compiler = "*"; }).myPro;
      myShell = pkgs.mkShell {
        buildInputs = [ myPro pkgs.nixd pkgs.rnix-lsp ];
        LSP_SERVERS = "ocamllsp, rnix, nixd";
      };
    in
    {
      packages.x86_64-linux.default = myPro;
      apps.x86_64-linux.default = { type = "app"; program = "${myPro}/bin/myPro"; };
      checks.x86_64-linux.tests = pkgs.stdenv.mkDerivation {
        name = "dune-test";
        buildInputs = [ myPro ];
        src = ./.;
        checkPhase = "dune test && touch $out/ok ";
        installPhase = "echo No installation needed for test && mkdir -p $out && touch $out/testOK";
      };


      formatter.x86_64-linux = pkgs.nixpkgs-fmt;
      devShells.x86_64-linux.default = myShell;
    };
}

