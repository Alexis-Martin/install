set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Plugin 'LucHermitte/lh-vim-lib'
" Plugin 'LucHermitte/lh-tags'
" Plugin 'LucHermitte/lh-dev'
" Plugin 'LucHermitte/lh-brackets'
" Plugin 'LucHermitte/searchInRuntime'
" Plugin 'LucHermitte/mu-template'
" Plugin 'tomtom/stakeholders_vim'
" Plugin 'LucHermitte/alternate-lite'
" Plugin 'LucHermitte/lh-cpp'
Plugin 'majutsushi/tagbar'
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tmhedberg/SimpylFold'
" Plugin 'vim-scripts/indentpython.vim'
"Plugin 'minibufexplorerpp'
" Plugin 'taglist.vim'
" Plugin 'pydoc.vim'
Bundle 'Valloric/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'
" Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

call vundle#end()            " required
filetype plugin indent on    " required

if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  autocmd BufRead,BufNewFile,FileReadPost *.py source ~/.vim/python
endif

" This beauty remembers where you were the last time you edited the file, and returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding with the spacebar
nnoremap <space> za

let g:SimpylFold_docstring_preview=1
let g:nerdtree_tabs_open_on_console_startup=2
let g:nerdtree_tabs_autofind=1

map <C-N> <plug>NERDTreeFocusToggle<CR>
let NERDTreeQuitOnOpen=1
" map <C-n> :NERDTreeToggle<CR>
" map s<cr> :NERDTreeClose<cr>
" autocmd BufEnter NERD_tree_* nmap  s<CR> <CR> :NERDTreeToggle <CR>
" autocmd BufLeave NERD_tree_* unmap s<CR>
" autocmd BufEnter NERD_tree_* nmap  d<CR> <CR> :NERDTreeToggle <CR>
" autocmd BufLeave NERD_tree_* unmap d<CR>

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

set nu

set showcmd         " Show (partial) command in status line.

set showmatch       " When a bracket is inserted, briefly jump to the matching
                    " one. The jump is only done if the match can be seen on the
                    " screen. The time to show the match can be set with
                    " 'matchtime'.

set hlsearch        " When there is a previous search pattern, highlight all
                    " its matches.
 
set incsearch       " While typing a search command, show immediately where the
                    " so far typed pattern matches.

set ignorecase      " Ignore case in search patterns.

set smartcase       " Override the 'ignorecase' option if the search pattern
                    " contains upper case characters.

set autoindent      " Copy indent from current line when starting a new line
                    " (typing <CR> in Insert mode or when using the "o" or "O"
                    " command).

set tabstop=2       " number of space characters that will be inserted when the tab key is pressed

set shiftwidth=2    " number of space characters inserted for indentation

set expandtab       " all the new tab characters entered will be changed to spaces. ":retab 'range' to old tabs 

set softtabstop=2   " makes the spaces feel like real tabs

set smartindent     " inserts blanks when the tab key is pressed in front of a line

set mouse=a         " Enable the use of the mouse.

set ruler           " Show the line and column number of the cursor position,
                    " separated by a comma.


"hilight current line
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40

" Hide the mouse cursor while typing
set mousehide 

"Resize splits when the window is resized
"au VimResized * :wincmd =

"Display Windows/Mac end of line
set fileformats=unix

" use :W to sudo-write the current buffer
command! W w !sudo tee % > /dev/null

set encoding=utf-8

" Wrapping
set tw=100 


colorscheme monokai
syntax on

" Smart indenting
set smartindent cinwords=if,else,for,while,catch,try,except,finally,def,class

nnoremap <F4> :make!<cr>
