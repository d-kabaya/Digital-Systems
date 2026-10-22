# Lesson 1.1 — Electrical Circuits

> Based on lecture slides **1.1 Electrical circuits** (COMP20020).
> ⬅️ [Back to index](../README.md) · Next ➡️ [1.2 Digital Abstraction](02-digital-abstraction.md)

## What are we learning?

Before a computer can do anything clever, electricity has to flow around a loop of wire. This lesson covers the basic physics: what electric charge is, what current, voltage, resistance and power mean, and how to use **Ohm's law** to pick a resistor for an LED.

---

## 1. Electric charge

All matter is made of atoms, and atoms are made of three kinds of particle:

| Particle | Charge | Where it lives |
|---|---|---|
| Proton | positive (+) | in the nucleus |
| Neutron | none | in the nucleus |
| Electron | negative (−) | orbiting the nucleus |

Two rules:

- **Same signs repel** (+ and +, or − and −).
- **Opposite signs attract** (+ and −).

An atom normally has as many protons as electrons, so it looks neutral. Electrons are held in place more weakly than the nucleus is held together, so a strong enough "push" can knock one out. That process is called **ionisation**. It leaves a free electron (−) and a positive **ion** (+).

## 2. Current electricity vs static electricity

- **Current electricity:** charged particles *moving* because an electric field pushes them. In metals such as copper, the outer electrons drift easily from atom to atom, forming a "sea" of electrons that can flow.
- **Static electricity:** charge that *builds up and stays put* on an object. Rubbing glass with wool, for example, transfers electrons. This is called the *triboelectric effect*.

> ⚠️ **Direction gotcha:** by historical convention, current flows from **+ to −**. That is the *opposite* of the direction the electrons actually move.

## 3. Conductors, insulators and breakdown

| Conductors (let current flow) | Insulators (block current) |
|---|---|
| copper, aluminium, gold, salt water | air, paper, rubber, plastic, pure water |

If the electric "pressure" across an insulator is strong enough, it rips electrons off the atoms and an avalanche of current flows. This is **electrical breakdown**, and lightning is an example. The insulating layers inside chips are microscopically thin, so even the static on your body can break them down. That's why electrostatic discharge (ESD) damages chips.

## 4. Electrical sources

A battery, solar panel, generator or thermocouple builds up extra electrons on one terminal (−) and removes them from the other (+). The difference in charge between the terminals is the **potential difference**, or **voltage**.

## 5. The parts of a circuit

Every circuit has four kinds of part:

1. **Active component:** supplies energy (e.g. a battery).
2. **Passive component:** uses up energy (e.g. a bulb, LED or resistor).
3. **Switch:** starts or stops the current.
4. **Wires:** form a closed conductive **loop**. With no loop, there's no current.

Circuit diagrams save clutter with two shorthand symbols:

- **Vs** (voltage supply) means "connected to the + terminal".
- **GND** (ground) means "connected to the − terminal". The name comes from early telegraphs, which used the actual earth as the return wire.

## 6. The four key quantities

The easiest way to think about this is to **compare electricity to water flowing in pipes.**

| Quantity | Symbol | Unit | Water analogy |
|---|---|---|---|
| Current | I | Ampere (A) = 1 coulomb per second | how much water flows past per second |
| Voltage | U | Volt (V) | water pressure |
| Resistance | R | Ohm (Ω) | how narrow the pipe is |
| Power | P | Watt (W) | how much "work" the flow can do |

**Measuring with a multimeter:**

- **Voltage:** connect the meter **in parallel** (across the two points).
- **Current:** connect the meter **in series** (break the loop and put the meter in it).
- **Resistance:** connect it directly across the component.

## 7. Ohm's law and power

```
U = I × R          I = U / R          R = U / I
P = I × U
```

1 V across 1 Ω gives 1 A. 1 A at 1 V is 1 W of power. Every component has a power limit, and if you exceed it, the component burns out.

### Metric prefixes

| Prefix | Meaning | Example |
|---|---|---|
| m (milli) | × 0.001 | 6 mA = 0.006 A |
| μ (micro) | × 0.000001 | 15 μV = 0.000015 V |
| k (kilo) | × 1000 | 47k Ω = 47 000 Ω |

## 8. Diodes, LEDs and resistors

- A **diode** is a one-way valve for current. Current flows from the **anode (+)** to the **cathode (−)** only.
- An **LED** is a diode that lights up. Its anode is the **longer leg**.
- A diode needs a minimum voltage before it conducts. This is the **voltage drop**, usually about 0.5–2 V.
- Once an LED conducts, its resistance is tiny. Connected straight to a battery, it would draw too much current and burn. So you always put a **resistor** in series with it to limit the current.

### Worked example (from the slides)

**Question:** Vs = 3.0 V and the LED's voltage drop is 2.0 V. What resistor limits the current to 0.01 A?

1. The LED "uses up" 2.0 V, so the resistor only sees what's left: 3.0 − 2.0 = **1.0 V**.
2. Ohm's law gives R = U / I = 1.0 V / 0.01 A = **100 Ω**.

✅ **Answer: 100 Ω**

---

## Common mistakes

- Forgetting to **subtract the LED's voltage drop** before using Ohm's law.
- Forgetting to convert mA to A (divide by 1000).
- Connecting an ammeter in parallel instead of in series.
- Mixing up conventional current (+ to −) with electron flow (− to +).

## Quick summary

- Charge comes in + and −. Like charges repel and opposites attract.
- Current is moving charge (A), voltage is electrical pressure (V), resistance opposes current (Ω), and power is P = I × U (W).
- Ohm's law is U = I × R.
- An LED always needs a series resistor: R = (Vs − V_drop) / I.

---

## 📝 Quiz

Try each question before you open the answer.

**Q1.** Which sub-atomic particle carries a negative charge?

<details><summary>Answer</summary>

The **electron**. Protons are positive and neutrons have no charge.
</details>

**Q2.** What is the difference between current electricity and static electricity?

<details><summary>Answer</summary>

Current electricity is charge that is **moving** under an electric field. Static electricity is charge that has **built up and isn't moving** on an object.
</details>

**Q3.** A 60 Ω circuit has 6 V across it. What current flows?

<details><summary>Answer</summary>

I = U / R = 6 / 60 = **0.1 A** (100 mA).
</details>

**Q4.** 0.1 A flows through a 100 Ω resistor. What is the voltage across it?

<details><summary>Answer</summary>

U = I × R = 0.1 × 100 = **10 V**.
</details>

**Q5.** A bulb draws 104 mA at 5.0 V. How much power does it use?

<details><summary>Answer</summary>

Convert first: 104 mA = 0.104 A. Then P = I × U = 0.104 × 5.0 = **0.52 W**.
</details>

**Q6.** You want 20 mA through a red LED with a 2.0 V drop, powered from Vs = 5 V. Which resistor do you need?

<details><summary>Answer</summary>

The resistor sees 5 − 2 = 3 V. R = 3 / 0.020 = **150 Ω**.
</details>

**Q7.** How do you connect a multimeter to measure current: in series or in parallel?

<details><summary>Answer</summary>

**In series.** All the current has to pass through the meter.
</details>

**Q8.** A resistor is labelled "47k". What is its resistance in ohms?

<details><summary>Answer</summary>

47 × 1000 = **47 000 Ω**.
</details>

**Q9.** Why can static electricity on your fingers destroy a chip that runs happily on 3 V?

<details><summary>Answer</summary>

The insulating layers inside a chip are microscopically thin. Static charge can be thousands of volts, which is enough to cause **electrical breakdown** of those layers. An avalanche of current then burns through them.
</details>
