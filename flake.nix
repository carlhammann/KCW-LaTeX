{
  nixConfig.bash-prompt-suffix = "❄ ";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    # fonts.url = "git+file:///home/privat/KCW-fonts"; #
    flake-utils.url = "github:numtide/flake-utils";
    # It's probably worth noting that all three of the fonts I'm pulling here
    # from GitHub are under the SIL Open Font License (OFL):
    #
    # https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL
    crimsonpro = {
      url = "github:FontHausen/CrimsonPro";
      flake = false;
    };
    montserrat = {
      url = "github:JulietaUla/Montserrat";
      flake = false;
    };
    courier = {
      url = "github:quoteunquoteapps/CourierPrime";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, crimsonpro, montserrat, courier } :
    flake-utils.lib.eachDefaultSystem (system :
       let
         pkgs = nixpkgs.legacyPackages.${system};

         texWithPackages = pkgs.texlive.combine {
           inherit (pkgs.texlive)
             scheme-basic
             latexmk

             # Here are all of the LaTex packages we're using:
             appendix
             babel-german
             blindtext
             csquotes
             environ
             float
             fontspec
             hyperref
             hyphen-german
             koma-script
             mdframed
             needspace
             pdflscape
             pdfpages
             pgf
             titlesec
             xcolor
             zref
             ;
         };

         crimsonproFont = pkgs.stdenvNoCC.mkDerivation {
           name = "crimsonpro-font";
           src = crimsonpro;
           installPhase = ''
             install -Dm 444 fonts/otf/*.otf -t $out/share/fonts/otf
             install -Dm 444 fonts/ttf/*.ttf -t $out/share/fonts/ttf
           '';
         };

         montserratFont = pkgs.stdenvNoCC.mkDerivation {
           name = "montserrat-font";
           src = montserrat;
           installPhase = ''
             install -Dm 444 fonts/otf/*.otf -t $out/share/fonts/otf
             install -Dm 444 fonts/ttf/*.ttf -t $out/share/fonts/ttf
           '';
         };

         courierFont = pkgs.stdenvNoCC.mkDerivation {
           name = "courier-font";
           src = courier;
           installPhase = ''
             install -Dm 444 fonts/ttf/*.ttf -t $out/share/fonts/ttf
           '';
         };

         allFonts = [ crimsonproFont montserratFont courierFont ];

         allYouNeed = [pkgs.coreutils texWithPackages] ++ allFonts;

         # This line cost me more than half an hour, because Kpathsea has a very
         # interesting syntax for paths: They are separated by semicolons, and
         # double slahses mean that you should look into subdirectories...
         osFontDir = pkgs.lib.concatStringsSep ";" (map (path : path + "/share/fonts//") allFonts);

         setTexEnvironment = ''
           mkdir -p .cache/texmf-var
           export TEXMFHOME=.cache;
           export TEXMFVAR=.cache/texmf-var;
           export OSFONTDIR="${osFontDir}";
           export TEXINPUTS="${self}/{tex,Logos}//:";
         '';

       in rec {
         packages.exampleDocuments = pkgs.stdenvNoCC.mkDerivation rec {
           name = "Kammerchor-LaTeX-Vorlagen";
           src = self;
           buildInputs = allYouNeed;
           phases = ["unpackPhase" "buildPhase" "installPhase"];
           buildPhase = ''
             ${setTexEnvironment}
             latexmk -interaction=nonstopmode -pdf -lualatex Vorlagen/*.tex
           '';
           installPhase = ''
             mkdir -p $out
             cp *.pdf $out
           '';
         };

         defaultPackage = packages.exampleDocuments;

         devShell = pkgs.mkShell {
           inputsFrom = [defaultPackage];
           shellHook = setTexEnvironment;
         };
       }
    );
}
