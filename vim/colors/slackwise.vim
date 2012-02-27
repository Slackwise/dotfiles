" vim: fdm=marker
"  Author:      Adam Flanczewski <http://slackwi.se>
"  Description: IANADesigner, so this is just a colorscheme I will be adding
"               to as I continue to work on it.


"       #######################
"       ### Lost? Press zR ####
"       #######################



" BOILERPLATE --------------------------------------------------------------{{{
hi clear
if exists("syntax_on")
	syntax reset
endif
let g:colors_name = "slackwise"
set background=dark
" }}}----------------------------------


" UTILITY FUNCTIONS --------------------------------------------------------{{{
command! -nargs=+ DefHi call s:defhighlight(<f-args>)
function! s:defhighlight(...)
    
endfunction

command! -nargs=+ Hi call s:usehighlight(<f-args>)
function! s:usehighlight(name, ...)
    let colour_order = ['guifg', 'guibg']
    let command = 'hi ' . a:name
    if (len(a:000) < 1) || (len(a:000) > (len(colour_order)))
        echoerr "No colour or too many colours specified"
    else
        for i in range(0,len(a:000)-1)
            let command . ' ' . colour_order[i] . '=' . a:000[i]
        endfor
        exe command
    endif
endfunction
" }}}----------------------------------


" COLOR DEFINITIONS --------------------------------------------------------{{{
" }}}----------------------------------

 
" USER INTERFACE -----------------------------------------------------------{{{
" }}}----------------------------------


" GENERAL ------------------------------------------------------------------{{{
" }}}----------------------------------
 
 
" RUBY ---------------------------------------------------------------------{{{
" }}}----------------------------------
