"
" 
"

if exists("g:triggerloaded")
    finish
else
    let g:triggerloaded=1
endif

function! ReloadMyNginx()
    execute "Cmd renginx.sh"
endfunction

function! FileWritePostHandler()
    let s:currfile = expand("%:p")
    if s:currfile == "/home/alex/bin/openresty/nginx/default\.conf"
        call ReloadMyNginx()
    endif

endfunction
