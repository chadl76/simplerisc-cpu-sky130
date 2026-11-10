# 32-Bit SimpleRisc CPU — RTL to GDS on SkyWater 130 nm

A single-cycle, five-stage 32-bit processor for the SimpleRisc ISA (21 instructions), designed first in Logisim, rewritten in Verilog, verified by running a factorial program, and taken through the open-source LibreLane flow to a **DRC-, LVS- and antenna-clean** layout in the SkyWater 130 nm process.

![CPU layout on Sky130](docs/layout.png)

## Results (LibreLane, sky130A, sky130_fd_sc_hd)

| Metric | Value |
|---|---|
| Clock constraint | 200 ns (5 MHz) |
| Worst setup slack | +135 ns (all corners) |
| Worst hold slack | +0.17 ns |
| Standard cells | ~16.8k (logic, excluding fill/tap) |
| Die size | 563 × 573 µm |
| Power (typical) | ~24 mW |
| Magic DRC / KLayout DRC | 0 / 0 |
| LVS | Pass |
| Antenna | Pass |

Full numbers are in [`asic/results/metrics.json`](asic/results/metrics.json) and the sign-off summary in [`asic/results/manufacturability.rpt`](asic/results/manufacturability.rpt). The final layout is [`asic/results/cpu.gds.gz`](asic/results/cpu.gds.gz) (gzipped, open with KLayout after `gunzip`).

The large setup slack means the design would close at a much faster clock. Tightening the constraint is the next step.

## Architecture

Every instruction passes through all five stages in one clock cycle:

| Stage | File | Job |
|---|---|---|
| IF — Instruction Fetch | `if_stage.v` | PC register, loadable instruction memory |
| OF — Operand Fetch | `of_stage.v`, `regFile.v`, `immgen.v`, `branchTarget.v` | Decode fields, read registers, build immediate and branch target |
| EX — Execute | `ex_stage.v`, `alu.v`, `flag.v` | ALU operations, compare flags, branch decision |
| MA — Memory Access | `ma_stage.v` | Data RAM for `ld` / `st` |
| RW — Register Writeback | `rw_stage.v` | Write ALU result, loaded value or return address |
| Control | `control_unit.v` | Decodes the opcode into control signals |

Top level: [`rtl/cpu.v`](rtl/cpu.v). The program memory can be loaded through `prog_we` / `prog_addr` / `prog_data`, so the same chip can run different programs.

![SimpleRisc instruction formats](docs/instruction_formats.png)

**ASIC note:** the hardware divider (`div`, `mod`) was removed from the ALU for the silicon version. A 32-bit combinational divider dominated area and the critical path.

## Verification

[`tb/tb_cpu.v`](tb/tb_cpu.v) loads a factorial program into instruction memory, runs it, and checks the registers, RAM and final PC:

```
mov r0, 10        ; n
mov r1, 1         ; result
mov r2, r0        ; counter
loop: mul r1, r1, r2
      sub r2, r2, 1
      cmp r2, 1
      bgt loop
st  r1, 5[r2]     ; store the answer
b   0             ; halt
```

Expected result: `r1 = 10! = 3,628,800 (0x00375F00)`.

## How to run

```bash
# Simulation (Icarus Verilog)
iverilog -o sim tb/tb_cpu.v rtl/*.v && vvp sim

# Layout (inside the IIC-OSIC-TOOLS container)
cd asic
librelane config.yaml
```

## Repository structure

```
rtl/    Verilog source (12 modules)
tb/     factorial testbench
asic/   LibreLane config + sign-off results and final GDS
docs/   layout screenshot, instruction formats, IEEE-style report, slides
```

## Author

Chad Lucas, B.S. Electrical Engineering, University of North Dakota
