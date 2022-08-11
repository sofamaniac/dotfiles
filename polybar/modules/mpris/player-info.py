#!/usr/bin/env python
"""
Script to display info of mpris player with
limited text length
"""

import time
import sys
import subprocess
from wcwidth import wcwidth

CMD_PREFIX = ["playerctl"]
LENGTH = 20  # max length of text
INTERVAL_QUERY = 1  # time between querying playerctl for info
INTERVAL_ANIMATION = 5  # for how long the text is not moving between cycles

def char_size(char):
    return wcwidth(char)

def run_playerctl(parameters):
    player = ""
    with open("/home/sofamaniac/dotfiles/polybar/modules/mpris/player") as f:
        player = f.read().strip()
    if player == "default":
        res = subprocess.run(CMD_PREFIX + parameters, capture_output=True, encoding="utf-8")
    else:
        res = subprocess.run(CMD_PREFIX + ["-p", player] + parameters, capture_output=True, encoding="utf-8")
    return res.stdout.strip()

def _print(string, *args):
    print(string, *args)
    sys.stdout.flush()

def create_string_of_length(string, length, start=0):
    i = start
    l = 0
    while i < len(string) and l < length:
        l += char_size(string[i])
        i += 1
    while l > length:
        i -= 1
        l -= char_size(string[i])
    return i, length - l

def create_slices(title):
    result = []
    offset = 0
    if len(title) < LENGTH:
        return [title]
    end = 0
    title2 = title + (LENGTH//2)*' ' + title
    while offset < len(title) + LENGTH//2:
        end, space = create_string_of_length(title2, LENGTH, offset)
        result.append(title2[offset:end] + " "*space)
        offset += 1
    return result

title = ""
slices = [""]
offset = 0
last_query = time.time() - INTERVAL_QUERY
last_reset = time.time() - INTERVAL_ANIMATION
while True:
    sys.stdout.flush()
    t = time.time()
    if run_playerctl(["status"]) not in ["Playing", "Paused"]:
        _print(run_playerctl(["status"]))
    else:
        if t - last_query > INTERVAL_QUERY:
            new_title = run_playerctl(["metadata","title"])
            if new_title != title:
                title = new_title
                slices = create_slices(title)
                offset = 0
                last_reset = t
            last_query = t
        if offset >= len(slices):
            offset = 0
            last_reset = t
        _print(slices[offset])
        if t - last_reset > INTERVAL_ANIMATION:
            offset += 1
    time.sleep(0.15)



