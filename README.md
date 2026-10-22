# Synchronous-FIFO-RTL
Designed an 8-bit, 8-entry synchronous FIFO using Verilog HDL. Implemented read/write pointers, full/empty flags, simultaneous operations, and explored synthesis and gate-level implementation in Vivado.

# Verilog FIFO Design

## Overview
This project implements an 8-bit, 8-entry synchronous FIFO (First-In, First-Out) using Verilog HDL. It is designed and synthesized using Xilinx Vivado to understand RTL design and FPGA implementation.

## Features
- 8-bit data width
- 8-entry storage capacity
- Synchronous read and write operations
- Read and write pointer management
- Full and empty status flags
- Support for simultaneous read and write operations
- RTL synthesis and gate-level schematic inspection

## Design Architecture
The FIFO consists of:
- **Memory Array:** Stores up to 8 data entries.
- **Write Pointer:** Tracks the next memory location for writing.
- **Read Pointer:** Tracks the next memory location for reading.
- **Counter:** Maintains the number of stored entries.
- **Full Flag:** Indicates when the FIFO cannot accept more data.
- **Empty Flag:** Indicates when the FIFO contains no valid data.

## Tools Used
- Verilog HDL
- Xilinx Vivado Design Suite

## Implementation Flow
1. Write the RTL code.
2. Elaborate and check the design.
3. Run RTL simulation to verify functionality.
4. Run synthesis to generate the synthesized netlist.
5. Inspect the synthesized schematic and FPGA resource utilization.
6. Run implementation for placement and routing.

## Applications
- Temporary data buffering
- Digital communication systems
- Data transfer between hardware modules
- FPGA-based digital systems

## Learning Outcomes
This project provides practical experience with sequential logic, memory management, pointer control, FIFO status flags, Verilog RTL coding, synthesis, and FPGA implementation.

## Author

S.Kishore Naik

Developed as a digital design learning project using Verilog HDL and Vivado.
