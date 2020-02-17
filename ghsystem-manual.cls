% --------------------------------------------------------------------------
% the GHSYSTEM package
%
%   globally harmonised system
%
% --------------------------------------------------------------------------
% Clemens Niederberger
% --------------------------------------------------------------------------
% https://github.org/cgnieder/ghsystem/
% contact@mychemistry.eu
% --------------------------------------------------------------------------
% If you have any ideas, questions, suggestions or bugs to report, please
% feel free to contact me.
% --------------------------------------------------------------------------
% Copyright 2011--2020 Clemens Niederberger
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
% The Current Maintainer of this work is Clemens Niederberger.
% --------------------------------------------------------------------------
\ProvidesClass{ghsystem-manual}[2020/02/17]

\LoadClass[load-preamble,add-index]{cnltx-doc}
\RequirePackage{imakeidx}
\RequirePackage[utf8]{inputenc}

\RequirePackage{ghsystem,chemmacros}

\setcnltx{
  package  = {ghsystem},
  info     = \acl*{ghs} ,
  url      = https://github.com/cgnieder/ghsystem/ ,
  authors  = Clemens Niederberger ,
  email    = contact@mychemistry.eu ,
  abstract = {%
    \centering
    \includegraphics{chemmacros-logo.pdf}
    \par
  } ,
  add-cmds = {
    chemsetup,
    ghs, ghslistall, ghspic, ghssetup
  } ,
  index-setup = { noclearpage , level = \addsec }
}

\RequirePackage{booktabs}

\def\libertine@figurestyle{LF}
\RequirePackage{amsmath}
\undef\lvert \undef\lVert
\undef\rvert \undef\rVert
\RequirePackage[libertine]{newtxmath}
\def\libertine@figurestyle{OsF}

\RequirePackage[biblatex]{embrac}
\ChangeEmph{[}[,.02em]{]}[.055em,-.08em]
\ChangeEmph{(}[-.01em,.04em]{)}[.04em,-.05em]

\RequirePackage[accsupp]{acro}
\acsetup{
  long-format  = \scshape ,
  short-format = \scshape
}

\chemsetup{
  greek = newtx ,
  formula = chemformula ,
  chemformula/format = \libertineLF
}

\ghssetup{
  language = {german,english}
}

\sisetup{
  detect-mode=false,
  mode=text,
  text-rm=\libertineLF
}

\RequirePackage{fontawesome}
\RequirePackage{datetime2}
\DTMsetup{useregional=numeric,datesep=/}
\newrobustcmd*\ghsystem@add@version[2]{%
  \csdef{ghsystem@ver@#2}{%
    \DTMdate{#1}%
    \csgdef{ghsystem@ver@#2used}{}%
    \csdef{ghsystem@ver@#2}{\DTMdate{#1}}%
  }%
}

\newrobustcmd*\ghsystem@date[1]{%
  \ifcsdef{ghsystem@ver@#1used}{}{ (\csuse{ghsystem@ver@#1})}}
\newrobustcmd*\ghsystem@ifnew[1]{\ifcsstring{c_ghsystem_version_tl}{#1}}
\newrobustcmd*\ghsystem@NEW{\faStarO\ New}

\renewrobustcmd*\sinceversion[1]{%
  \ghsystem@ifnew{#1}%
    {\cnltx@version@note{\textcolor{red}{\ghsystem@NEW}}}%
    {\cnltx@version@note{\GetTranslation{cnltx-introduced}~#1\ghsystem@date{#1}}}%
}
\renewrobustcmd*\changedversion[1]{%
  \cnltx@version@note{\GetTranslation{cnltx-changed}~#1\ghsystem@date{#1}}%
}

\newnote*\sincechanged[2]{%
  \GetTranslation{cnltx-introduced}~#1\ghsystem@date{#1},
  changed with version~#2\ghsystem@date{#2}\ghsystem@ifnew{#2}{ \ghsystem@NEW}{}%
}

\RenewDocumentEnvironment{commands}{}
  {%
    \cnltx@set@catcode_{12}%
    \let\command\cnltx@command
    \cnltxlist
  }
  {\endcnltxlist}
  
\RequirePackage{tcolorbox,xsimverb}
\tcbuselibrary{skins,breakable}
\tcbset{enhanced,enhanced jigsaw}

\newtcolorbox{bewareofthedog}{
  colback  = white ,
  colframe = red ,
  underlay={%
    \path[draw=none]
      (interior.south west)
      rectangle node[red]{\Huge\bfseries !}
      ([xshift=-4mm]interior.north west);
    }%
}

\newtcolorbox{cnltxcode}[1][]{
  boxrule = 1pt ,
  colback = cnltxbg ,
  colframe = cnltx ,
  arc = 5pt ,
  beforeafter skip = .5\baselineskip ,%
  #1%
}

\newcommand*\ghsystem@readoptions[1]{%
  \catcode`\^^M=13
  \ghsystem@read@options{#1}%
}

\begingroup
\catcode`\^^M=13
\gdef\ghsystem@read@options#1#2^^M{%
  \endgroup
  \ifblank{#2}{}{\ghsystem@read@options@#2}%
  #1%
  \XSIMfilewritestart*{\jobname.tmp}%
}%
\endgroup
\def\ghsystem@read@options@[#1]{\pgfqkeys{/cnltx}{#1}}

\RenewDocumentEnvironment{sourcecode}{}
  {%
    \begingroup
    \ghsystem@readoptions{%
      \setlength\cnltx@sidebysidewidth
        {\dimexpr .45\columnwidth -\lst@xleftmargin -\lst@xrightmargin\relax}%
      \expanded{%
        \noexpand\lstset{
          style=cnltx,
          \ifboolexpe{ bool {cnltx@sidebyside} and not bool {cnltx@codeonly} }
            {linewidth=\cnltx@sidebysidewidth,}{}%
          \expandonce\cnltx@local@listings@options
        }%
      }%
      \XSIMgobblechars{2}%
    }%
  }
  {%
    \XSIMfilewritestop
    \cnltxcode[breakable]%
    \lstinputlisting[style=cnltx]{\jobname.tmp}%
    \endcnltxcode
  }

\RenewDocumentEnvironment{example}{}
  {%
    \begingroup
    \ghsystem@readoptions{%
      \setlength\cnltx@sidebysidewidth
        {\dimexpr .45\columnwidth -\lst@xleftmargin -\lst@xrightmargin\relax}%
      \expanded{%
        \noexpand\lstset{
          style=cnltx,
          \ifboolexpe{ bool {cnltx@sidebyside} and not bool {cnltx@codeonly} }
            {linewidth=\cnltx@sidebysidewidth,}{}%
          \expandonce\cnltx@local@listings@options
        }%
      }%
      \XSIMgobblechars{2}%
    }%
  }
  {%
    \XSIMfilewritestop
    \ifbool{cnltx@sidebyside}
      {%
        \cnltxcode
        \noindent
        \minipage[c]{\cnltx@sidebysidewidth}%
          \cnltx@pre@source@hook
          \lstinputlisting[style=cnltx] {\jobname.tmp}%
          \cnltx@after@source@hook
        \endminipage\hfill
        \minipage[c]{\cnltx@sidebysidewidth}%
          \cnltx@pre@example@hook
          \input {\jobname.tmp}%
          \cnltx@after@example@hook
        \endminipage
      }
      {%
        \cnltxcode[breakable]%
        \cnltx@pre@source@hook
        \lstinputlisting{\jobname.tmp}%
        \cnltx@after@source@hook
        \tcblower
        \cnltx@pre@example@hook
        \input {\jobname.tmp}%
        \cnltx@after@example@hook
      }%
    \endcnltxcode
  }

\RequirePackage[
  backend=biber,
  style=cnltx,
  sortlocale=en_US,
  indexing=cite]{biblatex}
\RequirePackage{csquotes,varioref}
\defbibheading{bibliography}{\section{References}}

\RequirePackage[biblatex]{embrac}[2012/06/29]
\ChangeEmph{[}[,.02em]{]}[.055em,-.08em]
\ChangeEmph{(}[-.01em,.04em]{)}[.04em,-.05em]

\ghsystem@add@version{2012-01-28}{3.0}
\ghsystem@add@version{2012/01/30}{3.0a}
\ghsystem@add@version{2012/02/05}{3.0c}
\ghsystem@add@version{2012/05/13}{3.3a}
\ghsystem@add@version{2012/05/18}{3.3b}
\ghsystem@add@version{2012/05/18}{3.3c}
\ghsystem@add@version{2012/07/24}{3.3d}
\ghsystem@add@version{2013/02/19}{3.5a}
\ghsystem@add@version{2013/07/06}{4.0}
\ghsystem@add@version{2013/12/13}{4.0a}
\ghsystem@add@version{2014/01/09}{4.2e}
\ghsystem@add@version{2014/04/08}{4.5}
\ghsystem@add@version{2014/04/13}{4.5a}
\ghsystem@add@version{2014/06/30}{4.5b}
\ghsystem@add@version{2014/08/08}{4.6}
\ghsystem@add@version{2016/01/15}{4.7}
\ghsystem@add@version{2016/07/16}{4.8}
\ghsystem@add@version{2019/09/30}{4.8a}
\ghsystem@add@version{2020/01/16}{4.8b}
\ghsystem@add@version{2020/02/17}{4.8c}

\endinput
