{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";

    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      #packageOverrides = pkgs.callPackage ./python-packages.nix {};
      #python3 = pkgs.python3.override { inherit packageOverrides; };
    in {
      devShell = pkgs.mkShell {
        name = "python-venv";
        venvDir = "./.venv";
        buildInputs = with pkgs; [
            R
            rPackages.pagedown
            rPackages.tidyverse
            rPackages.quarto
            rPackages.patchwork
            rPackages.gcookbook
            rPackages.hexbin
            rPackages.webshot2
            rPackages.mapproj
            rPackages.rgl
            rPackages.ggcorrplot
            rPackages.corrplot
            rPackages.vcd
            rPackages.maps
            rPackages.MASS
            rPackages.ggrepel
            rPackages.igraph
            rPackages.sf
            rPackages.tidyr
            chromium
            pandoc
            texlive.combined.scheme-full
            rstudio
            quarto
        ];

        shellHook = ''
            export BROWSER=zen
            #jupyter lab
        '';

      };
    }
  );
}
