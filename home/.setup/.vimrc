"###################################################################################################
"          _
" __   __ (_)  _ __ ___
" \ \ / / | | | '_ ` _ \
"  \ V /  | | | | | | | |
"   \_/   |_| |_| |_| |_|
"
" vim configuration file
"###################################################################################################
" set script encoding
scriptencoding utf8

"###################################################################################################
" CUSTOM STATUSLINE
"###################################################################################################
set statusline=                                 " Clear line
set statusline+=\--\                            " Divider
set statusline+=%r                              " Display read only
set statusline+=\ %F                            " Full Path to file
set statusline+=\ %m                            " Display modified flag

set statusline+=\ --\                           " Divider
set statusline+=%=
set statusline+=%*                              "

set statusline+=%=                              " Seperate left and right part of line

set statusline+=\ [Enc:%{&fenc}]                " Display file encoding
set statusline+=\ [Format:%{&ff}]               " Display file format
set statusline+=\ --\                           " Divider
set statusline+=\ Pos:%c                       " Display current line number
set statusline+=\ Line:%l                       " Display current line number
set statusline+=\/%L                      " Display total number of lines
set statusline+=\ --\                           " Divider

"###################################################################################################
" CUSTOM SETTINGS
"###################################################################################################
" system clipboard (requires +clipboard)
set clipboard^=unnamed,unnamedplus
set modeline          " enable vim modelines
set hlsearch          " highlight search items
set incsearch         " searches are performed as you type
set number            " enable line numbers
set rnu               " Enable relative line numbering
set confirm           " ask confirmation like save before quit.
set wildmenu          " Tab completion menu when using command mode
set expandtab         " Tab key inserts spaces not tabs
set softtabstop=4     " spaces to enter for each tab
set shiftwidth=4      " amount of spaces for indentation
set shortmess+=aAcIws " Hide or shorten certain messages
set showmode          " Show current mode vim is in
set colorcolumn=+1
set textwidth=100

" map leader to ,
let g:mapleader = ","

" enable filetype specific plugins
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
" INSERTING SNIPPET COMMANDS
"###################################################################################################
" insert ![Bild](/preview) at current line, used for embedding images in markdown
command MDNexImage :normal i![Bild](/preview)

"###################################################################################################
" settings i have not checked yet and idk what they do
"###################################################################################################
" local keyword jump
nnoremap <Leader>fw
    \ [I:let b:jump = input('Go To: ') <Bar>
    \ if b:jump !=? '' <Bar>
    \   execute "normal! ".b:jump."[\t" <Bar>
    \   unlet b:jump <Bar>
    \ endif <CR>


" quit the current buffer and switch to the next
" without this vim will leave you on an empty buffer after quiting the current
function! <SID>quitbuffer() abort
    let l:bf = bufnr('%')
    let l:pb = bufnr('#')
    if buflisted(l:pb)
        buffer #
    else
        bnext
    endif
    if bufnr('%') == l:bf
        new
    endif
    if buflisted(l:bf)
        execute('bdelete! ' . l:bf)
    endif
endfunction

" switch active buffer based on pattern matching
" if more than one match is found then list the matches to choose from
function! <SID>bufferselect(pattern) abort
    let l:bufcount = bufnr('$')
    let l:currbufnr = 1
    let l:nummatches = 0
    let l:matchingbufnr = 0
    " walk the buffer count
    while l:currbufnr <= l:bufcount
        if (bufexists(l:currbufnr))
            let l:currbufname = bufname(l:currbufnr)
            if (match(l:currbufname, a:pattern) > -1)
                echo l:currbufnr.': '.bufname(l:currbufnr)
                let l:nummatches += 1
                let l:matchingbufnr = l:currbufnr
            endif
        endif
        let l:currbufnr += 1
    endwhile

    " only one match
    if (l:nummatches == 1)
        execute ':buffer '.l:matchingbufnr
    elseif (l:nummatches > 1)
        " more than one match
        let l:desiredbufnr = input('Enter buffer number: ')
        if (strlen(l:desiredbufnr) != 0)
            execute ':buffer '.l:desiredbufnr
        endif
    else
        echoerr 'No matching buffers'
    endif
endfunction
