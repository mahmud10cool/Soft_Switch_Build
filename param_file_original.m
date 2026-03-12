param = struct();

% load coeff_pressure_data.mat
% load T_fric.mat
% 
% % Friction Information
% param.coeff_pressure_data = coeff_pressure_data;
% param.T_fric = I_vals;
% param.w_vals = w_vals;
% param.p_vals = p_vals;

% % Pressure Rails
param.P_T = 101325;
param.P_H = 10.342e6;
param.P_M = 3.447e6;
param.P_L = param.P_T;

% param.P_T = 101325;
% param.P_H = 10.342e6;
% param.P_M = 6.895e6;
% param.P_L = param.P_T;

% Pressure Rails
% param.P_T = 101325;
% param.P_H = 7e6;
% param.P_M = 3.5e6;
% param.P_L = param.P_T;

% Linear Actuator Chamber
param.V1_0 = 300e-6;
param.Acap = pi*(2.54)^2*1e-4;

% Intermediary volumes
param.V3_0 = 10e-6;
param.V4_0 = 10e-6;

% Fluid
param.beta = 1.8e9;
param.air = 0.5/100;
param.rho = 870;

% Valve
param.max_Avt = 4.9160e-06;
param.Cd = 0.6;
param.stroke = 5e-3;
param.leakage = 1e-16;

% Hoses
param.D_hose = 6.4;

% Valve Dynamics
% Soft Switch Valve
param.wn_ssv = 50*2*pi;
param.zeta_ssv = 1;

% Pressure Rail Valve
param.wn_prv = 50*2*pi;
param.zeta_prv = 1;
param.delay_switch = 10e-3;

% param.wn = 25*2*pi;
% param.zeta = 1;
% param.delay_switch = 10e-3;

% Hydraulic Pump/Motor
% param.J_hyd = 3000e-7;
% param.D = 0.8e-6;    % In cc/rev
% param.pump_mech_eff = 100*(1/100);
% param.pump_vol_eff = 100*(1/100);
% 
% % Electric Motor/Generator
% param.J_elec = 3060e-7;
% param.Kt = 109e-3;
% param.Kv = (87.6082*pi)/30; % In rads^-1/Volt
% param.elec_eff = 100*(1/100);
% param.max_mech_power = 90;

% % Hydraulic Pump/Motor
param.J_hyd = 3000e-7;
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
param.start_final_velocity = 600*(2*pi/60);
param.max_speed = 600*(2*pi/60);

% param.start_final_velocity = 0;
% param.max_speed = 0;

% param.start_final_velocity = 100;
% param.max_speed = 125;

% Damping
% param.damping = 5e-4; 
param.damping = 0; 

%% Initial Condition Stuff
% Initial pressure
param.P_initial = param.P_M;

% Initial Position for the pressure rail valve
param.initial_stroke = -param.stroke;

% Constant speed of electric motor
% param.rpm_speed = 1200;

%% Timing
param.big_delay = 30e-3;
param.regen_time = 150e-3;
param.between_switches = 400e-3;
param.first_time = param.between_switches/2;

% Final Time
final_time = 2*param.big_delay+2*param.regen_time+2*param.between_switches;

% Switching Time
param.T_period = final_time;

param.delay = 0;
