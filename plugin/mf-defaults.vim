" mf-defaults.vim - Default settings for vim
" Maintainer:       Matthew Franglen
" Version:          0.0.1

if exists('g:loaded_mf_defaults') || &compatible
  finish
else
  let g:loaded_mf_defaults = 1
endif

" Use :help 'option' to see the documentation for the given option.

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

" Vim supports undofiles from approximately v7.3. These allow for a persistent
" undo between sessions. Very useful!
if ( v:version >= 703 )
    let undodir=expand('~/.vim/undo')

    if !isdirectory(undodir)
        silent !mkdir -p ~/.vim/undo
    endif

    set undofile
    set undodir=$HOME/.vim/undo
    set undolevels=1000
    set undoreload=10000
endif

""""""""""""""
" KEYMAPPING "
""""""""""""""

" Left/Right arrow keys change buffers in all modes
map <Left>  <Esc>:bp<CR>
map <Right> <Esc>:bn<CR>

" Disable up/down arrow keys
map <Up>   <nop>
map <Down> <nop>

" Ctrl-J now adds a newline (without going into insert), so it is the reverse
" of Shift-J. See:
" http://vim.wikia.com/wiki/Insert_newline_without_entering_insert_mode
nmap <C-J> a<CR><Esc>k$

" \s syncs syntax from start.
" Only useful if the auto command has not triggered
nmap <leader>s :syntax sync fromstart<CR>

" \h turns off highlighting for the current search
nmap <leader>h  :nohls<CR>

" \p changes paste mode.
nmap <leader>p :set paste!<CR>

" Split commands from:
" https://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/

" Split by window
nmap <leader>sw<left>  :topleft  vnew<CR>
nmap <leader>swh       :topleft  vnew<CR>
nmap <leader>sw<right> :botright vnew<CR>
nmap <leader>swl       :botright vnew<CR>
nmap <leader>sw<up>    :topleft  new<CR>
nmap <leader>swk       :topleft  new<CR>
nmap <leader>sw<down>  :botright new<CR>
nmap <leader>swj       :botright new<CR>

" Split by buffer
nmap <leader>s<left>  :leftabove  vnew<CR>
nmap <leader>sh       :leftabove  vnew<CR>
nmap <leader>s<right> :rightbelow vnew<CR>
nmap <leader>sl       :rightbelow vnew<CR>
nmap <leader>s<up>    :leftabove  new<CR>
nmap <leader>sk       :leftabove  new<CR>
nmap <leader>s<down>  :rightbelow new<CR>
nmap <leader>sj       :rightbelow new<CR>

"""""""""""""""""
" AUTO COMMANDS "
"""""""""""""""""

" :help autocmd to learn more
" BufEnter    - After entering a buffer.
" BufRead     - When starting to edit a new buffer, after reading the file
"               into the buffer, before executing the modelines.
" BufWinEnter - After a buffer is displayed in a window.
" ...

function! s:LoadCustomSettings()
    if filereadable("./vimrc")
        source ./vimrc
    endif
endfunction
autocmd! BufEnter * :call s:LoadCustomSettings()

" Highlight from the start of the file
function! s:FullSyntaxCheck()
    " My, what big files you have Grandma!
    if line('$') < 100 * 1000
        syntax sync fromstart
    endif
endfunction
autocmd! BufEnter,BufRead,BufWinEnter * :call s:FullSyntaxCheck()
