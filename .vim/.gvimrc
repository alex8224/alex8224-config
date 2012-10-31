
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

set sw=4
set tabstop=4
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:pylint_onwrite = 0
" set list
" set listchars=tab:..

set cscopequickfix=s-,c-,d-,i-,t-,e-

"set cursorline
set laststatus=2

" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L] 
set statusline=%F%m%r%h%w\ type=%y\ %l行的第%v个字\ 共%L行\ %p%%

let g:vimim_toggle = 'pinyin,sogou' 
let g:pyflakes_use_quickfix =0
" if has("gui_win32")
    " set gfn=文泉驿等宽微米黑\ 11
    set gfn=Consolas\ 11
    set guifontwide=微软雅黑
	"exec 'set guifontwide='.iconv('微软雅黑', &enc, 'gbk').':h12'
" endif

" map <silent> <F5> :TlistToggle<cr> 
map <silent> <F6> :call ToggleEncoding()<cr>
map <silent> <F7> :make<cr> <F6>
map <silent> <F4> :NERDTreeToggle<cr>
map <silent> <F3> :NERDTree<cr>
map <silent> <A-z> :call ToggleMaxWin()<cr>
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
map <silent> <F6> :!svn commit -m ""<cr>
map <silent> <C-f> :FufFile<cr>
inoremap <C-A> <Esc>^i
inoremap <C-E> <Esc>$i

"mo  :q" ve to next word
"inoremap <C-A-W> <Esc>wwwi
"inoremap <C-B><C-W> <Esc>bi


let g:tagbar_ctags_bin="/home/alex/bin/bin/ctags"
let g:tagbar_width=38

" map<silent> <c-m> :call libcall("tune","maxVIM","")<cr>

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
let g:haddock_browser = "/home/alex/storage/download/software/firefox/firefox" 

" autocmd FileType python compiler pylint
autocmd BufRead *.vala,*.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala,*.vapi setfiletype vala

" Disable valadoc syntax highlight
"let vala_ignore_valadoc = 1

" Enable comment strings
let vala_comment_strings = 1

" Highlight space errors
let vala_space_errors = 1
" Disable trailing space errors
"let vala_no_trail_space_error = 1
" Disable space-tab-space errors
let vala_no_tab_space_error = 1

" Minimum lines used for comment syncing (default 50)
"let vala_minlines = 120
"pylint settings
" let g:pylint_onwrite = 1
" let g:pylint_show_rate = 1
" let g:pylint_cwindow = 1

"rope settings
let ropevim_vim_completion=1
let ropevim_extended_complete=1

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd BufNewFile,BufRead *.rst map <silent> <F7> :CmdShell sphinx-build c:\source c:\build<cr><a-m>q
autocmd BufReadPre * :set relativenumber
autocmd BufRead *.class call Jad()
autocmd! BufRead  build.xml compiler ant
autocmd! BufRead  *.java compiler ant
autocmd! VimEnter * call Onload()
autocmd! BufRead,BufWrite * call OnUnload()
autocmd! BufWritePost * call FileWritePostHandler()
au Bufenter *.hs compiler ghc
" autocmd BufWritePost *.js call Tossh()
" autocmd BufWritePost *.htm call Tossh()
" autocmd BufWritePost *.css call Tossh()
" autocmd VimEnter * call AfterVimEnter()
" autocmd VimLeave * call AfterVimLeave()
" autocmd BufWinEnter  * execute "normal \<a-z>"
 " autocmd FileType python compiler pylint

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
    execute "NERDTree"
    execute "wincmd l"
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

