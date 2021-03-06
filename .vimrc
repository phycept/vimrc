" if has('python3') || has('python')
"   silent! python3 1
" endif

" fix meta-keys which generate <Esc>a .. <Esc>z
" http://vim.wikia.com/wiki/Fix_meta-keys_that_break_out_of_Insert_mode
" let c='A'
" while c <= 'Z'
"   " exec "set <M-".toupper(c).">=\e".toupper(c)
"   exec "inoremap \e".toupper(c)." <M-".toupper(c).">"
"   let c = nr2char(1+char2nr(c))
" endw

" let g:Tex_AdvancedMath = 1
" imap \eL <Plug>Tex_LeftRight

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copied_from: 
"       Amir Salihefendic
"       http://amix.dk - amix@amix.dk
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups                       |vimrc-files|
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers         |buffer|
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"    -> vim-latex                                |vim-latex|
"    -> python mode  |pymode|
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()
"Plug 'Valloric/YouCompleteMe', {
"			\'do': 'CXX=clang++ CC=clang CMAKE_CXX_FLAGS=-Ofast python install.py --clang-completer --system-libclang'}
Plug 'vim-latex/vim-latex'
Plug 'kien/ctrlp.vim'
Plug 'chr4/nginx.vim'
Plug 'xolox/vim-misc'                 " Required by vim-easytags
Plug 'xolox/vim-easytags'             " Tag 自动生成和高亮
" Plug 'jlanzarotta/bufexplorer'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = " "
let g:mapleader = " "

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

" enable mouse
" set mouse=a

" silent
" http://vim.wikia.com/wiki/Avoiding_the_%22Hit_ENTER_to_continue%22_prompts
:command! -nargs=1 Silent execute ':silent !' . <q-args> . ' &' | execute ':redraw!'

" copy
set clipboard=unnamed


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en' 
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.aux,*.dvi,*.pdf
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2


" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif


" Add a bit extra margin to the left
set foldcolumn=1

set relativenumber 
set number  

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable 

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme desert
catch
endtry

set background=dark
" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files and backups              |vimrc-files|
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" autowrite: https://stackoverflow.com/questions/1313323/vim-write-back-my-file-on-each-key-press
autocmd TextChanged,TextChangedI <buffer> write

" netrw config: https://shapeshed.com/vim-netrw/
" change directory browser view
let g:netrw_liststyle = 3
" open file in split
let g:netrw_browse_split = 0
" width of dir explorer
let g:netrw_winsize = 25
" launch dir explor right after enter Vim
" :autocmd!: Remove ALL autocommands for the current group.
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore | :wincmd l
" augroup END
" change the <c-l> way in netrw, https://github.com/christoomey/vim-tmux-navigator/issues/189#issuecomment-362079200
augroup netrw_mapping
  autocmd!
  autocmd Filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
  nnoremap <buffer> <c-l> :wincmd l<cr>
  nnoremap <buffer> <c-j> :wincmd j<cr>
  nnoremap <buffer> <c-k> :wincmd k<cr>
  nnoremap <buffer> <c-h> :wincmd h<cr>
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
" set si "Smart indent
set cindent "
set wrap "Wrap lines

" python PEP 8 indentation
" https://realpython.com/vim-and-python-a-match-made-in-heaven/
au BufNewFile,BufRead *.py
    \ set softtabstop=4  |
    \ set textwidth=79  |
    \ set autoindent  |
    \ set fileformat=unix  

" web indentation
" https://realpython.com/vim-and-python-a-match-made-in-heaven/
au BufNewFile,BufRead *.js
    \ set tabstop=2  |
    \ set softtabstop=2  |
    \ set shiftwidth=2

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers       |buffer|
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" A buffer becomes hidden when it is abandoned
set hidden

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
" https://stackoverflow.com/questions/9092982/mapping-c-j-to-something-in-vim
let g:C_Ctrl_j = 'off'
let g:C_Ctrl_k = 'off'
let g:C_Ctrl_l = 'off'
let g:C_Ctrl_h = 'off'
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l


" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
" https://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
nmap <leader>bq :bp <BAR> bd #<CR>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Split panes to right
set splitright
set splitbelow

" insert a new-line after the current line by pressing Enter (Shift-Enter for inserting a line before the current line)
" http://vim.wikia.com/wiki/Insert_newline_without_entering_insert_mode 
" nmap <S-Enter> o<Esc>
" nmap <CR> o<Esc>

" new line for insert model
imap <S-Enter> <C-o>o
imap <C-S-Enter> <C-o>O

" move cursor in insert mode
inoremap jj <Esc>j 
inoremap jk <Esc> 
inoremap kk <Esc>k

" map shell short cut
inoremap <C-w> <C-o>db
inoremap <C-f> <C-o>l
inoremap <C-b> <C-o>h

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ag searching and cope displaying
"    requires ag.vim - it's much better than vimgrep/grep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you Ag after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ag and put the cursor in the right position
map <leader>g :Ag 

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ag, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"function! CmdLine(str)
"    exe "menu Foo.Bar :" . a:str
"    emenu Foo.Bar
"    unmenu Foo
"endfunction 

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ag \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/\<'. l:pattern . '\>/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" Make VIM remember position in file after reopen
" if has("autocmd")
"   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-latex |vim-latex|
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
" set shellslash

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" default pdf
let g:Tex_DefaultTargetFormat='pdf'

" https://stackoverflow.com/questions/3740609/how-do-i-make-vim-latex-compile-correctly-without-having-to-save
" autocmd FileType tex call Tex_MakeMap('<Leader>ll', ':w<CR>:silent call Tex_RunLaTeX()<CR>', 'n', '<buffer>')
" autocmd FileType tex call Tex_MakeMap('<leader>ll', '<ESC>:w<CR>:silent call Tex_RunLaTeX()<CR>', 'v', '<buffer>')

" silent output
" map <leader>ll :silent call Tex_RunLaTex()<cr>
"
" Disable fold
" https://stackoverflow.com/questions/3322453/how-can-i-disable-code-folding-in-vim-with-vim-latex
let Tex_FoldedMisc=""
let Tex_FoldedSections=""
let Tex_FoldedEnvironments=""

" let g:Tex_CompileRule_pdf = 'pdflatex '
"   \. '-synctex=-1 -src-specials -interaction=nonstopmode $*; '
"   \. 'pdflatex '
"   \. '-synctex=-1 -src-specials -interaction=nonstopmode $*'

let g:Tex_MultipleCompileFormats="dvi,pdf"

" You can set the location where Latex-Suite will search for .bib and .bbl files using the |Tex_BIBINPUTS| variable. 
" http://vim-latex.sourceforge.net/documentation/latex-suite/latex-completion-cite.html

let g:Tex_BIBINPUTS="/Users/yan/Library/texmf/bibtex/bib/"

" view rule
let g:Tex_ViewRule_pdf = 'open -a Skim'

" use latexmk
let g:Tex_CompileRule_pdf = "latexmk --synctex=-1 -src-specials -interaction=nonstopmode -bibtex -pdf $*"

" ignore wranings
" http://vim-latex.sourceforge.net/documentation/latex-suite/customizing-compiling.html#Tex_IgnoredWarnings
" let  g:Tex_IgnoreLevel=8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => python-mode |pymode|
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:pymode_python = 'python3'
" let g:pymode_run_bind = '<leader>ll'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => k
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:easytags_async=1
let g:easytags_dynamic_files=1 " 0 for always at ~/ ; 1 for priority at ./ ; 2 for always at ./

