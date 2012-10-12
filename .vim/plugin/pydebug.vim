"
"主要目标：
" 调试python代码
"
"

if exists("g:pydebug")
	finish
else
	let g:pydebug=1
endif

let g:pydebugCmd="winpdb"

function! DebugThis()
	let curFile=expand("%:f")
	execute "Cmd ".g:pydebugCmd." -c " .curFile
endfunction

function! DebugFile(file)
	execute "Cmd ".g:pydebugCmd." -c " .a:file
endfunction

command! -nargs=0 Dcpy :call DebugThis()
command! -nargs=1 Dpy :call DebugFile(<q-args>)
