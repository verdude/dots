set -e

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
xset b 0 200 200

source ~/.Xprofile
xrdb -merge ~/.Xresources

xrandr_out=$(xrandr)

if xrandr_out | grep -q "DP-2 connected" && xrandr_out | grep -q "DP-0 connected"; then
  xrandr --output DP-2 --mode 3840x2160 --rate 144 --primary
  xrandr --output DP-0 --mode 2560x1440 --rate 144 --right-of DP-2
fi

exec i3
