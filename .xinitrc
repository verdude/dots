set -e

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
xset b 0 200 200
xset s off -dpms

source ~/.Xprofile
xrdb -merge ~/.Xresources

exec i3
