" mf-defaults.vim - Default settings for vim
" Maintainer:       Matthew Franglen
" Version:          0.0.8

if exists('g:loaded_mf_defaults') || &compatible
  finish
endif
let g:loaded_mf_defaults = 1

function s:Main()
    call s:LoadSettings()
    call s:ConfigureUndoFiles()
    call s:ApplyKeymapping()
    call s:LoadAutoCommands()
endfunction

function s:LoadSettings()
    set clipboard=unnamedplus           " Allow the + register to copy between vim instances
    set encoding=utf-8                  " Necessary to show Unicode glyphs
    set expandtab                       " Convert tabs to spaces
    set hidden                          " Stop the 'unsaved changes' warning when changing buffers
    set hlsearch                        " Highlight searches. Use <leader>h to turn off
    set laststatus=2                    " Always show the statusline
    set list listchars=tab:\ \ ,trail:· " Highlight tabs & trailing spaces
    set modeline
    set noswapfile                      " More annoying than useful
    set scrolloff=5                     " Always have 5 rows around the cursor
    set shiftwidth=4
    set sidescrolloff=5                 " Always have 5 columns around the cursor
    set tabstop=4
    set linebreak                       " Perform word wrapping without breaking words
endfunction

" Vim supports undofiles from approximately v7.3. These allow for a persistent
" undo between sessions. Very useful!
function s:ConfigureUndoFiles()
    if s:CannotUseUndoFiles()
        return
    endif

    call s:MakeUndoDirectoryIfMissing()

    set undofile
    set undodir=$HOME/.vim/undo
    set undolevels=1000
    set undoreload=10000
endfunction

function s:CannotUseUndoFiles()
    return v:version < 703
endfunction

function s:MakeUndoDirectoryIfMissing()
    let undodir=expand('~/.vim/undo')

    if !isdirectory(undodir)
        silent !mkdir -p ~/.vim/undo
    endif
endfunction

function s:ApplyKeymapping()
    call s:AddCustomMaps()
    call s:AddArrowKeyMaps()
    call s:AddWindowMaps()
    call s:AddBufferMaps()
endfunction

function s:AddCustomMaps()
    " Ctrl-J now adds a newline (without going into insert), so it is the reverse of Shift-J
    nmap <C-J> a<CR><Esc>k$

    " \s syncs syntax from start.
    " Only useful if the auto command has not triggered
    nmap <leader>s :syntax sync fromstart<CR>

    " \h turns off highlighting for the current search
    nmap <leader>h  :nohls<CR>

    " \p changes paste mode.
    nmap <leader>p :set paste!<CR>

    " \c copies the text into the clipboard using xsel
    vmap <leader>c :'<,'> ! xsel -b -i<CR>

    " Disable shift-k (manpage for word under cursor)
    nmap K <nop>

    " Disable shift-Q (ex mode)
    nmap Q <nop>

    " Make shift-y yank to end of line
    nmap Y y$
endfunction

function s:AddArrowKeyMaps()
    " Left/Right arrow keys change tabs in normal mode
    map  <Left>  <nop>
    map  <Right> <nop>
    imap <Left>  <nop>
    imap <Right> <nop>
    nmap <Left>  <Esc>:tabprevious<CR>
    nmap <Right> <Esc>:tabnext<CR>

    " Disable up/down arrow keys
    map <Up>   <nop>
    map <Down> <nop>
endfunction

function s:AddWindowMaps()
    nmap <leader>sw<left>  :topleft  vnew<CR>
    nmap <leader>swh       :topleft  vnew<CR>
    nmap <leader>sw<right> :botright vnew<CR>
    nmap <leader>swl       :botright vnew<CR>
    nmap <leader>sw<up>    :topleft  new<CR>
    nmap <leader>swk       :topleft  new<CR>
    nmap <leader>sw<down>  :botright new<CR>
    nmap <leader>swj       :botright new<CR>
endfunction

function s:AddBufferMaps()
    nmap <leader>s<left>  :leftabove  vnew<CR>
    nmap <leader>sh       :leftabove  vnew<CR>
    nmap <leader>s<right> :rightbelow vnew<CR>
    nmap <leader>sl       :rightbelow vnew<CR>
    nmap <leader>s<up>    :leftabove  new<CR>
    nmap <leader>sk       :leftabove  new<CR>
    nmap <leader>s<down>  :rightbelow new<CR>
    nmap <leader>sj       :rightbelow new<CR>
endfunction

function s:LoadAutoCommands()
    autocmd! BufEnter * :call s:LoadCustomSettings()
    autocmd! BufEnter,BufRead,BufWinEnter * :call s:FullSyntaxCheck()
endfunction

function s:LoadCustomSettings()
    if filereadable("./vimrc")
        source ./vimrc
    endif
endfunction

function s:FullSyntaxCheck()
    if s:FileIsInsane()
        return
    endif
    syntax sync fromstart
endfunction

function s:FileIsInsane()
    return line('$') > 100 * 1000
endfunction

call s:Main()
