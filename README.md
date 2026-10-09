# UART Transmitter in Verilog

## Overview

A parameterized UART (Universal Asynchronous Receiver/Transmitter) transmitter implemented in Verilog HDL. The design serializes an 8-bit parallel input into a UART-style serial frame.

## Features

* Configurable clock cycles per bit
* Start bit, 8 data bits, and stop bit
* Least-significant-bit-first transmission
* Busy status output
* Self-checking simulation testbench

## Design Parameters

* `CLKS_PER_BIT`: Number of clock cycles per transmitted bit (default: 16)

## Module Interface

| Signal         | Direction | Description         |
| -------------- | --------- | ------------------- |
| `clk`          | Input     | System clock        |
| `rst`          | Input     | Reset               |
| `tx_start`     | Input     | Starts transmission |
| `tx_data[7:0]` | Input     | Byte to transmit    |
| `tx`           | Output    | Serial data output  |
| `tx_busy`      | Output    | Transmission status |

## Verification

The testbench transmits `8'hA5` and checks:

* Start bit
* All eight data bits
* Stop bit
* Return of `tx_busy` to low

## Simulation

Requires Icarus Verilog.

```bash
iverilog -g2012 -o uart_sim uart_tx.v tb_uart_tx.v
vvp uart_sim
```

## Synthesis

Requires Yosys.

```bash
yosys -p "read_verilog uart_tx.v; hierarchy -top uart_tx; proc; opt; check; stat" | tee synthesis_report.txt
```

The synthesis report is saved in `synthesis_report.txt`.

## Tools

* Verilog HDL
* Icarus Verilog
* Yosys
* Ubuntu on WSL
