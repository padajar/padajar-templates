% Copyright 2025 Paolo Adajar (padajar.com, paoloadajar@mit.edu)

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

% padajar-slides.cls - Custom LaTeX slides style package
% Created on 2025-03-22

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{padajar-slides}[2025/03/21 padajar slides template]

\newif\ifpadajarserif 			  \padajarseriffalse 			% serif font
	\DeclareOption{noreflections}{\printreflectionsfalse}		% (default sans)
\newif\ifpadajarsectionslides	  \padajarsectionslidesfalse	% slide at start of section
	\DeclareOption{sectionslides}{\padajarsectionslidestrue}	% (default no slide)

% load beamer class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass[aspectratio=169]{beamer}

% Pass the serif option to padajar-defaults if needed
\ifpadajarserif \RequirePackage[serif, slides]{padajar-defaults}
\else			\RequirePackage[slides]{padajar-defaults}
\fi

% other beamer options
\setbeamertemplate{note page}[plain]
\usetheme[numbering=fraction, sectionpage=simple, block=fill]{moloch}           % Use moloch theme
\setbeamertemplate{frametitle continuation}{(\insertcontinuationcount)}
\setbeamercovered{transparent}



\setbeamercolor{normal text} {fg = padajarbg}
\setbeamercolor{alerted text}{fg = padajaralert}
\setbeamercolor{section in head/foot}{fg = normal text.fg, bg=structure.bg}
\setbeamertemplate{blocks}[rounded][shadow=true]
\useinnertheme[rounded, shaded=false]{tcolorbox}

% Define commands to set document information
\makeatletter
\def\@name      {Student Name}
\def\@email     {email@me.com}
\def\@pdftitle  {Class Assignment}
\def\@date      {\today}

% Define user-friendly interface
\newcommand  {\name}      [1]{\def\@name      {#1}}
\newcommand  {\email}     [1]{\def\@email     {#1}}
\newcommand  {\pdftitle}  [1]{\def\@pdftitle  {#1}}
\renewcommand{\date}      [1]{\def\@date      {#1}}

% set sections in footline
\setbeamertemplate{footline}{%
	\begin{beamercolorbox}[colsep=1.5pt]{upper separation line head}
	\end{beamercolorbox}
	\begin{beamercolorbox}{section in head/foot}
		\vskip2pt\insertnavigation{\paperwidth}\vskip2pt
	\end{beamercolorbox}%
	\begin{beamercolorbox}[colsep=1.5pt]{lower separation line head}
	\end{beamercolorbox}
}

% set a new "covered" environment
\def\beamer@startmycovered{%
	\def\opaqueness<##1>##2{%
		\only<##1>{%
			\beamer@actions{%
				\expandafter\xdef\csname beamer@oldcolorhook%
				\the\beamer@coveringdepth\endcsname{\beamer@colorhook}%
				\expandafter\xdef\csname beamer@oldpgfextension%
				\the\beamer@coveringdepth\endcsname{\beamer@pgfextension}%
				{\globalcolorstrue\colorlet{beamer@freeze\the\beamer@coveringdepth}{bg}}%
				\xdef\beamer@colorhook{!##2!beamer@freeze%
					\the\beamer@coveringdepth\beamer@colorhook}%
				\gdef\beamer@pgfextension{!##2opaque}%
				\color{.}%
			}%
			{%
				\xdef\beamer@colorhook{\csname beamer@oldcolorhook%
					\the\beamer@coveringdepth\endcsname}%
				\xdef\beamer@pgfextension{\csname beamer@oldpgfextension%
					\the\beamer@coveringdepth\endcsname}%
				\color{.}%
	}}}%
	\ifnum\beamer@slideinframe<\beamer@minimum%ok, at beginning
	{%
		\beamer@saveanother%
		\advance\beamer@minimum by-\beamer@slideinframe%
		\beamer@slideinframe=\beamer@minimum%
		\beamer@uncoverbeforeactions%
		\beamer@restoreanother%
	}%
	\else%
	{%
		\beamer@saveanother%
		\advance\beamer@slideinframe by-\beamer@minimum%
		\beamer@uncoverafteractions%
		\beamer@restoreanother%
	}%
	\fi%
	\beamer@do%
	%  }%
}
\long\def\beamer@makemycovered#1{\beamer@startmycovered#1\beamer@endcovered}
\def\mycover{%
\alt{\beamer@makemycovered}{\beamer@fakeinvisible}}
\def\c@slideinframe{\beamer@slideinframe}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% \btIfInRange{number}{range list}{TRUE}{FALSE}
%
% Test in int number <number> is element of a (comma separated) list of ranges
% (such as: {1,3-5,7,10-12,14}) and processes <TRUE> or <FALSE> respectively

\newcount\bt@rangea
\newcount\bt@rangeb

\newcommand\btIfInRange[2]{%
	\global\let\bt@inrange\@secondoftwo%
	\edef\bt@rangelist{#2}%
	\foreach \range in \bt@rangelist {%
		\afterassignment\bt@getrangeb%
		\bt@rangea=0\range\relax%
		\pgfmathtruncatemacro\result{ ( #1 >= \bt@rangea) && (#1 <= \bt@rangeb) }%
		\ifnum\result=1\relax%
		\breakforeach%
		\global\let\bt@inrange\@firstoftwo%
		\fi%
	}%
	\bt@inrange%
}
\newcommand\bt@getrangeb{%
	\@ifnextchar\relax%
	{\bt@rangeb=\bt@rangea}%
	{\@getrangeb}%
}
\def\@getrangeb-#1\relax{%
	\ifx\relax#1\relax%
	\bt@rangeb=100000%   \maxdimen is too large for pgfmath
	\else%
	\bt@rangeb=#1\relax%
	\fi%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% \btLstHL<overlay spec>{range list}
%
% TODO BUG: \btLstHL commands can not yet be accumulated if more than one overlay spec match.
%
\newcommand<>{\btLstHL}[1]{%
	\only#2{\btIfInRange{\value{lstnumber}}{#1}{\color{padajarorange!15}\def\lst@linebgrdcmd{\color@block}}{\def\lst@linebgrdcmd####1####2####3{}}}%
}%

\newcommand{\graycitep}[1]{{\footnotesize\textcolor{normal text.fg!50}{\citep{#1}}}}


\let\beamer@writeslidentry@miniframeson=\beamer@writeslidentry%
\def\beamer@writeslidentry@miniframesoff{%
	\expandafter\beamer@ifempty\expandafter{\beamer@framestartpage}{}% does not happen normally
	{%else
		% removed \addtocontents commands
		\clearpage\beamer@notesactions%
	}
}
\newcommand*{\miniframeson}{\let\beamer@writeslidentry=\beamer@writeslidentry@miniframeson}
\newcommand*{\miniframesoff}{\let\beamer@writeslidentry=\beamer@writeslidentry@miniframesoff}

\ifpadajarsectionslides
	\AtBeginSection[]
	{
		\miniframesoff
	 	\begin{frame}[noframenumbering, plain]{Outline}
		 		\tableofcontents[currentsection]
		 	\end{frame}
	 	\miniframeson
	}
\else
	\AtBeginSection[]{}
\fi

\AtBeginDocument{
	% Make internal variables accessible to hyperref
	\global\let\name=\name
	\global\let\pdftitle=\pdftitle
}
\makeatother

\lstset{backgroundcolor=\color{normal text.bg},
		rulecolor=\color{normal text.fg!40},
		numberstyle=\color{normal text.fg!40}
	}

\usepackage{hyperref}
\hypersetup{colorlinks = true,
	linkcolor=normal text.fg,
	citecolor=gray,
	urlcolor = padajarblue,
	pdfauthor  = {test},
	pdftitle   = {test},
}
\usepackage[nameinlink]{cleveref}

\endinput
