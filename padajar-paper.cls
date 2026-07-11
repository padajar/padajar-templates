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
\ProvidesClass{padajar-paper}[2026/07/11 v1.3.1 padajar paper template]

% for header settings
\PassOptionsToPackage{twoside}{fancyhdr}

% load padajar-memo class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{padajar-memo}}
\ProcessOptions\relax
\LoadClass{padajar-memo}

% margins inherited from padajar-memo, so paper matches the memo page geometry

% fix for silence/authblk interaction (etoolbox loaded via padajar-defaults)
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


\newcommand  {\papertitle}        [1]{\def\@papertitle        {#1}}
\newcommand  {\papersubtitle}     [1]{\def\@papersubtitle     {#1}}
\newcommand  {\papershorttitle}   [1]{\def\@papershorttitle   {#1}}
\newcommand  {\paperthanks}       [1]{\def\@paperthanks       {#1}}
\newcommand  {\papershortauthors} [1]{\def\@papershortauthors {#1}}
\newcommand  {\paperabstract}     [1]{\def\@paperabstract     {#1}}


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
\RequirePackage[noblocks]{authblk}

\renewcommand{\maketitle} {
	\renewcommand*{\thefootnote}{\fnsymbol{footnote}}
	\newpage
	\null
	\vfill
	
	\begin{center}%
		{\LARGE \rmfamily \@papertitle\ifnotempty{\@papersubtitle}{}{\processthanks}}
		{\processsubtitle\ifnotempty{\@papersubtitle}{\!\!\! \processthanks}{}}
		\vskip 0.25 em %
		{\@author}
		\vskip 1em%
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
	\renewcommand{\headrulewidth}{0pt} % removes horizontal header line
}

\makeatletter
\AtBeginDocument{
	
	\pagestyle{fancy}
	\fancyhf{}
	\setlength{\headsep}{11pt}
%	\fancyhead[R]{\@name}
%	\fancyhead[L]{\@memotitle}
%	\fancyfoot[L]{\small\@date}
%	\fancyfoot[R]{\small\thepage}
	\fancyhead[EL, OR]{\rmfamily \small\thepage}
	\fancyhead[EC]{\rmfamily \small\@papershorttitle}
	\fancyhead[OC]{\rmfamily \small\@papershortauthors}
%	\renewcommand{\headrulewidth}{0pt} % removes horizontal header line
	
	\thispagestyle{firstpage}
	
	\setlength{\parskip}{11pt}
	%	\setlist[1]{before=\vspace{-11pt}, after=\vspace{-11pt}}
	
}
\makeatother
\RequirePackage{hyperref}
\RequirePackage[nameinlink]{cleveref}


\endinput