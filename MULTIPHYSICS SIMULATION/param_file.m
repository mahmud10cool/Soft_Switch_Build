param = struct();

% Switching Time
param.T_period = 0.4;

% Pressure Rails
param.P_T = 101325;
param.P_H = 10.342e6;
param.P_M = 3.447e6;
param.P_L = param.P_T;

% Linear Actuator Chamber
param.V1_0 = 150e-6;
param.Acap = pi*(2.54)^2*1e-4;

% Intermediary volumes
% param.V3_0 = 20e-6;
% param.V4_0 = 20e-6;
% param.V5_0 = 20e-6;
% param.V6_0 = 20e-6;

% Hose parameters
param.D_hose = 6.4e-3;
param.L_hose = 0.6;
param.mu = 0.04;
param.ResistHose = 0.01*128*param.mu*param.L_hose/(pi*param.D_hose^4);

% Hose volumes
param.VA_0 = 0.25*pi*param.D_hose^2*param.L_hose;
param.VB_0 = 0.25*pi*param.D_hose^2*param.L_hose;
param.VP_0 = 0.25*pi*param.D_hose^2*param.L_hose;
param.VT_0 = 0.25*pi*param.D_hose^2*param.L_hose;

% Fluid
param.beta = 1.8e9;
param.air = 0.5/100;
param.rho = 870;

% Valve
param.max_Avt = 4.9160e-06;
param.Cd = 0.6;
% param.stroke = 5e-3;
param.stroke = 1;
param.wn = 1000;
param.zeta = 1;
param.delay_switch = 10e-3;

% Hydraulic Pump/Motor
param.J_hyd = 3000e-7;
param.D = 0.8e-6;    % In cc/rev

% Volumetric Efficiency Stuff
param.eta_v_nom = 0.99;  
param.omega_nom = 3000;      
param.dp_nom = 21e6;     

% Mechanical Efficiency Stuff
param.eta_m_nom = 0.99;
param.tau0 = 0.01;

% Electric Motor/Generator
param.J_elec = 3060e-7;
param.Kt = 109e-3;
param.Kv = (87.6082*pi)/30; % In rads^-1/Volt
param.B  = 1.16e-4;    % Nm*s/rad

% Damping
param.damping = 0;

% Plunger related parameters
param.plunger_mass = 1;   % In kg
param.Aplunger = pi*(2.54)^2*1e-4;

% Damping
param.damping = 5e-4; 

% Initial speed
param.start_final_velocity = 500*(2*pi/60);
% param.max_speed = 900*(2*pi/60);

% param.start_final_velocity = 100;
% param.max_speed = 125;

%% Initial Condition Stuff
% Initial pressure
param.P_initial = param.P_M;

% Delay
param.delay = 0;

% Initial Position for the pressure rail valve
param.initial_stroke = -param.stroke;

% Constant speed of electric motor
% param.rpm_speed = 1200;