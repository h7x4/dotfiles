#!/usr/bin/env bash

ifExistsThen() {
  if command -v $1 &> /dev/null; then 
    eval $2
  fi
}

xrdb -merge ~/.Xresources
export _JAVA_AWT_WM_NONREPARENTING=1

# ░█▀▄░▀█▀░█▀▀░█▀█░█░░░█▀█░█░█
# ░█░█░░█░░▀▀█░█▀▀░█░░░█▀█░░█░
# ░▀▀░░▀▀▀░▀▀▀░▀░░░▀▀▀░▀░▀░░▀░

# export QT_AUTO_SCREEN_SCALE_FACTOR=1

ifExistsThen picom \
  "picom --experimental-backends &"
ifExistsThen feh \
  "feh --bg-fill $HOME/Dropbox/bilder/Wallpapers/pixiv/80242900_p0.jpg"

# ░█░█░█▀▀░█░█░█▀▀
# ░█▀▄░█▀▀░░█░░▀▀█
# ░▀░▀░▀▀▀░░▀░░▀▀▀

setxkbmap -option caps:escape

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# ░▀█▀░█▀▄░█▀█░█░█
# ░░█░░█▀▄░█▀█░░█░
# ░░▀░░▀░▀░▀░▀░░▀░

# flameshot &
# pa-applet &
ifExistsThen nm-applet \
  "nm-applet --sm-disable --indicator &"
ifExistsThen dropbox \
  "dropbox &"
ifExistsThen fcitx \
  "fcitx &"
ifExistsThen protonmail-bridge \
  "protonmail-bridge --no-window &"
ifExistsThen mpd \
  "mpd"
ifExistsThen piavpn \
  "piavpn"
ifExistsThen copyq \
  "copyq --start-server"

source ~/.aliases

xmonad