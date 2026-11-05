# Lesson 4.4 — FSM Timing: Setup, Hold & Clock Speed

> Based on lecture slides **4.4 FSM timing** (COMP20020).
> ⬅️ [4.3 Finite State Machines](13-finite-state-machines.md) · [Index](../README.md)

## What are we learning?

A flip-flop captures its input at the clock edge. But real signals take **time** to travel through gates ([Lesson 2.4](06-simplification-universal-gates.md)), so the input must be **ready and steady** around that edge. This lesson covers the three timing numbers of a flip-flop, what goes wrong when they're broken, and how they decide **how fast a circuit can be clocked**.

---

## 1. Quick recap: FSMs with inputs

- With an input, the next state depends on the **current state and the input**.
- **Moore:** outputs depend on the state only. **Mealy:** outputs depend on the state and the inputs.
- Electronic computers are (very complex) finite state machines.

## 2. The three flip-flop timing numbers

```
CLK   ______________|‾‾‾‾‾‾‾‾‾‾‾‾‾
D     ====X  stable | stable  X=====
          |<-setup->|<-hold->|
Q     ______________:___|‾‾‾‾‾‾‾‾‾
                    |<->|
               clock-to-Q delay
```

| Term | Meaning |
|---|---|
| **Setup time** | how long **before** the rising edge the input must already be stable |
| **Hold time** | how long **after** the rising edge the input must **stay** stable |
| **Clock-to-Q delay** | how long after the edge before Q shows the new value |

> 💡 It's like taking a photo. The subject has to be still a moment **before** the shutter (setup) and a moment **after** it (hold), and the photo takes a moment to appear (clock-to-Q).

## 3. What goes wrong: timing violations

### Setup violation: the input arrives too late

The flip-flop may:
- capture the **previous** cycle's value,
- capture a **glitch**, or
- become **metastable**.

### Hold violation: the input changes too soon after the edge

The new value overwrites the one that should have been captured. This can also cause metastability.

### Metastability

> "When a circuit is in a metastable state, the logic value on a node is unable to settle into a stable 0 or 1 logic level within the time required for proper circuit operation."

The flip-flop gets stuck **between** 0 and 1. It will eventually settle on one of them, but **how long that takes is unbounded**. Designers spend a lot of effort making sure violations can't happen.

## 4. Choosing the clock period (avoiding setup violations)

A signal leaves one flip-flop (the **launch**), goes through combinational logic, and must reach the next flip-flop (the **capture**) at least one **setup time** before the next edge:

```
critical_path = max( clock-to-Q + combinational delay + setup time )   ← over all paths
clock_period ≥ critical_path
slack        = clock_period − critical_path
```

- Use the **worst-case** (slowest) delays here.
- **Maximum frequency** = 1 / (minimum clock period).
- **Slack** is the spare time. If it's negative, the circuit fails.

## 5. Avoiding hold violations

The **fastest** path must still be slower than the hold time, so the new data can't arrive while the capture flip-flop is still holding the old value:

```
hold_time ≤ min( clock-to-Q + combinational delay )   ← use best-case delays
```

If a path is too fast, the fix is to **add delay** to it, for example a buffer or two inverters.

## 6. PVT: why best case and worst case?

Gate delays vary with **P**rocess (manufacturing), **V**oltage and **T**emperature:

- Process: about ±2%
- Temperature: 0–125 °C (hotter is slower)
- Voltage: nominal ±10% (lower voltage is slower)

So timing is checked twice. The **worst case** (slowest) sets the clock period, and the **best case** (fastest) is used to check hold times.

## 7. Clock skew and the clock tree

All flip-flops should receive the clock edge at **exactly the same time**. But long wires and heavy loads delay the clock to some flip-flops more than others.

- **Clock skew** is the difference in when the clock arrives at different flip-flops.
- The fix is a **balanced clock tree**: a tree of buffers designed so that every leaf (flip-flop) is the **same delay** from the root.

---

## Worked example (pop quiz from the slides)

The inputs X₁, X₂ and the outputs Y₁, Y₂, Y₃ are all stored in flip-flops:

- Y₁ = X₁ · X₂ (AND)
- Y₂ = X₁ + X₂ (OR)
- Y₃ = X₁ (a direct wire)

| | Best case | Worst case |
|---|---|---|
| Flip-flop clock-to-Q | 0.1 ns | 1 ns |
| OR gate | 0.1 ns | 1.5 ns |
| AND gate | 0.5 ns | 1.2 ns |
| Flip-flop setup time | — | 0.5 ns |
| Flip-flop hold time | 0.2 ns | — |

**Step 1: find the critical path (worst case).**
- Through the OR: 1 + 1.5 + 0.5 = **3.0 ns** ← the longest
- Through the AND: 1 + 1.2 + 0.5 = 2.7 ns
- The direct wire: 1 + 0 + 0.5 = 1.5 ns

**Step 2: clock limits.**
- Minimum clock period = **3 ns**
- Maximum frequency = 1 / 3 ns ≈ **333 MHz**

**Step 3: check hold times (best case).**
- The fastest path is the direct wire X₁ → Y₃: clock-to-Q 0.1 ns + 0 = **0.1 ns**.
- The hold time is 0.2 ns, and 0.1 < 0.2, so this is a **hold violation**!
- **Fix:** add delay on that path, such as a buffer or two inverters, until it's at least 0.2 ns.

> ⚠️ *Slide note: the answer slide says to add the buffer "between X2 and Y3". Since Y₃ = X₁, the too-fast path is actually **X₁ → Y₃**.*

---

## Common mistakes

- Using best-case delays to work out the clock period. The period needs the **worst case**.
- Using worst-case delays to check hold. Hold needs the **best (fastest) case**.
- Forgetting to add **clock-to-Q** and **setup** time to the logic delay.
- Thinking a slower clock fixes hold violations. It **doesn't**, because hold doesn't depend on the period.

## Quick summary

- Setup: stable before the edge. Hold: stable after the edge. Clock-to-Q: the delay until Q updates.
- Minimum clock period = max(clock-to-Q + logic + setup), using the worst case. f_max = 1 / period.
- Hold check: min(clock-to-Q + logic) ≥ hold time, using the best case. Fix fast paths by adding delay.
- Violations can cause metastability. Clock skew is kept down with a balanced clock tree.

---

## 📝 Quiz

**Q1.** Define setup time and hold time.

<details><summary>Answer</summary>

**Setup time** is how long before the clock edge the input must be stable. **Hold time** is how long after the edge it must stay stable.
</details>

**Q2.** What is metastability, and why is it dangerous?

<details><summary>Answer</summary>

The flip-flop output gets stuck between 0 and 1 and can't settle in time. It will settle eventually, but the time this takes is **unbounded**, so the rest of the circuit may read a wrong or undefined value.
</details>

**Q3.** Clock-to-Q = 0.3 ns, the slowest logic path = 2.0 ns, and setup = 0.2 ns. What are the minimum clock period and maximum frequency?

<details><summary>Answer</summary>

Period = 0.3 + 2.0 + 0.2 = **2.5 ns**. Frequency = 1 / 2.5 ns = **400 MHz**.
</details>

**Q4.** In Q3, the clock is set to 3 ns. What is the slack?

<details><summary>Answer</summary>

Slack = 3 − 2.5 = **0.5 ns** (positive, so it's fine).
</details>

**Q5.** Best-case clock-to-Q = 0.1 ns, and the fastest path has no gates. The hold time is 0.3 ns. Is there a violation? How do you fix it?

<details><summary>Answer</summary>

The fastest path is 0.1 ns, which is less than 0.3 ns, so **yes, it's a hold violation**. Fix it by **adding delay** to that path (buffers or inverter pairs) until it's at least 0.3 ns.
</details>

**Q6.** Will slowing down the clock fix a hold violation?

<details><summary>Answer</summary>

**No.** A hold check compares the fastest path with the hold time *at the same edge*. The clock period isn't part of it.
</details>

**Q7.** Which PVT conditions make a circuit slowest?

<details><summary>Answer</summary>

**High temperature, low voltage**, and slow-process ("worst corner") chips.
</details>

**Q8.** What is clock skew, and how do designers reduce it?

<details><summary>Answer</summary>

Clock skew is the **difference in when the clock edge arrives** at different flip-flops. It's reduced with a **balanced clock tree**, which gives equal delay from the root to every flip-flop.
</details>
