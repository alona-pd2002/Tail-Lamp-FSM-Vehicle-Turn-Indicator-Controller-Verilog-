# Tail-Lamp-FSM-Vehicle-Turn-Indicator-Controller-Verilog-
A synthesizable Verilog FSM for automotive tail-lamp control featuring turn indicators, hazard mode, adjustable flash rate, and FPGA-ready clock division.
The system controls six lamps  
(three on the left, three on the right) and supports:

- **LEFT turn indication**
- **RIGHT turn indication**
- **EMERGENCY / HAZARD mode**
- **RESET (clear all lights)**

The behavior exactly follows the tail-lamp sequence pattern shown in the problem
statement.

---

## 📌 Features

### ✔ LEFT Indicator Mode
Lamps on the **left side** turn on progressively:

Sequence | Left Lamps | Right Lamps
---------|------------|-------------
0        | 000        | 000  
1        | 100        | 000  
2        | 110        | 000  
3        | 111        | 000  

---

### ✔ RIGHT Indicator Mode
Lamps on the **right side** turn on progressively:

Sequence | Left Lamps | Right Lamps
---------|------------|-------------
0        | 000        | 000  
1        | 000        | 001  
2        | 000        | 011  
3        | 000        | 111  

---

### ✔ EMERGENCY / HAZARD Mode
Both left and right lamps flash **together**, in a bidirectional pattern:

0 → 1 → 2 → 3 → 2 → 1 → repeat



Emergency mode flashes at **double the speed** of normal turn signals.

Sequence | Lamps (Left + Right)
---------|----------------------
0        | 000000  
1        | 100001  
2        | 110011  
3        | 111111  

---

## 🧠 Design Overview

The design uses:

- **FSM counters** for each mode  
- **Bidirectional step counter** for emergency flashing  
- **Clock divider** to generate human-visible blinking frequency  
- **6-bit LED output**:  
  - `led[5:3]` → Left lamps  
  - `led[2:0]` → Right lamps
  ## ▶ How to Simulate

1. Open your simulator (ModelSim, Vivado, iverilog, etc.).
2. Add the following files:
   - `src/tail_lamp.v`
   - `src/clockdivi.v`
   - `src/tb_tail_lamp.v`
3. Run the simulation.
4. Observe blinking patterns in waveform (seq, dir, led outputs).

---

## ▶ How to Use on FPGA (Basys3)

- Connect switches/buttons to:
  - `LEFT`
  - `RIGHT`
  - `EMERGENCY`
  - `RST`
- Drive LEDs with `led[5:0]`.

The clock divider is tuned for the **100 MHz Basys3 clock**.

---

## 🛠 Tools Used

- Verilog HDL  
- Xilinx Vivado / ModelSim  
- Basys3 FPGA Board 
