clc; clear; close all;
load test_C_1000RPM.mat

fc_pressure = 100;
fc_speed = 50;
fc_current = 100;
fs = 1000;

[b_pressure,a_pressure] = butter(2,fc_pressure/(fs/2));
[b_speed,a_speed] = butter(2,fc_speed/(fs/2));
[b_current,a_current] = butter(2,fc_current/(fs/2));

no_of_sensors = 3;

sampling_time = 1;

kwte = 90000;

speed_turn = 3;
current_turn = 1;
pressure_turn = 2;

x = some_data(speed_turn:no_of_sensors:kwte);
y = some_data(current_turn:no_of_sensors:kwte);
z = some_data(pressure_turn:no_of_sensors:kwte);

if isnan(y(1))
    y(1) = 0;
end

t_x = t(speed_turn:no_of_sensors:kwte);
t_y = t(current_turn:no_of_sensors:kwte);
t_z = t(pressure_turn:no_of_sensors:kwte);

figure(1)

% subplot(3,1,1)
t_speed = sampling_time/no_of_sensors*(t_x-speed_turn);
speed = filtfilt(b_speed,a_speed,(0.78125*x - 1600));
% plot(t_speed, speed,LineWidth=2)
% title('Speed from ESCON')
% ylabel('Speed (RPM)')
% xlabel('Time (ms)')
% grid on
% xlim([0 10000])

% subplot(3,1,2)
t_torque = sampling_time/no_of_sensors*(t_y-current_turn);
torque = 109e-3*(0.0048828125*filtfilt(b_current,a_current,y) - 10);
% plot(t_torque,torque,LineWidth=2)
% title('Torque from Sensor')
% xlabel('Time (s)')
% ylabel('Torque (Nm)')
% grid on
% % xlim([10 25])
% xlim([0 10000])
% 
% subplot(3,1,3)
t_pressure = sampling_time/no_of_sensors*(t_z-pressure_turn);
pressure = 1.6113281*filtfilt(b_pressure,a_pressure,z);
plot(t_pressure,pressure,LineWidth=2)
ylabel('Pressure (PSI)')
xlabel('Time (s)')
title('Pressure')
grid on
% xlim([10 25])
xlim([0 10000])

some_fig = gcf;
set(findobj(some_fig,'type','axes'),"FontSize",15)

disp('Click two points on the plot to define the friction index range.');
[friction_index, ~] = ginput(2); % Select two points (start and end)
friction_index = find(t_pressure >= friction_index(1) & t_pressure <= friction_index(2)); % Get indices in time array

%% Desired Range
figure(2)
subplot(3,1,1)
t_f_pressure = t_pressure(friction_index);
t_pressure_adjust = t_f_pressure - t_f_pressure(1);
plot(t_pressure_adjust,pressure(friction_index),LineWidth=2)
xlabel('Time (ms)')
ylabel('Pressure (PSI)')
% xline(180,'-',{'SSV Switched to one side'},LineWidth=2);
% xline(210,'-',{'PRV Switched'},LineWidth=2);
% xline(270,'-',{'SSV Switched to the middle position'},LineWidth=2);
grid on
xlim([0 1100])

subplot(3,1,2)
t_f_speed = t_speed(friction_index);
t_speed_adjust = t_f_speed - t_f_speed(1);
plot(t_speed_adjust,speed(friction_index),LineWidth=2)
xlabel('Time (ms)')
ylabel('Speed (RPM)')
grid on
xlim([0 1100])

subplot(3,1,3)
hold on
t_f_torque = t_torque(friction_index);
t_torque_adjust = t_f_torque - t_f_torque(1);
plot(t_torque_adjust,torque(friction_index),LineWidth=2)
xlabel('Time (ms)')
ylabel('Torque (Nm)')
xlim([0 1100])
grid on


some_fig = gcf;

sgtitle('Experimental Results','FontName','Arial','FontSize',18,'FontWeight','Bold', 'LineWidth', 2)
set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2);

set(some_fig, 'position', [0, 0, 1920, 1080])
