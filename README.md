# Summary

This project contains the estimator and controller for the canards that will fly on the 2025 rocket, Aurora. 
Additionally, it contains a 6DOF rocket plant model designed to enable closed loop simulation, including sensor dynamics. 
There are a number of setup and support scripts for the main model (such as evaluating the Barrowman equations from input geometry). 

Ideally, setting the rocket to simulate should be as easy as changing the first line in `configure_plant_model.m` to run the appropriate script. 
It probably isn't, so at that point you should ask someone for help.

# How to use

## Running the Sim 

0. run Simulinkcanards.prj (if the folders and subfolders are not yet added to your path)

#### Option A 
1. open the `CC_Flight_Simulation.slx` in the `plant-model` folder \
   a. Open as model and project \
   b. Click on "continue" in the pop-up window   

2. run `configure_plant_model`
3. When everything has loaded and simulink is open, click the big green start button in center of the top header
4. Plot access: scope blocks in subsystems `/visualization_estimator`, or `/plant_combined/visualization_sim`

#### Option B
1. run `sim_call` (in `monte-carlo/`) to simulate a single sim and plot

#### Option C
1. configure a batch run by editing `sim_call_sweep` (in `monte-carlo/`)
2. run `sim_call_sweep` to simulate a batch of sims
3. (edit and) run `plot_sweep` to plot results 

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


# Documentation
Most up to date internal documentation is [here](https://www.overleaf.com/project/67239de67b73b702d3233692). \
A backup is on the `documentation` [branch](https://github.com/FinnBreu/WR-Controller-and-Estimator-Design/tree/main).
