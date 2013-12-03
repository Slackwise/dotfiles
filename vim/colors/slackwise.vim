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
function! s:highlight(highlight, style)
    let command = 'hi ' . 
        \ a:highlight . 
        \ ' guifg=' . a:style[0]
    execute command
endfunction

function! s:sethighlights(highlights)
    for key in keys(a:highlights)
        call s:highlight(key, a:highlights[key])
    endfor
endfunction
" }}}----------------------------------


" COLOR DEFINITIONS --------------------------------------------------------{{{
"
" Focusing on the RGB Additive color system allows me to differentiate tokens
" faster than if I use aesthetically pleasing colors that are too similar.
"
" First and foremost: Syntax Highlighting is for function, not aesthetics.
"
"                                   FIXME: cterm uses 8-bit integers!
let s:colors = {
    \ 'black':          ['#000000', '#000000'],
    \ 'white':          ['#FFFFFF', '#FFFFFF'],
    \ 'red':            ['#FF0000', '#FF0000'],
    \ 'green':          ['#00FF00', '#00FF00'],
    \ 'blue':           ['#0000FF', '#0000FF'],
    \ 'cyan':           ['#00FFFF', '#00FFFF'],
    \ 'magenta':        ['#FF00FF', '#FF00FF'],
    \ 'yellow':         ['#FFFF00', '#FFFF00'],
\}
" }}}----------------------------------


" STYLE DEFINITIONS --------------------------------------------------------{{{
"                   RR
"                  RRRR
"                 RRRRRR
"                RRRRRRRR
"               RRRRRRRRRR
"              RRRRRRRRRRRR
"             RRRRRRRRRRRRRR
"            RRRRRRRRRRRRRRRR
"           RRRRRRRRRRRRRRRRRR          
"          B                  G
"         BBB                GGG
"        BBBBB              GGGGG
"       BBBBBBB            GGGGGGG
"      BBBBBBBBB          GGGGGGGGG
"     BBBBBBBBBBB        GGGGGGGGGGG
"    BBBBBBBBBBBBB      GGGGGGGGGGGGG
"   BBBBBBBBBBBBBBB    GGGGGGGGGGGGGGG
"  BBBBBBBBBBBBBBBBB  GGGGGGGGGGGGGGGGG
" BBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGG
" 
" Red           Power           Scalars
" Green         Courage         Functions
" Blue          Wisdom          Keywords
"
"     (Yes, I'm a huge Zelda nerd.)
"
"       {{ WORK IN PROGRESS }}
"
let s:styles = {
    \ 'power':      s:colors.red,
    \ 'courage':    s:colors.green,
    \ 'wisdom':     s:colors.blue,
\}
" }}}----------------------------------

 
" USER INTERFACE -----------------------------------------------------------{{{
" }}}----------------------------------


" GENERAL ------------------------------------------------------------------{{{
call s:sethighlights({
    \ 'String':         s:styles.power,
\})
" }}}----------------------------------
 
 
" RUBY ---------------------------------------------------------------------{{{
" }}}----------------------------------
