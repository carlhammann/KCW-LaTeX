{
  nixConfig.bash-prompt-suffix = "❄ ";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils } :
    flake-utils.lib.eachDefaultSystem (system :
       let
         pkgs = nixpkgs.legacyPackages.${system};

         texWithPackages = pkgs.texlive.combine {
           inherit (pkgs.texlive)
             scheme-basic

             # thankfully, all fonts our CI needs are already packaged for us:
             montserrat
             crimsonpro

             # We're building our classes on Koma classes:
             koma-script

             # German language support:
             babel-german
             hyphen-german

             # All other LaTex packages we're using:
             appendix
             blindtext
             csquotes
             etoolbox
             float
             fontaxes
             hyperref
             ly1
             mdframed
             microtype
             needspace
             pdfpages
             xcolor
             xkeyval
             zref
             ;
         };

         allYouNeed = [pkgs.coreutils pkgs.latexrun texWithPackages];

         setTexEnvironment = ''
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
             for i in Vorlagen/*.tex; do latexrun $i; done
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
