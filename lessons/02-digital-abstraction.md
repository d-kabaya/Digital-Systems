# Lesson 1.2 — Digital Abstraction & Number Systems

> Based on lecture slides **1.2 Digital Abstraction** (COMP20020).
> ⬅️ [1.1 Electrical Circuits](01-electrical-circuits.md) · [Index](../README.md) · ➡️ [1.3 Logic Gates](03-logic-gates.md)

## What are we learning?

How do we go from voltages on wires to letters and numbers? The key idea is **abstraction**. We agree that certain voltages *mean* 1 or 0, and then that certain *patterns* of 1s and 0s mean letters or numbers. This lesson covers binary, octal and hexadecimal, and the ASCII character code.

---

## 1. Symbols and meaning

- **Humans** give meaning to symbols. "123" means one hundred and twenty-three only because we agree that it does.
- **Computers** just shuffle symbols around mechanically, following an algorithm.

This split is the core of digital systems.

## 2. Representing 1 and 0 with voltage

Digital electronics uses only **two** symbols:

```
 Vs (e.g. 3.0 V)  ┌──────────────┐
                  │  HIGH  = "1" │
                  ├──────────────┤
                  │ forbidden    │  ← signals must never sit here
                  ├──────────────┤
                  │  LOW   = "0" │
 GND (0 V)        └──────────────┘
```

**Why use ranges instead of exact voltages?** Real wires pick up **electrical noise**. If "1" meant exactly 0.5 V, then 0.51 V would be an error. With *ranges*, a bit of noise still lands inside the right zone, so digital circuits are **noise-tolerant**.

In a circuit, a **switch** can set an input. Connecting the input to Vs gives "1", and connecting it to GND gives "0".

## 3. Making bigger symbols from bits

The idea is the same as Chappe's optical telegraph, where each letter was a particular arrangement of moving arms. Several wires, each carrying 1 or 0, together form a **code**.

### ASCII

- 7 bits give 2⁷ = **128 codes**.
- 95 of them are printable characters (letters, digits, punctuation) and 33 are **control characters**. For example, **CR** (carriage return) moves the print head back to the start of the line, and **LF** (line feed) moves down one line.
- Example: `1111010` = **"z"**.

## 4. Positional number systems

In any base *p*, a digit's **weight** depends on its position *n*, counted from 0 on the right:

```
weight = p^n
```

**Decimal (base 10):**

```
123 = 1×10² + 2×10¹ + 3×10⁰ = 100 + 20 + 3
```

**Binary (base 2):** the digits are only 0 and 1, and each one is called a **bit**.

```
1001₂ = 1×2³ + 0×2² + 0×2¹ + 1×2⁰ = 8 + 0 + 0 + 1 = 9
```

The binary place values are worth memorising: **… 128 64 32 16 8 4 2 1**

Example: `1111010₂` = 64 + 32 + 16 + 8 + 0 + 2 + 0 = **122**. That's the ASCII code for "z" as a number. With 7 wires you can represent 0 up to 1111111₂ = **127**.

### Which digits are allowed?

A base-*p* system uses the digits **0 up to p−1**:

| Base | Digits |
|---|---|
| 2 (binary) | 0 1 |
| 8 (octal) | 0–7 |
| 10 (decimal) | 0–9 |
| 16 (hex) | 0–9, then **A=10, B=11, C=12, D=13, E=14, F=15** |

**Octal example:** 177₈ = 1×64 + 7×8 + 7×1 = 64 + 56 + 7 = **127**

**Hex examples:**

- 43₁₆ = 4×16 + 3 = **67**
- 3F₁₆ = 3×16 + 15 = **63**

## 5. Why use hexadecimal?

Long binary strings are hard for humans to read and remember. Converting between decimal and binary takes real work. **Hex ↔ binary, on the other hand, is a simple lookup**, because one hex digit is always exactly four bits. That makes hex a handy shorthand for binary.

### The conversion chart (memorise it!)

| Bin | Hex | Bin | Hex |
|---|---|---|---|
| 0000 | 0 | 1000 | 8 |
| 0001 | 1 | 1001 | 9 |
| 0010 | 2 | 1010 | A |
| 0011 | 3 | 1011 | B |
| 0100 | 4 | 1100 | C |
| 0101 | 5 | 1101 | D |
| 0110 | 6 | 1110 | E |
| 0111 | 7 | 1111 | F |

### Binary → hex

1. Split the bits into groups of 4, **starting from the right**.
2. Pad the leftmost group with leading zeros if needed.
3. Replace each group with its hex digit.

```
1000111010010001010101101100110
0100 0111 0100 1000 1010 1011 0110 0110
  4    7    4    8    A    B    6    6     →  4748AB66₁₆
```

### Hex → binary

Replace each hex digit with its 4 bits:

```
F    F    B    E
1111 1111 1011 1110
```

> Converting **decimal → binary** (repeated division by 2) is covered in [Lesson 3.3](10-fixed-and-floating-point.md). See also your own worked example in [`worked-examples/decimal-conversion.txt`](../worked-examples/decimal-conversion.txt).

---

## Common mistakes

- Counting positions from the **left**. Always count from the **right**, starting at 0.
- Grouping bits for hex starting from the left. Always start from the **right**.
- Writing "10" as a single hex digit. Ten is **A**.
- Using the digit 8 or 9 in an octal number.

## Quick summary

- 1 and 0 are **voltage ranges** (near Vs and near GND), which makes circuits noise-tolerant.
- Patterns of bits encode characters (ASCII uses 7 bits) and numbers (binary).
- A digit's value is digit × base^position.
- One hex digit = 4 bits, so hex is shorthand for binary.

---

## 📝 Quiz

**Q1.** Why are HIGH and LOW defined as voltage *ranges* rather than exact values?

<details><summary>Answer</summary>

To tolerate **electrical noise**. A slightly wrong voltage still falls inside the correct range, so it's still read correctly.
</details>

**Q2.** Convert 101101₂ to decimal.

<details><summary>Answer</summary>

32 + 0 + 8 + 4 + 0 + 1 = **45**
</details>

**Q3.** Convert 2A₁₆ to decimal.

<details><summary>Answer</summary>

2×16 + A(10)×1 = 32 + 10 = **42**
</details>

**Q4.** Convert 10110111₂ to hex.

<details><summary>Answer</summary>

Group from the right: `1011 0111` → B 7 → **B7₁₆**
</details>

**Q5.** Convert C8₁₆ to binary, then to decimal.

<details><summary>Answer</summary>

C = 1100 and 8 = 1000, so C8₁₆ = **11001000₂**. In decimal that's 12×16 + 8 = **200**.
</details>

**Q6.** How many different codes can ASCII's 7 bits represent? What is the largest 7-bit unsigned number?

<details><summary>Answer</summary>

2⁷ = **128** codes. The largest number is 1111111₂ = **127**.
</details>

**Q7.** What does 177₈ equal in decimal?

<details><summary>Answer</summary>

1×64 + 7×8 + 7 = **127**
</details>

**Q8.** An LCD controller receives the 7-bit ASCII code 1001000. Which character is it? (Hint: 'A' = 1000001.)

<details><summary>Answer</summary>

1001000₂ = 72. 'A' is 65, so 72 is 7 letters later: **'H'**.
</details>

**Q9.** Is "1A9" a valid octal number?

<details><summary>Answer</summary>

**No.** Octal only uses the digits 0–7, so "A" and "9" aren't allowed.
</details>
