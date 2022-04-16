# EE 417 Final Project Spring 2022 - QAM Demapper
  Project Participants: Zach Martin, Saunders Riley

## Functional Description
  The purpose of this FPGA Module is to convert a 16QAM input as signed 8-bit I and Q data into a serial data stream. This project is for the De-mapping portion of a QAM demodulator, which assumes the RF front-end, filtering, PLL, and ADC conversion is handled by external hardware and logic. Furthermore, this de-mapping module will perform the function of a hard decision demodulator with no error correction.  This module will function by mapping sections of the phasor constellation diagram to particular symbols in the QAM scheme. The image below depicts the symbol locations in a 16-QAM constellation diagram. In researching this project, it appears that there are several schemes for QAM constellations, so one was chosen arbitrarily.

## Input/Output Definitions
  PORT NAME   |   TYPE    |   DESCRIPTION
  ------------|-----------|--------------
  **Controller Ports**
  ENABLE      |   INPUT   |   Enables the module: if LOW, QAM input discarded, ignored if module is in shift out cycle
  RESET       |   INPUT   |   Resets the controller FSM and clears the output register
  CALIBRATE   |   INPUT   |   Sets the I and Q offsets while a known symbol is being transmitted
  **Datapath Ports**
  I_IN        |   IN[7:0] |   I input from IQ demodulator (8 bit signed)
  Q_IN        |   IN[7:0] |   Q input from IQ demodulator (8 bit signed)
  I_OFFSET    |   IN[7:0] |   I offset (8 bit signed)
  Q_OFFSET    |   IN[7:0] |   Q offset (8 bit signed)
  SCLK        |   INPUT   |   Symbol Clock
  DCLK        |   INPUT   |   Shift Register Clock
  DATA_OUT    |   OUTPUT  |   Serial Data Output
  RESET       |   INPUT   |   Reset (same as above)
  
## Block Diagrams
  (Uploaded Separately)
