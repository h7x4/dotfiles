#!/bin/python
#
# Based on: https://superuser.com/a/1452828

import unicodedata
from itertools import chain
# from os import walk, path
import os
from fontTools.ttLib import TTFont

def find_fonts_in(path):
  fonts = []
  for root,dirs,files in os.walk(path):
    for file in files:
      if file.endswith(".ttf"): fonts.append(os.path.join(root,file))
  return fonts

def char_in_font(unicode_char, font):
  for cmap in font['cmap'].tables:
    if cmap.isUnicode():
      if ord(unicode_char) in cmap.cmap:
        return True
  return False

def test(ch, fonts):
  for fontpath in fonts:
    font = TTFont(fontpath)
    if char_in_font(ch, font):
      print(ch + " "+ unicodedata.name(ch) + " in " + fontpath) 

if __name__ =='__main__':
  font_dirs = [ "/usr/share/fonts/"
              , "/usr/local/share/fonts/"
              , "~/.local/share/fonts"
              ]
  fonts = [font for font_dir in font_dirs for font in find_fonts_in(font_dir)]

  test(u'🪞', fonts)
