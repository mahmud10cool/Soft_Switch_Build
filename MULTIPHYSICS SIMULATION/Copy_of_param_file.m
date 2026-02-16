param = struct();

% Pressure Rails
param.P_T = 101325;
param.P_H = 10.342e6;
param.P_M = 3.447e6;
param.P_L = param.P_T;

% Linear Actuator Chamber
param.V1_0 = 250e-6;
param.Acap = pi*(2.54)^2*1e-4;

% Intermediary volumes
param.V3_0 = 10e-6;
param.V4_0 = 10e-6;

% Fluid
param.beta = 1.8e9;
param.air = 0;
param.rho = 870;

% Valve
param.max_Avt = 4.9160e-06;
param.Cd = 0.6;
param.stroke = 5e-3;

% Valve Dynamics
param.wn = 50*2*pi;
param.zeta = 1;

% Hydraulic Pump/Motor
param.J_hyd = 3000e-7;
param.D = 0.8e-6;    % In cc/rev
param.pump_mech_eff = 93*(1/100);
param.pump_vol_eff = 95*(1/100);

% Electric Motor/Generator
param.J_elec = 3060e-7;
param.Kt = 109e-3;
param.Kv = (87.6082*pi)/30; % In rads^-1/Volt
param.elec_eff = 93*(1/100);
param.max_mech_power = 90;

% Initial speed
param.start_final_velocity = 0;
% param.max_speed = 1200*(2*pi/60);

% Damping
param.damping = 5e-4; 

%% Initial Condition Stuff
% Initial pressure
param.P_initial = param.P_M;

% Delay
param.delay = 0.2;

% Initial Position for the pressure rail valve
param.initial_stroke = -param.stroke;
