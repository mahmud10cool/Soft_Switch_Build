%% Run Simple Turbine Model over Several Flow Rates
clear; clc; close all;

%% Load parameters
param_file_turbine;

%% Model name
modelName = "rahcel_pump_vs_pd_pump";

%% Simulation time
Tstop = 1;

%% Flow rates to test
% Units: [m^3/s]
Q_vec = [2]*1e-5;

% Convert to L/min for legend
Q_Lmin = Q_vec*60000;

%% Plot instantaneous efficiency
figure;
hold on;
grid on;

for i = 1:length(Q_vec)

    %% Set flow rate
    param.Q0 = Q_vec(i);

    %% Run simulation
    out = sim(modelName, "StopTime", num2str(Tstop));

    omega_ts = out.omega.Data; 
    tau_turbine_ts = out.tau_turbine.Data; 
    tau_friction_ts = out.friction.Data; 
    DeltaP_total_ts = out.DeltaP_total.Data; 
    DeltaP_inlet_ts = out.DeltaP_inlet.Data; 
    DeltaP_center_ts = out.DeltaP_center.Data;

    %% Extract data
    t = out.tout;

    hydraulic_power  = out.hydraulic_power.Data;
    mechanical_power = out.mechanical_power.Data;
    friction_power   = out.friction_power.Data;

    %% Net mechanical power
    net_mech_power = mechanical_power - friction_power;

    %% Instantaneous efficiency
    efficiency = net_mech_power ./ hydraulic_power;

    %% Clean bad values
    efficiency(hydraulic_power < 1e-12) = 0;
    efficiency(~isfinite(efficiency)) = 0;

    %% Plot
    % plot(t, efficiency*100, ...
    %     "LineWidth", 2, ...
    %     "DisplayName", sprintf("Q = %.4g L/min", Q_Lmin(i)));
    plot(t, hydraulic_power, t, net_mech_power, LineWidth=2)

end

hold off;

xlabel("Time [s]");
ylabel("Power [W]");
title("Power vs. Time");
% legend("Location", "best");