"###################################################################################################
" BASIC vim configuration file
"###################################################################################################
" set script encoding
scriptencoding utf8

"##########################################################################
" CUSTOM SETTINGS
"##########################################################################
" system clipboard (requires +clipboard)
set clipboard^=unnamed,unnamedplus
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
" SPELL CHECKER SETTINGS
"##########################################################################
" enable spellcheck for language DE or EN
" use z= to check for correction
command SpellDE setlocal spell spelllang=de
command SpellEN setlocal spell spelllang=en

hi clear SpellBad
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal

hi SpellBad cterm=underline, ctermfg=red
hi SpellCap cterm=underline, ctermfg=yellow
hi SpellRare cterm=underline, ctermfg=green
hi SpellLocal cterm=underline, ctermfg=grey

"##########################################################################
" CUSTOM STATUS LINE
"##########################################################################
" function to change color of status line depending on mode
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=Green ctermfg=2 guifg=Black ctermbg=0
  elseif a:mode == 'r'
    hi statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
  else
    hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
  endif
endfunction

" trigger for function
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

" default the status line to green when entering Vim
hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

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
" CUSTOM ALIAS AND HOTKEYS
"##########################################################################
" show whitespaces
set listchars=eol:$,space:_,tab:>#,trail:~
nmap <F5> :set list! list?<cr>

