#!/usr/bin/env python3
# Copyright 2026 Paul Maddern (paul@arcadegeek.co.uk)
"""Render The Trap Door rooms as an OpenSeadragon Deep Zoom image.

Each room camera window is drawn with the game's own frame path used by
#ROOM in sources/trapdoor.ref: clear both display buffers at $EA3C,
populate them at $E6DB (room passes $00 to $05 over $8B69 to $9207, so
brickwork, arches, ladders and furniture all land), then blit at $E991.
Camera edges are written to $72FB and $72FC.

The camera code at $F1F3 steps $72FB by $20 between $20 and $A0, so
there are five upper cameras. Placement follows the C64-Wiki Spectrum
map: Storage Cupboard left, Patio right, Swamp under the Weight room.
The Weight to Patio wrap is at $F226, and the Patio to Weight wrap is
at $F240. The Swamp camera at $E0 to $FF is entered from the Weight
room via the white arch entity at $917B ($B771 to $B785).

Writes castle-map.dzi plus PNG tiles into each images directory.
"""
import argparse
import math
import os
import shutil
import sys

import numpy as np
from PIL import Image, ImageDraw
from skoolkit import ROM48, read_bin_file
from skoolkit.simulator import Simulator
from skoolkit.snapshot import get_snapshot

SCALE = 2
TILE_SIZE = 512
PAD = 16
GAP = 12
PLAY_W = 256
PLAY_H = 192
CELL_W = PLAY_W + GAP
CELL_H = PLAY_H + GAP
TITLE_H = 18

# Camera windows from sources/rooms.ref / #ROOM (five upper + Swamp).
ROOMS = (
    # id, cam_lo, cam_hi, short title
    (0x00, 0x20, 0x40, 'Patio'),
    (0x01, 0x40, 0x60, 'Storage Cupboard'),
    (0x03, 0x60, 0x80, 'Trap Door'),
    (0x04, 0x80, 0xA0, 'Kitchen'),
    (0x05, 0xA0, 0xC0, 'Weight'),
    (0x06, 0xE0, 0xFF, 'Swamp'),
)

# Wiki-style placement: Storage Cupboard left, Patio right, Swamp under Weight.
GRID = {
    0x01: (0, 0),  # Storage Cupboard
    0x03: (1, 0),  # Trap Door
    0x04: (2, 0),  # Kitchen
    0x05: (3, 0),  # Weight
    0x00: (4, 0),  # Patio
    0x06: (3, 1),  # Swamp under Weight
}

# Rising camera X neighbours. Weight wraps to Patio at $F226 / $F240.
CAMERA_LINKS = (
    (0x00, 0x01),  # Patio / Storage Cupboard (normal $20 step)
    (0x01, 0x03),  # Storage Cupboard / Trap Door
    (0x03, 0x04),  # Trap Door / Kitchen
    (0x04, 0x05),  # Kitchen / Weight
    (0x05, 0x00),  # Weight / Patio (wrap)
)

# Wiki edges among the five upper rooms, plus Swamp under Weight.
WIKI_LINKS = (
    (0x01, 0x03),  # Storage Cupboard / Trap Door
    (0x03, 0x04),  # Trap Door / Kitchen
    (0x04, 0x05),  # Kitchen / Weight
    (0x05, 0x00),  # Weight / Patio (wrap)
    (0x00, 0x01),  # Patio / Storage Cupboard
    (0x05, 0x06),  # Weight / Swamp (white arch at $917B)
)


def word_set(memory, addr, value):
    memory[addr] = value & 0xFF
    memory[addr + 1] = (value >> 8) & 0xFF


def run_routine(memory, start, sp=0x5BFC):
    """Run a game routine that returns via the address at SP (0)."""
    memory[sp] = 0
    memory[sp + 1] = 0
    sim = Simulator(memory, registers={'SP': sp})
    sim.run(start=start, stop=0)
    return list(sim.memory)


def draw_room(base, cam_lo, cam_hi):
    """Match #ROOM: $EA3C clear, $E6DB populate, $E991 blit."""
    memory = base[:]
    memory[0x4000:0x5B00] = [0] * 0x1B00
    memory[0x72F5] = 0xA0
    memory[0x72F6] = 0x63
    memory[0x72EA] = 0
    memory[0x72FB] = cam_lo & 0xFF
    memory[0x72FC] = cam_hi & 0xFF
    # Snapshot already holds the closed trap ($EDC9 types and lever $A809).
    for start in (0xEA3C, 0xE6DB, 0xE991):
        memory = run_routine(memory, start)
    return screen_rgb(memory)


def screen_rgb(memory):
    """Convert the Spectrum display file at $4000 into an RGB array."""
    ink = [
        (0, 0, 0),
        (0, 0, 0xD7),
        (0xD7, 0, 0),
        (0xD7, 0, 0xD7),
        (0, 0xD7, 0),
        (0, 0xD7, 0xD7),
        (0xD7, 0xD7, 0),
        (0xD7, 0xD7, 0xD7),
    ]
    bright = [
        (0, 0, 0),
        (0, 0, 0xFF),
        (0xFF, 0, 0),
        (0xFF, 0, 0xFF),
        (0, 0xFF, 0),
        (0, 0xFF, 0xFF),
        (0xFF, 0xFF, 0),
        (0xFF, 0xFF, 0xFF),
    ]
    pixels = np.zeros((PLAY_H, PLAY_W, 3), dtype=np.uint8)
    attrs = memory[0x5800:0x5B00]
    for cy in range(24):
        for cx in range(32):
            attr = attrs[cy * 32 + cx]
            palette = bright if attr & 0x40 else ink
            ink_rgb = palette[attr & 7]
            paper_rgb = palette[(attr >> 3) & 7]
            for row in range(8):
                y = cy * 8 + row
                addr = ((y & 0xC0) << 5) | ((y & 7) << 8)
                addr |= ((y & 0x38) << 2) | cx
                byte = memory[0x4000 + addr]
                for bit in range(8):
                    pixels[y, cx * 8 + bit] = (
                        ink_rgb if byte & (0x80 >> bit) else paper_rgb
                    )
    return pixels


def scale_room(pixels, scale):
    if scale == 1:
        return pixels
    return np.repeat(np.repeat(pixels, scale, axis=0), scale, axis=1)


def blit(dst, src, dx, dy):
    dh, dw = dst.shape[:2]
    sh, sw = src.shape[:2]
    x0 = max(0, dx)
    y0 = max(0, dy)
    x1 = min(dw, dx + sw)
    y1 = min(dh, dy + sh)
    if x0 >= x1 or y0 >= y1:
        return
    sx0 = x0 - dx
    sy0 = y0 - dy
    dst[y0:y1, x0:x1] = src[sy0:sy0 + (y1 - y0), sx0:sx0 + (x1 - x0)]


def compose(rooms_px, scale=SCALE):
    max_col = max(col for col, _row in GRID.values())
    max_row = max(row for _col, row in GRID.values())
    width = PAD * 2 + (max_col + 1) * CELL_W
    height = PAD * 2 + TITLE_H + (max_row + 1) * CELL_H
    canvas = np.zeros((height * scale, width * scale, 3), dtype=np.uint8)
    labels = []
    by_id = {room_id: pixels for room_id, pixels in rooms_px}
    for room_id, cam_lo, cam_hi, title in ROOMS:
        col, row = GRID[room_id]
        x = PAD + col * CELL_W
        y = PAD + TITLE_H + row * CELL_H
        blit(canvas, scale_room(by_id[room_id], scale), x * scale, y * scale)
        label = '#%02X %s' % (room_id, title)
        labels.append((x * scale, (y - 14) * scale, label))
    image = Image.fromarray(canvas, mode='RGB')
    draw = ImageDraw.Draw(image)
    for tx, ty, text in labels:
        draw.text((tx, ty), text, fill=(255, 255, 0))
    return image, width * scale, height * scale


def write_dzi(image, dest, name='castle-map', tile_size=TILE_SIZE):
    width, height = image.size
    max_level = math.ceil(math.log2(max(width, height)))
    files_dir = os.path.join(dest, name + '_files')
    if os.path.isdir(files_dir):
        shutil.rmtree(files_dir)
    dzi_path = os.path.join(dest, name + '.dzi')
    with open(dzi_path, 'w') as handle:
        handle.write(
            '<?xml version="1.0" encoding="UTF-8"?>\n'
            '<Image xmlns="http://schemas.microsoft.com/deepzoom/2008"\n'
            '       Format="png" Overlap="0" TileSize="%d">\n'
            '  <Size Width="%d" Height="%d"/>\n'
            '</Image>\n' % (tile_size, width, height)
        )

    level_img = image
    lw, lh = width, height
    written = 0
    for level in range(max_level, -1, -1):
        level_dir = os.path.join(files_dir, str(level))
        os.makedirs(level_dir, exist_ok=True)
        cols = math.ceil(lw / tile_size)
        rows = math.ceil(lh / tile_size)
        for ty in range(rows):
            for tx in range(cols):
                box = (
                    tx * tile_size,
                    ty * tile_size,
                    min((tx + 1) * tile_size, lw),
                    min((ty + 1) * tile_size, lh),
                )
                tile = level_img.crop(box)
                tile.save(
                    os.path.join(level_dir, '%d_%d.png' % (tx, ty)),
                    format='PNG',
                    compress_level=6,
                )
                written += 1
        print('  level %d %dx%d (%d tiles)' % (level, lw, lh, cols * rows),
              flush=True)
        if level == 0:
            break
        lw = math.ceil(lw / 2)
        lh = math.ceil(lh / 2)
        level_img = level_img.resize((lw, lh), Image.Resampling.NEAREST)
    return written


def copy_output(src, dest, name='castle-map'):
    os.makedirs(dest, exist_ok=True)
    for entry in (name + '.dzi', name + '_files'):
        source = os.path.join(src, entry)
        target = os.path.join(dest, entry)
        if os.path.isdir(target):
            shutil.rmtree(target)
        elif os.path.isfile(target):
            os.remove(target)
        if os.path.isdir(source):
            shutil.copytree(source, target)
        else:
            shutil.copy2(source, target)
    leftover = os.path.join(dest, name + '.png')
    if os.path.isfile(leftover):
        os.remove(leftover)


def report_connections():
    print('connections:', flush=True)
    print('  camera X links:',
          ', '.join('%02X-%02X' % edge for edge in CAMERA_LINKS),
          '(05-00: Weight to Patio $F226, Patio to Weight $F240)',
          flush=True)
    print('  wiki links:',
          ', '.join('%02X-%02X' % edge for edge in WIKI_LINKS), flush=True)
    print('  note: five upper cameras at $20,$40,$60,$80,$A0.',
          'Swamp at $E0 to $FF via white arch $917B.', flush=True)


def main(argv):
    parser = argparse.ArgumentParser(
        description='Render The Trap Door Deep Zoom map.')
    parser.add_argument('snapshot', help='TrapDoor Z80/SNA snapshot')
    parser.add_argument('dest', nargs='+',
                        help='HTML images directory (repeat to copy)')
    parser.add_argument('--scale', type=int, default=SCALE)
    args = parser.parse_args(argv)

    print('snapshot', args.snapshot, flush=True)
    mem = list(get_snapshot(args.snapshot))
    mem[0:0x4000] = list(read_bin_file(ROM48))
    report_connections()

    rooms_px = []
    for room_id, cam_lo, cam_hi, title in ROOMS:
        print('draw room #%02X %s cam=$%02X-$%02X' % (
            room_id, title, cam_lo, cam_hi), flush=True)
        rooms_px.append((room_id, draw_room(mem, cam_lo, cam_hi)))

    print('compose scale', args.scale, flush=True)
    image, width, height = compose(rooms_px, scale=args.scale)
    print('image', width, 'x', height, flush=True)

    dests = [os.path.abspath(path) for path in args.dest]
    os.makedirs(dests[0], exist_ok=True)
    leftover = os.path.join(dests[0], 'castle-map.png')
    if os.path.isfile(leftover):
        os.remove(leftover)
    print('tiles', dests[0], flush=True)
    written = write_dzi(image, dests[0])
    for extra in dests[1:]:
        print('copy', extra, flush=True)
        copy_output(dests[0], extra)
    print('wrote', written, 'tiles', flush=True)


if __name__ == '__main__':
    main(sys.argv[1:])
