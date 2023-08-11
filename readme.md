# ADPLL

## Background 

Project to learn how to build a relatively simple All Digital Phase Lock Loop
(ADPLL) on a FPGA. 

PLL types:

| Category         | Phase Detector    | Phase Error Signal | Loop Filter      |
| ---------------- | ----------------- | ------------------ | ---------------- |
| LPLL (Linear PLL)| Analog            | Analog             | Analog           |
| DPLL (Digital PLL)| Digital           | Analog             | Analog           |
| ADPLL (All Digital PLL)| Digital       | Digital            | Digital          |
| SPLL (Software PLL)| Software         | Software           | Software         |

## Carry chain length

- N: number of CARRY4 blocks
- $T_{rf}$: period of the reference clock signal = 20ns 
- $T_{prop}$: period of propagation delay CARRY4 = 187ps

$$ N = \frac{T_{rf}}{T_{prop}} = \frac{20n}{187p} \approx 106 \Rightarrow 128 $$

In the Xilinx/AMD docs the main advantage and limitation of the carry chain is described as:

```text
The propagation delay for an adder increases linearly with the number of bits in the
operand, as more carry chains are cascaded. The carry chain can be implemented with a
storage element or a flip-flop in the same slice

Carry logic cascading is limited only by the height of the column of slices. Carry logic
cannot be cascaded across super logic regions (SLRs) in devices using stacked silicon
interconnect (SSI) technology. See Devices Using Stacked Silicon Interconnect (SSI)
Technology in Chapter 6.
```

Meaning that the chain stays linear if the size is increased, but 
we can not have a chain larger than the height of the FPGA, for
the Zynq-7000 series it is 150.

## Voltage level IO bank

The IO bank is powered at 1.8/2.5V not 3.3V, the 1.8/2.5V is needed to get the 
differential pairs to work, see Xilinx/AMD docs:

```text
The LVDS I/O standard is only available in the HP I/O banks. It requires a VCCO to be
powered at 1.8V for outputs and for inputs when the optional internal differential
termination is implemented (DIFF_TERM = TRUE).
The LVDS_25 I/O standard is only available in the HR I/O banks. It requires a VCCO to be
powered at 2.5V for outputs and for inputs when the optional internal differential
termination is implemented (DIFF_TERM = TRUE).
```

The JC1 bank is a 'High Range (HR)' bank, only 2.5V possible.
The 1V8 ports on headers such as PA1 and PA2 can provide 1.8V. 
The 2.5V can be found on header J18.

## Sources 

- [PLL ZipCPU documentation](https://zipcpu.com/dsp/2017/12/14/logic-pll.html)
- [PLL ZipCPU source code](https://github.com/ZipCPU/dpll/tree/master)
- [2's complement Ben Eater video](https://www.youtube.com/watch?v=4qH4unVtJkE)
- [ADPLL example](https://github.com/filipamator/adpll)
- [Overview PLL types](https://www.skyworksinc.com/-/media/Skyworks/SL/documents/public/application-notes/AN575.pdf)
- [Digital Subsampling Phase Lock Techniques for Frequency Synthesis and Polar Transmission ](https://link-springer-com.ezproxy2.utwente.nl/book/10.1007/978-3-030-10958-5)
- [ADPLL Matlab/Simulink model](https://nl.mathworks.com/help/msblks/ug/digital-phase-locked-loop.html)
- [TDC docs/implementation TU Delft](https://sps.ewi.tudelft.nl/fpga_tdc/TDC_basic.html)
- [TDC verilog implementation](https://github.com/RuiMachado39/TDC)
- [Xilinx/AMD external simulators](https://docs.xilinx.com/r/en-US/ug900-vivado-logic-simulation/Running-Timing-Simulation-Using-Third-Party-Tools)
- [Xilinx/AMD carry chains](https://docs.xilinx.com/v/u/en-US/ug474_7Series_CLB)
- [Xilinx/AMD IBUFDS (differential input buffer)](https://docs.xilinx.com/r/en-US/ug953-vivado-7series-libraries/IBUFDS)
- [Voltage level IO-bank](https://krtkl.com/faq-items/snickerdoodle-io-voltage/)

Post-synthesis timing simulation requires a Verilog based testbench, VHDL not supported!

Additional Questa Sim elaboration settings for Post-synthesis timing simulation 
```console
+transport_int_delays +pulse_int_e/0 +pulse_int_r/0
```
