" #########################################################################
" Author:       Ruiyi Zhang (ruiyizhang at gmail dot com)
" Description:  Vim Settings for Vim 7
" Revision:     r13
" Last Change:  11/11/2008
" #########################################################################


" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" NERDTree plugin configuration
" let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', 'harvest.sig']

if has('autocmd')
    " Enable file type detection.  Use the default filetype settings, so that
    " mail gets 'tw' set to 72, 'cindent' is on in C files, etc.  Also load
    " indent files, to automatically do language-dependent indenting.
    filetype plugin indent on           " 

    " Remove ALL autocommands for the current group
    augroup vimrcEx au!

    " For all text files set 'textwidth' to 78 characters
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.  Don't
    " do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

    augroup END
else
    set autoindent
endif

" Windows GUI specific settings
if has("gui_running")
    colorscheme molokai             " Set default color schema
    set guifont=Envy\ Code\ R:h10:b   " Set font as Consolas

    " No tearoff menu entries (Windows only)
    if has("win32") || has("win64")
        let &guioptions = substitute(&guioptions, "t", "", "g")
    endif

    " Toolbar and scrollbar settings
    set guioptions-=T               " Toggle off the toolbar
    set guioptions-=r               " Toggle off the right-hand scrollbar
    set guioptions-=l               " Toggle off the left-hand scrollbar
    set guioptions-=b               " Toggle off the bottom scrollbar
    set guioptions-=m               " Toggle off the menubar
    let do_syntax_sel_menu = 1      " Always show file types in menu
    " Set default size to 120x45
    set columns=120                 " Set width of the window in number of columns
    set lines=45                    " Set height of the window
    " Set start position to (0,0)
    winpos 0 0                     " Set position of window
endif

" Better Search
set incsearch                       " do incremental searching
set hlsearch                        " highlight search term
set ignorecase                      " Case insensitive when searching and replacing

" Disable Generation of Backup Files
set nobackup
set noswapfile

" Behavior of Splitting Windows
set splitbelow
set splitright

" Tab and Indention Handling
set smarttab
set tabstop=4                       " Set tab width
set expandtab                       " Use spaces when <Tab> hit
set autoindent                      " 
set shiftwidth=4                    " Set shift width

" Misc settings
set nocuc                           " 
set noea                            " allow unequal size windows when splitting window
set backspace=indent,eol,start      " allow backspacing over everything in insert mode
set history=50                      " keep 50 lines of command line history
set ruler                           " show the cursor position all the time
set showcmd                         " display incomplete commands
set foldmethod=marker               " Set folding method to use explicit marker
set undolevels=5000                 " Set how many undos can be done
set scrolloff=6                     " 
set laststatus=2                    " Always display status line
set number ruler                    " Display line number
set showmatch                       " Show matching braces
set vb t_vb=                        " Flashes the screen when a command doesn't work

" Set PowerShell as default shell
set shell=C:\WINDOWS\system32\windowspowershell\v1.0\powershell.exe

" Plugin settings
"
" Disable warnings from NERDCommenter
let g:NERDShutUp = 1

" Key Mappings
" ------------
map     Q gq
map     <silent> <F9> :tabnew<CR>
nmap    <silent> <C-E><C-E> :NERDTreeToggle<CR>
imap    <silent> <C-E><C-E> <C-O>:NERDTreeToggle<CR>
" map     <silent> <F12> :BufExplorer<CR>
map     <SPACE> <C-F>
map     <BS> <C-B>

" Emulate Windows Copy&Paste Behaviors
" Copy
vnoremap <silent> <F2> "+y
" Paste
map  <silent> <F3> "+gP
cmap <silent> <F3> <C-R>+
" Cut
vnoremap <silent> <F4> "+x

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.
exe 'inoremap <script> <F3>' paste#paste_cmd['i']
exe 'vnoremap <script> <F3>' paste#paste_cmd['v']

" Alt-Space is System menu
if has("gui")
    noremap  <silent> <M-Space> :simalt ~<CR>
    inoremap <silent> <M-Space> <C-O>:simalt ~<CR>
    cnoremap <silent> <M-Space> <C-C>:simalt ~<CR>
endif

" CTRL-Tab is Next window
noremap  <silent> <C-Tab> <C-W>w
inoremap <silent> <C-Tab> <C-O><C-W>w
cnoremap <silent> <C-Tab> <C-C><C-W>w
onoremap <silent> <C-Tab> <C-C><C-W>w
nnoremap <silent> <C-S-Tab> <C-W>W
inoremap <silent> <C-S-Tab> <C-O><C-W>W

" CTRL-F4 is Close window
noremap  <silent> <C-F4> <C-W>c
inoremap <silent> <C-F4> <C-O><C-W>c
cnoremap <silent> <C-F4> <C-C><C-W>c
onoremap <silent> <C-F4> <C-C><C-W>c

" ALT-LEFTARROW is Previous tab
map <silent> <M-Left> :tabprev<CR>

" ALT-RIGHTARROW is Next tab
map <silent> <M-Right> :tabnext<CR>


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis


" Set Working Directory to The File Being Edited
" ----------------------------------------------
function! ChangeCurrentDir()
    let _dir = expand("%:p:h")
    exec "cd " . _dir
    unlet _dir
endfunction

autocmd BufEnter * call ChangeCurrentDir()


" Mapping to Make Movements Operate on 1 Screen Line in Wrap Mode
" ---------------------------------------------------------------
function! ScreenMovement(movement)
    if &wrap
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


" Date/Time abbreviations
" -----------------------
iab  mdyl  <c-r>=strftime("%a, %d %b %Y")<cr>
iab  mdys  <c-r>=strftime("%y%m%d")<cr>
iab  mdyc  <c-r>=strftime("%c")<cr>
iab  hml   <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
iab  hms   <c-r>=strftime("%H:%M:%S")<cr>


" Automatically find scripts in the autoload directory
" ----------------------------------------------------
au FuncUndefined Syn* exec 'runtime autoload/' . expand('<afile>') . '.vim'


" File type specific configurations
" ---------------------------------

" C & Cpp
au FileType c,cpp               setlocal cinoptions=:0,g0,(0,w1 shiftwidth=4 tabstop=4 expandtab

" C#
au FileType cs                  setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab 

" Java
au FileType java                setlocal shiftwidth=4 tabstop=4 expandtab

" Python
au FileType python              setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
let python_highlight_all=1
let python_highlight_exceptions=0
let python_highlight_builtins=0

" Ruby
au FileType ruby                setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" SQL
au FileType sql                 setlocal shiftwidth=4 tabstop=4 expandtab softtabstop=4

" Markup Languages
au FileType html,xhtml          setlocal indentexpr=
au BufNewFile,BufRead *.config  setlocal filetype=xml
au BufNewFile,BufRead *.xaml    setlocal filetype=xml

" Misc
au FileType diff                setlocal shiftwidth=4 tabstop=4
au FileType changelog           setlocal textwidth=76
au FileType cvs                 setlocal textwidth=72
au FileType mail                setlocal expandtab softtabstop=2 textwidth=70

" Quickly Exiting Help Files
au BufRead *.txt      if &buftype=='help'|nmap <buffer> q <C-W>c|endif


" Syntax highlighting
" --------------------------
syntax on                       " Enable syntax highlighting
syntax sync fromstart
filetype plugin indent on


" Status line configuration (from tomasr)
" ---------------------------------------
set ls=2 " Always show status line
if has('statusline')
   " Status line detail:
   " %f		file path
   " %y		file type between braces (if defined)
   " %([%R%M]%)	read-only, modified and modifiable flags between braces
   " %{'!'[&ff=='default_file_format']}
   "			shows a '!' if the file format is not the platform
   "			default
   " %{'$'[!&list]}	shows a '*' if in list mode
   " %{'~'[&pm=='']}	shows a '~' if in patchmode
   " (%{synIDattr(synID(line('.'),col('.'),0),'name')})
   "			only for debug : display the current syntax item name
   " %=		right-align following items
   " #%n		buffer number
   " %l/%L,%c%V	line number, total number of lines, and column number
   function SetStatusLineStyle()
      if &stl == '' || &stl =~ 'synID'
         let &stl="%f %y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]}%{'~'[&pm=='']}%=#%n %l/%L,%c%V "
      else
         let &stl="%f %y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]} (%{synIDattr(synID(line('.'),col('.'),0),'name')})%=#%n %l/%L,%c%V "
      endif
   endfunc
   " Switch between the normal and vim-debug modes in the status line
   nmap _ds :call SetStatusLineStyle()<CR>
   call SetStatusLineStyle()
   " Window title
   if has('title')
	   set titlestring=%t%(\ [%R%M]%)
   endif
endif

