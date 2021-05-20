#!/usr/bin/python

import argparse
from sys import argv
from pathlib import Path
from os import path, link, remove, walk, mkdir

DEBUG_MODE = False
REPLACE_MODE = False

# def askYesNo(msg):
#   while True:
#     ans = input(msg + ' [Y/N]')
#     if ans in 'Yy':
#       return True
#     elif ans in 'Nn':
#       return False
#     else:
#       print('Please answer with Y or N')

def info(msg):
  print(f'\033[1;32m[INFO] {msg}\033[0m')

def warn(msg):
  print(f'\033[1;33m[WARNING] {msg}\033[0m')

def error(msg):
  print(f'\033[1;5;31m[ERROR] {msg}\033[0m')

def hardlink(src_path, dest_path):
  if not path.exists(src_path):
    error('File does not exist: ' + src_path)
    return
  
  if path.exists(dest_path):
    if REPLACE_MODE:
      info('Removing ' + dest_path)
      if not DEBUG_MODE:
        remove(dest_path)
    else:
      warn(f'File {dest_path} already exists. Skipping')
      return
    
  info('Linked ' + src_path + " -> " + dest_path)
  if not DEBUG_MODE:
    link(src_path, dest_path)

def copy_folder_structure(src_dir, dest_dir):
  for root, dirs, _ in walk(src_dir):
    for d in dirs:
      new_dir = path.join(dest_dir, d)
      if not path.isdir(new_dir):
        info('New dir: ' + new_dir)
        if not DEBUG_MODE:
          mkdir(new_dir)
      else:
        warn(f'Dir {new_dir} already exists. Skipping')
    break

def hardlink_contents_of(src_dir, dest_dir):
  for _, _, files in walk(src_dir):
    for file in files:
      hardlink(path.join(src_dir, file), path.join(dest_dir, file))
    break

def hardlink_dir_recursively(src_dir, dest_dir):
  for root, dirs, _ in walk(src_dir):
    src = path.join(path.abspath(src_dir), root[len(src_dir) + 1:])
    dest = dest_dir + root[len(src_dir):]
    copy_folder_structure(root, dest)
    hardlink_contents_of(src, path.abspath(dest))
  
def parse_file(filepath):
  with open(filepath) as file:
    return (line.split() for line in file.readlines() if len(line.split()) != 0)


if __name__ == '__main__':

  parser = argparse.ArgumentParser(description='Recursively hardlink dotfiles')

  parser.add_argument('-r', '--replace', dest='REPLACE_MODE', action='store_const',
                      const=True, default=False,
                      help='Replace files if they already exist at location')

  parser.add_argument('-d', '--debug', dest='DEBUG_MODE', action='store_const',
                      const=True, default=False,
                      help='Run a fake run where all ouput is generated but nothing is executed')

  parser.add_argument('SRC', nargs='?', metavar='src', type=str,
                      help='Source folder to recursively scan for files')

  parser.add_argument('DEST', nargs='?', metavar='dest', type=str,
                      help='Destination folder to hardlink all files to')
  
  args = parser.parse_args()

  DEBUG_MODE = args.DEBUG_MODE
  REPLACE_MODE = args.REPLACE_MODE

  if hasattr(args, 'src') and hasattr(args, 'dest'):
    src_dir = path.abspath(args.src)
    dest_dir = path.abspath(args.dest)
    hardlink_dir_recursively(src_dir, dest_dir)
  else:
    for src,dest in parse_file(path.join(Path(__file__).parent.absolute(), 'hardlinklist.txt')):
      project_dir = Path(__file__).parent.parent.absolute()
      src_dir = path.abspath(path.join(project_dir, path.expanduser(src)))
      dest_dir = path.abspath(path.join(project_dir, path.expanduser(dest)))

      if path.exists(src_dir):
        if path.isfile(src_dir):
          hardlink(src_dir, dest_dir)
        else:
          hardlink_dir_recursively(src_dir, dest_dir)
      else:
        error(src_dir + ' does not exist')