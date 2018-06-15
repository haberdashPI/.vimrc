if has('nvim')
  let s:plugin_dir = '~/.local/share/nvim/plugged'
else
  let s:plugin_dir = '~/.vim/plugged'
end

call plug#begin(s:plugin_dir)
Plug 'vim-scripts/SyntaxRange'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'maverickg/stan.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'w0rp/ale'
" Plug 'neomake/neomake'
" Plug 'syngan/vim-vimlint'

Plug 'FooSoft/vim-argwrap'

Plug 'tpope/vim-vinegar'
Plug 'Shougo/deoplete.nvim' 

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive' 

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kristijanhusak/vim-hybrid-material'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'haya14busa/incsearch.vim'

Plug '~/Google Drive/Home/Software/vim-multi-repl'

Plug 'kana/vim-operator-user'
Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'rhysd/vim-operator-surround'

Plug 'vim-scripts/YankRing.vim'
Plug 'tommcdo/vim-exchange'
Plug 'mhinz/vim-grepper'
Plug 'tpope/vim-commentary'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mhinz/vim-startify'
Plug 'dbakker/vim-projectroot'
Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
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
nnoremap <Leader>S :syntax sync fromstart<cr>

nnoremap <Leader>M :set lines=999 columns=9999<cr>

set gdefault
set noedcompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimrc quick config
let g:vimrc_file = '~/Google Drive/Preferences/dot_vimrc/.vimrc'
nnoremap <Leader>vim :exe ':tabedit '.g:vimrc_file<cr>
nnoremap <Leader>vimr :exe ':update '.g:vimrc_file<cr>
      \:exe ':source '.g:vimrc_file<cr>

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
if !has('gui_vimr')
  set guifont=SauceCodePro_Nerd_Font_Mono:h12
end

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color theme
set background=dark
colorscheme hybrid_reverse

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fast search and replace

vnoremap <Leader>R "sy:%s/<c-r>s/
nnoremap <Leader>R "sye:%s/<c-r>s/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" improve incrmental search

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

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
" argwrap configuraiton

noremap <silent> gqa :ArgWrap<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" terminal configuration
tnoremap ƒ <esc>f
tnoremap ∫ <esc>b
tnoremap ∂ <esc>d
tnoremap <a-backspace> <esc><backspace>

nmap ,.. <Plug>(repl-send-text)

if has('nvim')
  augroup NeoVimTerm
    au!
    au BufEnter * if &buftype == 'terminal' | startinsert | endif
  augroup END

  tnoremap <c-w> <c-\><c-n><c-w>
end

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" surround operator

map <silent>( <Plug>(operator-surround-append)

nmap <silent>)d <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
nmap <silent>)r <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)

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
  au!
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
    if !empty(a:path) && !(a:path =~ 'term:')
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

let g:ale_r_lintr_options = 'with_defaults(assignment_linter = NULL,commas_linter=NULL,infix_spaces_linter=NULL)'

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
  au FileType julia call SyntaxRange#Include('R\"\"\"', '\"\"\"','R', 
        \ 'NonText')
  au FileType julia call SyntaxRange#Include('py\"\"\"', '\"\"\"','python',
        \ 'NonText')
  au FileType julia call SyntaxRange#Include('mat\"\"\"', '\"\"\"','matlab',
        \ 'NonText')
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
  au FileType markdown call SyntaxRange#Include('```julia','```','julia',
        \ 'NonText')
  au FileType markdown call SyntaxRange#Include('```python','```','python',
        \ 'NonText')
  au FileType markdown call SyntaxRange#Include('```matlab','```','matlab',
        \ 'NonText')
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

if hostname() == 'deus1.hwcampus.jhu.edu'
  let g:ale_matlab_mlint_executable = '/Applications/MATLAB_R2017a.app/bin/maci64/mlint'
elseif hostname() == 'Claude.local'
  let g:ale_matlab_mlint_executable = '/Applications/MATLAB_R2017a.app/bin/maci64/mlint'
else
  echoer "Location of mlint is unknown. Please update .vimrc to get linting in MATLAB."
end

augroup MATLAB
  au!
  au FileType matlab set commentstring=%\ %s
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ag search
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
end

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" yank ring
let g:yankring_replace_n_pkey='<c-y>'
let g:yankring_replace_n_nkey='<c-h>'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" airline

let g:airline_powerline_fonts = 1
let g:airline_theme = 'hybrid'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fugitive configuration

noremap <silent><Leader>G :Gstatus<CR>

" manual refresh until this issue is resolved: https://github.com/airblade/vim-gitgutter/issues/502
nnoremap <silent><Leader>gg :GitGutterAll<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" startify

let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1
let g:startify_session_autoload = 1
nnoremap <Leader>S :Startify<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" convienient save shortcut

nnoremap <Leader>s :update<CR>
inoremap <C-s> <Esc>:update<CR>
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
" ale

let g:airline#extensions#ale#enabled=1 
let g:ale_set_signs = 0
highlight link ALEErrorLine ALEError
highlight ALEWarningLine cterm=underline gui=underline
highlight ALEInfoLine cterm=underline gui=underline

nnoremap ]e :ALENext<CR>
nnoremap [e :ALEPrevious<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Easy Motion 
let g:EasyMotion_do_mapping=0
let g:EasyMotion_smartcase=1

" <Leader>f{char} to move to {char}
map  <Leader>a <Plug>(easymotion-bd-f)
nmap <Leader>a <Plug>(easymotion-s)

" Move to line
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
nmap <Leader>w <Plug>(easymotion-overwin-w)

