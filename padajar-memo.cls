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

% padajar-memo.cls - Custom LaTeX memo package
% Created on 2025-03-22

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{padajar-memo}[2026/07/11 padajar memo template]

\newif\ifpadajarserif 			  \padajarseriffalse 		% serif font
	\DeclareOption{serif}{\padajarseriftrue}				% (default sans)

% load article class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}


% Pass the serif option to padajar-defaults if needed
\ifpadajarserif \RequirePackage[serif, doc, nofancyhdr]{padajar-defaults}
\else			\RequirePackage[doc, nofancyhdr]{padajar-defaults}
\fi

\setlength{\parskip}{11pt}

% Define commands to set document information
\makeatletter
\def\@memotitle {\symbol{92}memotitle}
\def\@memonote  {\symbol{92}memonote}
\def\@name      {\symbol{92}name}
\def\@email     {\symbol{92}email}
\def\@pdftitle  {\@memotitle}
\def\@date      {\symbol{92}date (usually \symbol{92}today)}


% Define user-friendly interface
\newcommand  {\name}      [1]{\def\@name      {#1}}
\newcommand  {\email}     [1]{\def\@email     {#1}}
\newcommand  {\pdftitle}  [1]{\def\@pdftitle  {#1}}
\renewcommand{\date}      [1]{\def\@date      {#1}}
\newcommand  {\memotitle} [1]{\def\@memotitle {#1}}
\newcommand  {\memonote}  [1]{\def\@memonote  {#1}}

\RequirePackage{fancyhdr}

\RequirePackage{titlesec}
\titlespacing\section{0pt}{0pt plus 2pt minus 0pt}{0pt plus 2pt minus 0pt}
\titlespacing\subsection{0pt}{0pt plus 2pt minus 0pt}{0pt plus 2pt minus 0pt}
\titlespacing\subsubsection{0pt}{0pt plus 2pt minus 0pt}{0pt plus 2pt minus 0pt}


\fancypagestyle{firstpage} {
\fancyhf{}
\setlength{\headheight}{22.01pt}
\setlength{\headsep}{11pt}
\setlength{\footskip}{22.3pt}
\addtolength{\textheight}{-11.31pt}
\fancyhead[R]{\@name \\ \href{mailto:\@email}{\@email}}
\fancyhead[L]{\@memotitle \\ \@memonote, \@date}

\fancyfoot[L]{}
\fancyfoot[R]{\small\thepage}
}


% theorem setups
\newtheoremstyle{theorem-custom}%
				{}{}%
				{}{}%
				{\itshape}{.}%
				{ }%
				{\thmname{#1}\thmnumber{ #2}\thmnote{ (#3)}}

\theoremstyle{theorem-custom}
\newtheorem{theorem}{Theorem}
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{example}[theorem]{Example}
\newtheorem{proposition}[theorem]{Proposition}

\AddToHook{env/lemma/begin}{\crefalias{theorem}{lemma}}
\AddToHook{env/example/begin}{\crefalias{theorem}{example}}
\AddToHook{env/proposition/begin}{\crefalias{theorem}{proposition}}

\newcolumntype{R}{>{\raggedleft\arraybackslash}X}
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
\newcolumntype{C}{>{\centering\arraybackslash}X}


\AtEndPreamble{
\crefname{proposition}{proposition}{propositions}
\Crefname{proposition}{Proposition}{Propositions}
\crefname{lemma}{lemma}{lemmas}
\Crefname{lemma}{Lemma}{Lemmas}
\crefname{example}{example}{examples}
\Crefname{example}{Example}{Examples}
}

\AtBeginDocument{
	% Make internal variables accessible to hyperref
	\global\let\name=\name
	\global\let\pdftitle=\pdftitle

	\hypersetup{
		pdfauthor  = {\@name},
		pdftitle   = {\@pdftitle},
		colorlinks = true,
		linkcolor  = padajargreen,
		filecolor  = padajarpurple,
		urlcolor   = padajaralert,
		citecolor  = padajarblue
	}

	\pagestyle{fancy}
	\fancyhf{}
	\setlength{\headsep}{11pt}
	\setlength{\footskip}{22pt}
	\fancyhead[R]{\@name}
	\fancyhead[L]{\@memotitle}
	\fancyfoot[L]{\small\@date}
	\fancyfoot[R]{\small\thepage}
	\addtolength{\textheight}{11pt}

	\thispagestyle{firstpage}

	\setlength{\parskip}{11.31pt}
%	\setlist[1]{before=\vspace{-11pt}, after=\vspace{-11pt}}
}
\makeatother
\RequirePackage{hyperref}
\RequirePackage[noabbrev, nameinlink]{cleveref}

\endinput
