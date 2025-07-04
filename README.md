# How to use
## Setup
1. Clone the repo `git clone https://github.com/waterloo-rocketry/simulink-canards.git`
2. Make sure you have MATLAB **2024b** installed (The specific version matters cause Simulink ;-;)
3. Install (do this with Matlab install when you can select multiple at once, if possible):
    - Simulink
    - Signal Processing Toolbox
    - DSP System Toolbox
    - Aerospace Toolbox
    - Aerospace Blockset
    - Control System Toolbox
    - Instrument Control Toolbox
    - MATLAB Support for MinGW-w64 C/C++/Fortran Compiler
4. In Matlab run `mex -setup C` and `mex -setup C++`

## Using the Sim
1. open the `CC_Flight_Simulation.slx` in the `plant-model` folder \
   a. Open as model and project \
   b. Click on "continue" in the pop-up window   
2. When everything has loaded and simulink is open, click the big green start button in center of the top header

# Documentation
Most up to date internal documentation is [here](https://www.overleaf.com/project/67239de67b73b702d3233692). \
A backup is on the `documentation` [branch](https://github.com/FinnBreu/WR-Controller-and-Estimator-Design/tree/main).

## Summary

This project contains the estimator and controller for the canards that will fly on the 2025 rocket, Aurora. Additionally, it contains a 6DOF rocket plant model designed to enable closed loop simulation (previously this has been done using [or-brake](https://github.com/waterloo-rocketry/or-airbrake-plugin)), including sensor dynamics. There are a number of setup and support scripts for the main model (such as evaluating the Barrowman equations from input geometry). 

Ideally, setting the rocket to simulate should be as easy as changing the first line in `configure_plant_model.m` to run the appropriate script. It probably isn't, so at that point you should ask someone for help

## Sample Plots
This is a quick plot of sim vs OpenRocket results for Borealis, as an example of what the plant model can do.

![.](/sample.png)
