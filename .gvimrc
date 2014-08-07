" size
set lines=80
set columns=100

" zenkaku space
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" highlight cursor
set cursorline
augroup cch " only current window
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END
hi clear CursorLine
hi CursorLine gui=underline
hi CursorLine ctermfg=black guibg=black
set lazyredraw
set ttyfast
