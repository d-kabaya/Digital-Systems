# Lesson 1.3 — Digital Circuits & Electronic Logic Gates

> Based on lecture slides **1.3 Electronic logic gates** (COMP20020).
> ⬅️ [1.2 Digital Abstraction](02-digital-abstraction.md) · [Index](../README.md) · ➡️ [2.1 Combinational Circuits](04-combinational-circuits.md)

## What are we learning?

1. What logic gates do: NOT, AND, OR, NAND, NOR.
2. How they're actually *built* from transistors (CMOS).
3. Why gates take time to switch and use power.
4. How to read a chip (integrated circuit) package.

---

## Part A — Logic gates as boxes

A **digital circuit** diagram is like an electrical diagram, but more abstract. Its wires carry **0/1** (False/True) instead of voltages, and its building blocks are **logic gates**. A gate has one or more inputs and **exactly one output**.

| Gate | Boolean | C/Java | Output is 1 when… |
|---|---|---|---|
| NOT | Y = A̅ | `!A` | A is 0 |
| AND | Y = A·B (or AB) | `A && B` | **both** inputs are 1 |
| OR | Y = A + B | `A \|\| B` | **at least one** input is 1 |
| NAND | Y = (AB)̅ | `!(A && B)` | NOT both are 1 |
| NOR | Y = (A+B)̅ | `!(A \|\| B)` | **both** inputs are 0 |

**Truth tables:**

```
NOT        AND          OR           NAND         NOR
A | Y      A B | Y      A B | Y      A B | Y      A B | Y
0 | 1      0 0 | 0      0 0 | 0      0 0 | 1      0 0 | 1
1 | 0      0 1 | 0      0 1 | 1      0 1 | 1      0 1 | 0
           1 0 | 0      1 0 | 1      1 0 | 1      1 0 | 0
           1 1 | 1      1 1 | 1      1 1 | 0      1 1 | 0
```

### Example: combination lock with a smoke detector (from the slides)

The secret code is a=1, b=0, c=1. The door should also open if smoke is detected:

```
release = (a AND (NOT b) AND c) OR smoke
release = a·b̅·c + smoke
```

In C: `if (((a && !b) && c) || smoke) release = 1; else release = 0;`

---

## Part B — How a gate is built (CMOS)

An electronic logic gate is really an **electrically controlled switch**. It connects its output either to **Vs ("1")** or to **GND ("0")**, depending on its inputs.

### B1. Semiconductors

- Pure **silicon** is almost an insulator, because all its electrons are locked in bonds. At room temperature a few break free, leaving **holes** behind. You can treat a hole like a positive particle.
- **n-type:** add phosphorus (5 outer electrons). The spare electron is free to move, so there are extra **negative** carriers.
- **p-type:** add boron (3 outer electrons). There's a missing electron, so there are extra **positive holes**.
- A **pn junction** is where p-type meets n-type. Electrons diffuse across and create a **depletion zone** with no free carriers.
  - Battery one way round: the zone *grows* and no current flows.
  - Battery the other way round: the zone *disappears* and current flows.
  - So a pn junction conducts in one direction only. **That's a diode!**

### B2. Capacitors

Two conductive plates separated by an insulator (a *dielectric*) form a **capacitor**, which stores charge. Charging or discharging one **takes time**. After one time constant τ it reaches about 63%, and after 5τ about 99%. Stored charge also slowly leaks away.

### B3. MOS transistors (the switches)

A MOSFET has a **gate**, a **source** and a **drain**. The metal gate sits on a thin oxide insulator above the silicon, so the gate is effectively a small capacitor.

| | nMOS | pMOS |
|---|---|---|
| Source connects towards | GND (−) | Vs (+) |
| Turns **ON** when the gate is | **1** (Vs) | **0** (GND) |
| Symbol | plain gate | gate with a **small circle** ("active on 0") |
| Think of it as | a button "pressed" by 1 | a button "pressed" by 0 |

### B4. CMOS gates (Complementary MOS)

Each CMOS gate uses **pMOS transistors to connect the output up to Vs** and **nMOS transistors to connect it down to GND**. Only one of the two paths is ever on at a time.

**NOT (inverter):** one pMOS on top, one nMOS below, with both gates tied to input A.

```
        Vs
        |
   A─o[pMOS]
        |──── Q
   A──[nMOS]
        |
       GND
```

- A = 0: the pMOS is ON and the nMOS is OFF, so Q connects to Vs and **Q = 1**.
- A = 1: the pMOS is OFF and the nMOS is ON, so Q connects to GND and **Q = 0**.

**NAND:** two pMOS in **parallel** on top and two nMOS in **series** below. Q is pulled to 0 only when *both* nMOS are on, i.e. A=1 **and** B=1. Every other input combination gives 1.

**NOR:** two pMOS in **series** on top and two nMOS in **parallel** below. Q is connected to 1 only when *both* pMOS are on, i.e. A=0 **and** B=0.

**AND and OR are built in two stages:**

- AND = NAND followed by NOT.
- OR = NOR followed by NOT.

So in CMOS, NAND and NOR are actually *simpler* than AND and OR.

### B5. Switching time and power

- Switching a transistor means **charging its gate capacitor**, which takes time. So there is always a **delay** between an input changing and the output changing. The more gates you chain together, the longer the delay.
- CMOS uses energy mostly **while switching**. Once a gate has settled, it draws almost nothing. More switching per second (a higher clock frequency) means more power and more heat. That's why "turbo" mode makes a CPU run hot.

---

## Part C — Integrated circuits (ICs)

- An **IC** is a whole circuit built on one small piece of semiconductor. The first one was made by Jack Kilby in 1958.
- Example: the **7404** contains six NOT gates (it's a "hex inverter").
- **Pin numbering:** find the "key" notch or dot. Pin 1 is next to it, and pins are numbered **counter-clockwise when viewed from the top**.
- ⚠️ **Always connect Vs/Vcc and GND to the chip.** The gates inside need power to work.

---

## Common mistakes

- Thinking pMOS turns on with a 1. It's the **opposite**: pMOS turns on with a 0, which is what the circle on its symbol means.
- Mixing up NAND and NOR transistor layouts. Remember: NAND has its **n**MOS in series and its pMOS in parallel. NOR is the reverse.
- Forgetting to power the IC in the simulator.

## Quick summary

- Gates have one output. Their behaviour is defined by a truth table.
- CMOS uses pMOS (on at 0) to pull the output up and nMOS (on at 1) to pull it down.
- NOT, NAND and NOR are the natural CMOS gates. AND and OR each add an inverter.
- Switching takes time (capacitors) and uses power.

---

## 📝 Quiz

**Q1.** Complete the NAND truth table for A=1, B=1 and for A=0, B=1.

<details><summary>Answer</summary>

A=1, B=1 gives **0**. A=0, B=1 gives **1**. NAND is 0 only when both inputs are 1.
</details>

**Q2.** Which transistor type turns ON when its gate is at 0?

<details><summary>Answer</summary>

**pMOS.** That's why its symbol has a small circle on the gate.
</details>

**Q3.** In a CMOS inverter with A = 1, which transistor is ON and what is Q?

<details><summary>Answer</summary>

The **nMOS** is ON and the pMOS is OFF. Q is connected to GND, so **Q = 0**.
</details>

**Q4.** In a CMOS NOR gate, are the nMOS transistors in series or in parallel? Explain why.

<details><summary>Answer</summary>

**In parallel.** If *either* input is 1, its nMOS turns on and pulls Q to 0. That's exactly NOR: the output is 0 whenever any input is 1.
</details>

**Q5.** Write the Boolean expression for this lock: open if (a pressed AND b NOT pressed AND c pressed) OR smoke detected.

<details><summary>Answer</summary>

**release = a·b̅·c + smoke**
</details>

**Q6.** How do you build an AND gate from a NAND gate and one other gate?

<details><summary>Answer</summary>

Put a **NOT** after the NAND. Inverting NAND gives back AND.
</details>

**Q7.** Why is there always a delay between an input changing and a gate's output changing?

<details><summary>Answer</summary>

Switching a MOS transistor means **charging or discharging its gate capacitor**, and that takes time.
</details>

**Q8.** Why does a CPU use more power at a higher clock frequency?

<details><summary>Answer</summary>

CMOS uses energy mainly **when transistors switch**. A higher frequency means more switches per second, so more energy per second, which is more power.
</details>

**Q9.** You can see the key notch on a 14-pin DIL chip. How are the pins numbered?

<details><summary>Answer</summary>

Pin 1 is next to the key, and the pins are numbered **counter-clockwise when viewed from the top**: 1–7 down one side, then 8–14 back up the other.
</details>
