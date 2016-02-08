" execute pathogen#infect()
filetype plugin indent on
syntax enable
filetype indent plugin on
set wildmenu
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set nostartofline
set mouse=a
set cmdheight=2
set number
set pastetoggle=<F10>
set shiftwidth=4
set softtabstop=4
set expandtab
nnoremap <C-L> :nohl<CR><C-L>

let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=0
let g:flake8_show_quickfix=1

" autocmd BufWritePost *.py call Flake8()

highlight Pmenu ctermfg=black ctermbg=gray
highlight PmenuSel ctermfg=red  ctermbg=gray

