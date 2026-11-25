# BEAG programs

Example programs for the BEAG computer from lecture **5.2**, with the assembler that turns them into Logisim ROM images. See [Lesson 5.2](../lessons/16-beag-programming.md) for a step-by-step explanation of each one.

| Source (`.asm`) | Machine code (`.mem`) | What it does |
|---|---|---|
| `hi.asm` | `hi.mem` | Example 2: prints **Hi** |
| `five_asterisks.asm` | `five_asterisks.mem` | Example 3: prints `*****` in a loop |
| `back1.asm` | `backwards_printer.mem` | Example 4 exactly as on the slides, with numeric branch offsets |
| `back2.asm` | (same machine code) | The same program with labels for the loops |
| `back3.asm` | (same machine code) | The same program with labels, the `li` shortcut and comments |

All five have been assembled and checked against the machine code on the slides.

## Running a program in Logisim

1. Open `circuits/beag_harward.circ` (or `beag_von_neumann.circ`).
2. Right-click the program ROM → **Load Image…** → pick the `.mem` file. (Or **Edit Contents…** and type the hex codes.)
3. **Ctrl+R** to reset, then **Ctrl+T** to tick the clock one step at a time, or **Ctrl+K** to run it.
4. In the von Neumann version each instruction takes two clock cycles (four Ctrl+T presses).

> The BEAG circuits were saved by **Logisim-evolution-ucd 5.0.5**, the course's version of Logisim.

## Assembling your own programs

`beagasm.py` (with `beag_memory.py` next to it) is the course's BEAG assembler. It needs Python 3:

```
python3 beagasm.py back3.asm                 # writes back3.mem
python3 beagasm.py back3.asm -l back3.lst    # also writes a listing with the address and code of every line
```

Things it lets you write, beyond the plain instructions:

| You write | It means |
|---|---|
| `loop:` | a **label**: the address of the next instruction |
| `bnz r2,loop` | branch to a label; the assembler works out the offset |
| `bnz r2,-2` | a plain number is still the offset itself, as in the lectures |
| `li r1,0x4000` | `lli r1,0x00` + `lhi r1,0x40` (always 2 words) |
| `b loop` | `bz r0,loop` (always jump) |
| `nop` | `add r0,r0,r0` (do nothing) |
| `; comment` | ignored |
