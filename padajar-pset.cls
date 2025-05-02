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

% padajar-pset.cls - Custom LaTeX pset package
% Created on 2025-03-22

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{padajar-pset}[2025/03/21 padajar pset template]

\newif\ifprintreflections 		  \printreflectionsfalse 	% show reflections 
	\DeclareOption{reflections}  {\printreflectionstrue}	% (default hide)
\newif\ifpadajarserif 			  \padajarseriffalse 		% serif font
	\DeclareOption{noreflections}{\printreflectionsfalse}	% (default sans)

% load exam class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{exam}}
\ProcessOptions\relax
\LoadClass{exam}

% Pass the serif option to padajar-defaults if needed
\ifpadajarserif \RequirePackage[serif, doc, nofancyhdr]{padajar-defaults}
\else			\RequirePackage[doc, nofancyhdr]{padajar-defaults}
\fi

% set tcolorbox settings
\tcbuselibrary{breakable,skins}
\allowdisplaybreaks[1]

%\usepackage{tikz}
%\usepackage{istgame}

% Define commands to set document information
\makeatletter
\def\@classnum  {Class Number}
\def\@classname {Class Name}
\def\@assignment{Assignment Name}
\def\@name      {Student Name}
\def\@email     {email@me.com}
\def\@pdftitle  {Class Assignment}
\def\@date      {\today}

% Define user-friendly interface
\newcommand  {\classnum}  [1]{\def\@classnum  {#1}}
\newcommand  {\classname} [1]{\def\@classname {#1}}
\newcommand  {\assignment}[1]{\def\@assignment{#1}}
\newcommand  {\name}      [1]{\def\@name      {#1}}
\newcommand  {\email}     [1]{\def\@email     {#1}}
\newcommand  {\pdftitle}  [1]{\def\@pdftitle  {#1}}
\renewcommand{\date}      [1]{\def\@date      {#1}}

% commands to handle optional professors, collaborators
\newcommand{\ifempty}[3]{									% command for if empty
	\ifthenelse{\equal{#1}{}}{#2}{#3}%
}

% Professors
\def\@professorlist{}
\def\@firstprofessor{}
\def\@professorlist{}
\newcommand{\professors}[1]{%
	\def\@firstprofessor{#1}%
	\def\@professorlist{#1}%
	\@ifnextchar\bgroup{\@professorsnext}{}%
}
\def\@professorsnext#1{%
	\edef\@professorlist{\@professorlist, #1}%
	\@ifnextchar\bgroup{\@professorsnext}{}%
}
\newcommand{\processprofessor}{%
	\ifempty{\@professorlist}{}{%
		\ifempty{\@firstprofessor}{}{%
			\ifthenelse{\equal{\@firstprofessor}{\@professorlist}}{%
				Professor: \@professorlist%
			}{%
				Professors: \@professorlist%
			}%
		}%
	}%
}

% Collaborators
\def\@firstcollab{}
\def\@collablist{}
\newcommand{\collaborators}[1]{%
	\def\@firstcollab{#1}%
	\def\@collablist{#1}%
	\@ifnextchar\bgroup{\@collabsnext}{}%
}
\def\@collabsnext#1{%
	\edef\@collablist{\@collablist, #1}%
	\@ifnextchar\bgroup{\@collabsnext}{}%
}
\newcommand{\processcollaborator}{%
	\ifempty{\@collablist}{}{\!$^*$% Just add a marker
	}%
}


% set headers, footers
\pagestyle{headandfoot}
\firstpageheader{\@classnum: \@classname 			   \\
				 \@assignment 						   \\
				 \processprofessor
			 	}
				{}
				{\@name\processcollaborator 		   \\
				 \href{mailto:\@email}{\@email} \\
				 \@date
			 	}
\firstpagefooter{\parbox[t]{0.5\textwidth}
					{
					\ifempty{\@collablist}{}{
						\small{$^*$\!%
						\ifthenelse{\equal{\@firstcollab}{\@collablist}}
							{\;Collaborator: \@collablist}
							{\;Collaborators: \@collablist}
							}
						}
					}
				}
{\parbox[t]{0.2\textwidth}{}}
{\parbox[t]{0.3\textwidth}{\small{\hfill \thepage\ of \numpages}}}
\firstpageheadrule
\firstpagefootrule


\runningheader{\@date}
			  {}
			  {\@name}
\runningfooter{\small {\@classnum: \@assignment}}
			  {}
			  {\small{Page \thepage\ of \numpages}}

\runningheadrule
\runningfootrule

\setlength{\parskip}{11pt}
\extraheadheight[22pt]{0pt}
\extrafootheight{-11pt}
\setlength{\headsep}{6pt}
\setlength{\footskip}{6pt}

\renewcommand{\questionshook}{%
	\setlength{\leftmargin}{0pt}%
	\setlength{\labelwidth}{-\labelsep}%
}

% theorem setups
\newtheoremstyle{theorem-custom}%
				{2mm}{}%
				{}{}%
				{\itshape}{.}%
				{ }%
				{\thmname{#1}\thmnumber{ #2}\thmnote{ (#3)}}

\theoremstyle{theorem-custom}
\newtheorem{theorem}{Theorem}
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{example}[theorem]{Example}

% Redefine the TheSolution environment to have boxes
\renewenvironment{TheSolution}%
{%
	% Force a new line before starting the solution
	\par  %\addvspace{\baselineskip}%
	\leftskip=0pt
	\rightskip=0pt
	\begin{tcolorbox}[breakable, colback=green!5!white, colframe=green!75!black, enhanced jigsaw]
		\setlength{\parskip}{2mm}%
		\ignorespaces
		\textit{Solution. \quad}
	}%
	{%
%		\ifx\qedsymbol\undefined\else
%		\renewcommand{\qedsymbol}{$\blacksquare$}
%		\hfill\qedsymbol
%		\fi
	\end{tcolorbox}
	\par %\addvspace{\baselineskip}%
}

% new reflection environment (adapted from solution code of exam class)

% Command shortcuts to toggle reflections
\def\printreflections  {\printreflectionstrue}
\def\noprintreflections{\printreflectionsfalse}

% Define a counter to save equation numbers (similar to solution environment)
\newcounter{exam@saved@refl@eqnum}

% Define emphasis command for reflections
\newcommand\ReflectionEmphasis[1]{%
	\def\Reflection@Emphasis{#1}%
}
\ReflectionEmphasis{}

% Define TheReflection environment to contain reflection content
\newenvironment{TheReflection}%
{%
	% Force a new line before starting the solution
	\par  %\addvspace{\baselineskip}%
	\leftskip=0pt
	\rightskip=0pt
	\begin{tcolorbox}[breakable, colback=black!8!white, colframe=black!60!white, enhanced jigsaw]
		\setlength{\parskip}{2mm}%
		\ignorespaces
		\textit{Reflection. \quad}
	}%
	{%
%		\ifx\qedsymbol\undefined\else
%		\renewcommand{\qedsymbol}{$\blacksquare$}
%		\hfill\qedsymbol
%		\fi
	\end{tcolorbox}
	\par %\addvspace{\baselineskip}%
}

% Main reflection environment (no space parameter like solution env)
\newenvironment{reflection}%
{%
	\setcounter{exam@saved@refl@eqnum}{\value{equation}}%
	\setcounter{equation}{0}%
	\ifprintreflections
	\begingroup
	\Reflection@Emphasis
	\begin{TheReflection}%
		\else
		% If not printing reflections, create an invisible box
		\setbox\z@\vbox\bgroup
		\fi
	}{%
		\ifprintreflections
	\end{TheReflection}%
	\endgroup
	\else
	\egroup
	\fi
	\setcounter{equation}{\value{exam@saved@refl@eqnum}}%
}%

%% qedh for solution env
%\newcommand{\qedh}{\renewcommand{\qedsymbol}{$\blacksquare$}\qedhere}



% set points in margins
\marginpointname{ \points}
\pointsinmargin
\addpoints

% set question format
\qformat{\parbox{\textwidth}{\vspace*{12pt} \Large\bfseries\rmfamily Problem \thequestion. \thequestiontitle{} \hfill (\totalpoints\;\points)  \vspace*{6pt}}}
\renewcommand{\thesubpart}{(\roman{subpart})}
\renewcommand{\subpartlabel}{\thesubpart}   %% to remove the dot



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

}
\makeatother
\RequirePackage{hyperref}
\RequirePackage[nameinlink]{cleveref}

\endinput