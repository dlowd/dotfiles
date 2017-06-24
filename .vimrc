" vim:set ts=4 sw=4:
" Daniel's Personal Vim Settings

" Enable Vundle plugin manager
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
Bundle 'gmarik/Vundle.vim'

" Use the Solarized Dark theme
set background=dark
"colorscheme solarized
"let g:solarized_termtrans=1

" Make Vim more useful
set nocompatible
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
set wildmenu                    " Enhance command-line completion
set esckeys                     " Allow cursor keys in insert mode
set backspace=indent,eol,start  " Allow backspace in insert mode
set ttyfast                     " Optimize for fast terminal connections
"set gdefault                   " Add the g flag to search/replace by default
set encoding=utf-8 nobomb       " Use UTF-8 without BOM
let mapleader=","               " Change mapleader
set binary                      " Don’t add empty newlines at the end of files
set noeol
set backupdir=~/.vim/backups    " Centralize backups, swapfiles and undo history
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
"set number             " Enable line numbers
syntax on               " Enable syntax highlighting
"set cursorline         " Highlight current line
set tabstop=2           " Make tabs as wide as two spaces
"set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_ " Show “invisible” characters
"set list
set hlsearch            " Highlight searches
"set ignorecase         " Ignore case of searches
"set incsearch          " Highlight dynamically as pattern is typed
set laststatus=2        " Always show status line
set mouse=a             " Enable mouse in all modes
set noerrorbells        " Disable error bells
set nostartofline       " Don’t reset cursor to start of line when moving around.
set ruler               " Show the cursor position
set shortmess=atI       " Don’t show the intro message when starting Vim
set showmode            " Show the current mode
set title               " Show the filename in the window titlebar
set showcmd             " Show the (partial) command as it’s being typed
" Use relative line numbers
"if exists("&relativenumber")
"	set relativenumber
"	au BufReadPost * set relativenumber
"endif
set scrolloff=2         " Start scrolling three lines before the horizontal window border

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif


" FROM DANIEL'S .vimrc -- much of this taken from elsewhere.
filetype plugin on
augroup filetypedetect
        au! BufNewFile,BufRead *.jemdoc setf jemdoc
augroup END

" Last line is for proper wrapping of jemdoc lists, etc.
autocmd Filetype jemdoc setlocal comments=:#,fb:-,fb:.,fb:--,fb:..,fb:\:

"if has("gui_running")
"  set bg=light
"endif

"if exists('+autochdir')
"  set autochdir
"else
"  autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
"endif

autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Taken from here: 
" http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

noremap <buffer> <Cmd-j> gj

" mapping to make movements operate on 1 screen line in wrap mode
function! ScreenMovement(movement)
  if &wrap && b:gmove == 'yes'
    return "g" . a:movement
  else
    return a:movement
  endif
endfunction
onoremap <silent> <expr> j ScreenMovement("j")
onoremap <silent> <expr> k ScreenMovement("k")
onoremap <silent> <expr> 0 ScreenMovement("0")
onoremap <silent> <expr> ^ ScreenMovement("^")
onoremap <silent> <expr> $ ScreenMovement("$")
nnoremap <silent> <expr> j ScreenMovement("j")
nnoremap <silent> <expr> k ScreenMovement("k")
nnoremap <silent> <expr> 0 ScreenMovement("0")
nnoremap <silent> <expr> ^ ScreenMovement("^")
nnoremap <silent> <expr> $ ScreenMovement("$")
vnoremap <silent> <expr> j ScreenMovement("j")
vnoremap <silent> <expr> k ScreenMovement("k")
vnoremap <silent> <expr> 0 ScreenMovement("0")
vnoremap <silent> <expr> ^ ScreenMovement("^")
vnoremap <silent> <expr> $ ScreenMovement("$")
vnoremap <silent> <expr> j ScreenMovement("j")
" toggle showbreak
function! TYShowBreak()
  if &showbreak == ''
    set showbreak=>
  else
    set showbreak=
  endif
endfunction
let b:gmove = "yes"
function! TYToggleBreakMove()
  if exists("b:gmove") && b:gmove == "yes"
    let b:gmove = "no"
  else
    let b:gmove = "yes"
  endif
endfunction
nmap  <expr> ,b  TYShowBreak()
nmap  <expr> ,bb  TYToggleBreakMove()


" Error checking with Syntastic
Bundle 'scrooloose/syntastic'
let g:syntastic_ocaml_checkers = ['merlin']

" Recommended Syntastic settings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

au BufEnter *.ml setf ocaml
au BufEnter *.mli setf ocaml
au FileType ocaml call FT_ocaml()
function FT_ocaml()
    set textwidth=80
    set colorcolumn=80
    set shiftwidth=2
    set tabstop=2
    " ocp-indent with ocp-indent-vim
    let opamshare=system("opam config var share | tr -d '\n'")
    execute "autocmd FileType ocaml source".opamshare."/vim/syntax/ocp-indent.vim"
    filetype indent on
    filetype plugin indent on
endfunction

" MORE STUFF

" Variables
" -- From Matt Brubeck's .vimrc
set tw=75               " Default text width
set et                  " Expand tabs
set ww=[,],<,>,h,l,b,s  " Allow movement commands to wrap
"set shortmess+=a        " abbreviate messages
set autowrite           " write buffer when switching (e.g. :make)
"set fo+=ro              " format comments
"set ts=8 sw=2           " short tabstops

" -- From other sources, or added by Daniel

set ai			" always set autoindenting on
set nowrap		" don't wrap lines at the edge of the screen
set mouse=a		"We like using the mouse sometimes.
set tildeop		" allow tilde (~) to act as an operator -- ~w, etc.
set shell=bash
set cpt=.,b,u	" allow autocomplete to use all loaded and unloaded bufs

" read/write a .viminfo file, don't store more than 50 lines of registers
set viminfo='20,\"50

" for code editing
set tags=tags;/
