
" Vim Compiler File
" Compiler:	reStructText sphinx-build 
" Maintainer:	Alex zhang<alex8224@gmail.com>
" Last Change:	21/09/2012
"

if exists("current_compiler") && current_compiler == "rst"
  finish
endif
let current_compiler = "rst"

set CompilerSet errorformat&
execute 'set CompilerSet makeprg=make html'
"
"let s:scriptname = "rst.vim"
"
"if exists(":CompilerSet")!=2
"    command -nargs=* CompilerSet setlocal <args>
"endif
"
" set makeprg (for quickfix mode) 

"execute 'setlocal makeprg=' . g:ghc .'\ -e\ :q\ %'
"execute 'setlocal makeprg=' . g:ghc .'\ --make\ %'

" quickfix mode: 
" fetch file/line-info from error message
" TODO: how to distinguish multiline errors from warnings?
"       (both have the same header, and errors have no common id-tag)
"       how to get rid of first empty message in result list?
setlocal errorformat=
                    \%-Z\ %#,
                    \%W%f:%l:%c:\ Warning:\ %m,
                    \%E%f:%l:%c:\ %m,
                    \%E%>%f:%l:%c:,
                    \%+C\ \ %#%m,
                    \%W%>%f:%l:%c:,
                    \%+C\ \ %#%tarning:\ %m,

" oh, wouldn't you guess it - ghc reports (partially) to stderr..
setlocal shellpipe=2>
