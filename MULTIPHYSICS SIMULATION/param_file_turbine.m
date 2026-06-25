%% Turbine Simulation Parameters
clear; clc;

%% Parameters
param = struct();

%% Fluid
param.rho = 870;          % density [kg/m^3]
param.mu  = 0.03;         % dynamic viscosity [Pa*s]

%% Rotor / friction parameters
param.R = 0.015;          % rotor radius [m]
param.c = 50e-6;          % clearance [m]
param.A_surf = 2*pi*param.R*0.01;  % wetted surface area [m^2]

param.J = 1e-5;           % inertia [kg*m^2]

%% Inlet orifice
param.Cd_in = 0.65;
param.A_in = 1e-6;        % inlet flow area [m^2]

%% Center section pressure drop
param.k_center = 1e-12;   % empirical coefficient
param.D_center = 1e-3;    % hydraulic diameter [m]
param.m_center = 2;       % flow exponent
param.n_center = 4;       % diameter exponent

%% Turbine section pressure drop
param.k_DP_turb = 1e11;   % empirical coefficient [Pa/(m^3/s)^2]

%% Outlet orifice
param.Cd_out = 0.65;
param.A_out = 1e-6;       % outlet flow area [m^2]

%% Turbine torque coefficient
% tau_turb = k_tau * Q^2
param.k_tau = 5e6;        % [N*m/(m^3/s)^2]

%% Input flow
param.Q0 = 2e-5;          % flow rate [m^3/s]
                          % 2e-5 m^3/s = 1.2 L/min

%% Load torque
param.tau_load = 0.02;    % useful load torque [N*m]
