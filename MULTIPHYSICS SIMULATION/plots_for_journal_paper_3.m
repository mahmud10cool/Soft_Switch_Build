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

normal_sim = sim("no_soft_switch_sim.slx");
t_norm = normal_sim.tout;
input_energy_norm = normal_sim.Input_Energy.Data;
output_energy_norm = normal_sim.Output_Energy.Data;
work_norm = normal_sim.Work.Data;
throttling_loss_norm = normal_sim.Throttling_Loss.Data;
prv_open_norm = normal_sim.PRV_Opening.Data;
Px_chamber_norm = normal_sim.Px.Data;

%% Plots
figure(1)

subplot(5,1,1)
yyaxis left
hold on
h_left = plot(t_soft, Px_chamber, 'b-', ...
              t_soft, Pdesired, 'c-', ...
              'LineWidth', 2);
h_left_norm = plot(t_norm, Px_chamber_norm, 'r-', ...
     'LineWidth', 2);
hold off
ylabel('Pressure (Pa)')


% yyaxis right
% h_right = plot(t_soft, prv_open, 'c--', ...
%                t_soft, ssv_open, 'm--', ...
%                'LineWidth', 2);
% ylabel('Valve Opening')
% 
% ylim([min(prv_open) 1.2*max(prv_open)])

all_handles = [h_left(:); h_left_norm(:)];
labels = {'Chamber', 'Desired', 'Normal'};
legend(all_handles, labels, 'Location', 'best')
% 
% xlabel('Time (s)')
grid on
% title('Pressure vs. Time')
hold off

subplot(5,1,2)
% yyaxis left
h_left_2 = plot(t_soft, omega_rot, 'b-', 'LineWidth', 2);
ylabel('Rotational Speed (rads^{-1})')

yyaxis right
h_right_2 = plot(t_soft, regen_torque, 'r-', 'LineWidth', 2);
ylabel('Torque (Nm)')
% 
all_handles_2 = [h_left_2(:), h_right_2(:)];
labels = {'Speed', 'Torque'};
legend(all_handles_2, labels, 'Location', 'best')

% xlabel('Time (s)')
grid on
% title('Speed and Torque vs. Time')
hold off

% Subplot 1: Input Energy
subplot(5,1,3)
hold on

% yyaxis left
h_left = plot(t_soft, input_energy, 'b-', ...
              t_norm, input_energy_norm, 'r-', ...
              'LineWidth', 2);
ylabel('Input Energy (J)')

ylim([min(input_energy_norm) 1.2*max(input_energy_norm)])

% yyaxis right
% h_right = plot(t_soft, prv_open, 'c--', ...
%                t_soft, ssv_open, 'm--', ...
%                'LineWidth', 2);
% ylabel('Valve Opening')
% 
% ylim([min(prv_open) 1.2*max(prv_open)])
% 
all_handles = [h_left(:)];
labels = {'Soft-Switch', 'Normal'};
legend(all_handles, labels, 'Location', 'best')

% xlabel('Time (s)')
grid on
% title('Input Energy vs. Time')
hold off

% Subplot 4: Throttling Loss
subplot(5,1,4)
hold on

% yyaxis left
% h_left = plot(t_soft, throttling_loss, 'b-', ...
%               t_norm, throttling_loss_norm, 'r-', ...
%               t_soft, kinetic_energy, 'g-', ...
%               'LineWidth', 2);
% ylabel('Throttling Loss (J)')

h_left = plot(t_soft, throttling_loss, 'b-', ...
              t_norm, throttling_loss_norm, 'r-', ...
              t_soft, -regen, 'g-', ...
              t_soft, (pump_loss+elec_loss), 'm-', ...
              'LineWidth', 2);
ylabel('Throttling Loss (J)')

ylim([min(throttling_loss_norm) 1.2*max(throttling_loss_norm)])
% 
% yyaxis right
% h_right = plot(t_soft, prv_open, 'c--', ...
%                t_soft, ssv_open, 'm--', ...
%                'LineWidth', 2);
% ylabel('Valve Opening')
% 
% ylim([min(prv_open) 1.2*max(prv_open)])

all_handles = [h_left(:)];
% labels = {'Soft-Switch', 'Normal','Kinetic Energy'};
labels = {'Soft-Switch', 'Normal','Regen', 'Pump + Motor Losses'};
legend(all_handles, labels, 'Location', 'best')

grid on
% title('Throttling Loss vs. Time')
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


