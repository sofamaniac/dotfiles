#!/usr/bin/env python
import subprocess
import time

WIDTH=20

def get_track():
    player = ""
    with open("/var/tmp/player_selector", "r") as file:
        player = file.read()

    proc = subprocess.Popen(["playerctl", "-p", player, "-s", "metadata", "title"], stdout=subprocess.PIPE)
    title, err = proc.communicate()
    new_title = title.decode().strip()
    if new_title == get_track.old_title:
        return new_title, False
    else:
        get_track.old_title = new_title
        return new_title, True

get_track.old_title = ""

def get_length(s):
    length_proc = subprocess.Popen(["wc", "-L"], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    out, err = length_proc.communicate(input=s.encode())
    return int(out.decode().strip())

def make_string(title, start):
    end = max(len(title), WIDTH)
    while get_length(title[start:end])> WIDTH:
        end -= 1
    final_size = get_length(title[start:end])
    final_string = title[start:end] + (' '*(WIDTH - final_size))
    return final_string

def make_all(title):
    true_length = len(title)
    if get_length(title) < WIDTH:
        return [title]
    title = prep_title(title)
    res = []
    for i in range(true_length + WIDTH//2):
        res.append(make_string(title, i))
    return res


def prep_title(title):
    title = title + ' ' * (WIDTH//2) + title
    return title


SONG_REFRESH=1.00
IN_BETWEEN_PAUSE=5.000
ADVANCE_DELAY = 0.400

def main():
    title = prep_title("")
    start = 0
    last_time = time.time()
    last_song_refresh=time.time()
    time_beginning = time.time()
    time_advance = time.time()
    strings = []
    while True:
        t = time.time()
        if t - last_song_refresh:
            title, changed = get_track()
            if changed:
                start = 0
                time_beginning = t
                strings = make_all(title)
        if start == 0 and t - time_beginning > IN_BETWEEN_PAUSE:
            start += 1
            time_advance = t
        if start > 0 and t - time_advance > ADVANCE_DELAY:
            start += 1
            time_advance = t

        if start == len(strings):
            time_beginning = t

        if len(strings):
            start = start % len(strings)
            print(strings[start], flush=True)
        time.sleep(0.100)
        last_time = t



main()
