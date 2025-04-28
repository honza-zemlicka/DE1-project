# DE1 Timer project

### Team members

* Vojtěch Šafařík (responsible for coding & poster creation)
* Hana Štěrbová (responsible for coding & diagrams)
* Martin Zatloukal (responsible for simulations & code formatting)
* Jan Žemlička (responsible for managing GitHub repository & video presentation)

### Abstract
This project focuses on creating a simple [pomodoro timer](https://pomofocus.io/) with Nexys A7-50T FPGA board. Pomodoro technique is a time management method that breaks your work into intervals (usually 25 minutes long), followed by short breaks (5 minutes long). After 4 working intervals a longer break follows (15 minutes). This technique is used to improve focus & productivity by balancing working intervals with regular rest times.

[**Video demonstration of our project**](https://youtu.be/NcyMTQrKaDQ)

![Project poster](images/poster.png "A3 project poster")

## Hardware description of demo application

When launching the device, the user finds themselves in idle mode, indicated by LED16 emmiting blue colour. Upon pressing BTNC, the first working interval starts.

## Software description

The VHDL code consists of several entities:

- [**Pomodoro**](Pomodoro-Project/Pomodoro-Project.srcs/sources_1/pomodoro.vhd) module
    - The pomodoro module controls the timer logic. Once started, it counts down a preset time interval (25 minutes of work) and automatically transitions into an idle state. The user then can start their break period (5 or 15 minutes, depending on *work_counter* value). It allows starting, pausing, resetting, and switching between work and break phases via buttons. Outputs of the module are the current minutes (*MM*) and seconds (*SS*) for display, and LED signals to indicate the current phase (work, break, or idle). It is driven by the main 100 MHz clock from onboard crystal oscillator, with internal generation of 1-second ticks.

- [**BinTo7seg**](Pomodoro-Project/Pomodoro-Project.srcs/sources_1/7seg.vhd) module
    - The BinTo7seg module converts two 8-bit binary values (minutes and seconds) into corresponding digits for a 4-digit 7-segment display. It implements digit selection, multiplexing, and digit-to-segment conversion using a synchronized clock signal. The module generates signal to cycle through digits approximately every 1 ms, ensuring a stable visual output. Segment and position outputs are active low.

- [**Debounce**](Pomodoro-Project/Pomodoro-Project.srcs/sources_1/debounce.vhd) module
    - The debounce module filters mechanical bounce from button inputs and synchronizes them with the clk signal. It uses a two-stage synchronizer and a counter to verify the button state stability over 25 ms long debounce time. The module also generates signals for edge detection, including rise and fall events, which can be used to detect button presses and releases.

- [**Top level**](Pomodoro-Project/Pomodoro-Project.srcs/sources_1/top_level.vhd)
    - The top_level module connects the timer, display driver, and debounced button inputs into one functional system. It manages the flow of signals between the Pomodoro timer core, the BinTo7seg display converter, and user operated buttons. The top module prepares the outputs for LEDs and the 7-segment display, creating a working timer system.

### Top level diagram
![Toplevel diagram](images/diagram.jpg "Top level diagram")

### Component(s) simulations

**TBD MARTINE RIIGHT**

## References

- https://en.wikipedia.org/wiki/Pomodoro_Technique
- https://pomofocus.io/
- https://github.com/tomas-fryza/vhdl-labs