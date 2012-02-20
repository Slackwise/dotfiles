" vimrc
" Adam 'Slackwise' Flanczewski
" http://slackwi.se


" ### VUNDLE CONFIGURATION ###
set nocompatible
filetype off " Apparently required for Vundle to function...?
let $MYVIMRC="~/src/dotfiles/vimrc"
set rtp+=~/.vim/
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'repeat.vim'
Bundle 'surround.vim'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'yurifury/hexHighlight'
Bundle 'shawncplus/Vim-toCterm'
Bundle 'astashov/vim-ruby-debugger'


" ### SOURCE OTHER SCRIPTS FIRST ###
source $VIMRUNTIME/vimrc_example.vim    " Has some good defaults
source $VIMRUNTIME/mswin.vim            " Always behave Windows-like, because
                                        " I like my Ctrl-X/C/V/S bindings.

" ### CUSTOM KEYBINDINGS ###
" I never use 's' for anything I'd rather us 'c' for, so I've decided to use
" it for my own personal scripts and utilities.
nmap ss .
nmap sh :call ToggleFlag("guioptions", "b")<CR>
nmap sV :call Vimrc()<CR>
nmap sC :call SynStack()<CR>
nmap <F5> :w<CR>:!%<CR>
nmap <S-Return> i<Return><Esc>
nmap <Return> o<Esc>
nmap n nzz
nmap N Nzz


" ### SOME BASE SETTINGS ###
set guioptions-=T       " Diable toolbar in gVim
"if $USERDOMAIN == "MILLNET" | set guioptions+=b | endif
set shortmess+=I        " Disable :intro
set nowrap              " Do not wrap lines
set backup
let &backupdir=finddir("backup", &rtp)
let &dir=finddir("swap", &rtp)
set background=dark
try | colorscheme hemisu | catch /^Vim\%((\a\+)\)\=:E185/ | colorscheme slate | endtry


" ### DEFAULT TAB/INDENTATION SETTINGS ###
set tabstop=4           " How many columns <Tab> counts for
set softtabstop=4       " Causes backspace to delete X spaces
set shiftwidth=4        " Number of spaces to use for each step of (auto)indent
set smarttab            " Uses shiftwidth instead of tabstop at start of lines 
set expandtab           " Expand tabs into spaces of tabstop size


" ### FILETYPE SETTINGS ###
syntax on               " Enable syntax highlighting
filetype on             " Enable filetype detection
filetype indent on      " Enable filetype-specific indenting
filetype plugin on      " Enable filetype-specific plugins


" ### RUBY SPECIFIC SETTINGS ###
autocmd FileType ruby,eruby set tabstop=2 | set shiftwidth=2 | set expandtab
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
function RubyDebug(filename)
    if !exists("b:choice") | let b:choice = 0 | endif
    if search('Shoes.app') > 0
        if !b:choice | let b:choice = confirm("Shoes.app?", "&Yes\n&No") | endif
    endif
    if has("win32")
        let oldshell = &shell
        let oldshellcmdflag = &shellcmdflag
        if b:choice == 1 " Shoes
            "set shell=\"C:\Program\ Files\Common\ Files\Shoes\shoes.bat\"
            let shoesfound = FindInPath('shoes.bat')
            if shoesfound != ''
                let &shell = shoesfound
                set shellcmdflag=
            else
                echoerr 'Cannot find Shoes'
                return
            endif
        else " Ruby 
            let rubyfound = FindInPath('ruby.exe')
            if rubyfound  != ''
                let &shell = rubyfound
                set shellcmdflag=-d " Set $DEBUG to true
            else
                echoerr 'Cannot find Ruby'
                return
            endif
        endif
        execute ":w|:!" . a:filename
        let &shell = oldshell
        let &shellcmdflag = oldshellcmdflag
    else " Not Windows... Unix?
        if b:choice == 1
            let shoesfound = FindInPath('shoes')
            if shoesfound != ''
                execute ":w|:!shoes -d " . a:filename
            else
                echoerr 'Cannot find Shoes'
                return
            endif
        else
            let rubyfound = FindInPath('ruby')
            if rubyfound  != ''
                execute ":w|:!ruby " . a:filename
            else
                echoerr 'Cannot find Ruby'
                return
            endif
        endif
    endif
endfunction
autocmd FileType ruby map <F5> <Esc><Esc>:call RubyDebug(expand("%"))<CR>


" ### UTILITY FUNCTIONS ###
function Vimrc()
    if has("win32")
        edit $HOME/_vimrc
    else
        edit $HOME/.vimrc
    endif
endfunction

function FindInPath(filename)
    let paths = split($PATH, has("win32") ? ';' : ':')
    for path in paths
        let filepath = findfile(a:filename, resolve(path))
        if filepath != '' | return shellescape(filepath) | endif
    endfor
    " returns '' if filname not found in $PATH
endfunction

function ToggleFlag(option, flag)
  exec ('let lopt = &' . a:option)
  if lopt =~ (".*" . a:flag . ".*")
    exec ('set ' . a:option . '-=' . a:flag)
  else
    exec ('set ' . a:option . '+=' . a:flag)
  endif
endfunction

function SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" ### WINDOWS SPECIFIC SETTINGS ###
if has("gui_win32")
    set guifont=Consolas:h9:cANSI   " Set the gVim.exe font to Consolas 9pt
endif
if has("win32")
    let g:netrw_scp_cmd="\c:\\bin\\pscp.exe"
    
    set diffexpr=MyDiff()
    function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

