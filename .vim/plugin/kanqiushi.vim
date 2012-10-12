"
"增加缓冲区文件拷贝到剪贴板的功能
"
" 开新的百科缓冲区
function! SetBaiKeBuffer()
let bkbuffloaded=bufloaded("baike")
if !bkbuffloaded
	execute "sp baike"
	execute "normal \Z"
else
	while 1
		execute "normal \<c-w>w"
		let currBuff=bufname("%")
		if currBuff == "baike"
			execute "normal \Z"
			break
		endif
	endwhile

endif
endfunction

function! InitVim()
	execute "normal \'j"
endfunction

"调用特定的关联程序打开指定的文件
function! ShellExecute()
let b:fileLink=iconv(getline("."),"utf-8","gbk")
python << EOF
import vim
import win32api,win32con
fullPath=vim.eval("b:fileLink")
try:
	rCode=win32api.ShellExecute(0,"open",fullPath,None,None,win32con.SW_SHOWNA)
	vim.command("call AddsearchKey(g:searchPattern)")
except:
	vim.command("echohl ErrorMsg| echo \"没有个设置关联的程序设置用于打开此文件!\" | echohl None")
	
EOF
endfunction

function! KanXiaoHua(url,page)   
call SetBaiKeBuffer()
let b:baikeurl=a:url
let b:baikepage=a:page
if a:page == ""
	let b:currbkpage=1
	let b:baikeurl=b:baikeurl."/page/".b:currbkpage
else
	let b:currbkpage=b:currbkpage+1
	let b:baikeurl=b:baikeurl."/page/".b:currbkpage
endif
echo "访问 ".b:baikeurl."中，请稍后......"
python << EOF   

import vim
import win32com.client
import time

def getBaiKe():
	browser=win32com.client.Dispatch("InternetExplorer.Application")
	browser.Visible=False
	url=vim.eval("b:baikeurl")	
	browser.Navigate(url)
	while True:
		try:
			if browser.Document:
				break
		except:
			time.sleep(0.5)
			continue

	time.sleep(10)
	document=browser.Document
	bodyContainer=document.getElementById("center-container")
	qiuShiBody=""
	if bodyContainer:
		qiushiNodes=bodyContainer.childNodes
		if qiushiNodes and qiushiNodes.length>0:
			for qiushiIndex in xrange(qiushiNodes.length):
				if qiushiNodes[qiushiIndex].tagName == "DIV" and qiushiNodes[qiushiIndex].id.startswith("article"):
					tmpStr=qiushiNodes[qiushiIndex].innerText.encode("utf-8").replace("\r",'')
					strList=tmpStr.split("\n")
					for line in strList:
						vim.current.buffer.append(line)
				vim.current.buffer.append("\n")		

	try:
		browser.Quit()
		del browser
	except:
		pass

vim.current.buffer[:]=None
getBaiKe()
EOF   
endfunction   

function! MinWin()
while winheight(0)>1
	execute "normal \<c-w>-"
endwhile
endfunction

function! FindBuffer()
if !bufloaded("cmdShell")
	execute "bo sp cmdShell"
	while winheight(0)>10
		execute "normal \<c-w>-"
	endwhile
else
	while 1
		execute "normal \<c-w>w"
		if bufname("%") == "cmdShell"
			while winheight(0)<10
				execute "normal \<c-w>+"
			endwhile
			break
		endif
	endwhile
endif

setlocal modifiable
setlocal buftype=nofile
setlocal bufhidden=delete
setlocal noswapfile
setlocal nowrap
setlocal nobuflisted
"
" Use fixed height for the MRU window
setlocal winfixheight
"
" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

" Setup the cpoptions properly for the maps to work
let old_cpoptions = &cpoptions
set cpoptions&vim

" Create mappings to select and edit a file from the MRU list
" move to _vimrc
 nnoremap <buffer> <silent> <CR> :call OpenFileInVim()<cr>
 nnoremap <buffer> <silent> x :call ShellExecute()<cr>
 nnoremap <buffer> <silent> e :call OpenFileInExplorer()<cr>
 nnoremap <buffer> <silent> q :bd!<cr>
 nnoremap <buffer> <silent> c :call ClearBuffer()<cr>
 nnoremap <buffer> <silent> t :call ToDirInDos()<cr>

" Restore the previous cpoptions settings
let &cpoptions = old_cpoptions
  
endfunction

"窗体透明函数
function! TransVimWin(op)  
  
if !exists("g:alphaValue")  
    let g:alphaValue=240  
endif  
  
if !exists("g:stepValue")  
    let g:stepValue=5  
endif  
  
let g:alphaOp=a:op  
  
python << EOF  
  
import win32gui,win32con  
import vim  
  
def setWindowTransp():
	hwnd=win32gui.FindWindow("Vim",None)  
	if hwnd:  
		s=win32gui.GetWindowLong(hwnd,win32con.GWL_EXSTYLE)  
		win32gui.SetWindowLong(hwnd, win32con.GWL_EXSTYLE, s|win32con.WS_EX_LAYERED)  
		opCode=vim.eval("g:alphaOp")  
		alphaValue=int(vim.eval("g:alphaValue"))  
		stepValue=int(vim.eval("g:stepValue"))  
	  
		if opCode=="plus":  
		    alphaValue=alphaValue+stepValue  
		else:  
		    alphaValue=alphaValue-stepValue  
		  
		if alphaValue<200 or alphaValue>255:  
		    vim.command("echo 'AlphaValue exceed!'")  
		else:  
		    vim.command("let g:alphaValue="+str(alphaValue))  
		    win32gui.SetLayeredWindowAttributes(hwnd, 0, alphaValue,win32con.LWA_ALPHA)  
  
setWindowTransp()  
  
EOF  
endfunction  

" 命令提示包装函数
function! WrapDj(cmdText)
	if !a:cmdText
		let selected=input("Django助手提示你选择操作:[project|app|syncdb]:")
		call Dj(selected)
	endif	
endfunction

" Django命令执行函数
function! Dj(cmdText)

	if !exists("g:djangoCmdList")
		let g:djangoCmdList={"syncdb":"manage.py syncdb","project":"django-admin.py startproject","app":"django-admin.py startapp"}
	endif

	if !exists("g:scriptPath")
		let g:scriptPath="C:\\Python25\\Lib\\site-packages\\django\\bin\\"
	endif

	if !exists("g:pyPath")
		let g:pyPath="C:\\Python25\\python.exe "
	endif

	let b:completeCmd=g:pyPath.g:scriptPath
	let trueCmd=""
	if a:cmdText =="project"
		let projectName=input("请输入要创建 DjangoProject 的名称:")
		if projectName!=""
			let trueCmd=b:completeCmd.g:djangoCmdList["project"]." ".projectName
		endif
		
	elseif a:cmdText =="app"
		let appName=input("请输入要创建 DjangoApp 的名称:")
		if appName!=""
			let trueCmd=b:completeCmd.g:djangoCmdList["app"]." ".appName
		endif
	elseif a:cmdText == "syncdb"
		if findfile("manage.py")=="manage.py"
			let confirm=input("你确定要同步数据库么？(y/n)")
			if confirm == "y"
				let trueCmd=g:pyPath." ".getcwd()."\\".g:djangoCmdList["syncdb"]
			endif
		else
			echo "当前目录没有 manage.py 文件,不能执行syncdb!"
		endif
	endif
	if trueCmd!=""
		call ExecuteCmd(trueCmd)
		" echo trueCmd
	endif
endfunction

"在新的线程里面执行程序
function! ExecuteCmdNoResult(cmdText)
let b:cmdName=a:cmdText
python << EOF
import vim
import threading
import subprocess

class ExecuteThread(threading.Thread):
    def __init__(self,cmdline):
        threading.Thread.__init__(self)
	self.cmdLine=cmdline;
    def run(self):
	subprocess.Popen(self.cmdLine,shell=True)    

ExecuteThread(vim.eval("b:cmdName").replace("cmd","start cmd").replace("python","start python")).start()

EOF

endfunction

" 通用命令执行函数
function! ExecuteCmd(cmdText)
call FindBuffer()
let b:cmdName=a:cmdText
python << EOF
import vim
import subprocess
p=subprocess.Popen(vim.eval("b:cmdName"),shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
out,err=p.communicate()

if p.returncode==0:
		response=out.replace("\r","")
		lines=response.split("\n")
		for line in lines:
				vim.current.buffer.append(line)
else:
		response=err.replace("\r","")
		lines=response.split("\n")
		for line in lines:
				vim.current.buffer.append(line)

EOF

setlocal nomodifiable
endfunction

function! AutoCmds(A,L,P)
	let b:useableCmds=['dir','ping','netstat','nmap','rm','winscp.exe','securecrt']
	return b:useableCmds
endfunction

function! Searchcomplete(ArgLead,L,P)
	let cList=[]
	for index in g:searchList
		if index =~? a:ArgLead
			call add(cList,index)
		endif
	endfor
	return cList
endfunction


"从vim中访问everything中的功能，实现文件的快速搜索
function! SearchFile(filePattern)
	let g:pyeverything="c:\\pythonscript\\search.py"
	let g:searchPattern=a:filePattern
	execute "CmdShell python ".g:pyeverything." ".iconv(a:filePattern,"utf-8","gbk")
endfunction

"在vim缓冲区中打开当前文件
function! OpenFileInVim()
	let g:currselectfile=getline(".")
	execute "normal \<c-w>k"
	let g:currselectfile
	execute "e! ".g:currselectfile
endfunction

"在资源管理器中打开vim选中的文件
function! OpenFileInExplorer()
	let b:currline=iconv(getline("."),"utf-8","gbk")
	execute "CmdShell explorer /select,".b:currline
endfunction

"删除临时缓冲区的内容
function! ClearBuffer()
	if bufname("%") == "cmdShell"
		setlocal modifiable
		execute "normal ggvG$d\<ESC>"
		setlocal nomodifiable
	endif
endfunction

"在dos中进入某个指定的目录
function! ToDirInDos()
	let b:tmpfilename=iconv(getline("."),"utf-8","gbk")
	if isdirectory(b:tmpfilename)
		execute "Cmd cmd.exe /K cd /d  ".b:tmpfilename
	else
		let patharray=split(getline("."),"\\")
		let fullpath=''
		for aIndex in range(len(patharray)-1)
			let fullpath=fullpath.patharray[aIndex]."\\"
		endfor
		execute "Cmd cmd.exe /K cd /d  ".iconv(fullpath,"utf-8","gbk")
	endif
endfunction

"反编译选中的CLASS文件到当前缓冲区
function! Jad()
	let g:jadpath="E:\\cordys_zxq\\software\\XJad\\Jad.exe -p -s .java "
	let currfile=expand("%")
	execute "!".g:jadpath.'"'.iconv(currfile,"utf-8","gbk").'"'." >c:\\_tmp.java"
	execute "bd!"
        execute "e c:\\_tmp.java"
	execute "set ft=java"
endfunction


" 定义命令
command! -nargs=0 JOKE :call KanXiaoHua("http://www.qiushibaike.com/groups/2/latest","")
command! -nargs=0 NEXTJOKE :call KanXiaoHua("http://www.qiushibaike.com/groups/2/latest","N")
command! -nargs=0 BESTJOKE :call KanXiaoHua("http://www.qiushibaike.com/groups/2/hottest/day","")
command! -nargs=0 NEXTBESTJOKE :call KanXiaoHua("http://www.qiushibaike.com/groups/2/hottest/day","N")
command! -nargs=1  -complete=customlist,AutoCmds CmdShell :call ExecuteCmd(<q-args>)
command! -nargs=1  Cmd :call ExecuteCmdNoResult(<q-args>)
command! -nargs=?  DJANGO :call WrapDj(<q-args>)
command! -nargs=1  -complete=customlist,Searchcomplete Searchfile :call SearchFile(<q-args>)
