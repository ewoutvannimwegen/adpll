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
- [Xilinx/AMD simulator settings](https://docs.xilinx.com/r/en-US/ug900-vivado-logic-simulation/Running-Timing-Simulation-Using-Third-Party-Tools)

Post-synthesis timing simulation requires a Verilog based testbench, VHDL not supported!

Additional Questa Sim elaboration settings for Post-synthesis timing simulation 
```console
+transport_int_delays +pulse_int_e/0 +pulse_int_r/0
```
