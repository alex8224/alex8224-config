
"自动给当前行加包围字符
function! RoundBy(roundChar)
	let currLine=getline(".")
	let firstCharPos=match(currLine,"[a-zA-Z0-9]")

	if firstCharPos<0 
		let firstCharPos=0
	endif

	if a:roundChar =~ "[" || a:roundChar =~ "{" || a:roundChar =~ "("
		let newLine=strpart(currLine,0,firstCharPos).a:roundChar[0].strpart(currLine,firstCharPos).a:roundChar[1]
		call setline(".",newLine)
	else
		if a:roundChar =~ """
			if currLine =~ """
				"自动转义字符串
				let currLine=substitute(currLine,"\"","\\\\\"","g")	
			endif
			let newLine=strpart(currLine,0,firstCharPos).a:roundChar[0].strpart(currLine,firstCharPos).a:roundChar[1]
			call setline(".",a:roundChar[0].currLine.a:roundChar[1])
		endif
	endif
endfunction

function! MarkText(action,start,end)
	if visualmode() =="v"
		let lineText=getline(line("."))
		let newList=[]
		for c in range(len(lineText))
			call add(newList,lineText[c])
		endfor
		let newVstr=join(insert(insert(newList,a:action[0],a:start-1),a:action[1],a:end),"")
		call setline(".",newVstr)
		call cursor(line("."),a:start)
	endif
endfunction

"自动扩展成函数
imap  <a-e>( <ESC>:call RoundBy("()")<cr>^i
imap  <a-e>" <ESC>:call RoundBy("\"\"")<cr>^i
imap  <a-e>{ <ESC>:call RoundBy("{}")<cr>^i
imap  <a-e>[ <ESC>:call RoundBy("[]")<cr>^i
vmap <silent> ( :call MarkText("()",col("'<"),col("'>"))<cr>
vmap <silent> [ :call MarkText("[]",col("'<"),col("'>"))<cr>
vmap <silent> { :call MarkText("{}",col("'<"),col("'>"))<cr>
vmap <silent> " :call MarkText("\"\"",col("'<"),col("'>"))<cr>
" vmap <silent> < :call MarkText("<>",col("'<"),col("'>"))<cr>

