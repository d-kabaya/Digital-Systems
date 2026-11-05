# COMP20020 Digital Systems — Study Lessons & Quizzes

Simple, beginner-friendly lesson notes for **COMP20020 Digital Systems** (UCD), following the lecture order. Each lesson explains the topic step by step, works through the slide examples, lists common mistakes, and ends with a **quiz whose answers stay hidden until you click them**.

> These are personal study notes written *from* the lecture slides. They aren't official course material. Where something is extra explanation that isn't in the slides, it's marked 📌 *additional*.

## 📚 Lessons

| # | Lecture | Topics | Quiz |
|---|---|---|---|
| 1 | [1.1 Electrical Circuits](lessons/01-electrical-circuits.md) | charge, current, voltage, resistance, Ohm's law, power, LEDs & resistors | 9 Qs |
| 2 | [1.2 Digital Abstraction](lessons/02-digital-abstraction.md) | 1/0 as voltage ranges, ASCII, binary, octal, hexadecimal | 9 Qs |
| 3 | [1.3 Logic Gates](lessons/03-logic-gates.md) | NOT/AND/OR/NAND/NOR, semiconductors, nMOS/pMOS, CMOS gates, ICs | 9 Qs |
| 4 | [2.1 Combinational Circuits](lessons/04-combinational-circuits.md) | truth tables, Boolean algebra, precedence, SOP, design process | 9 Qs |
| 5 | [2.3 Karnaugh Maps](lessons/05-karnaugh-maps.md) | K-map method, grouping rules, wrap-around, don't-cares | 9 Qs |
| 6 | [2.4 Simplification & Universal Gates](lessons/06-simplification-universal-gates.md) | POS, shared logic, NAND/NOR-only circuits, timing & critical path | 9 Qs |
| 7 | [2.6 Building Blocks](lessons/07-building-blocks.md) | decoder, MUX, DEMUX, ALU, ROM (NOR/NAND), hex dumps | 9 Qs |
| 8 | [3.1 Signed Integers](lessons/08-signed-integers.md) | full adder, ripple carry, two's complement, overflow, adder/subtractor | 10 Qs |
| 9 | [3.2 Multiplication & Division](lessons/09-multiplication-division.md) | comparators, array multiplier, signed multiply, long division | 9 Qs |
| 10 | [3.3 Fixed & Floating Point](lessons/10-fixed-and-floating-point.md) | fractional binary, conversions, Ua.b/Qa.b, IEEE 754 | 11 Qs |
| 11 | [4.1 Latches & Flip-Flops](lessons/11-latches-and-flip-flops.md) | feedback, SR/gated SR/D latches, master–slave, D/SR/JK/T flip-flops | 10 Qs |
| 12 | [4.2 Synchronous Circuits](lessons/12-synchronous-circuits.md) | registers, resets, RAM (SRAM/DRAM), frequency dividers, counters, shift registers | 9 Qs |
| 13 | [4.3 Finite State Machines](lessons/13-finite-state-machines.md) | Moore vs Mealy, 8-step design process, sequence generator, hex code printer controller | 9 Qs |
| 14 | [4.4 FSM Timing](lessons/14-fsm-timing.md) | setup/hold/clock-to-Q, metastability, critical path, max clock frequency, PVT, clock skew | 8 Qs |

> Lectures 2.2 and 2.5 weren't in the uploaded slide set. The Sum-of-Products basics that 2.3 relies on are covered briefly in Lesson 4.

## 🔌 Logisim circuits

The [`circuits/`](circuits/) folder holds Logisim-evolution (v3.8/3.9) files that go with the lessons. See [`circuits/README.md`](circuits/README.md) for what each one shows and how to try it.

## ✍️ Worked examples

[`worked-examples/`](worked-examples/) holds handwritten truth tables (2-bit multiplier, 1-bit multiplexer) and a decimal-conversion exercise. All of them have been checked and are correct.

## 🧭 How to use this repo

1. Read a lesson **alongside the matching lecture slides**.
2. Cover up the explanations and try the worked examples yourself.
3. Do the quiz. **Answer each question before you click "Answer".**
4. Any you got wrong? Re-read the "Common mistakes" section, then retry tomorrow.
5. Open the matching Logisim circuit and poke the inputs to see the behaviour.

## Exam quick-reference

| Topic | Remember |
|---|---|
| Ohm's law | U = I·R, P = I·U, LED resistor = (Vs − V_drop)/I |
| Hex | 1 hex digit = 4 bits, group from the **right** |
| Precedence | () > NOT > AND > OR |
| K-map order | 00, 01, **11, 10**, and it wraps around |
| De Morgan | (AB)̅ = A̅ + B̅, (A+B)̅ = A̅·B̅ |
| Two's complement | −X = invert + 1. Range −2ⁿ⁻¹ … 2ⁿ⁻¹−1 |
| Signed overflow | same-sign inputs → opposite-sign result |
| Multiply | n × n bits → 2n bits |
| IEEE single | 1 sign / 8 exponent (bias 127) / 23 mantissa, implied 1. |
| Latch vs flip-flop | latch = level-sensitive (while E = 1); flip-flop = edge-triggered (on the clock edge) |
| JK flip-flop | 00 hold, 01 reset, 10 set, **11 toggle** |
| FSM flip-flops | ⌈log₂(states)⌉; with D flip-flops, D = next state |
| Moore vs Mealy | Moore: outputs from state only; Mealy: state + inputs |
| Clock period | ≥ max(clk-to-Q + logic + setup), worst case; f_max = 1/T |
| Hold check | min(clk-to-Q + logic) ≥ hold time, best case |
