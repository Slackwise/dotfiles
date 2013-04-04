echo "media-libs/freetype infinality" >> /etc/portage/package.use
emerge freetype
eselect fontconfig enable 52-infinality.conf
eselect infinality set osx2
eselect lcdfilter set osx
