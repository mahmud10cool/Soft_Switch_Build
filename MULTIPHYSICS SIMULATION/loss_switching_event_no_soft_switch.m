clc; clear; close all;

T_sim = 0.25;

normal_sim = sim("no_soft_switch_sim.slx");

time = normal_sim.tout;
Px = normal_sim.Px.Data;
Pdes = normal_sim.Pdes.Data;
flow = normal_sim.valve_flow.Data;
throttling_power = normal_sim.throttling_power.Data;

%% Plots
figure(1)
subplot(211)
yyaxis left
plot(time, (Pdes-Px)*1e-6, 'b-', LineWidth=2); % Plot Px data
ylabel('Pressure Difference (MPa)');
ax = gca;
ax.YAxis(1).Color = 'b';
yyaxis right
plot(time, flow, 'r-', LineWidth=2);
ylabel('Flow (m^3s^{-1})')
xlabel('Time (s)')
xlim([0 7.3e-3])
ax.YAxis(2).Color = 'r';
grid on;

subplot(212)
plot(time, throttling_power*1e-3, 'g-', LineWidth=2);
ylabel('Power Loss (kW)')
xlabel('Time (s)')
xlim([0 7.3e-3])
grid on;


% Format all axes
all_axes = findall(gcf, 'Type', 'axes');
set(all_axes, ...
    'FontSize', 22, ...
    'FontWeight', 'bold', ...
    'LineWidth', 1.2);

% Format all legends
all_legends = findall(gcf, 'Type', 'legend');
set(all_legends, ...
    'FontSize', 18, ...
    'FontWeight', 'bold');
