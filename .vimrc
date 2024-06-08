" language
syntax on                     " Basic syntax highlighting
" setlocal spell spelllang=en_us " Enable spell check

" keys
" nnoremap <space> <nop>
let mapleader="\\"
set backspace=indent,eol,start    " Make backspace key work as one would expect

" search
nnoremap / /\v
vnoremap / /\v
set ignorecase " Case-insensitive search by default
set smartcase  " Case-sensitive search when specified
set hlsearch   " Highlight search matches
set incsearch  " Highlight search matches dynamically as they are typed
" begin search for current selection in visual mode
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction
" end search for current selection in visual mode

" notifications
set visualbell " Screen flashes instead of audible bell

" history
set undofile " Allow undo history to persist after file is closed

" visuals
" set colorcolumn=100
set formatoptions=qrn1
set relativenumber     " Show relative line numbers to left of editor
set nu rnu             " Show current absolute line number to left of editor
set scrolloff=5        " Keep at least 5 lines at bottom of screen when scrolling
set textwidth=80
set wrap
set cursorline
" set termguicolors

" autocomplete
set wildmenu
set wildmode=full
set infercase  " Infer case matching for autocompletion
" enable omni-completion
set nocompatible
filetype plugin on

" make & trigger && to preserve flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" custom commands
" nnoremap <leader>w <C-w>v<C-w>l " Split window vertically
" nnoremap <C-h> <C-w>h                " Move between splits to left
" nnoremap <C-j> <C-w>j                " Move between splits down
" nnoremap <C-k> <C-w>k                " Move between splits up
" nnoremap <C-l> <C-w>l                " Move between splits to right
nnoremap <silent> <leader>cs :<C-u>nohlsearch<CR><C-l> " Clear search highlighting temporarily

" tabs & indentation
set tabstop=2     " 2 spaces per tab
set shiftwidth=2  " 2 spaces for indent width
set expandtab     " expand tab to spaces
set autoindent    " copy indent from current line to new line

" easy expansion for active file dir
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" quickfix helpers
nnoremap <leader>qo :copen<CR> " Open quick fix menu
nnoremap <leader>qx :cclose<CR> " Close quick fix menu
