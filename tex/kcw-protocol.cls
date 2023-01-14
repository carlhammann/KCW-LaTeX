\newcommand\fileversion{0.0.1}
\newcommand\filedate{2023/01/14}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kcw-protocol}[\filedate\space Kammerchor Wernigerode e.V., class for protocols (v\fileversion)]

% Base Class
\def\KCWP@Base{scrartcl}

% If someone ever wants to print, cmyk will guarantee faithful colours
\DeclareOption{cmyk}{\PassOptionsToPackage{cmyk}{xcolor}}

% Here we can pass undeclared options to some class or package
\DeclareOption*{%
  \ClassWarning{kcw-protocol}{Unknown option '\CurrentOption'.
    I'll pass it to '\KCWP@Base' just in case.}
  \PassOptionsToClass{\CurrentOption}{\KCWP@Base}%
}
\ProcessOptions\relax
% The command above finishes the 'options' section

% We'll build on top of the '\KCWP@Base' class.
\LoadClass{\KCWP@Base}

%%%%%%%%%%%
% Colours %
%%%%%%%%%%%

\RequirePackage{xcolor}
% our nice dark blue colour
\definecolor{kcwblue}{HTML}{012B3A}

% our nice light red colour
\definecolor{kcwred}{HTML}{ff8f89} % TODO

%%%%%%%%%%%%%%%%%%
% Font Selection %
%%%%%%%%%%%%%%%%%%

% Font selection is an art, and while we're still waiting for definite
% instructions from our artist, I'll just do whatever I think looks right, using
% the fonts from our CI.
%
% In particular, I think it is a typographic faux-pas to use a sans-serif font
% for the body of the text, so here goes:

\RequirePackage{fontspec}

\newfontfamily\montserratL{Montserrat Light}
\newfontfamily\montserratR{Montserrat Regular}
\newfontfamily\montserratM{Montserrat Medium}
\newfontfamily\montserratB{Montserrat Bold}
\newfontfamily\montserratBB{Montserrat Black}

\setromanfont[Numbers={OldStyle}]{Crimson Pro}
\setsansfont{Montserrat}
% I don't know whether out CI already has a mono font, thus I'll chose
% Courier. I think it looks OK, but not perfect, with both of the other fonts.
\setmonofont{Courier Prime}

% sectioning commands and their entries in the table of contents
\setkomafont{disposition}{\montserratM}

%%%%%%%%%%%%%%%%%%%%%%%
% Headers and footers %
%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{graphicx}
\titlehead{\centering\includegraphics[width=0.5\textwidth]{kch-logo-dunkel.png}}

%%%%%%%%%%%%%%%%%%%
% Custom Commands %
%%%%%%%%%%%%%%%%%%%

\RequirePackage{float}
\RequirePackage{hyperref}
\RequirePackage{ifthen}
\RequirePackage{mdframed}

% This command is for remarks concerning the (temporary) presencee or absence of
% members.
\newcommand{\anwesenheit}[1]{
  \begin{flushright}
    \begin{minipage}[t][][t]{0.9\linewidth}
      \raggedleft
      \textit{\small #1}
    \end{minipage}
  \end{flushright}}

% For "Abstimmungen" in the strict sense: The four first arguments are a
% concrete proposal being voted on, and the numbers of "yes", "no", and
% abstention votes. The fifth argument is a remark, to be used to note whether a
% vote was accepted etc. If you leave it blank, a message indicating whether the
% proposal was accepted with more than half of the non-abstention votes
% ("einfache Stimmenmehrheit").
\newcommand{\abstimmungMitBemerkung}[5]{
  \begin{mdframed}[topline = false, bottomline = false, rightline = false, linecolor=kcwblue, linewidth=1mm]
    \noindent\textbf{\color{kcwblue} Abstimmung:}~~\textit{#1}
    \begin{table}[H]
      \centering
      \begin{tabular}
        {rl}
        dafür & #2 \\
        dagegen & #3\\
        Enthaltung & #4\\
        gesamt & \the\numexpr #2 + #3 + #4\relax
      \end{tabular}
    \end{table}
    \ifthenelse{\equal{#5}{}}
      {\ifthenelse{#2 > #3}
        {\noindent Der Vorschlag ist mit einfacher Stimmenmehrheit \textbf{angenommen}.}
        {\noindent Der Vorschlag ist mit einfacher Stimmenmehrheit \textbf{abgelehnt}.}
      }
      {\noindent #5}
  \end{mdframed}
}

% Like "\abstimmungMitBemerkung", but always using the default remark
\newcommand{\abstimmung}[4]{\abstimmungMitBemerkung{#1}{#2}{#3}{#4}{}}

% For more general votes -- "Meinungsbilder". The two first arguments are a
% proposal being voted on and an arbitrary number of possible answers, together
% with the number of votes they received, given as the rows of the table being
% constructed. The third argument is a remark. If you leave it blank, nothing
% will be printed.
\newcommand{\meinungsbild}[3]{
  \begin{mdframed}[topline = false, bottomline = false, rightline = false, linecolor=kcwblue, linewidth=1mm]
    \textbf{\color{kcwblue} Meinungsbild:}~~\textit{#1}
    \begin{table}[H]
      \centering
      \begin{tabular}{rl}
        #2
      \end{tabular}
    \end{table}
    \ifthenelse{\equal{#3}{}}
      {}
      {\noindent #3}
  \end{mdframed}
}

% The macro "\unterschriften" typesets a few nice fields for signatures. The
% trick to implement variadic macros is shamelessly stolen from
%
% https://davidyat.es/2016/07/27/writing-a-latex-macro-that-takes-a-variable-number-of-arguments/

\newcommand{\unterschriftenKopf}{\centerline{\montserratB Unterschriften}\begin{table}[H]\centering\vspace{2cm}\noindent\begin{tabular}{p{0.55\textwidth}l}}
\newcommand{\unterschriftenFuss}{\end{tabular}\end{table}}

\newcommand{\GobbleUnterschriftenArg}[1]{& Ort, Datum\\[2cm] \makebox[0.55\textwidth]{\hrulefill} & \makebox[0.35\textwidth]{\hrulefill}\\ #1\CheckUnterschriftenArg}
\newcommand{\CheckUnterschriftenArg}{\csname @ifnextchar\endcsname\bgroup{\GobbleUnterschriftenArg}{& Ort, Datum\\[2cm]\unterschriftenFuss}}
\newcommand{\unterschriften}[1]{\unterschriftenKopf\makebox[0.55\textwidth]{\hrulefill} & \makebox[0.35\textwidth]{\hrulefill}\\ #1\CheckUnterschriftenArg}

% appendices should appear in the table of contents, under the heading "Anhänge"
\RequirePackage{appendix}
\renewcommand{\appendixtocname}{Anhang}
\NewCommandCopy{\oldappendix}{\appendix}
\renewcommand{\appendix}{\centerline{\montserratB Anhang}\oldappendix\addappheadtotoc}

%%%%%%%%%
% Title %
%%%%%%%%%

\newtoks\versammlungsort
\newtoks\versammlungsbeginn
\newtoks\versammlungsende
\newtoks\versammlungsleitung
\newtoks\protokoll
\newtoks\anwesende

\renewcommand{\maketitle}{
  \thispagestyle{empty}
  \begin{center}
    \includegraphics[width=0.5\linewidth]{kch-logo-dunkel.png}\par\vspace{1cm}
    {\huge \montserratB \@title}
  \end{center}
  \begin{table}[H]
    \begin{tabular}{ll}
      \textbf{Versammlungsort} & \the\versammlungsort \\
      \textbf{Beginn} & \the\versammlungsbeginn\\
      \textbf{Ende} & \the\versammlungsende\\
      \textbf{Anwesende} & \the\anwesende\\
      \textbf{Versammlungsleitung} & \the\versammlungsleitung\\
      \textbf{Protokoll} &\the\protokoll
    \end{tabular}
  \end{table}
}
