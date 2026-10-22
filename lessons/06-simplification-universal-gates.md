# Lesson 2.4 — Other Simplification Approaches, Universal Gates & Timing

> Based on lecture slides **2.4 Other simplification approaches; universal gates** (COMP20020).
> ⬅️ [2.3 Karnaugh Maps](05-karnaugh-maps.md) · [Index](../README.md) · ➡️ [2.6 Building Blocks](07-building-blocks.md)

## What are we learning?

1. **Product of Sums (POS)**, the "mirror image" of SOP.
2. **Sharing logic** between several outputs.
3. **Universal gates**: building anything from only NAND (or only NOR).
4. **Timing**: propagation delay, glitches, logic paths and the critical path.

---

## 1. Product of Sums (POS)

- **SOP** is OR of ANDs, e.g. AB + C̅D.
- **POS** is AND of ORs, e.g. **(A + B)(A + B̅ + C)**.
- Any expression can be written in either form.
- **Standard POS (SPOS)** has one sum term for **every row whose output is 0**, using every variable in each term.

> 📌 *Additional detail: for a 0-row, write each variable **as-is if it's 0** and **barred if it's 1**. That's the opposite of SOP. For example, row A=1, B=0 gives (A̅ + B).*

**When should you use POS?** When a truth table has **mostly 1s and only a few 0s**, POS has fewer terms.

## 2. Circuits with multiple outputs

If two outputs need the **same sub-expression**, compute it **once** and share it.

**Example from the slides:**

- X = AD + BC + AC
- Y = AD + BC + A̅B̅

Both contain AD + BC, so let **T = AD + BC**. Then:

- **X = T + AC**
- **Y = T + A̅B̅**

That saves gates. It's called **multi-level logic optimisation**.

## 3. Universal gates

**NAND and NOR are universal.** Any truth table can be built from NAND gates alone, or from NOR gates alone.

Building the basic gates from NAND:

| Want | NAND-only version |
|---|---|
| NOT A | NAND(A, A) |
| A AND B | NOT(NAND(A,B)) = NAND(NAND(A,B), NAND(A,B)) |
| A OR B | NAND(NOT A, NOT B) = NAND(NAND(A,A), NAND(B,B)) |

The OR row works because of **De Morgan's law** *(additional; it's used implicitly in the slides)*:

```
(A·B)̅ = A̅ + B̅        (A + B)̅ = A̅ · B̅
```

### Converting a circuit to NAND-only

1. Starting with the innermost operation, replace each gate with its NAND equivalent.
2. Cancel any double NOTs (A̿ = A).

**Example from the slides:** AB + CD

```
AB + CD = ((AB + CD)̅)̅ = ( (AB)̅ · (CD)̅ )̅ = NAND( NAND(A,B), NAND(C,D) )
```

- Original circuit: 2 AND + 1 OR = 3 × 1.3 = **3.9 G.E.**
- NAND-only circuit: 3 NAND = 3 × 1 = **3 G.E.** It's smaller.

NAND and NOR are physically smaller than AND and OR (recall from [Lesson 1.3](03-logic-gates.md) that AND = NAND + NOT).

## 4. Timing

### Timing diagrams

A **timing diagram** draws each signal against time as a square wave. It's another way to define a Boolean function.

Example, Z = A ⊕ B:

```
A: 0 1 0 1
B: 0 1 1 0
Z: 0 0 1 1
```

### Key definitions

- **Transition time:** how long a wire takes to switch between logic levels.
- **Propagation delay:** the time from the 50% point of an *input* change to the 50% point of the resulting *output* change.
- **Glitch:** a short, unwanted spike on an output. It's caused by signals reaching a gate at slightly different times.
- **Logic path:** the list of gates and wires from one circuit input to one output.
- **Critical path:** the path with the **longest** delay. It sets the circuit's speed.

### Gate delays (in G.E., relative to a 2-input NAND)

| Gate | Delay |
|---|---|
| NOT | 0.7 |
| AND | 1.2 |
| OR | 1.2 |
| XOR | 1.5 |
| NAND | 1.0 |
| NOR | 1.0 |
| XNOR | 1.5 |

To find a path's delay, **add up the delays of the gates along it** (wire delay is ignored).

### Worked example (from the slides): Y₁ = X₁X₂ + X₃

| Path | Delay |
|---|---|
| X₁ → AND → OR → Y₁ | 1.2 + 1.2 = **2.4** (max, critical) |
| X₂ → AND → OR → Y₁ | 1.2 + 1.2 = 2.4 |
| X₃ → OR → Y₁ | 1.2 (min) |

### In real chips

Delays are measured in picoseconds. They depend on the direction of the transition (0→1 or 1→0), on the load being driven, and on **PVT: Process, Voltage, Temperature**. Chips are slower when they're hot and when the voltage is low. Designers check both best-case and worst-case delays.

---

## Common mistakes

- Building SPOS from the 1-rows. **POS uses the 0-rows.**
- Forgetting that a NOT counts as a gate (0.7) on a path.
- Picking the *shortest* path as the critical path. The critical path is the **longest**.
- Writing (AB)̅ = A̅B̅. Wrong! De Morgan says (AB)̅ = A̅ **+** B̅.

## Quick summary

- POS is AND-of-ORs and comes from the 0-rows. It's useful when there are few 0s.
- Share common terms between outputs.
- NAND and NOR are universal and often smaller.
- Path delay is the sum of the gate delays. The longest path is the critical path.

---

## 📝 Quiz

**Q1.** Is (A + B)(B̅ + C) in SOP or POS form?

<details><summary>Answer</summary>

**POS** (product of sums).
</details>

**Q2.** How do you make NOT A from a single NAND gate?

<details><summary>Answer</summary>

Tie both inputs to A: **NAND(A, A) = (A·A)̅ = A̅**.
</details>

**Q3.** Use De Morgan's law to rewrite (A + B)̅.

<details><summary>Answer</summary>

**A̅ · B̅**
</details>

**Q4.** Write AB + CD using only NAND gates.

<details><summary>Answer</summary>

**NAND( NAND(A,B), NAND(C,D) )**
</details>

**Q5.** Complete the timing diagram for Z = A + BC:

```
A: 0 1 0 1 0 1 0 1
B: 0 0 1 1 0 0 1 1
C: 0 0 0 0 1 1 1 1
Z: ?
```

<details><summary>Answer</summary>

```
Z: 0 1 0 1 0 1 1 1
```

Z is 1 whenever A = 1, and also in the column where B = C = 1 and A = 0 (the 7th column).
</details>

**Q6.** Y₂ = X̅₁ · X₂. Give the maximum and minimum path delays.

<details><summary>Answer</summary>

- X₁ → NOT → AND: 0.7 + 1.2 = **1.9** (maximum, critical path)
- X₂ → AND: **1.2** (minimum)
</details>

**Q7.** What is a glitch, and why does it happen?

<details><summary>Answer</summary>

A glitch is a **short unwanted spike** on an output. It happens because the signals feeding a gate travel along paths with different delays, so the gate briefly sees a wrong combination of inputs.
</details>

**Q8.** X = AD + BC + AC and Y = AD + BC + A̅B̅. How can you save gates?

<details><summary>Answer</summary>

Compute **T = AD + BC** once and share it: X = T + AC and Y = T + A̅B̅.
</details>

**Q9.** Give two reasons why the same chip might be slower on a hot day.

<details><summary>Answer</summary>

Gate delay **increases with temperature**. If the supply **voltage** also sags, that slows it down further. Both are part of PVT (process, voltage, temperature) variation.
</details>
