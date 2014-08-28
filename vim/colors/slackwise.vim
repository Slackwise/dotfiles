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
        \ ' guifg=' . a:style[0] .
        \ ' gui=NONE'
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
" Colors adapted from Google's Material specs:
"   http://www.google.com/design/spec/style/color.html
"
" TODO: Add backgrounds? Optionals?
"                                   FIXME: cterm uses 8-bit integers!
let s:colors = {
    \ 'black':          ['#050505'],
    \ 'white':          ['#FFFBFF'],
    \ 'grey':           ['#9e9e9e'],
    \ 'red':            ['#e51c23'],
    \ 'green':          ['#259b24'],
    \ 'blue':           ['#5677fc'],
    \ 'pink':           ['#e91e63'],
    \ 'purple':         ['#9c27b0'],
    \ 'deeppurple':     ['#673ab7'],
    \ 'indigo':         ['#3f51b5'],
    \ 'lightblue':      ['#03a9f4'],
    \ 'lightgreen':     ['#8bc34a'],
    \ 'lime':           ['#cddc39'],
    \ 'cyan':           ['#00bcd4'],
    \ 'teal':           ['#009688'],
    \ 'yellow':         ['#ffeb3b'],
    \ 'amber':          ['#ffc107'],
    \ 'orange':         ['#ff9800'],
    \ 'deeporange':     ['#ff5722'],
    \ 'brown':          ['#795548'],
    \ 'bluegrey':       ['#607d8b']
\}
" }}}----------------------------------


" STYLE DEFINITIONS --------------------------------------------------------{{{
let s:styles = {
    \ 'whiteish':     s:colors.white,
    \ 'greyish':      s:colors.grey,
    \ 'cautionish':   s:colors.red,
    \ 'execish':      s:colors.green,
    \ 'constantish':  s:colors.blue,
    \ 'commentish':   s:colors.grey,
\}
" }}}----------------------------------

 
" USER INTERFACE -----------------------------------------------------------{{{
" }}}----------------------------------


" GENERAL ------------------------------------------------------------------{{{
let s:fgbg = 'hi Normal guifg=' . s:colors.white[0] . ' guibg=' . s:colors.black[0]
exec s:fgbg
call s:sethighlights({
    \ 'Comment':        s:styles.commentish,
    \ 'String':         s:styles.cautionish,
    \ 'Float':          s:styles.cautionish,
    \ 'Number':         s:styles.cautionish,
    \ 'Boolean':        s:styles.constantish,
    \ 'Character':      s:styles.cautionish,
    \ 'Function':       s:styles.execish,
    \ 'Keyword':        s:styles.constantish,
    \ 'PreProc':        s:styles.whiteish,
    \ 'Identifier':     s:styles.whiteish,
    \ 'Delimiter':      s:styles.whiteish,
    \ 'Statement':      s:styles.whiteish,
    \ 'Constant':       s:styles.constantish,
    \ 'Special':        s:styles.constantish,
    \ 'Type':           s:styles.constantish,
    \ 'FoldColumn':     s:styles.greyish,
    \ 'SignColumn':     s:styles.greyish,
    \ 'LineNr':         s:styles.greyish,
\})
" }}}----------------------------------
 
 
" RUBY ---------------------------------------------------------------------{{{
" }}}----------------------------------
