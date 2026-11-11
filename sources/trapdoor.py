#!/usr/bin/env python3
# Copyright 2026 Paul Maddern (paul@arcadegeek.co.uk)
"""HtmlWriter helpers for The Trap Door: layout pictures and script animations."""

from skoolkit import ROM48, get_int_param, read_bin_file
from skoolkit.graphics import Frame, Udg
from skoolkit.skoolhtml import HtmlWriter


class TrapDoorHtmlWriter(HtmlWriter):
    """Render graphic-layout bytecode and script-driven layout animations."""

    # Graphic-layout opcodes (Trap Door: $EE-$FF).
    OP_START_LOOP = 0xEE
    OP_END_LOOP = 0xEF
    OP_SET_SOUND = 0xF0
    OP_RAND_ADDR_LIST = 0xF1
    OP_SET_ATTR = 0xF2
    OP_INC_INDEX_JUMP = 0xF3
    OP_SET_SET = 0xF4
    OP_RAND_TILE = 0xF5
    OP_RAND_JUMP = 0xF6
    OP_TIMER_TILE = 0xF7
    OP_JUMP = 0xF8
    OP_TIMER_JUMP = 0xF9
    OP_MOVE = 0xFA
    OP_NEST = 0xFB
    OP_COND = 0xFC
    OP_WIDTH_JUMP = 0xFD
    OP_MOVE_STORE = 0xFE
    OP_RETURN = 0xFF

    # Script opcodes that imply a short delay between frames.
    SCRIPT_MOVE_OPS = frozenset({0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09})

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Menu / HUD text uses the 48K ROM font at $3C00 (CHARSET-$0100). The
        # game snapshot has no ROM below $4000, so inject SkoolKit's bundled
        # 48.rom into sim memory for #SIM/#SCR (do not commit a ROM file).
        rom = read_bin_file(ROM48)
        self.snapshot[0x0000:0x4000] = list(rom)
        self._layout_frames = {}  # addr -> Frame (named, reusable)

    def _set_base(self, set_index):
        if set_index <= 0 or set_index > 6:
            return 0
        table = 0x730B + set_index * 2
        return self.snapshot[table] + 256 * self.snapshot[table + 1]

    def _tile_udg(self, set_index, tile_index, attr):
        base = self._set_base(set_index)
        if base == 0:
            return Udg(attr & 0x7F, [0] * 8)
        addr = base + (tile_index & 0xFF) * 8
        data = list(self.snapshot[addr:addr + 8])
        if len(data) < 8:
            data.extend([0] * (8 - len(data)))
        # Bit 7 of the attribute byte selects horizontal mirror in-game; approximate
        # by reversing each row when bit 7 of the *tile index path* is unused — the
        # layout engine stores mirror in attribute bit 7 via the draw path. Mirror
        # when attribute bit 7 is set.
        if attr & 0x80:
            data = [self._mirror_byte(b) for b in data]
        return Udg(attr & 0x7F, data)

    @staticmethod
    def _mirror_byte(b):
        return int(f'{b:08b}'[::-1], 2)

    @staticmethod
    def _sex(b):
        return b if b < 0x80 else b - 0x100

    def _apply_delta(self, x, y, delta):
        """Match Process_GraphicLayoutDataContinueB2 / sequel do_cursor_shift."""
        cursor = delta & 0x7F
        if cursor == 0x21:
            return x + 1, y
        if cursor < 0x21:
            return x + (cursor - 0x20), y + 1
        return x + (cursor - 0x20), y

    def render_layout(self, address, max_steps=6000, origin_x=8, origin_y=8):
        """Walk graphic-layout data and return a UDG grid."""
        mem = self.snapshot
        ix = address
        x, y = origin_x, origin_y
        stored_x, stored_y = x, y
        attr = 0
        set_index = 3
        cells = {}
        call_stack = []
        loop_count = 0
        loop_restart = 0
        steps = 0
        jump_hits = {}

        while steps < max_steps and 0 <= ix < 0x10000:
            steps += 1
            op = mem[ix]
            if op < 0xEE:
                tile = op
                if attr == 0:
                    if ix + 2 >= 0x10000:
                        break
                    tile_attr = mem[ix + 1]
                    delta = mem[ix + 2]
                    next_ix = ix + 3
                else:
                    if ix + 1 >= 0x10000:
                        break
                    tile_attr = attr
                    delta = mem[ix + 1]
                    next_ix = ix + 2
                if 0 <= x < 48 and 0 <= y < 32:
                    cells[(x, y)] = self._tile_udg(set_index, tile, tile_attr)
                x, y = self._apply_delta(x, y, delta)
                ix = next_ix
                continue

            if op == self.OP_RETURN:
                attr = 0
                x, y = stored_x, stored_y
                if call_stack:
                    ix = call_stack.pop()
                    continue
                break

            if op == self.OP_SET_SET:
                set_index = mem[ix + 1]
                ix += 2
                continue

            if op == self.OP_SET_ATTR:
                attr = mem[ix + 1]
                ix += 2
                continue

            if op == self.OP_SET_SOUND:
                ix += 2
                continue

            if op == self.OP_MOVE or op == self.OP_MOVE_STORE:
                y += self._sex(mem[ix + 1])
                x += self._sex(mem[ix + 2])
                if op == self.OP_MOVE_STORE:
                    stored_x, stored_y = x, y
                ix += 3
                continue

            if op == self.OP_JUMP:
                target = mem[ix + 1] + 256 * mem[ix + 2]
                key = (ix, target)
                jump_hits[key] = jump_hits.get(key, 0) + 1
                if jump_hits[key] > 2:
                    break
                ix = target
                continue

            if op == self.OP_NEST:
                target = mem[ix + 1] + 256 * mem[ix + 2]
                call_stack.append(ix + 3)
                ix = target
                continue

            if op == self.OP_START_LOOP:
                loop_count = mem[ix + 1]
                loop_restart = ix + 2
                ix += 2
                continue

            if op == self.OP_END_LOOP:
                loop_count = (loop_count - 1) & 0xFF
                if loop_count:
                    ix = loop_restart
                else:
                    ix += 1
                continue

            if op == self.OP_TIMER_JUMP:
                # F9 n_states, current_state, then 4-byte records; take state 0 address.
                # Stable still: first listed address.
                n = mem[ix + 1]
                if n == 0 or n > 8:
                    n = 1
                # record at ix+3: time, max, addr_lo, addr_hi
                target = mem[ix + 5] + 256 * mem[ix + 6]
                key = (ix, target)
                jump_hits[key] = jump_hits.get(key, 0) + 1
                if jump_hits[key] > 2:
                    break
                ix = target
                continue

            if op == self.OP_INC_INDEX_JUMP:
                # F3 index, max, then address list: like #R$E8E8, step the
                # index (wrapping at max) and take that address.
                count = mem[ix + 2] or 1
                index = (mem[ix + 1] + 1) % count
                target = mem[ix + 3 + 2 * index] + 256 * mem[ix + 4 + 2 * index]
                key = (ix, target)
                jump_hits[key] = jump_hits.get(key, 0) + 1
                if jump_hits[key] > 2:
                    break
                ix = target
                continue

            if op in (self.OP_RAND_JUMP, self.OP_RAND_ADDR_LIST):
                # F6 / F1: n then n addresses (F1 uses ×3 index in-game); take first.
                n = mem[ix + 1]
                base = ix + 2
                target = mem[base] + 256 * mem[base + 1]
                key = (ix, target)
                jump_hits[key] = jump_hits.get(key, 0) + 1
                if jump_hits[key] > 2:
                    break
                ix = target
                continue

            if op == self.OP_RAND_TILE:
                n = mem[ix + 1]
                ix += 2 + max(n, 0)
                continue

            if op == self.OP_TIMER_TILE:
                # Skip timer header; leave following tile instruction alone.
                n = mem[ix + 3] if ix + 3 < 0x10000 else 0
                ix += 4 + max(n, 0)
                continue

            if op in (self.OP_COND, self.OP_WIDTH_JUMP):
                # Prefer non-taken / continue path for a stable composition.
                ix += 3
                continue

            break

        if not cells:
            cells[(origin_x, origin_y)] = Udg(0x07, [0] * 8)

        min_x = min(cx for cx, _ in cells)
        max_x = max(cx for cx, _ in cells)
        min_y = min(cy for _, cy in cells)
        max_y = max(cy for _, cy in cells)
        width = min(max(max_x - min_x + 1, 1), 40)
        height = min(max(max_y - min_y + 1, 1), 24)
        grid = [[Udg(0x00, [0] * 8) for _ in range(width)] for _ in range(height)]
        for (cx, cy), udg in cells.items():
            gx = cx - min_x
            gy = cy - min_y
            if 0 <= gx < width and 0 <= gy < height:
                grid[gy][gx] = udg
        return grid

    def layout_frame(self, address, scale=2, delay=32, name=None):
        """Return a named Frame for a layout address, caching the UDG grid."""
        if name is None:
            name = f'layout-{address:04x}'
        if address not in self._layout_frames:
            grid = self.render_layout(address)
            self._layout_frames[address] = Frame(grid, scale, name=name)
        base = self._layout_frames[address]
        # Copy with requested delay so animations can vary timing per use.
        return Frame(base.udgs, scale, delay=delay, name=name)


    def _is_graphic_layout_addr(self, addr):
        """True if addr looks like graphic-layout data, not script/code."""
        if not (0x9200 <= addr < 0xE000):
            return False
        # Reject addresses that fall inside known script-data blocks.
        for start, end in (
            (0xB9A5, 0xBC00),
            (0xCF44, 0xD234),
            (0xCCB9, 0xCF00),
            (0xD234, 0xD300),
            (0xD67D, 0xD800),
        ):
            if start <= addr < end:
                return False
        b0 = self.snapshot[addr]
        # Layout data commonly begins with an opcode or a nested call/set.
        if b0 >= 0xEE:
            return True
        # Or a short tile run that hits an opcode/$FF soon.
        for i in range(addr, min(addr + 48, 0x10000)):
            b = self.snapshot[i]
            if b in (0xFB, 0xF4, 0xF8, 0xF9, 0xFF):
                return True
        return False

    def _script_frames(self, address, limit=48):
        """Walk script words from address; return [(layout_addr, delay_cs)]."""
        mem = self.snapshot
        ix = address
        seen_pos = {}
        frames = []
        move_ticks = 0

        # Known script entry points nested inside mixed layout/script blocks.
        nested_entries = {
            0xBE6D: (0xBE79, 0xBE81, 0xBE89, 0xBE91, 0xBEB9),
            0xC70E: (0xCA23,),
            0x9C8A: (),  # layout-led Berk actions; still below
        }
        if address in nested_entries and nested_entries[address]:
            combined = []
            for entry in nested_entries[address]:
                combined.extend(self._script_frames(entry, limit=max(8, limit // 2)))
                if len(combined) >= limit:
                    break
            if combined:
                return combined[:limit]

        # If the block itself starts as layout data, treat it as a single frame.
        if self._is_graphic_layout_addr(address) and mem[address] >= 0xEE:
            return [(address, 40)]

        while len(frames) < limit and 0 <= ix < 0xFFFE:
            hits = seen_pos.get(ix, 0)
            if hits > 2:
                break
            seen_pos[ix] = hits + 1

            lo = mem[ix]
            hi = mem[ix + 1]
            word = lo + 256 * hi

            if hi == 0:
                opcode = lo
                if opcode > 0x50:
                    break
                if opcode in self.SCRIPT_MOVE_OPS:
                    move_ticks += 1
                if opcode == 0x01:
                    # $0001 <addr>: jump to script address.
                    target = mem[ix + 2] + 256 * mem[ix + 3]
                    ix = target
                    continue
                ix += 2
                continue

            # Non-zero high byte: graphic layout address (when it really is one).
            if self._is_graphic_layout_addr(word):
                delay = 40
                if move_ticks:
                    delay = max(10, min(80, 8 * move_ticks))
                move_ticks = 0
                if frames and frames[-1][0] == word:
                    delay = max(8, delay // 2)
                frames.append((word, delay))
            ix += 2

        return frames

    def expand_scriptanim(self, text, index, cwd):
        """#SCRIPTANIM$addr[(fname)] — animate layouts referenced by script data."""
        end, addr, fname = self._parse_addr_fname(text, index)
        if fname is None:
            fname = f'script-{addr:04x}'
        entries = self._script_frames(addr)
        if not entries:
            # Scan a short window for the first script-like entry that yields frames.
            for off in range(0, 0x80, 2):
                entries = self._script_frames(addr + off, limit=24)
                if len(entries) >= 1 and not (
                    len(entries) == 1 and entries[0][0] == addr + off
                ):
                    break
            else:
                entries = []
        if not entries:
            # Last resort: still of the address as layout data.
            frame = self.layout_frame(addr, name=f'layout-{addr:04x}')
            return end, self.handle_image(frame, fname, cwd)

        frames = [
            self.layout_frame(layout_addr, delay=delay, name=f'layout-{layout_addr:04x}')
            for layout_addr, delay in entries
        ]
        if len(frames) == 1:
            return end, self.handle_image(frames[0], fname, cwd)
        return end, self.handle_image(frames, fname, cwd)

    def _parse_addr_fname(self, text, index):
        end = index
        while end < len(text) and text[end] in '$0123456789abcdefABCDEF':
            end += 1
        addr = get_int_param(text[index:end])
        fname = None
        if end < len(text) and text[end] == '(':
            close = text.find(')', end)
            if close < 0:
                raise ValueError(f'No closing ")" for image name at: {text[index:index + 20]}')
            fname = text[end + 1:close]
            end = close + 1
        return end, addr, fname

    @staticmethod
    def _xml10_safe(text):
        # XML 1.0 forbids most C0/C1 controls; #STR bytes can emit them.
        # Replace so check-links (minidom) can parse published HTML.
        out = []
        for ch in text:
            o = ord(ch)
            ok = (
                o in (0x9, 0xA, 0xD)
                or 0x20 <= o <= 0xD7FF
                or 0xE000 <= o <= 0xFFFD
                or 0x10000 <= o <= 0x10FFFF
            )
            out.append(ch if ok else '?')
        return ''.join(out)

    def write_file(self, fname, contents):
        super().write_file(fname, self._xml10_safe(contents))
