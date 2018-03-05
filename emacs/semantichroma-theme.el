;;; semantichroma-theme.el

(deftheme semantichroma
  "Semantic colors")

(defconst material-colors
  '(('black'          . '#050505')
    ('white'          . '#FFFBFF')
    ('grey'           . '#9e9e9e')
    ('red'            . '#e51c23')
    ('green'          . '#259b24')
    ('blue'           . '#5677fc')
    ('pink'           . '#e91e63')
    ('purple'         . '#9c27b0')
    ('deeppurple'     . '#673ab7')
    ('indigo'         . '#3f51b5')
    ('lightblue'      . '#03a9f4')
    ('lightgreen'     . '#8bc34a')
    ('lime'           . '#cddc39')
    ('cyan'           . '#00bcd4')
    ('teal'           . '#009688')
    ('yellow'         . '#ffeb3b')
    ('amber'          . '#ffc107')
    ('orange'         . '#ff9800')
    ('deeporange'     . '#ff5722')
    ('brown'          . '#795548')
    ('bluegrey'       . '#607d8b')))

(defconst semantichroma-colors '())

 
;; Not a bad idea to define a palette...
(let (
   (color-1 "#ffffff") 
   (color-2 "#ff0000") 
   (color-3 "#00ff00")
   (color-4 "#0000ff"))
 
  ;; Set faces
  (custom-theme-set-faces
   'semantichroma ;; you must use the same theme semantichroma here...
   '(default ((t (:foreground ,color-1 :background black))))
   '(cursor  ((t (:background ,color-4))))
   '(fringe  ((t (:background ,color-3))))
   ;;; etc... 
   ;;; don't use these settings of course, 
   ;;; they're horrible.
   )
 
  ;; Set variables
  (custom-theme-set-variables
   'semantichroma ;; again specify the same theme semantichroma...
   '(any-variable EXPR)
 
(provide-theme 'semantichroma)
