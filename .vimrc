call plug#begin('~/.vim/plugged')
Plug 'vim-scripts/SyntaxRange'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'maverickg/stan.vim'
Plug 'editorconfig/editorconfig-vim'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kristijanhusak/vim-hybrid-material'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/LustyExplorer'
Plug 'scrooloose/nerdtree'

Plug '~/MEGA/Software/vim-repl'

Plug 'kana/vim-operator-user'
Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'rhysd/vim-operator-surround'

Plug 'tommcdo/vim-exchange'
Plug 'dkprice/vim-easygrep'
Plug 'tpope/vim-commentary'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mhinz/vim-startify'
Plug 'dbakker/vim-projectroot'
Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'houtsnip/vim-emacscommandline'
Plug 'simnalamburt/vim-mundo'
call plug#end()

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" general interface settings

let mapleader = ","
let maplocalleader = "_"

set visualbell
set timeoutlen=1200
set hidden

set mouse=a
set lazyredraw
set history=1000
set wildmode=list:longest
set backspace=indent,eol,start

set hlsearch incsearch
nnoremap <Leader>? :noh<cr>
nnoremap <Leader>R :syntax sync fromstart<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" appearance

set ignorecase 
set smartcase

set number
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

" available at https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/SourceCodePro/Regular/complete
set guifont=SauceCodePro_Nerd_Font_Mono:h12

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" undo history
set undofile

" uses a specific project directory when were in a project to avoid adding
" lots of extra files
function! SetupUndo()
  let l:dir = projectroot#get(expand('%'))
  if empty(l:dir)
    let &l:undodir=expand('%:p:h')
  else
    let &l:undodir=l:dir.'/.undo/'
    call system('mkdir ' . &l:undodir)
  endif
endfunction

augroup UndoHistory
  au!
  au BufEnter * call SetupUndo()
augroup END

nnoremap <Leader>U :MundoToggle<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" terminal configuration
tnoremap ƒ <esc>f
tnoremap ∫ <esc>b
tnoremap ∂ <esc>d
tnoremap <a-backspace> <esc><backspace>

nmap ,.. <Plug>(repl-send-text)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" surround operator
map <silent>Sa <Plug>(operator-surround-append)
map <silent>Sd <Plug>(operator-surround-delete)
map <silent>Sr <Plug>(operator-surround-replace)

nmap <silent>Saa <Plug>(operator-surround-append)<Plug>(textobj-anyblock-a)
nmap <silent>Sdd <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
nmap <silent>Srr <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" sneak commands
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
map <Leader>, <Plug>Sneak_,

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" multiple cursor settings
let g:multi_cursor_quit_key = '<C-g>'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentation/editorconfig

augroup Appearance
  au BufWinEnter * set cc=81
augroup END
set autoindent
set smartindent

set softtabstop=2
set shiftwidth=2
set expandtab

let g:EditorConfig_max_line_indicator = 'line'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set working directory

function! SetDirByProject(path)
  let l:dir = projectroot#get(a:path)
  if empty(l:dir)
    if !empty(a:path)
      execute "cd " . fnamemodify(a:path,":h")
    endif
  else
    execute "cd " . l:dir
  endif
endfunction

augroup WorkingDir
  au!
  au BufEnter * call SetDirByProject(expand('%'))
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" R configuration

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Julia configuration
let g:tagbar_type_julia = {
  \ 'ctagstype' : 'julia',
  \ 'kinds'     : ['a:abstract', 'i:immutable', 't:type', 
  \                'f:function', 'm:macro']
  \ }

augroup Julia
  au!
  au FileType julia set commentstring=#\ %s
  au FileType julia call SyntaxRange#Include('R\"\"\"', '\"\"\"','R', 'NonText')
  au FileType julia call SyntaxRange#Include('py\"\"\"', '\"\"\"','python', 'NonText')
augroup END

runtime macros/matchit.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Markdown configuration

augroup Markdown
  au!
  au FileType makrdown
  au FileType markdown call SyntaxRange#Include('```vim','```','vim','NonText')
  au FileType markdown call SyntaxRange#Include('```sh','```','sh','NonText')
  au FileType markdown call SyntaxRange#Include('```R','```','R','NonText')
  au FileType markdown call SyntaxRange#Include('```julia','```','julia','NonText')
  au FileType markdown call SyntaxRange#Include('```python','```','python','NonText')
  au FileType markdown call SyntaxRange#Include('```matlab','```','matlab','NonText')
augroup END

""""""""""""""""""""""""""""""""""""""""
" attempt #1 to add linting
"
" let g:default_julia_version = '0.6'

" " language server
" let g:LanguageClient_autoStart = 1
" let g:LanguageClient_serverCommands = {
" \   'julia': ['julia', '--startup-file=no', '--history-file=no', '-e', '
" \       using LanguageServer;
" \       server = LanguageServer.LanguageServerInstance(STDIN, STDOUT, false);
" \       server.runlinter = true;
" \       run(server);
" \   '],
" \ }

" nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>

""""""""""""""""""""""""""""""""""""""""
" attempt #2 to add linting

" if executable('julia')
  " augroup JuliaLSP
    " au!
    " au User lsp_setup call lsp#register_server({
      " \ 'name': 'julia-language-server',
      " \ 'cmd': {server_info->['julia --startup-file=no --history-file=no ' .
      " \         '-e using LanguageServer; ' .
      " \         'server = LanguageServer.LanguageServerInstance(STDIN, STDOUT, false);' .
      " \         'server.runlinter = true;' .
      " \         'run(server);'}
      " \ 'root_uri': {server_info->lsp#path_to_uri(projectroot#get(expand('%')))},
      " \ 'whitelist': ['julia']
      " \ })
  " augroup END
" endif

" nnoremap <silent> K :LspHover<CR>
" nnoremap <silent> gd :LspDefinition<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MATLAB configuration

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ag search
let g:ackprg = 'ag --vimgrep --smart-case'
let g:EasyGrepRoot="search:.git"
let g:EasyGrepCommand=1
let g:grepprg="ag --vimgrep"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" airline

let g:airline_powerline_fonts = 1
let g:airline_theme = 'hybrid'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fugitive configuration

noremap <silent><Leader>G :Gstatus<CR>
augroup FugitiveGitGutter
  autocmd BufWritePost * GitGutter
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" startify

let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1
let g:startify_session_autoload = 1
nnoremap <Leader>S :Startify<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" convienient save shortcut

nnoremap <Leader>s :update<CR>:GitGutter<cr>
inoremap <C-s> <Esc>:update<CR>:GitGutter<cr>i
vmap <Leader>s <esc>:w<CR>gv

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fzf fuzzy searching
" NOTE: to install this on a new machine
" you have to install the binary for fzf 
" (e.g. via brew install fzf)
set rtp+=/usr/local/opt/fzf
nnoremap <silent><C-p>f :execute ":Files " . projectroot#get(expand('%'))<CR>
nnoremap <silent><C-p>b :Buffers<CR>
nnoremap <silent><C-p>r :History<CR>
nnoremap <silent><C-p>c :Commands<CR>
nnoremap <silent><C-p>s :Ag<CR>

let g:LustyExplorerDefaultMappings = 0
nnoremap <silent><C-p>F :LustyFilesystemExplorer<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerd tree

nnoremap <Leader>d :NERDTreeFind<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" git gutter
let g:gitgutter_realtime=1
set updatetime=250

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color theme
set background=dark
colorscheme hybrid_reverse

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Easy Motion 
let g:EasyMotion_do_mapping=0
" <Leader>f{char} to move to {char}
nmap <Leader>a <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
" nmap s <Plug>(easymotion-overwin-f2)

" Move to line
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
nmap <Leader>w <Plug>(easymotion-overwin-w)

