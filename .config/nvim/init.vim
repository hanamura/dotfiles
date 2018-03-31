" plug
" ====

call plug#begin('~/.local/share/nvim/plugged')

" nerdtree
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle']}

" edit
Plug 'Lokaltog/vim-easymotion'
Plug 'kana/vim-smartword'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tyru/caw.vim'
Plug 'w0rp/ale'

" syntax
Plug 'cakebaker/scss-syntax.vim', {'for': ['scss']}
Plug 'elzr/vim-json', {'for': ['json']}
Plug 'jwalton512/vim-blade', {'for': ['blade']}
Plug 'kchmck/vim-coffee-script', {'for': ['coffee']}
Plug 'othree/yajs.vim', {'for': ['javascript']}

" utility
Plug 'editorconfig/editorconfig-vim'
Plug 'thinca/vim-qfreplace'
Plug 'tpope/vim-fugitive'

" colorscheme
Plug 'morhetz/gruvbox'

" ctrlp
Plug 'ctrlpvim/ctrlp.vim'
Plug 'endel/ctrlp-filetype.vim'
Plug 'mattn/ctrlp-ghq'

" completion
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet.vim'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }

call plug#end()

" preferences
" ===========

language en_US

set autoindent
set autoread
set breakindent
set cindent
set cursorline
set expandtab
set hidden
set ignorecase
set inccommand=split
set list
set listchars=tab:▸-,trail:-
set number
set scrolloff=5
set shiftwidth=2
set smartcase
set smartindent
set softtabstop=2
set tabstop=2

let mapleader=" "

" colorscheme
set background=dark
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" deoplete
let g:deoplete#enable_at_startup=1
let g:deoplete#ignore_sources=get(g:, 'deoplete#ignore_sources', {})
let g:deoplete#ignore_sources.php=['omni']

" neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: "\<TAB>"
let g:neosnippet#snippets_directory='~/.snippets'

" nerdtree
let g:NERDTreeShowHidden=1
let g:NERDTreeShowBookmarks=1
let g:NERDTreeIgnore=[
      \ '.lock$[[file]]',
      \ '\~$',
      \ '^.DS_Store$[[file]]',
      \ '^.bundle$[[dir]]',
      \ '^.git$[[dir]]',
      \ '^.gitmodules$[[file]]',
      \ '^.sass-cache$[[dir]]',
      \ '^.vagrant$[[dir]]',
      \ '^node_modules$[[dir]]',
      \ '^npm-debug.log$[[file]]',
      \ '^package-lock.json$[[file]]',
      \ '^vendor$[[dir]]',
      \ ]
nmap <silent> <C-t> :NERDTreeToggle<CR>
vmap <silent> <C-t> <Esc>:NERDTreeToggle<CR>
omap <silent> <C-t> :NERDTreeToggle<CR>
cmap <silent> <C-t> <C-u>:NERDTreeToggle<CR>

" ctrlp
let g:ctrlp_map='<C-l>'
let g:ctrlp_cmd='CtrlP'
let g:ctrlp_working_path_mode='ra'
let g:ctrlp_extensions=[
      \ 'filetype',
      \ 'ghq',
      \ ]
let g:ctrlp_show_hidden=1
let g:ctrlp_prompt_mappings={
      \ 'PrtSelectMove("j")':   ['<c-n>', '<c-j>', '<down>'],
      \ 'PrtSelectMove("k")':   ['<c-p>', '<c-k>', '<up>'],
      \ 'PrtHistory(-1)':       [],
      \ 'PrtHistory(1)':        [],
      \ 'AcceptSelection("e")': ['<c-e>', '<cr>', '<2-LeftMouse>'],
      \ 'PrtCurEnd()':          [],
      \ 'PrtCurRight()':        ['<right>'],
      \ 'PrtExit()':            ['<esc>', '<c-c>', '<c-g>', '<c-l>'],
      \ }
let g:ctrlp_match_window='bottom,order:btt,min:1,max:30,results:30'
let g:ctrlp_custom_ignore={
      \ 'dir':  '\v[\/](\.(cache|git|hg|svn|sass-cache|jekyll)|node_modules|bower_components|wp-content)$',
      \ 'file': '\v\.(DS_Store|eot|gif|ico|lock|jar|jpeg|jpg|png|sqlite|swf|ttf|webp|woff|woff2|zip)$',
      \ }
let g:ctrlp_max_files=30000
let g:ctrlp_user_command=[
      \ '.git',
      \ 'cd %s && git ls-files | grep -v "\.\(eot\|gif\|ico\|lock\|jar\|jpeg\|jpg\|pdf\|png\|sqlite\|swf\|ttf\|webp\|woff\|woff2\|zip\)$"',
      \ 'find %s -type f',
      \ ]

" easymotion
let g:EasyMotion_do_mapping=0
let g:EasyMotion_enter_jump_first=1
let g:EasyMotion_space_jump_first=1
nmap s <Plug>(easymotion-s2)
xmap s <Plug>(easymotion-s2)
nmap g/ <Plug>(easymotion-sn)
xmap g/ <Plug>(easymotion-sn)
omap g/ <Plug>(easymotion-tn)

" emmet
let g:user_emmet_leader_key='<c-k>'

" ale
let g:ale_lint_on_text_changed='never'
let g:ale_linters={
      \ 'javascript': ['eslint'],
      \ 'php': ['php', 'phpcs'],
      \ 'scss': ['stylelint'],
      \ }

" json
let g:vim_json_syntax_conceal=0

" smartword
map b <Plug>(smartword-b)
map e <Plug>(smartword-e)
map w <Plug>(smartword-w)

" other keymaps
nn <Esc><Esc> :noh<CR>

nn <silent> gj j
vn <silent> gj j

nn <silent> gk k
vn <silent> gk k

nn <silent> j gj
vn <silent> j gj

nn <silent> k gk
vn <silent> k gk

nn <Leader>P "*P
vn <Leader>P "*P

nn <Leader>p "*p
vn <Leader>p "*p

nn <Leader>y "*y
vn <Leader>y "*y

nn <Leader>yy "*yy
vn <Leader>yy "*yy

no <silent> gp "0p
no <silent> gP "0P

nn <Leader>w :w<CR>

nn ; :
vn ; :

nn : q:a
vn : q:a

" autocmd
" =======

augroup checktime
  autocmd!
  autocmd WinEnter * checktime
augroup END

augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost *grep* cwindow
augroup END

augroup filetypes
  autocmd!

  " json
  autocmd BufNewFile,BufRead .babelrc setlocal filetype=json
  autocmd BufNewFile,BufRead .eslintrc setlocal filetype=json
  autocmd BufNewFile,BufRead .stylelintrc setlocal filetype=json
  autocmd BufNewFile,BufRead .tern-project setlocal filetype=json

  " htmldjango
  autocmd BufRead,BufNewFile *.twig set filetype=htmldjango
  autocmd BufRead,BufNewFile *.nunj set filetype=htmldjango
  autocmd BufRead,BufNewFile *.njk set filetype=htmldjango
augroup END
