% Copyright 2025 Phi Adajar (padajar.com, phiadajar@mit.edu)

% Permission is hereby granted, free of charge, to any person obtaining a copy
% 	of this software and associated documentation files (the "Software"), to 
% 	deal in the Software without restriction, including without limitation the 
% 	rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
% 	sell copies of the Software, and to permit persons to whom the Software is 
% 	furnished to do so, subject to the following conditions:
%
% 	The above copyright notice and this permission notice shall be included in
%	all copies or substantial portions of the Software.
% 
% 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% 	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% 	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% 	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
% 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
% 	IN THE SOFTWARE.

% padajar-paper.cls - Custom LaTeX paper package
% Created on 2025-07-17

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{padajar-paper}[2026/10/04 v1.5.0 padajar paper template]

% for header settings
\PassOptionsToPackage{twoside}{fancyhdr}

% load padajar-memo class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{padajar-memo}}
\ProcessOptions\relax
\LoadClass{padajar-memo}

% margins inherited from padajar-memo, so paper matches the memo page geometry

% ---- paragraph style -------------------------------------------------------
% Indented paragraphs, no vertical space between them. \parskip itself is set
% in the \AtBeginDocument block below (it must run after padajar-memo.cls's).
\setlength{\parindent}{15pt}

% \parskip no longer supplies the air around headings (padajar-memo.cls sets
% \titlespacing to ~0pt), so set it explicitly. Starred form => the first
% paragraph after a heading is NOT indented.
\titlespacing*{\section}      {0pt}{3.0ex plus 1ex minus .2ex}{1.4ex plus .2ex}
\titlespacing*{\subsection}   {0pt}{2.6ex plus 1ex minus .2ex}{1.0ex plus .2ex}
\titlespacing*{\subsubsection}{0pt}{2.2ex plus 1ex minus .2ex}{0.8ex plus .2ex}
% \paragraph is a run-in heading, indented to line up with the body text.
\titlespacing*{\paragraph}{15pt}{1.6ex plus .5ex minus .2ex}{1em}

% ---- references (AER style: smaller font, tight entries) -------------------
\def\bibfont{\small}
\setlength{\bibsep}{0pt plus 0.3ex}

% fix for silence/authblk interaction
\RequirePackage{etoolbox}
\makeatletter
\robustify\@latex@warning@no@line
\makeatother

% Define commands to set document information
\makeatletter
\def\@papertitle        {\symbol{92}papertitle}
\def\@papersubtitle     {\symbol{92}papersubtitle (optional)}
\def\@papershorttitle   {\symbol{92}papershorttitle}
\def\@paperthanks       {\symbol{92}paperthanks}
\def\@papershortauthors {\symbol{92}papershortauthors}
\def\@paperabstract     {\symbol{92}paperabstract (optional)}
\def\@paperpdfauthors   {}


\newcommand  {\papertitle}        [1]{\def\@papertitle        {#1}}
\newcommand  {\papersubtitle}     [1]{\def\@papersubtitle     {#1}}
\newcommand  {\papershorttitle}   [1]{\def\@papershorttitle   {#1}}
\newcommand  {\paperthanks}       [1]{\def\@paperthanks       {#1}}
\newcommand  {\papershortauthors} [1]{\def\@papershortauthors {#1}}
\newcommand  {\paperabstract}     [1]{\def\@paperabstract     {#1}}
\newcommand  {\paperpdfauthors}   [1]{\def\@paperpdfauthors   {#1}}  % PDF metadata author list

% US-style date ("October 4, 2026"); isodate makes \today print ISO dates.
\newcommand{\usdate}{\ifcase\month\or January\or February\or March\or April\or May\or June\or July\or August\or September\or October\or November\or December\fi\ \number\day, \number\year}
% Link to the latest version, on its own line under the date: \date{\usdate \latestversion{url}}
\newcommand{\latestversion}[1]{\\ \href{#1}{Click here for the latest version}}


\newcommand{\ifnotempty}[3]{						
	\ifthenelse{\equal{#1}{}}{#3}{#2}%
}
\newcommand{\processsubtitle}{
	\ifnotempty{\@papersubtitle}{\\ \Large \rmfamily \@papersubtitle}{}
}
\newcommand{\processthanks}{
	\ifnotempty{\@paperthanks}{\rmfamily\!\!\!\!\footnote{\@paperthanks}}{}
}

\RequirePackage{changepage}
% authblk in BLOCKS mode: each author gets their own name-over-affiliation
% block. NOTE: blocks-mode \@author expands to \AB@authors, which emits
% \\[\affilsep] and nested tabulars -- it is written to sit INSIDE the
% tabular that stock \maketitle wraps around \@author. Our \maketitle below
% must supply that tabular; dropping \@author into a bare center gives
% "Misplaced \crcr" from \endtabular. That is what sent this to [noblocks]
% before -- it was never the shorttitle machinery.
\RequirePackage[blocks]{authblk}

% Author blocks are laid out in EQUAL-WIDTH centred columns rather than at
% their natural widths. Centring the row as a whole leaves the names visibly
% lopsided whenever the affiliations differ in length (measured: 15pt of
% asymmetry with three authors, against 1pt here). \and is what authblk uses
% to separate blocks, so it has to open the same column type; it is
% redefined inside \maketitle so the change does not leak.
% Widen \AB@authwidth if an affiliation wraps; 2x width must stay under
% \textwidth or the blocks stack one per row. Affiliations are set at full
% size (authblk's \Affilfont default), so a long one needs a short form --
% at 0.46\textwidth a column holds roughly 30 characters.
\newcommand{\AB@authwidth}{0.46\textwidth}
\newcolumntype{Z}{>{\centering\arraybackslash}p{\AB@authwidth}}
\setlength{\affilsep}{2pt}   % authblk default is 1em -- too airy under a name


\renewcommand{\maketitle} {
   
	\renewcommand*{\thefootnote}{\fnsymbol{footnote}}
	\newpage
	\null
	\vfill
	
	\begin{center}%
		{\LARGE \rmfamily \@papertitle\ifnotempty{\@papersubtitle}{}{\processthanks}}
		{\processsubtitle\ifnotempty{\@papersubtitle}{\!\!\! \processthanks}{}}
		\par\vskip 1.2em%
		\renewcommand{\and}{\end{tabular}\hfil\begin{tabular}[t]{Z}}%
		\begin{tabular}[t]{Z}\@author\end{tabular}%
		\par\vskip 1em%
		{\@date}%
	\end{center}%		
	\vfill
	
	\ifnotempty{\@paperabstract}{		%
		\begin{adjustwidth}{0.5in}{0.5in}
		\small \itshape \@paperabstract
		\end{adjustwidth}
		\vfill
	}{}
	
	\clearpage
	
	\renewcommand*{\thefootnote}{\arabic{footnote}}
	\setcounter{footnote}{0}
	\setstretch{1.15}
}

% backwards-compatible alias for the former command name
\newcommand{\makepapertitle}{\maketitle}

\makeatother


%
%\newcommand{\makepapertitle} {
	%\begin{center}
	%	\LARGE\textrm{\centering\@papertitle}
	%	\\
	%	\Large\textrm{\centering\@papersubtitle}
	%	
	%	\@author
	%\end{center}
	%}



\fancypagestyle{firstpage}{
	\fancyhf{}
	\setlength{\headsep}{11pt}
	\setlength{\footskip}{0pt}
	\renewcommand{\headrulewidth}{0pt} % removes horizontal header line
}

\makeatletter
\AtBeginDocument{
	
	\pagestyle{fancy}
	\fancyhf{}
	\setlength{\headsep}{11pt}
	\setlength{\footskip}{0pt}
%	\fancyhead[R]{\@name}
%	\fancyhead[L]{\@memotitle}
%	\fancyfoot[L]{\small\@date}
%	\fancyfoot[R]{\small\thepage}
	\fancyhead[EL, OR]{\rmfamily \small\thepage}
	\fancyhead[EC]{\rmfamily \small\@papershorttitle}
	\fancyhead[OC]{\rmfamily \small\@papershortauthors}
%	\renewcommand{\headrulewidth}{0pt} % removes horizontal header line
	
	\thispagestyle{firstpage}
	
	\setlength{\parskip}{0pt plus 0.5pt}
	% PDF metadata (replaces padajar-memo.cls's \@name, which papers never set)
	\hypersetup{pdftitle={\@papertitle}, pdfauthor={\@paperpdfauthors}}
	%	\setlist[1]{before=\vspace{-11pt}, after=\vspace{-11pt}}
	
}
\makeatother
\RequirePackage{hyperref}
\RequirePackage[nameinlink]{cleveref}

\endinput