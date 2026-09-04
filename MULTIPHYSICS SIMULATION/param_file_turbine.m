%% Turbine Simulation Parameters
clear; clc;

%% Parameters
param = struct();

%% Fluid
param.rho = 870;          % density [kg/m^3]
param.mu  = 0.03;         % dynamic viscosity [Pa*s]

%% Rotor / friction parameters
param.J = 1e-9;           % inertia [kg*m^2]

param.R_in = 0.01;        % inlet radius where jet hits rotor [m]
param.R = 0.015;          % rotor radius [m]
param.c = 50e-6;          % clearance [m]

param.L = 0.01;           % rotor wetted length [m]
param.A_surf = 2*pi*param.R*param.L;  
                          % wetted surface area [m^2]

%% Nozzle / inlet orifice
param.N = 3;              % number of nozzles

param.A_rhombus = 36.5e-6;   % total nozzle area [m^2]

param.A_in = param.A_rhombus/param.N;   % area of one nozzle [m^2]

param.A_axial = 6.2072e-05;     % total nozzle area [m^2]

param.Cd_in = 0.61;       % inlet discharge coefficient

%% Center PWM section pressure drop
param.k_center = 1.45e-6; % center section coefficient
param.D = 1e-3;           % center section diameter [m]
param.m = 1.91;           % flow exponent
param.n = 3.22;           % diameter exponent

%% Input flow
%param.Q0 = 2e-5;          % flow rate [m^3/s]
                          % 2e-5 m^3/s = 1.2 L/min

%% Simulation time
param.Tstop = 5;          % simulation time [s]

%% Numerical protection
param.eps_val = 1e-12;

%% Fixed volume parameters
param.beta = 1.8e9;      % bulk modulus [Pa]
param.V = 10e-6;         % fixed volume [m^3]
% param.P0 = 1e5;          % initial pressure [Pa]

%% Pressure rails
param.P_M = 3.447e6;      % 500 psi
param.P_H = 10.342e6;     % 1500 psi