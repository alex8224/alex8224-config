"
"主要目标：
"
"   在安装了TortoiseSVN的机器上添加vim中基本命令的支持
"   在安装了putty客户端的机器上添加通过SSH上传当前文件到远程的支持
"

if exists("g:svnloaded")
	finish
else
	let g:svnloaded=1
endif

if exists(":Cmd")!=2
	echohl ErrorMsg | echo "您的VIM不支持异步命令行，该功能无法使用！" | echohl None
	finish
endif

" let g:localdir="D:\\eclipse\\workspace\\Test\\javascript"
" let g:linuxpath="/opt/Cordys/Web/SouthwardFund/TZ"

let g:svnCmd="svn"

function! Svncommand(cmd)
    let curDir=expand("%:h")
    if curDir =="."
        let curDir=getcwd()
    endif
    if a:cmd == "commit"
        execute "CmdShell ".g:svnCmd." ".a:cmd " -m '' >>svnlog"
        echo "svn commit ok!"
    else
        execute "CmdShell ".g:svnCmd." ".a:cmd
    endif

endfunction

function! ToCurDir()
	let curDir=expand("%:h")
	if curDir =="."
		let curDir=getcwd()
	endif

	execute "cd ".curDir
endfunction

function! GetDirFromAbsPath(fpath)
	let index=stridx(a:fpath,".")
	while index>0
		if a:fpath[index]=="\\"
			break
		endif
		let index=index-1
	endwhile
	return strpart(a:fpath,0,index)
endfunction

function! GetFsuffix(cwd,fpath)
	let index=0
	let cwdpath=len(a:cwd)
	while index<len(a:fpath)
		if(a:fpath[index]!=a:cwd[index])
			break
		endif
		let index=index+1
	endwhile
	if(index<cwdpath)
		return "#"
	else
		return strpart(a:fpath,index)[1:]
	endif
endfunction

function! Tossh()
	let currFile=expand("%:p")
	if !exists("g:localdir")
		echohl ErrorMsg | echo "未设置本地上传目录，请设置后使用!" | echohl None
		return
	endif

	if !exists("g:linuxpath")
		echohl ErrorMsg | echo "未设置ssh服务器的路径，请设置后使用!" | echohl None
		return
	endif

	let fsuffix=GetFsuffix(g:localdir,GetDirFromAbsPath(currFile))
	if(fsuffix=="#")
		echo "当前文件的当前目录与设置的目录不一致" 
		return
	endif

	echo "文件".expand("%:f")."已上传"
	" echo "Cmd pscp -batch -q -pw qiu_2010sep ".currFile." root@172.16.18.14:".g:linuxpath."/".fsuffix."/".expand("%:t")
	execute "Cmd pscp -batch -q -pw qiu_2010sep ".currFile." root@172.16.18.14:".g:linuxpath."/".fsuffix."/".expand("%:t")
endfunction

function! Tosshd()
	if exists("g:linuxpath")
		let confirm=input("你确定要上传目录 ".getcwd()." 到服务器?(y/n)")
		if confirm=="y"
			execute "Cmd pscp -batch -q -pw qiu_2010sep -r ".getcwd()."\\ root@172.16.18.14:".g:linuxpath
			echo "目录 ".getcwd()." 已上传至 ".g:linuxpath
		endif
	else
		echohl ErrorMsg | echo "未设置ssh服务器的路径，请设置后使用!" | echohl None
	endif
endfunction

function! ToExplorerThis()
	let curDir=expand("%:h")
	if curDir =="."
		let curDir=getcwd()
	endif

    " for windows 
    " execute "Cmd explorer ".curDir
    " for ubuntu
	execute "Cmd nohup nautilus --no-desktop ".curDir . " >>/dev/null"
endfunction

command! -nargs=0 SvnC :call Svncommand("commit")
command! -nargs=0 SvnU :call Svncommand("update")
command! -nargs=0 SvnR :call Svncommand("revert")
command! -nargs=0 SvnD :call Svncommand("diff")
command! -nargs=0 SvnL :call Svncommand("log")
command! -nargs=0 SvnAdd :call Svncommand("add")
command! -nargs=0 To :call ToCurDir()
command! -nargs=0 ToG :call ToExplorerThis()
command! -nargs=0 Up :call Tossh()
command! -nargs=0 Upd :call Tosshd()

