"###################################################################################################
" Vim Terminal Text Editor
"###################################################################################################
scriptencoding utf8

"##########################################################################
" CUSTOM STATUS LINE
"##########################################################################
" clear/reset status line
set statusline=

" marker for beginning of status line
set statusline+=--
" display [RO] if file is read only
set statusline+=\ %r
" display [+] if file was modified
set statusline+=\ %m
" show full path to file
set statusline+=\ %F
" maker for end of left side
set statusline+=\ --

" separate left and right side
set statusline+=%=
" insert things here to show in middle part
set statusline+=%*
set statusline+=%=

set statusline+=\ --
" current position on line
set statusline+=\ Pos:%c
" current line/total lines in document
set statusline+=\ Line:%l/%L

" divider for position and file info
set statusline+=\ --

" show file encoding
set statusline+=\ [Enc:%{&fenc}]
" show file format
set statusline+=\ [Frmt:%{&ff}]

" marker for end of line
set statusline+=\ --

"##########################################################################
" CUSTOM SETTINGS
"##########################################################################

" system clipboard (requires +clipboard)
set clipboard+=unnamed,unnamedplus
" enable vim mode lines
set modeline
" highlight search items
set hlsearch
" searches are performed as you type
set incsearch
" enable line numbers
set number
" Enable relative line numbering
set rnu
" ask confirmation like save before quit.
set confirm
" Tab completion menu when using command mode
set wildmenu
" Tab key inserts spaces not tabs
set expandtab
" spaces to enter for each tab
set softtabstop=4
" amount of spaces for indentation
set shiftwidth=4
" Hide or shorten certain messages
set shortmess+=aAcIws
" Show current mode vim is in
set showmode
" set line length too 100 chars
set textwidth=100
" display red line as marker for text width + 1 chars
set colorcolumn=+1
" map leader to ,
let g:mapleader = ","
" set background to dark
set background=dark
" enable custom status line
set laststatus=2
" show commands/keys as they are being typed in
set showcmd
" enable mouse awareness
set mouse=a
" enable file type specific plugins
filetype plugin on
" enable syntax highlighting
syntax enable

"##########################################################################
" CUSTOM ALIAS AND HOTKEYS
"##########################################################################
" show whitespaces
set listchars=eol:$,space:_,tab:>#,trail:~
nmap <F5> :set list! list?<cr>

