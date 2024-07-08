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
    return title.decode().strip()

def get_length(s):
    proc = subprocess.Popen(["echo", s], stdout=subprocess.PIPE)
    length_proc = subprocess.Popen(["wc", "-L"], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    out, err = length_proc.communicate(input=s.encode())
    return int(out.decode().strip())

def make_string(title, start):
    end = 0
    while end < len(title) and get_length(title[start:end]) < WIDTH:
        end += 1
    if get_length(title[start:end])> WIDTH:
        end -= 1
    final_size = get_length(title[start:end])
    final_string = title[start:end] + (' '*(WIDTH - final_size))
    return final_string

def prep_title(old_title):
    title = get_track()
    title = title + ' ' * WIDTH + title
    if old_title == title:
        return old_title, False
    return title, True


SONG_REFRESH=1.500
IN_BETWEEN_PAUSE=1.500
ADVANCE_DELAY = 0.400

def main():
    title = prep_title("")
    start = 0
    last_song_refresh=time.time()
    time_beginning = time.time()
    time_advance = time.time()
    while True:
        if time.time() - last_song_refresh:
            title, changed = prep_title(title)
            if changed:
                start = 0
                time_beginning = time.time()
        if start == 0 and time.time() - time_beginning > IN_BETWEEN_PAUSE:
            start += 1
            time_advance = time.time()
        if start > 0 and time.time() - time_advance > ADVANCE_DELAY:
            start += 1
            time_advance = time.time()

        start = start % len(title)
        print(make_string(title, start))
        time.sleep(0.100)


main()
