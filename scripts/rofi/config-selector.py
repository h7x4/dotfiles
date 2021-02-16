#!/bin/python3

from subprocess import Popen, PIPE
from os.path import expandvars

def call_rofi(entries,command):
    proc = Popen(command,
            stdin=PIPE,
            stdout=PIPE)
    for e in entries:
        proc.stdin.write((e+"\n").encode('utf-8'))
    proc.stdin.close()
    answer = proc.stdout.read().decode('utf-8')
    return answer.replace("\n","")

with open('$HOME/.scripts/rofi/configfiles', 'r') as file:
  choices = dict([(file.capitalize(), path) for file, path in [line.split(' ') for line in file.readlines()]])
  choice = call_rofi(choices, ['rofi', '-dmenu','-i', '-matching', 'fuzzy', '-p', 'Configfile'])
  print(expandvars(choices[choice]), end='')

