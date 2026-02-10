# RTL Design: UART Transmitter and Receiver

## Overview

This project implements a UART (Universal Asynchronous Receiver Transmitter) in Verilog HDL.

The design includes:
- Baud rate generator
- UART Transmitter (TX)
- UART Receiver (RX)
- Separate testbenches for verification

The implementation follows standard UART protocol:
- 8 data bits
- 1 start bit
- 1 stop bit
- No parity

---

## Architecture

### Baud Rate Generator
Generates a baud tick from a 50 MHz system clock for 9600 baud communication.

### UART Transmitter
- FSM-based design
- Sends start bit, 8 data bits (LSB first), and stop bit
- Generates `tx_busy` signal during transmission

### UART Receiver
- Detects start bit
- Samples 8 data bits
- Validates stop bit
- Generates `rx_done` pulse when byte is received

---

## Simulation

The design was verified using Xilinx Vivado behavioral simulation.

For TX:
- Verified start bit generation
- Verified LSB-first data transmission
- Verified stop bit timing
- Verified `tx_busy` behavior

For RX:
- Verified correct data reconstruction
- Verified `rx_done` pulse generation
- Confirmed correct frame timing

---

## Tools Used

- Xilinx Vivado (RTL simulation and verification)

---

## Author

Jayanth Reddy

