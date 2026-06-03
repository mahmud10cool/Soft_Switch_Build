param = struct();

%% Simulation
param.T_period = 0.5;

%% Small Volume
param.Vy_0 = 20e-6;        % Initial chamber volume [m^3]

%% Pressure Rails
param.P_T = 101325;        % Tank pressure [Pa]
param.P_H = 10.342e6;      % Pressure rail 1 [Pa]
param.P_M = 3.447e6;       % Pressure rail 2 [Pa]

%% Fluid
param.beta = 1.8e9;        % Effective bulk modulus [Pa]
param.rho = 870;           % Fluid density [kg/m^3]
param.mu = 0.04;           % Dynamic viscosity [Pa.s]

%% Variable Chamber
param.Vx_0 = 150e-6;       % Initial chamber volume [m^3]
param.Ax = pi*(2.54)^2*1e-4; % Effective chamber area [m^2]

% Keep zero for fixed-volume chamber
param.xdot = 0;            % Chamber boundary velocity [m/s]
param.dVx = param.Ax*param.xdot;

%% PRV / Rail Selection Valve
param.max_Av = 4.9160e-6;  % Maximum valve opening area [m^2]
param.Cd = 0.6;            % Discharge coefficient
param.stroke = 1;          % Normalized valve stroke
param.wn = 500;            % Valve natural frequency [rad/s]
param.zeta = 1;            % Valve damping ratio
param.delay_switch = 10e-3;
param.valve_buffer = 0.01;
param.open_ratio = 1;

% Initial PRV position
% +1 means P1 connected
% -1 means P2 connected
%  0 means closed / center
param.initial_stroke = 0;

%% Turbine
param.At = 2.0e-5;         % Effective turbine flow area [m^2]
param.eta_t = 0.75;        % Turbine efficiency
param.omega_min = 10;      % Small speed value to avoid division by zero [rad/s]

%% Turbine / Shaft
param.At = 2.0e-5;              % Effective turbine flow area [m^2]
param.K_turbine = 1e-3;         % Torque per hydraulic power [Nm/W]
param.B_turbine = 0;            % Extra turbine damping [Nm.s/rad]

param.J_turbine = 3000e-7;      % Turbine inertia [kg.m^2]
param.J_elec = 3060e-7;         % Electric machine inertia [kg.m^2]
param.J_total = param.J_turbine + param.J_elec;

param.B_shaft = 1.16e-4;        % Shaft viscous damping [Nm.s/rad]
param.omega_initial = 0;        % Initial speed [rad/s]

%% Shaft / Electric Machine
param.J_turbine = 3000e-7; % Turbine rotor inertia [kg.m^2]
param.J_elec = 3060e-7;    % Electric machine inertia [kg.m^2]
param.J_total = param.J_turbine + param.J_elec;

param.Kt = 109e-3;         % Torque constant [Nm/A]
param.Kv = (87.6082*pi)/30; % Speed constant [rad/s/V]
% param.B = 1.16e-4;         % Viscous damping [Nm.s/rad]
param.B = 0;

%% Initial Conditions
param.P_initial = param.P_M;    % Initial chamber pressure [Pa]
param.omega_initial = 0;        % Initial turbine speed [rad/s]

%% Speed Limits
param.start_final_velocity = 600*(2*pi/60);
param.max_speed = 600*(2*pi/60);