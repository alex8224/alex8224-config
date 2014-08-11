"
" webqqclient for vim
" 
"

if exists("g:webqqclient")
    finish
else
    let g:webqqclient=1
endif


function! SendMessage(to, message)

let b:towho = a:to
let b:textmessage = a:message
python << EOF

import vim
from webqqclient import Chat,MESSAGE
towho = vim.eval("b:towho")
textmessage = vim.eval("b:textmessage")
Chat().sendto(MESSAGE, towho, textmessage)
EOF

endfunction

function! SendImageMessage(to, imagefile)
let b:towho = a:to
let b:imagefile = a:imagefile

python << EOF
import vim
from webqqclient import Chat,IMAGEMESSAGE
towho = vim.eval("b:towho")
imagefile = vim.eval("b:imagefile")
Chat().sendto(IMAGEMESSAGE, towho, imagefile)
EOF
endfunction

command! -nargs=* Send :call SendMessage(<f-args>)
command! -nargs=* -complete=file SendIMG :call SendImageMessage(<f-args>)


