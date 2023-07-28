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
