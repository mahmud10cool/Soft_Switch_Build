clc; clear; close all;

T_sim = 0.5;

soft_sim = sim("comparison_with_practice.slx");
t_soft = soft_sim.tout;
input_energy = soft_sim.Input_Energy.Data;
hyd_in_energy = soft_sim.Hydraulic_Input.Data;
output_energy = soft_sim.Output_Energy.Data;
pump_loss = soft_sim.Pump_Losses.Data;
regen = soft_sim.Regen.Data;
kinetic_energy = soft_sim.Kinetic_Energy.Data;
elec_loss = soft_sim.Elec_Losses.Data;
throttling_loss = soft_sim.Throttling_Loss.Data;
work = soft_sim.Work.Data;
stored_energy = soft_sim.Stored_Energy.Data;
prv_open = soft_sim.PRV_Opening.Data;
ssv_open = soft_sim.SSV_Opening.Data;
Px_chamber = soft_sim.Px.Data;
Pdesired = soft_sim.Pdes.Data;
omega_rot = soft_sim.omega.Data;
regen_torque = soft_sim.regen_torque.Data;

%% Plots
figure(1)

subplot(5,1,1)
yyaxis left
h_left = plot(t_soft, Px_chamber, 'b-', ...
              t_soft, Pdesired, 'c-', ...
              'LineWidth', 2);
ylabel('Pressure (Pa)')
all_handles = [h_left(:)];
labels = {'Chamber', 'Desired'};
legend(all_handles, labels, 'Location', 'best')
grid on
hold off

subplot(5,1,2)
h_left_2 = plot(t_soft, omega_rot, 'b-', 'LineWidth', 2);
ylabel('Rotational Speed (rads^{-1})')
yyaxis right
h_right_2 = plot(t_soft, regen_torque, 'r-', 'LineWidth', 2);
ylabel('Torque (Nm)')
all_handles_2 = [h_left_2(:), h_right_2(:)];
labels = {'Speed', 'Torque'};
legend(all_handles_2, labels, 'Location', 'best')
grid on
hold off

subplot(5,1,3)
hold on
h_left = plot(t_soft, input_energy, 'b-', ...
              'LineWidth', 2);
ylabel('Input Energy (J)')
all_handles = [h_left(:)];
labels = {'Soft-Switch'};
legend(all_handles, labels, 'Location', 'best')

% xlabel('Time (s)')
grid on
% title('Input Energy vs. Time')
hold off

% Subplot 4: Throttling Loss
subplot(5,1,4)
hold on


h_left = plot(t_soft, throttling_loss, 'b-', ...
              t_soft, -regen, 'g-', ...
              t_soft, (pump_loss+elec_loss), 'm-', ...
              'LineWidth', 2);
ylabel('Throttling Loss (J)')
all_handles = [h_left(:)];
% labels = {'Soft-Switch', 'Normal','Kinetic Energy'};
labels = {'Soft-Switch','Regen', 'Pump + Motor Losses'};
legend(all_handles, labels, 'Location', 'best')

grid on
hold off

subplot(5,1,5)
h_right = plot(t_soft, prv_open, 'k-', ...
               t_soft, ssv_open, 'k--', ...
               'LineWidth', 2);
ylabel('Valve Position')

ylim([min(prv_open) 1.2*max(prv_open)])

all_handles = [h_right(:)];
labels = {'PSV', 'SSV'};
legend(all_handles, labels, 'Location', 'best')

grid on
xlabel('Time (s)')

sgtitle('Soft-Switch vs. Normal System Energy Comparison for Two Switches', ...
        'FontSize', 14, ...
        'FontWeight', 'bold')

% Format all axes
all_axes = findall(gcf, 'Type', 'axes');
set(all_axes, ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'LineWidth', 1.2);

% Format all legends
all_legends = findall(gcf, 'Type', 'legend');
set(all_legends, ...
    'FontSize', 10, ...
    'FontWeight', 'bold');

x0 = 50;
y0 = 50;
width = 900;
height = 900;
set(gcf,'position',[x0,y0,width,height])

saveas(gcf, 'parameters_vs_time.png')


