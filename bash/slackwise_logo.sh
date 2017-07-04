#!/bin/bash

# Via: https://max.io/bash.html?zip=Zzl4MzFlMWcyeDNnNHgzMWUxZzJ4MXczZzN4MzFlMWcxeDJ3MXgzZzJ4MzFlMWcyeDF3M3gxZzJ4MzFlMWcyeDN3MXgyZzF4MzFlMWczdzN4MWcyeDMxZTFnNHgzZzJ4MzFlMWc5eDMxZTF4NDBlMXg0MGUxeDQwZTF4NDBlMXg0MGUxeDQwZTF4NDBlMXg0MGUxeDQwZTF4NDBlMXg0MGUxeDQwZTF4NDBlMXg0MA==

#Background Colors
E=$(tput sgr0);    R=$(tput setab 1); G=$(tput setab 2); Y=$(tput setab 3);
B=$(tput setab 4); M=$(tput setab 5); C=$(tput setab 6); W=$(tput setab 7);
function e() { echo -e "$E"; }
function x() { echo -n "$E  "; }
function r() { echo -n "$R  "; }
function g() { echo -n "$G  "; }
function y() { echo -n "$Y  "; }
function b() { echo -n "$B  "; }
function m() { echo -n "$M  "; }
function c() { echo -n "$C  "; }
function w() { echo -n "$W  "; }

#putpixels
function u() { 
    h="$*";o=${h:0:1};v=${h:1}; 
    for i in `seq $v` 
    do 
        $o;
    done 
}

img="\
g9 x31 e1 g2 x3 g4 x31 e1 g2 x1 w3 g3 x31 e1 g1 x2 w1 x3 g2 x31 e1 g2 x1 w3 x1 g2 x31 e1 g2 x3 w1 x2 g1 x31 e1 g3 w3 x1 g2 x31 e1 g4 x3 g2 x31 e1 g9 x31 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40"

for n in $img
do
    u $n
done
e;
exit 0;
