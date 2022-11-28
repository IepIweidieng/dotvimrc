" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2016 Mar 25
"
" To use it, copy it to
"     for Unix and OS/2:  /.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

let $BASH_ENV = "~/.bash_aliases"

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set noshowmode
set laststatus=2

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has('vms')
    set nobackup		" do not keep a backup file, use versions instead
else
    set nobackup		" keep a backup file (restore to previous version)
    set undofile		" keep an undo file (undo changes after closing)
endif
set history=128		" keep 128 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
if has('win32')
    let &guioptions = substitute(&guioptions, 't', '', 'g')
endif

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has('autocmd')

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=80

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        autocmd BufReadPost *
                    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
                    \   exe 'normal! g`"' |
                    \ endif

    augroup END

else

    set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(':DiffOrig')
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
    " Prevent that the langmap option applies to characters that result from a
    " mapping.  If unset (default), this may break plugins (but it's backward
    " compatible).
    set langnoremap
endif


" Plugins

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Helper function for determining whether to load the plugin depending on the condition
function! PlugCond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin('~/.vim/plugged')

" Register vim-plug as a plugin for Vim help (e.g. :help plug-options).
Plug 'junegunn/vim-plug'

" Retro groove color scheme for Vim
Plug 'morhetz/gruvbox'

" lean & mean status/tabline for vim that's light as air
Plug 'vim-airline/vim-airline'

" fugitive.vim: A Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-fugitive'

" dispatch.vim: Asynchronous build and test dispatcher
Plug 'tpope/vim-dispatch'

" hexokinase.vim - The fastest (Neo)Vim plugin for asynchronously displaying
" the colours in the file (#rrggbb, #rgb, rgb(a)? functions, hsl(a)?
" functions, web colours, custom patterns)
let has_func_chanclose = !has('nvim') || has('nvim-0.3.0')
Plug 'rrethy/vim-hexokinase', PlugCond(has_func_chanclose, { 'do': 'make hexokinase' })

" Improved AnsiEsc.vim: ansi escape sequences concealed, but highlighted as specified (conceal)
Plug 'powerman/vim-plugin-AnsiEsc'

call plug#end()

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
silent! packadd! matchit

" Configurate the color scheme

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has('gui_running')
    syntax on
    set hlsearch
endif

set termguicolors
set background=dark

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_improved_strings = 1
let g:gruvbox_improved_warnings = 1
colorscheme gruvbox

" Configurate the other plugins

let g:airline_powerline_fonts = 0

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:bufferline_echo = 0

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1

if !has('nvim')
    let g:Hexokinase_highlighters = [ 'foreground' ]
endif
let g:Hexokinase_refreshEvents = ['TextChanged', 'InsertLeave']

set ttimeoutlen=10
set ambiwidth=double

set number
set cursorline

set tabstop=8
set expandtab smarttab shiftwidth=4 softtabstop=2 smartindent

set list listchars=tab:>.,trail:~,extends:>,precedes:<

set fileencodings=ucs-bom,utf-8,default,big5,latin1
