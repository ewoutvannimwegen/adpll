# Simple PLL

Project to learn how to build relatively simple Digital Phase Lock Loops 
(DPLL) on a FPGA. 

## Implementation 1

The initial model will only try to replicate the phase of the input clock on 
the output clock. It will try to lock-on the phase of the input clock. 
Error is allowed, the PLL is all about getting the error stable, so there 
is a predictable phase difference between the input and generated signal.

- Which can be used to synchronize multiple input signals, with different phases.
- or to make sure that the phase shift stays predictable even if it changes
frequently for a single signal. By adjusting the step size and correction
variables.

#### Calculations for the system clock frequency:

The following formula can be used to determine the parameters:

$$f_{out} = \frac{step}{2^{RES}} * f_{clk} (=) step = \frac{f_{out} * 2^{RES}}{f_{clk}} $$

Lets assume the core clock frequency is 50MHz, below are some options listed
for possible values of the counter resolution and step size.

Option 1

$$ f_{in}=f_{out} = 10kHz, f_{clk} = 50MHz, RES=16 \Rightarrow $$

$$ step = \frac{10k * 2^{16}}{50M} \approx 13 $$

Option 2

$$ f_{in}=f_{out} = 10kHz, f_{clk} = 50MHz, RES=12 \Rightarrow $$

$$ step = \frac{10k * 2^{12}}{50M} \approx 1 $$

#### Design notes: 

- The step size must be larger or equal than the correction value when leading. 
If the step is smaller than the correction
the clock is glitching. The clock will go back to its previous edge, to than 
switch back to the current edge and so on. When the step size is small, 
there is less flexibility to change the correction value. This will make it 
more difficult to get quickly to the steady state, but will require less
resources.

- The internal counter is based on signed 2's complement, this way only the MSB has to be checked and a duty cycle of 50 % is quaranteed, with a very small amount of logic. No <i>if statements</i> required which take a specific unsigned value of the number, to than reset the counter. Only downside is the loss of a single bit for the step size, this has to be a signed number.

- The system clock frequency should be the static variable, only the step size 
can be varied to adjust to a new input frequency. The step size cannot always
be an exact number, like in the example above, this will introduce some error.

- When the error is stable the phase is locked, there is a fixed phase difference
between the input and output signal, this is what we are aiming for. We want
error, but ONLY steady fixed error.

#### Upgrades

- A potential upgrade would be a frequency tracker, which keeps track of the frequency of the input clock. This way it is possible to predict a high-low or low-high clock switch, thus avoid some small error introduced in this system, due the lack of prevention by prediction for future events.
- Currently when the generated clock is leading or lacking the counter is incremented or decremented by 1. By adding a NCO that can change this value around based on feedback, the system would be in a stable state much sooner. Currently reaching the stable state takes quiet a while, but again does not require much logic.
- Support for other output frequencies, although this does not really have to be in the PLL, this can be realized by an extra counter put in sequence. The main goal of the PLL is to lock-on the phase, once this is done changing the frequency is a piece of cake.

## Sources 

- [PLL ZipCPU documentation](https://zipcpu.com/dsp/2017/12/14/logic-pll.html)
- [PLL ZipCPU source code](https://github.com/ZipCPU/dpll/tree/master)
- [2's complement Ben Eater video](https://www.youtube.com/watch?v=4qH4unVtJkE)
- [NCO wikipedia](https://en.wikipedia.org/wiki/Numerically_controlled_oscillator)
- [PLL example](https://github.com/filipamator/adpll)
