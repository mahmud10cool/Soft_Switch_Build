clc;
clear;
close all;

%% ========================================================================
%  SIMULATION
%  ========================================================================

T_sim = 1.2;

soft_sim = sim("simulation.slx");

t_soft = soft_sim.tout * 1e3;   % ms

input_energy   = soft_sim.Input_Energy.Data;
hyd_in_energy  = soft_sim.Hydraulic_Input.Data;
output_energy  = soft_sim.Output_Energy.Data;

pump_loss       = soft_sim.Pump_Losses.Data;
regen_sim       = soft_sim.Regen.Data;
kinetic_energy  = soft_sim.Kinetic_Energy.Data;
elec_loss       = soft_sim.Elec_Losses.Data;
throttling_loss = soft_sim.Throttling_Loss.Data;

work          = soft_sim.Work.Data;
stored_energy = soft_sim.Stored_Energy.Data;

prv_open = soft_sim.PRV_Opening.Data;
ssv_open = soft_sim.SSV_Opening.Data;

Px_chamber_sim = soft_sim.Px.Data;
Pdesired       = soft_sim.Pdes.Data;
omega_rot_sim  = soft_sim.omega.Data;
regen_torque_sim = soft_sim.regen_torque.Data;


%% Simulation friction calculation

coeff_data = load('coeff_pressure_data.mat');
coeff_pressure_data = coeff_data.coeff_pressure_data;

pressure_sim = 0.000145038 * Px_chamber_sim(:).';       % psi
speed_sim    = (60/(2*pi)) * omega_rot_sim(:).';        % rpm

p_final_sim = [pressure_sim.^3;
               pressure_sim.^2;
               pressure_sim;
               ones(size(pressure_sim))];

w_final_sim = [speed_sim.^3;
               speed_sim.^2;
               speed_sim;
               ones(size(speed_sim))];

friction_sim = sum((coeff_pressure_data * p_final_sim) .* w_final_sim, 1);
friction_sim = friction_sim.';


%% ========================================================================
%  EXPERIMENTAL DATA
%  ========================================================================

% -------------------------------------------------------------------------
% Current / torque dataset
% -------------------------------------------------------------------------

exp_current_data = load('test_15_500RPM_current.mat');

some_data_current = exp_current_data.some_data;
t_current_raw     = exp_current_data.t;

fc = 100;
fs = 1000;

[b,a] = butter(2,fc/(fs/2));

no_of_sensors = 3;
sampling_time = 1;
kwte = 15000;

speed_turn   = 3;
torque_turn  = 1;
current_turn = 2;

x = some_data_current(speed_turn:no_of_sensors:kwte);
y = some_data_current(torque_turn:no_of_sensors:kwte);
z = some_data_current(current_turn:no_of_sensors:kwte);

if isnan(y(1))
    y(1) = 0;
end

t_x = t_current_raw(speed_turn:no_of_sensors:kwte);
t_y = t_current_raw(torque_turn:no_of_sensors:kwte);
t_z = t_current_raw(current_turn:no_of_sensors:kwte);

t_speed_exp = sampling_time/no_of_sensors * (t_x-speed_turn);
speed_exp = filtfilt(b,a,(0.78125*x - 1600));

t_torque_exp = sampling_time/no_of_sensors * (t_y-torque_turn);
torque_exp = 0.0032226562 * filtfilt(b,a,y);

t_current_exp = sampling_time/no_of_sensors * (t_z-current_turn);
current_exp = 109e-3 * (0.0048828126*filtfilt(b,a,z) - 10.7);


% -------------------------------------------------------------------------
% Pressure / speed dataset
% -------------------------------------------------------------------------

exp_pressure_data = load('test_15_500RPM.mat');

some_data_pressure = exp_pressure_data.some_data;
t_pressure_raw     = exp_pressure_data.t;

fc_pressure = 100;
fc_speed    = 50;
fc_current  = 100;
fs = 1000;

[b_pressure,a_pressure] = butter(2,fc_pressure/(fs/2));
[b_speed,a_speed]       = butter(2,fc_speed/(fs/2));
[b_current,a_current]   = butter(2,fc_current/(fs/2));

no_of_sensors_ = 3;
sampling_time_ = 1;
kwte_ = 15000;

speed_turn_    = 3;
current_turn_  = 1;
pressure_turn_ = 2;

x_ = some_data_pressure(speed_turn_:no_of_sensors_:kwte_);
y_ = some_data_pressure(current_turn_:no_of_sensors_:kwte_);
z_ = some_data_pressure(pressure_turn_:no_of_sensors_:kwte_);

if isnan(y_(1))
    y_(1) = 0;
end

t_x_ = t_pressure_raw(speed_turn_:no_of_sensors_:kwte_);
t_y_ = t_pressure_raw(current_turn_:no_of_sensors_:kwte_);
t_z_ = t_pressure_raw(pressure_turn_:no_of_sensors_:kwte_);

t_speed_exp_ = sampling_time_/no_of_sensors_ * (t_x_-speed_turn_);
speed_exp_ = filtfilt(b_speed,a_speed,(0.78125*x_ - 1600));

pressure_exp = 1.6113281 * filtfilt(b_pressure,a_pressure,z_);
t_pressure_exp = sampling_time_/no_of_sensors_ * (t_z_-pressure_turn_);

t_torque_exp_ = sampling_time_/no_of_sensors_ * (t_y_-current_turn_);
torque_exp_ = 0.0032226562 * filtfilt(b_current,a_current,y_);


%% Experimental friction calculation

pressure_for_friction = pressure_exp(:).';
speed_for_friction    = speed_exp(:).';

p_final_exp = [pressure_for_friction.^3;
               pressure_for_friction.^2;
               pressure_for_friction;
               ones(size(pressure_for_friction))];

w_final_exp = [speed_for_friction.^3;
               speed_for_friction.^2;
               speed_for_friction;
               ones(size(speed_for_friction))];

friction_exp = sum((coeff_pressure_data * p_final_exp) .* w_final_exp, 1);


%% Experimental frictionless torque

friction_index = 1850:3050;

t_friction = t_speed_exp_(friction_index);

torque_fric_1 = current_exp(friction_index(1:175)) ...
              - friction_exp(friction_index(1:175));
torque_fric_1 = torque_fric_1 - mean(torque_fric_1);

torque_fric_2 = current_exp(friction_index(176:261)) ...
              - friction_exp(friction_index(176:261)) - 0.2;

torque_fric_3 = current_exp(friction_index(262:322)) ...
              - friction_exp(friction_index(262:322)) - 0.1;

torque_fric_4 = current_exp(friction_index(323:763)) ...
              - friction_exp(friction_index(323:763));
torque_fric_4 = torque_fric_4 - mean(torque_fric_4);
torque_fric_4 = torque_fric_4 + 0.015;

torque_fric_5 = current_exp(friction_index(764:906)) ...
              - friction_exp(friction_index(764:906));

torque_fric_6 = current_exp(friction_index(907:end)) ...
              - friction_exp(friction_index(907:end));
torque_fric_6 = torque_fric_6 - mean(torque_fric_6);

torque_fric = [torque_fric_1, ...
               torque_fric_2, ...
               torque_fric_3, ...
               torque_fric_4, ...
               torque_fric_5, ...
               torque_fric_6];


%% ========================================================================
%  SIDE-BY-SIDE COMPARISON
%  Left column  = Simulation
%  Right column = Experiment
%  ========================================================================

comparison_fig = figure(1);
set(comparison_fig,'Position',[50 50 1600 1200]);

tl = tiledlayout(6,2,'TileSpacing','compact','Padding','compact');


% -------------------------------------------------------------------------
% Row 1 - Pressure
% -------------------------------------------------------------------------

nexttile(1)
plot(t_soft, pressure_sim, 'LineWidth', 2);
ylabel('Pressure (PSI)')
title('Simulation Results','FontWeight','bold')
grid on

nexttile(2)
plot(t_pressure_exp(friction_index)-t_friction(1), ...
     pressure_exp(friction_index)+100, ...
     'LineWidth',2);
ylabel('Pressure (PSI)')
title('Experimental Results','FontWeight','bold')
grid on


% -------------------------------------------------------------------------
% Row 2 - Speed
% -------------------------------------------------------------------------

nexttile(3)
plot(t_soft, speed_sim, 'LineWidth', 2);
ylabel('Speed (RPM)')
grid on

nexttile(4)
speed_fric = speed_exp_(friction_index);
plot(t_speed_exp_(friction_index)-t_friction(1), ...
     speed_fric, ...
     'LineWidth',2);
ylabel('Speed (RPM)')
grid on


% -------------------------------------------------------------------------
% Row 3 - Torque including friction
% -------------------------------------------------------------------------

nexttile(5)
plot(t_soft, regen_torque_sim + friction_sim, 'LineWidth', 2);
ylabel('Torque (Nm)')
grid on

nexttile(6)
plot(t_current_exp(friction_index)-t_friction(1), ...
     current_exp(friction_index), ...
     'LineWidth',2);
ylabel('Torque (Nm)')
grid on


% -------------------------------------------------------------------------
% Row 4 - Frictionless torque
% -------------------------------------------------------------------------

nexttile(7)
plot(t_soft, regen_torque_sim, 'LineWidth', 2);
ylabel('FL Torque (Nm)')
grid on

nexttile(8)
plot(t_current_exp(friction_index)-t_friction(1), ...
     torque_fric, ...
     'LineWidth',2);
ylabel('FL Torque (Nm)')
grid on


% -------------------------------------------------------------------------
% Row 5 - Power
% -------------------------------------------------------------------------

power_sim = regen_torque_sim .* omega_rot_sim;

nexttile(9)
plot(t_soft, power_sim, 'LineWidth',2);
ylabel('Power (W)')
grid on

power_fric = (speed_fric*((2*pi)/60)) .* torque_fric;

nexttile(10)
plot(t_pressure_exp(friction_index)-t_friction(1), ...
     power_fric, ...
     'LineWidth',2);
ylabel('Power (W)')
grid on


% -------------------------------------------------------------------------
% Row 6 - Energy
% -------------------------------------------------------------------------

nexttile(11)
plot(t_soft, regen_sim, 'LineWidth',2);
ylabel('Energy (J)')
xlabel('Time (ms)')
text(0.40*max(t_soft), ...
     min(regen_sim), ...
     ['Energy Saved = ',num2str(regen_sim(end)),' J'], ...
     'Color','black', ...
     'FontSize',10, ...
     'FontWeight','bold');
grid on

energy_fric = cumsum(power_fric*1e-3);
t_energy = t_pressure_exp(friction_index)-t_friction(1);

nexttile(12)
plot(t_energy, energy_fric, 'LineWidth',2);
ylabel('Energy (J)')
xlabel('Time (ms)')
text(0.40*max(t_energy), ...
     min(energy_fric), ...
     ['Energy Saved = ',num2str(energy_fric(end)),' J'], ...
     'Color','black', ...
     'FontSize',10, ...
     'FontWeight','bold');
grid on


%% Figure formatting

title(tl,'Simulation vs Experimental Results', ...
      'FontName','Arial', ...
      'FontSize',15, ...
      'FontWeight','bold');

set(findobj(comparison_fig,'Type','axes'), ...
    'FontName','Arial', ...
    'FontSize',11, ...
    'FontWeight','bold', ...
    'LineWidth',1.5);

exportgraphics(comparison_fig, ...
               'simulation_vs_experiment.png', ...
               'Resolution',300);


%% ========================================================================
%  VALVE TIMING
%  ========================================================================

figure(2)

h_right = plot(t_soft, prv_open, 'k-', ...
               t_soft, ssv_open, 'k--', ...
               'LineWidth',2);

ylabel('Valve Position')
xlabel('Time (ms)')

ylim([min(prv_open) 1.2*max(prv_open)])

labels = {'PSV','SSV'};
legend(h_right(:),labels,'Location','best')

grid on

set(gca, ...
    'FontName','Arial', ...
    'FontSize',12, ...
    'FontWeight','bold', ...
    'LineWidth',2);
