
set nocompatible
let &completeopt="menuone"

set diffexpr=MyDiff()
set go=
set nu
set ai
set ignorecase
" disable highlight search words
set nohls
" set color schema to Monokai
colo molokai
" set fdm=syntax
" set tab stop width
set expandtab
set tabstop=4
set shiftwidth=4
set relativenumber

" filetype plugin on
" filetype indent on
filetype plugin indent on

set fdm=marker
set noswapfile
set nobackup
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,latin1
set helplang=cn
" set t_Co=256

set sw=4
set tabstop=4
let g:pylint_onwrite = 0
" set list
" set listchars=tab:..

set cscopequickfix=s-,c-,d-,i-,t-,e-

let g:Powerline_symbols = 'fancy'

" if has("gui_win32")
	set gfn=文泉驿等宽微米黑
    set guifontwide=微软雅黑
	exec 'set guifontwide='.iconv('微软雅黑', &enc, 'gbk').':h12'
" endif

" map <silent> <F5> :TlistToggle<cr> 
map <silent> <F6> :call ToggleEncoding()<cr>
map <silent> <F7> :make<cr> <F6>
map <silent> <F4> :NERDTreeToggle<cr>
map <silent> <F3> :NERDTree<cr>
map <silent> tz :call ToggleMaxWin()<cr>
map <silent> <C-I> O<ESC>
map <silent> <A-h> :noh<cr>
map <silent> <c-2> :%s/\r//g<cr>
map <silent> <c-a> ggvG$
map <silent> <a-i> <c-a>=
map <silent> <A-m> :call MinWin()<cr>
map <silent> <A-d> :DJANGO<cr>
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
nmap <silent> <F5> :TagbarToggle<CR>
nmap <silent> <F6> :shell<CR>
nmap <silent> <C-s> :w<cr>
inoremap <silent> <C-s> <Esc>:w<cr>li
map <silent> m :q<cr>

inoremap <C-A> <Esc>^i
inoremap <C-E> <Esc>$i


inoremap <C-L> <Right>
inoremap <C-H> <Left>
inoremap <C-J> <Down>
inoremap <C-K> <Up>

"move to next word
inoremap <C-F> <Esc>wwwi

"move to prev word
inoremap <C-B> <Esc>bi

"del current char
inoremap <C-D>x <Esc>lxi

"del current word
inoremap <C-D>w <Esc>ldwi

"del current line
inoremap <C-D>l <Esc>ddi

"del content from x to line end
inoremap <C-D>e <Esc>lc$

"del content from x to line end
inoremap <C-D>a <Esc>lc^


let g:tagbar_ctags_bin="/home/alex/bin/bin/ctags"
let g:tagbar_width=38

" map <silent> <c-m> :call libcall("tune","maxVIM","")<cr>


"set supertab
let g:SuperTabMappingForward = "<tab>"
let g:SuperTabRetainCompletionType = 2
let g:SuperTabDefaultCompletionType = "<C-X><C-I>"

" set minibuffer
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1 

" set TList
let Tlist_Use_Right_Window=1
let Tlist_File_Fold_Auto_Close=1

"set comment tool
let g:EnhCommentifyRespectIndent = 'yes'
let g:EnhCommentifyPretty = 'yes'
let g:EnhCommentifyAlignRight = 'yes'

"set zencoding
let g:user_zen_expandabbr_key = '<a-e>' 
let g:use_zen_complete_tag = 1 

"setting session file fullpath
let g:sessionName=$VIMRUNTIME."\\session"

autocmd FileType python compiler pylint

"pylint settings
let g:pylint_show_rate = 0
let g:pylint_onwrite = 0
let g:pylint_cwindow = 0
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd BufNewFile,BufRead *.rst map <silent> <F7> :CmdShell sphinx-build c:\source c:\build<cr><a-m>q
autocmd BufRead *.class call Jad()
autocmd! BufRead  build.xml compiler ant
autocmd! BufRead  *.java compiler ant
autocmd! BufWritePost * call TestHandler()
" autocmd! VimEnter * call Onload()
" autocmd! BufRead,BufWrite * call OnUnload()
" autocmd BufWritePost *.js call Tossh()
" autocmd BufWritePost *.htm call Tossh()
" autocmd BufWritePost *.css call Tossh()
" autocmd VimEnter * call AfterVimEnter()
" autocmd VimLeave * call AfterVimLeave()
" autocmd BufWinEnter  * execute "normal \<a-z>"
 " autocmd FileType python compiler pylint

function! TestHandler()
    call FileWritePostHandler()
endfunction

function! ToggleEncoding()
	if &enc == "utf-8"
		execute "set enc=cp936"
	else
		execute "set enc=utf-8"
	endif

endfunction

function! Onload()
    let s:filecontent=readfile("/home/alex/.vim/session")
    let s:currworkdir=s:filecontent[0]
    let s:currfile=s:filecontent[1]
    let s:x=s:filecontent[2]
    let s:y=s:filecontent[3]
    execute "cd ".s:currworkdir
    " execute "NERDTree"
    " execute "wincmd l"
    execute "edit ".s:currfile
    call cursor([s:x,s:y])
    execute "filetype detect"
endfunction

function! OnUnload()
    let s:currworkdir=getcwd()
    let s:currfile=expand("%f")
    let s:cursorpos=getpos(".")
    call writefile([s:currworkdir,s:currfile,s:cursorpos[1],s:cursorpos[2]],"/home/alex/.vim/session")
endfunction

function! MyDiff()
	let opt = '-a --binary '
	if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	let arg1 = v:fname_in
	if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	let arg2 = v:fname_new
	if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	let arg3 = v:fname_out
	if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	let eq = ''
	if $VIMRUNTIME =~ ' '
		if &sh =~ '\<cmd'
			let cmd = '""' . $VIMRUNTIME . '\diff"'
			let eq = '"'
		else
			let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
		endif
	else
		let cmd = $VIMRUNTIME . '\diff'
	endif
	silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

