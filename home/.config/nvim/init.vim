"###################################################################################################
"                                 _
"  _ __     ___    ___   __   __ (_)  _ __ ___
" | '_ \   / _ \  / _ \  \ \ / / | | | '_ ` _ \
" | | | | |  __/ | (_) |  \ V /  | | | | | | | |
" |_| |_|  \___|  \___/    \_/   |_| |_| |_| |_|
"
" neovim configuration file
"###################################################################################################
" set script encoding
scriptencoding utf8

"###################################################################################################
" PLUGINS
" managed using vim-plug
"###################################################################################################
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.config/nvim/plugged')

" List starts here

" Ale
" https://github.com/dense-analysis/ale
" Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
" List of languages
" https://github.com/dense-analysis/ale/blob/master/supported-tools.md
Plug 'dense-analysis/ale'

" Indent Guides
" https://github.com/nathanaelkane/vim-indent-guides
" A Vim plugin for visually displaying indent levels in code
Plug 'nathanaelkane/vim-indent-guides'

" DelimitMate
" https://github.com/Raimondi/delimitMate
" Vim plugin, provides insert mode auto-completion for quotes, parens, brackets, etc.
Plug 'raimondi/delimitmate'

" vim-go
" https://github.com/fatih/vim-go
" Go development plugin for Vim
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" vim-surround
" https://github.com/tpope/vim-surround
" surround.vim: Delete/change/add parentheses/quotes/XML-tags/much more with ease 
Plug 'tpope/vim-surround'

" nvim-treesitter
" Nvim Treesitter configurations and abstraction layer
" List of supported languages https://github.com/nvim-treesitter/nvim-treesitter/tree/master#supported-languages
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" vim-nightfly-colors
" A dark midnight theme for modern Neovim & classic Vim 
Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }

" vim-moonfly-colors
" A dark charcoal theme for modern Neovim & classic Vim 
Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }

" List ends here
call plug#end()

"###################################################################################################
" PLUGIN SETTINGS
"###################################################################################################
" Vim-Indent-Guides
let g:indent_guides_enable_on_vim_startup = 1

"##########################################################################
" ALE SETTINGS
"##########################################################################
" lint on opening file
let g:ale_lint_on_enter = 1

" set fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace','prettier'],
\   'go': ['gofmt'],
\   'sh': ['shfmt'],
\   'markdown': ['pandoc'],
\}

" set linters
let g:ale_linters = {
\   '*': ['prettier'],
\   'go': ['gopls'],
\   'sh': ['shellcheck','language_server'],
\}

" enable ALE completion
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1

" enable hovering
let g:ale_hover_cursor = 1
" let g:ale_set_balloons = 1
" let g:ale_cursor_detail = 1

" function for counting number of erros in buffer, used in statusline
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

" custom ALE commands
command Alint ALELint
command Afix ALEFix
command Agoto ALEGoToDefinition

" go to next error
nmap <silent> <C-e> <Plug>(ale_next_wrap)
"nmap <silent> <C-k> <Plug>(ale_previous_wrap)
"nmap <silent> <C-j> <Plug>(ale_next_wrap)

"##########################################################################
" TREESITTER SETTINGS
"##########################################################################
" Use inline lua here to set treesitter options
" TODO Surely i will port my config to lua someday
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

"##########################################################################
" MOONFLY THEME SETTINGS
"##########################################################################
let g:moonflyUndercurls = v:true

"###################################################################################################
" CUSTOM STATUS LINE
"###################################################################################################
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

"###################################################################################################
" CUSTOM SETTINGS
"###################################################################################################
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

"###################################################################################################
" SPELL CHECKER SETTINGS
"###################################################################################################
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

"###################################################################################################
" CUSTOM ALIAS AND HOTKEYS
"###################################################################################################
" show whitespaces
set listchars=eol:$,space:_,tab:>#,trail:~
nmap <F5> :set list! list?<cr>

" insert ![Bild](/preview) at current line, used for embedding images in markdown
command MDNexImage :normal i![Bild](/preview)


"###################################################################################################
" COLORSCHEME SETTINGS
" put at bottom to overwrite previous color settings
"###################################################################################################
" set colorscheme
colorscheme moonfly
