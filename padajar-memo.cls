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
\ProvidesClass{padajar-memo}[2026/10/04 v1.5.0 padajar memo template]

\newif\ifpadajarserif 			  \padajarseriffalse 		% serif font
	\DeclareOption{serif}{\padajarseriftrue}	% (default sans)

% load article class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}


% Pass the serif option to padajar-defaults if needed
\ifpadajarserif \RequirePackage[serif, doc, nofancyhdr]{padajar-defaults}
\else			\RequirePackage[doc, nofancyhdr]{padajar-defaults}
\fi

\setlength{\parskip}{11pt plus 3pt minus 1pt}% flexible so pages can fill evenly

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

% --- page geometry ---------------------------------------------------
% The first-page header is two lines tall; size \headheight to exactly that
% and let geometry (loaded by padajar-defaults) recompute \textheight, so the
% text block and footer sit identically on page 1 and the running pages.
% NB: done here in the preamble, not \AtBeginDocument, or geometry has
% already fixed the page and the recompute is ignored.
\normalsize % ensure \baselineskip is set before we measure it
\setlength{\headheight}{2\baselineskip}
\geometry{headheight=\headheight, headsep=11pt, footskip=22pt}
% ---------------------------------------------------------------------

\RequirePackage{titlesec}
\titlespacing\section{0pt}{0pt plus 2pt minus 0pt}{0pt plus 2pt minus 0pt}
\titlespacing\subsection{0pt}{0pt plus 2pt minus 0pt}{0pt plus 2pt minus 0pt}
\titlespacing\subsubsection{0pt}{0pt plus 2pt minus 0pt}{0pt plus 2pt minus 0pt}


\fancypagestyle{firstpage} {
\fancyhf{}
\fancyhead[R]{\@name \\ \href{mailto:\@email}{\@email}}
% Empty \memonote{} -> header line shows only the date (no leading comma).
\fancyhead[L]{\@memotitle \\ \ifx\@memonote\@empty\else\@memonote, \fi\@date}

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
\newtheorem{definition}[theorem]{Definition}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{remark}[theorem]{Remark}
% Assumptions and implications run on their own counters, so the paper numbers
% Assumption 1..n and Implication 1..n independently of Theorem/Proposition.
\newtheorem{assumption}{Assumption}
\newtheorem{implication}{Implication}

% Deferred: cleveref is loaded by padajar-paper.cls, i.e. after this class, so
% \crefname does not yet exist here. The guard keeps this class usable on its own,
% where cleveref may never be loaded at all.
\AtBeginDocument{%
  \@ifundefined{crefname}{}{%
    \crefname{assumption}{assumption}{assumptions}%
    \Crefname{assumption}{Assumption}{Assumptions}%
    \crefname{implication}{implication}{implications}%
    \Crefname{implication}{Implication}{Implications}%
  }%
}



\AddToHook{env/lemma/begin}{\crefalias{theorem}{lemma}}
\AddToHook{env/example/begin}{\crefalias{theorem}{example}}
\AddToHook{env/proposition/begin}{\crefalias{theorem}{proposition}}
\AddToHook{env/definition/begin}{\crefalias{theorem}{definition}}
\AddToHook{env/corollary/begin}{\crefalias{theorem}{corollary}}
\AddToHook{env/remark/begin}{\crefalias{theorem}{remark}}

% Indent every theorem-like environment by an extra 0.5in on both sides. This
% widens the margins for the enclosed material only: no list is opened, so the
% environment contributes no vertical space of its own and the spacing above and
% below stays whatever `theorem-custom' specifies. Setting \leftskip would not
% work, since the trivlist inside every amsthm environment resets it; \parshape
% survives because \par is redefined to reset it only inside a group.
\newlength{\thmindentamount}
\setlength{\thmindentamount}{0.5in}
\newenvironment{thmindent}{%
  \par
  \advance\@totalleftmargin\thmindentamount
  \advance\linewidth -2\thmindentamount
  \parshape\@ne\@totalleftmargin\linewidth
  \@setpar{{\@@par}}%
}{%
  \par
  % The space below is the theorem style's own \topsep plus the \parskip of the
  % paragraph that follows; the space above is \topsep alone. Cancelling that
  % \parskip makes the two gaps equal.
  \vskip-\parskip\relax
}
\newcommand{\padajar@indentthm}[1]{%
  \AddToHook{env/#1/before}{\begin{thmindent}}%
  \AddToHook{env/#1/after}{\end{thmindent}}%
}
\padajar@indentthm{theorem}
\padajar@indentthm{lemma}
\padajar@indentthm{example}
\padajar@indentthm{proposition}
\padajar@indentthm{definition}
\padajar@indentthm{corollary}
\padajar@indentthm{remark}
\padajar@indentthm{assumption}
\padajar@indentthm{implication}
% amsthm's proof is a trivlist too, so the same hook indents it (added 2026-09-06).
\padajar@indentthm{proof}

% No paragraph indent after any theorem-like environment or proof. Every one
% of them is wrapped in thmindent, so hooking its end covers them all; this is
% the same mechanism the sectioning commands use to suppress the indent of the
% paragraph that follows a heading (added 2026-09-06).
\AddToHook{env/thmindent/after}{\@afterindentfalse\@afterheading}

% (R/L/C tabularx column types moved to padajar-defaults.sty, 2026-09-06)


\AtEndPreamble{
\crefname{appendix}{Appendix}{Appendices}
\Crefname{appendix}{Appendix}{Appendices}
\crefname{proposition}{proposition}{propositions}
\Crefname{proposition}{Proposition}{Propositions}
\crefname{lemma}{lemma}{lemmas}
\Crefname{lemma}{Lemma}{Lemmas}
\crefname{example}{example}{examples}
\Crefname{example}{Example}{Examples}
\crefname{definition}{definition}{definitions}
\Crefname{definition}{Definition}{Definitions}
\crefname{corollary}{corollary}{corollaries}
\Crefname{corollary}{Corollary}{Corollaries}
\crefname{remark}{remark}{remarks}
\Crefname{remark}{Remark}{Remarks}
\crefname{assumption}{assumption}{assumptions}
\Crefname{assumption}{Assumption}{Assumptions}
\crefname{implication}{implication}{implications}
\Crefname{implication}{Implication}{Implications}
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
	\fancyhead[R]{\@name}
	\fancyhead[L]{\@memotitle}
	\fancyfoot[L]{\small\@date}
	\fancyfoot[R]{\small\thepage}

	\thispagestyle{firstpage}
%	\setlist[1]{before=\vspace{-11pt}, after=\vspace{-11pt}}
}
\makeatother
\RequirePackage{hyperref}
\RequirePackage[noabbrev, nameinlink]{cleveref}

% After \appendix, \Cref{sec:...} says "Appendix C", not "Section C" (2026-09-06).
\AddToHook{cmd/appendix/before}{\crefalias{section}{appendix}\crefalias{subsection}{appendix}}

% After \appendix, theorem-like environments, tables and figures are numbered
% by appendix section (A.1, A.2, ...). Theorem-counter environments (lemma,
% example, proposition) restart in each section; assumptions and implications
% restart once at \appendix (2026-10-04).
\AddToHook{cmd/appendix/after}{%
  \renewcommand{\thetheorem}{\thesection.\arabic{theorem}}%
  \setcounter{theorem}{0}%
  \counterwithin*{theorem}{section}%
  \renewcommand{\theassumption}{\thesection.\arabic{assumption}}%
  \setcounter{assumption}{0}%
  \renewcommand{\theimplication}{\thesection.\arabic{implication}}%
  \setcounter{implication}{0}%
  \counterwithin{table}{section}%
  \counterwithin{figure}{section}%
  \renewcommand{\thetable}{\Alph{section}.\arabic{table}}%
  \renewcommand{\thefigure}{\Alph{section}.\arabic{figure}}%
}

\endinput
