
clc;
clear;
close all;

%% ========================================================================
% SIMULATION
% ========================================================================

T_sim = 1.2;

soft_sim = sim("simulation.slx");

t_soft = soft_sim.tout(:) * 1e3;   % ms

regen_sim        = soft_sim.Regen.Data(:);
Px_chamber_sim   = soft_sim.Px.Data(:);
omega_rot_sim    = soft_sim.omega.Data(:);
regen_torque_sim = soft_sim.regen_torque.Data(:);

prv_open = soft_sim.PRV_Opening.Data(:);
ssv_open = soft_sim.SSV_Opening.Data(:);

%% ========================================================================
% FRICTION CALCULATION
% ========================================================================

coeff_data = load('coeff_pressure_data.mat');
coeff_pressure_data = coeff_data.coeff_pressure_data;

pressure_sim = 0.000145038 * Px_chamber_sim;  % PSI
speed_sim = (60/(2*pi)) * omega_rot_sim;       % RPM

p_final_sim = [pressure_sim.'.^3;
               pressure_sim.'.^2;
               pressure_sim.';
               ones(1,length(pressure_sim))];

w_final_sim = [speed_sim.'.^3;
               speed_sim.'.^2;
               speed_sim.';
               ones(1,length(speed_sim))];

friction_sim = sum((coeff_pressure_data * p_final_sim) ...
                   .* w_final_sim, 1).';

%% ========================================================================
% POWER CALCULATION
% ========================================================================

power_sim = regen_torque_sim .* omega_rot_sim;

%% ========================================================================
% SIMULATION PLOTS
% ========================================================================

sim_fig = figure(1);
set(sim_fig,'Position',[100 50 1000 1500],'Color','white');

tl = tiledlayout(6,1, ...
    'TileSpacing','compact', ...
    'Padding','compact');

sim_color = [0.85 0.10 0.10];
line_width = 2;

% Row 1 - Pressure
ax1 = nexttile;
plot(t_soft, pressure_sim, ...
    'Color',sim_color,'LineWidth',line_width);
ylabel('Pressure (PSI)')
grid on

% Row 2 - Speed
ax2 = nexttile;
plot(t_soft, speed_sim, ...
    'Color',sim_color,'LineWidth',line_width);
ylabel('Speed (RPM)')
grid on

% Row 3 - Torque including friction
ax3 = nexttile;
plot(t_soft, regen_torque_sim + friction_sim, ...
    'Color',sim_color,'LineWidth',line_width);
ylabel('Torque (Nm)')
grid on

% Row 4 - Frictionless torque
ax4 = nexttile;
plot(t_soft, regen_torque_sim, ...
    'Color',sim_color,'LineWidth',line_width);
ylabel('FL Torque (Nm)')
grid on

% Row 5 - Power
ax5 = nexttile;
plot(t_soft, power_sim, ...
    'Color',sim_color,'LineWidth',line_width);
ylabel('Power (W)')
grid on

% Row 6 - Energy
ax6 = nexttile;
plot(t_soft, regen_sim, ...
    'Color',sim_color,'LineWidth',line_width);
ylabel('Energy (J)')
xlabel('Time (ms)')
grid on

text(0.70*max(t_soft), ...
     min(regen_sim)+0.25*abs(min(regen_sim)), ...
     ['Energy Saved = ',num2str(regen_sim(end),'%.2f'),' J'], ...
     'Color','black', ...
     'FontSize',12, ...
     'FontWeight','bold');

%% ========================================================================
% FIGURE FORMATTING
% ========================================================================

ax = [ax1 ax2 ax3 ax4 ax5 ax6];

set(ax, ...
    'FontName','Arial', ...
    'FontSize',14, ...
    'FontWeight','bold', ...
    'LineWidth',1.5, ...
    'Color','white');

linkaxes(ax,'x');

txt = findall(sim_fig,'Type','text');

set(txt, ...
    'FontName','Arial', ...
    'FontWeight','bold');

exportgraphics(sim_fig, ...
    'simulation_results.png', ...
    'Resolution',300, ...
    'BackgroundColor','white');

%% ========================================================================
% VALVE TIMING
% ========================================================================

valve_fig = figure(2);
set(valve_fig,'Position',[150 150 1000 400], ...
    'Color','white');

plot(t_soft, prv_open, 'k-', ...
     t_soft, ssv_open, 'k--', ...
     'LineWidth',2);

ylabel('Valve Position')
xlabel('Time (ms)')

legend({'PRV','SSV'},'Location','best')

grid on

set(gca, ...
    'FontName','Arial', ...
    'FontSize',14, ...
    'FontWeight','bold', ...
    'LineWidth',1.5);

exportgraphics(valve_fig, ...
    'simulation_valve_timing.png', ...
    'Resolution',300, ...
    'BackgroundColor','white');
