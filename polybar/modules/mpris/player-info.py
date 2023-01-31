#!/usr/bin/env python
"""
Script to display info of mpris player with
limited text length
"""

import time
import sys
import subprocess
from wcwidth import wcwidth
from dbus_next.aio import MessageBus

import asyncio


CMD_PREFIX = ["playerctl"]
LENGTH = 20  # max length of text
INTERVAL_QUERY = 1  # time between querying playerctl for info
INTERVAL_ANIMATION = 5  # for how long the text is not moving between cycles

title = ""
duration = ""
timestamp = "00:00/00:00"
slices = [""]
offset = 0
last_reset = time.time()
last_query = time.time()
player_name = ""


def char_size(char):
    return wcwidth(char)


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


async def get_info(player):
    metadata = await player.get_metadata()
    title = metadata["xesam:title"].value
    duration = int(metadata["mpris:duration"].value // 1e6)
    dur_m, dur_s = divmod(duration, 60)
    dur_h, dur_m = divmod(dur_m, 60)
    hour_str = f"{dur_h:02d}:" if dur_h > 0 else ""
    return title, f"{hour_str}{dur_m:02d}:{dur_s:02d}"


async def get_position(player):
    position = await player.get_position() // 1e6  # convert to second
    pos_m, pos_s = divmod(int(position), 60)
    pos_h, pos_m = divmod(int(pos_m), 60)
    hour_str = f"{pos_h:02d}:" if pos_h > 0 else ""
    return f"{hour_str}{pos_m:02d}:{pos_s:02d}"


def get_player_name():
    global player_name
    with open("/home/sofamaniac/dotfiles/polybar/modules/mpris/player", 'r') as f:
        player_name = f.read().strip()


def update_info(_title, _duration, reset=False):
    global title
    global slices
    global duration
    global offset
    if title != _title:
        reset = True
    title = _title
    duration = _duration
    if reset:
        slices = create_slices(title)
        offset = 0


async def main():
    bus = await MessageBus().connect()
    get_player_name()
    # the introspection xml would normally be included in your project, but
    # this is convenient for development
    introspection = await bus.introspect(f'org.mpris.MediaPlayer2.{player_name}', '/org/mpris/MediaPlayer2')

    obj = bus.get_proxy_object(f'org.mpris.MediaPlayer2.{player_name}', '/org/mpris/MediaPlayer2',
                               introspection)
    player = obj.get_interface('org.mpris.MediaPlayer2.Player')
    properties = obj.get_interface('org.freedesktop.DBus.Properties')

    # listen to signals
    async def on_properties_changed(interface_name, changed_properties, invalidated_properties):
        get_player_name()
        if "Metadata" in changed_properties:
            title, duration = await get_info(player)
            update_info(title, duration, reset=True)

    async def update_display():
        global offset
        global last_reset
        global last_query
        global duration
        position = await get_position(player)
        _print(f"({position}/{duration}) {slices[offset]}")
        t = time.time()
        if t - last_reset > INTERVAL_ANIMATION:
            offset += 1
        if offset >= len(slices):
            offset = 0
            last_reset = t
        if t - last_query > INTERVAL_QUERY:
            get_player_name()
            _title, _duration = await get_info(player)
            update_info(_title, _duration)
            last_query = t

    async def loop():
        while True:
            await update_display()
            await asyncio.sleep(0.15)

    properties.on_properties_changed(on_properties_changed)

    sys.stdout.flush()
    t, d = await get_info(player)
    update_info(t, d)
    await loop()
    await bus.wait_for_disconnect()


loop = asyncio.get_event_loop()
loop.run_until_complete(main())
