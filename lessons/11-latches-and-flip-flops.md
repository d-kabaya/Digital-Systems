# Lesson 4.1 — Latches & Flip-Flops: Memory Elements

> Based on lecture slides **4.1 Latches and flip-flops: memory elements of sequential logic circuits** (COMP20020).
> ⬅️ [3.3 Fixed & Floating Point](10-fixed-and-floating-point.md) · [Index](../README.md) · ➡️ [4.2 Synchronous Circuits](12-synchronous-circuits.md)

## What are we learning?

Everything up to now has been **combinational**: the output depends only on the inputs *right now*. This lesson adds **memory**. You'll see how a few gates wired in a loop can **remember** a 0 or a 1, and you'll meet the two families of memory element:

- **Latches**, which are **level-sensitive** (they react while a control input is held at a level).
- **Flip-flops**, which are **edge-triggered** (they react only at the instant the clock changes).

Logisim files for this lesson: [`latches.circ`](../circuits/latches.circ) and [`flip_flops.circ`](../circuits/flip_flops.circ).

---

## 1. Sequential logic and feedback

> "Sequential logic … produces a specified output for certain specified combinations of **current and previous** inputs."

To remember anything, a circuit needs **feedback**: an output wired back round to an input. Two NOT gates in a loop are the simplest example:

```
   ┌──►[NOT]──┐
   │          ▼
   └──[NOT]◄──┘
```

If the first output is 1, the second is 0, which keeps the first at 1. That's stable. The opposite (0 and 1) is stable too. A circuit with **two stable states** is called **bistable**.

But this loop raises two questions, which the slides ask: *What value does it start with?* and *How do you change it?* The latches below answer the second one.

## 2. The SR latch (Set–Reset)

An SR latch is made from **two NOR gates** cross-coupled (each one's output feeds the other's input). It has inputs **S** (set) and **R** (reset), and outputs **Q** and **Q̄**.

| S | R | Qₙ₊₁ | Meaning |
|---|---|---|---|
| 0 | 0 | Qₙ | **No change** (memory mode) |
| 1 | 0 | 1 | **Set** (store a 1) |
| 0 | 1 | 0 | **Reset** (store a 0) |
| 1 | 1 | — | **Invalid** (don't use it) |

Qₙ means "whatever Q was before" and Qₙ₊₁ means "Q after". This kind of table is called a **characteristic table**.

### Why it works: the NOR trick

Look at a NOR gate as having one "control" input:

| Control | NOR output |
|---|---|
| 0 | NOT (other input) |
| 1 | **0**, whatever the other input is |

So a 1 on any NOR input **forces** its output to 0.

**Storing a 0 (reset):** R goes to 1. That forces NOR2's output (Q) to 0. Q = 0 feeds back into NOR1, which now outputs 1 (Q̄ = 1). That 1 feeds back into NOR2 and keeps Q at 0 **even after R goes back to 0**. The value "sticks".

**Storing a 1 (set):** S goes to 1. That forces NOR1's output (Q̄) to 0, which makes NOR2 output 1, so Q = 1 sticks.

**Why S = R = 1 is invalid:** both NOR outputs would be forced to 0, so Q = Q̄ = 0, which is impossible for a "Q and NOT Q" pair. When both inputs drop back to 0, the result is unpredictable.

You can also build an SR latch from **NAND** gates. That version has **active-low** inputs (S̄ and R̄): it sets or resets when an input goes to **0**. In `latches.circ` it's labelled "Neg S Neg R NAND latch".

### Worked example (pop quiz from the slides)

Input sequence [S, R] and the resulting Q:

| [S,R] | 10 | 00 | 00 | 01 | 00 | 10 | 00 | 00 |
|---|---|---|---|---|---|---|---|---|
| Q | **1** set | 1 hold | 1 hold | **0** reset | 0 hold | **1** set | 1 hold | 1 hold |

## 3. The gated SR latch

The plain SR latch reacts to S and R **at any moment**. A **gated** latch adds an **Enable (E)** input so that it only listens when you allow it.

This works with the **AND trick**:

| Control | AND output |
|---|---|
| 0 | **0**, blocked |
| 1 | the data passes through |

S and R each go through an AND gate with E before reaching the latch:

| E | Behaviour |
|---|---|
| 1 | **Transparent**: Q follows S and R |
| 0 | **Memory mode**: Q doesn't change, whatever S and R do |

You still have to make sure S and R aren't both 1 while E = 1. A version built only from NAND gates (four of them) is **smaller in area** than the AND + NOR version (from [Lesson 2.4](06-simplification-universal-gates.md): NAND = 1 G.E., AND = 1.3).

**Pop quiz from the slides:** [E,S,R] = 110 → 1 (set), 100 → 1 (hold), 000 → 1 (disabled), 001 → 1 (disabled, so R is ignored), 100 → 1, 101 → **0** (reset), 110 → **1** (set), 010 → 1 (disabled).

## 4. The gated D latch

Simplify further. Instead of separate S and R, use a single **D (data)** input. Feed **S = D** and **R = NOT D**. Now S and R can **never** both be 1, so the invalid state is impossible.

| E | D | Q |
|---|---|---|
| 1 | 1 | 1 (set) |
| 1 | 0 | 0 (reset) |
| 0 | x | unchanged |

In words: **while E = 1, Q follows D. When E goes to 0, Q holds the last value of D.**

**Pop quiz from the slides:** [E,D] = 11 → 1, 10 → 0, 00 → 0, 01 → 0 (disabled), 11 → 1, 01 → 1, 00 → 1, 10 → 0.

## 5. Flip-flops: edge-triggered memory

A latch is "open" for the **whole time** E is high, so if D wobbles during that time, Q wobbles too. A **flip-flop** only captures its input at an **instant**: the **edge** of a clock signal.

> "Flip-flops are **synchronous** bistable memory devices." Their output only changes on the **edge** of a triggering control input, usually the **clock**.

### The clock

- **Clock:** a signal that oscillates between 0 and 1 at a fixed rate.
- **Positive (rising) edge:** the clock going 0 → 1. **Negative (falling) edge:** 1 → 0.
- **Clock period T:** the time for one full cycle, in seconds.
- **Clock frequency f = 1 / T**, in hertz. For example, T = 1 ns gives f = 1 GHz.

The clock **co-ordinates** every memory update in the circuit: all the flip-flops change together, on the same edge.

On a flip-flop symbol, the **small triangle (>)** on the clock input means "edge-triggered". A **circle before the triangle** means it triggers on the **negative** edge.

### How a flip-flop is built: master–slave

A positive-edge flip-flop is **two gated latches in a row**: a **master** and a **slave**. The clock is fed to them in **opposite** ways, through an inverter:

| CLK | Master | Slave |
|---|---|---|
| LOW | **transparent**, follows the input | memory, holds the output steady |
| HIGH | **memory**, freezes what it last saw | transparent, copies the master to Q |

So at the moment CLK goes **LOW → HIGH**, the master freezes the input and the slave passes it to Q. The input is "sampled" exactly at the rising edge. Before that, Q was held by the slave. After it, the master ignores the input. That's how two **level**-sensitive latches make one **edge**-triggered flip-flop.

> 💡 Think of a canal lock with two gates that are never open at the same time. Water (data) can only get through one step at a time, and only when the gates swap.

## 6. The four flip-flop types

↑ means "on the rising clock edge". Q₀ means "the value Q had before the edge".

### D flip-flop: "store D"

| D | CLK | Q | Comment |
|---|---|---|---|
| 1 | ↑ | 1 | set |
| 0 | ↑ | 0 | reset |

**Q becomes whatever D was at the clock edge.** It's the most common flip-flop, and the next state depends only on D.

### SR flip-flop

Like the SR latch, but only acts on the clock edge. S = R = 1 is still invalid.

### JK flip-flop: an SR flip-flop with the invalid case fixed

| J | K | CLK | Q | Comment |
|---|---|---|---|---|
| 0 | 0 | ↑ | Q₀ | no change |
| 0 | 1 | ↑ | 0 | reset |
| 1 | 0 | ↑ | 1 | set |
| 1 | 1 | ↑ | **Q̄₀** | **toggle** (flip to the opposite) |

J works like S and K works like R. The slides show it built from an SR flip-flop with Q and Q̄ fed back through AND gates, which turns "both 1" into "toggle".

### T flip-flop: "toggle"

| T | CLK | Q | Comment |
|---|---|---|---|
| 0 | ↑ | Q₀ | no change |
| 1 | ↑ | Q̄₀ | toggle |

It's a JK flip-flop with J and K tied together. You'll see it used for **counters** in the next lesson.

### Asynchronous set/reset

Many flip-flops also have extra **S** and **R** pins that act **immediately**, without waiting for the clock. These are **asynchronous** inputs. All four flip-flops in `flip_flops.circ` have them, so you can force a known starting value.

---

## Latch vs flip-flop at a glance

| | Latch | Flip-flop |
|---|---|---|
| Reacts to | a **level** (while E = 1) | an **edge** (the instant CLK changes) |
| Sensitive to glitches while enabled? | yes, transparent | no, samples once per edge |
| Built from | cross-coupled gates | two latches (master–slave) |
| Symbol clue | E input | **>** triangle on the clock input |

## Common mistakes

- Using S = R = 1 in an SR latch or flip-flop. It's **invalid**.
- Thinking a latch only updates once. It's **transparent the whole time E = 1**.
- Forgetting that a flip-flop changes **only at the edge**. Changes to D between edges are ignored.
- Mixing up JK's "11" (**toggle**) with SR's "11" (**invalid**).
- Missing the **circle** before the clock triangle, which means negative-edge triggered.

## Quick summary

- Feedback gives a circuit memory (bistable).
- SR latch: set, reset, hold, and an invalid 11. The gated version adds Enable. The D latch removes the invalid case.
- Flip-flops are edge-triggered (master–slave). D stores D, JK sets/resets/holds/toggles, T toggles.
- f = 1 / T.

---

## 📝 Quiz

**Q1.** What's the difference between a latch and a flip-flop?

<details><summary>Answer</summary>

A latch is **level-sensitive**: it's transparent the whole time its enable is high. A flip-flop is **edge-triggered**: it only captures its input at the clock edge.
</details>

**Q2.** An SR latch starts with Q = 0. Inputs [S,R] are applied in this order: 10, 00, 01, 00. Give Q after each step.

<details><summary>Answer</summary>

10 → **1** (set), 00 → **1** (hold), 01 → **0** (reset), 00 → **0** (hold).
</details>

**Q3.** Why is S = R = 1 forbidden in a NOR SR latch?

<details><summary>Answer</summary>

A 1 on any NOR input forces its output to 0, so **both** Q and Q̄ become 0. That contradicts Q̄ being the opposite of Q, and when S and R return to 0 the final state is unpredictable.
</details>

**Q4.** How does a gated D latch make the invalid state impossible?

<details><summary>Answer</summary>

It feeds **S = D** and **R = NOT D**, so S and R are always opposite and can never both be 1.
</details>

**Q5.** A gated D latch starts with Q = 0. Apply [E,D] = 11, 01, 00, 10. Give Q after each step.

<details><summary>Answer</summary>

11 → **1**, 01 → **1** (disabled, holds), 00 → **1** (disabled), 10 → **0**.
</details>

**Q6.** A clock has a period of 2 ns. What is its frequency?

<details><summary>Answer</summary>

f = 1 / T = 1 / (2 × 10⁻⁹ s) = **500 MHz**.
</details>

**Q7.** In a master–slave flip-flop, which latch is transparent while CLK is LOW?

<details><summary>Answer</summary>

The **master**. It follows the input while the slave holds Q. On the rising edge they swap.
</details>

**Q8.** A JK flip-flop has Q = 0. J = 1 and K = 1, and two rising clock edges arrive. What is Q after each?

<details><summary>Answer</summary>

JK = 11 means toggle: after the first edge **Q = 1**, after the second **Q = 0**.
</details>

**Q9.** How do you make a T flip-flop from a JK flip-flop?

<details><summary>Answer</summary>

**Tie J and K together** and call that input T. T = 0 gives JK = 00 (hold), and T = 1 gives JK = 11 (toggle).
</details>

**Q10.** What does a circle in front of the clock triangle on a flip-flop symbol mean?

<details><summary>Answer</summary>

The flip-flop is triggered on the **negative (falling) edge**, when the clock goes 1 → 0.
</details>
