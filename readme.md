# Simple PLL

## Background 

Project to learn how to build a relatively simple All Digital Phase Lock Loop
(ADPLL) on a FPGA. The digital part refers to the use of a digital implementation
of the Voltage Controlled Oscillator (VCO) (this is an analog component), 
I've decided to use a Numerical Controlled Oscillator (NCO).

The table below lists all PLL types:

| Category         | Phase Detector    | Phase Error Signal | Loop Filter      |
| ---------------- | ----------------- | ------------------ | ---------------- |
| LPLL (Linear PLL)| Analog            | Analog             | Analog           |
| DPLL (Digital PLL)| Digital           | Analog             | Analog           |
| ADPLL (All Digital PLL)| Digital       | Digital            | Digital          |
| SPLL (Software PLL)| Software         | Software           | Software         |

I will focus on ADPLL's because they are easy to develop and scalable. 
This project is somewhat serious, but mostly just to play around and learn some
stuff here and there, so I don't want to get stuck in the complex analog 
configuration playground.

The Xilinx/AMD example uses a SPI-bus attached to a Digital to Analog Converter
(DAC) to control a hardware VCO IC. I will use mainly VHDL-1993 (no fancy
VHDL-2008 tricks are used) to practice for
my study program, but using Verilog is probably easier here. The ZipCPU 
designer has some great verification scripts which use Verilator, a Verilog/
System Verilog only simulator.

Building blocks and how I use them:

- Phase Detector (PD): detects the phase of the incoming clock signal and
determines if the generated output coincides, leads or lags compared to the 
incoming signal.
- Low Pass Filter (LPF): not implemented
- Voltage Controlled Oscillator (VCO): not implemented
- Numerical Controlled Oscillator (NCO): sort of implemented, I use the 
original square wave as output signal. The main purpose of a NCO is to 
make a 'new' signal like a sine wave.

I've implemented the PD and NCO in a single block, both barely use any
logic, keeping them in the same file allows easy readability and understanding
of the logic for beginners.

```text
             |----|    |-----|    
ref_clk ---> | PD |--->| NCO |--->gen_clk
             |----|    |-----| |
               ^               |
               ---------------- 
```

## Implementation 

The initial model will only try to replicate the phase of the input clock signal on 
the generated output clock signal. It will try to lock-on the phase of the input. 
Error is allowed, the PLL is all about getting the error stable, so there 
is a predictable phase difference between the input and generated signal.

#### Calculations for the system clock frequency:

Variables:

- System clock frequency: $f_{clk}$, 
- Input clock frequency: $f_{in}$, 
- Generated output clock frequency: $f_{out}$, 
- Step size internal counter: $step$, 
- Resolution internal counter: $RES$, 

Relations:

$$f_{out} = \frac{step}{2^{RES}} * f_{clk} (=) step = \frac{f_{out} * 2^{RES}}{f_{clk}} $$

Lets assume the core clock frequency is static 50MHz. It is not realistic
to change this parameter around in a 'real' system, mainly because it is 
a hardware component such as a quarts crystal. The step size and counter 
resolution can be changed, below are some options listed
for possible values of the counter resolution and step size.

Option 1

$$ f_{in}=f_{out} = 10kHz, f_{clk} = 50MHz, RES=16 \Rightarrow $$

$$ step = \frac{10k * 2^{16}}{50M} \approx 13 $$

Option 2

$$ f_{in}=f_{out} = 10kHz, f_{clk} = 50MHz, RES=12 \Rightarrow $$

$$ step = \frac{10k * 2^{12}}{50M} \approx 1 $$

#### Design notes: 

- The system clock must be higher than the input clock, in order to make 
this system to work.

- The input signal goes through a large counter, so no de-glitching FF's needed.

- The step size must be larger or equal than the correction value when leading. 
If the step is smaller than the correction
the <b>clock is glitching</b>. The clock will go back to its previous edge, to than 
switch back to the current edge and so on. When the step size is small, 
there is less flexibility to change the correction value. This will make it 
more difficult to get quickly to the steady state, but will require less
resources.

- Internal counter can be signed or unsigned. Signed counts till the MSB flips
and the sign swaps (2's complement). Unsigned uses the same trick, but without
the sign swap. Note that both relay on a 50% duty cycle.

Unsigned 2's complement example 3-bit counter:

```text
0|000 
1|001
2|010
3|011
4|100
5|101
6|110
7|111
```

- Counts from 0 to 4 is 4 clock cycles till clock edge switch.
- Counts from 4 to 8 (0) is 4 clock cycles till clock edge switch.

Signed 2's complement example 3-bit counter:

```text
-4|100
-3|101 
-2|110
-1|111
 0|000
 1|001
 2|010
 3|011
```

- Counts from 0 to -4 is 4 clock cycles till clock edge switch.
- Counts from -4 to 0 is 4 clock cycles till clock edge switch.

Unsigned is preferred here, 
this way the step size and loop gain coefficient can also be unsigned.  These
won't be negative, so if signed they lose both 1-bit of resolution.
In VHDL we cannot add signed and unsigned numbers!

- When the error is stable the phase is locked, there is a fixed phase difference
between the input and output signal, this is what we are aiming for. We want
error, but ONLY steady fixed error.

## Sources 

- [PLL ZipCPU documentation](https://zipcpu.com/dsp/2017/12/14/logic-pll.html)
- [PLL ZipCPU source code](https://github.com/ZipCPU/dpll/tree/master)
- [2's complement Ben Eater video](https://www.youtube.com/watch?v=4qH4unVtJkE)
- [NCO wikipedia](https://en.wikipedia.org/wiki/Numerically_controlled_oscillator)
- [PLL example](https://github.com/filipamator/adpll)
- [Types of PLL's](https://www.skyworksinc.com/-/media/Skyworks/SL/documents/public/application-notes/AN575.pdf)
- [Digital Subsampling Phase Lock Techniques for Frequency Synthesis and Polar Transmission ](https://link-springer-com.ezproxy2.utwente.nl/book/10.1007/978-3-030-10958-5)
- [ADPLL matlab/simulink](https://nl.mathworks.com/help/msblks/ug/digital-phase-locked-loop.html)
