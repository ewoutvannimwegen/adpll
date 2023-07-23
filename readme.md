# Simple PLL

Project to learn how to build relatively simple Phase Lock Loops (PLL) on a FPGA. 


## Implementation 1

The initial model will only try to replicate the phase of the input clock on the output clock. It will try to lock-on the phase of the input clock. Some error is allowed they main goal is to keep the amount of logic needed very low. 

#### Calculations for the system clock frequency:

Assumed that:

$$ f_{in} = f_{out} $$

$$f_{out} = \frac{step}{2^{RES}} * f_{clk} (=) $$ 
$$f_{out} * 2^{RES} = step * f_{clk} (=) $$

$$ f_{clk} = \frac{f_{out} * 2^{RES}}{step} $$

$$ f_{in}=f_{out} = 10kHz, step = 1, RES=8 \Rightarrow $$

$$ f_{clk} = \frac{10k * 2^8}{1} = 2.56MHz, T_{clk} = 390.625ns $$

#### Design notes: 

- The internal counter is based on signed 2's complement, this way only the MSB has to be checked and a duty cycle of 50 % is quaranteed, with a very small amount of logic. No <i>if statements</i> required which take a specific unsigned value of the number, to than reset the counter. Only downside is the loss of a single bit for the step size, this has to be a signed number.

- If the step size is increased the system clock does not have to be very high. 
- The system always has 1 clock cycle of inprecision which introduces error. If the resolution is increased, which results in a higher system clock frequency, the error will be reduced, the single cycle takes less time.

#### Upgrades

- A potential upgrade would be a frequency tracker, which keeps track of the frequency of the input clock. This way it is possible to predict a high-low or low-high clock switch, thus avoid some small error introduced in this system, due the lack of prevention by prediction for future events.
- Currently when the generated clock is leading or lacking the counter is incremented or decremented by 1. By adding a NCO that can change this value around based on feedback, the system would be in a stable state much sooner. Currently reaching the stable state takes quiet a while, but again does not require much logic.
- Support for other output frequencies, although this does not really have to be in the PLL, this can be realized by an extra counter put in sequence. The main goal of the PLL is to lock-on the phase, once this is done changing the frequency is a piece of cake.

## Sources 

- [PLL ZipCPU documentation](https://zipcpu.com/dsp/2017/12/14/logic-pll.html)
- [PLL ZipCPU source code](https://github.com/ZipCPU/dpll/tree/master)
- [2's complement Ben Eater video](https://www.youtube.com/watch?v=4qH4unVtJkE)
- [NCO wikipedia](https://en.wikipedia.org/wiki/Numerically_controlled_oscillator)

