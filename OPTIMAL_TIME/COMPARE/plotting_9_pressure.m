clc; clear; close;
load test_20_500RPM.mat

fc = 10;
fs = 1000;

[b,a] = butter(2,fc/(fs/2));

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

subplot(3,1,1)
t_speed = sampling_time/no_of_sensors*(t_x-speed_turn);
speed = filtfilt(b,a,(0.78125*x - 1600));
plot(t_speed, speed,LineWidth=2)
title('Speed from ESCON')
ylabel('Speed (RPM)')
xlabel('Time (ms)')
grid on
xlim([0 10000])

subplot(3,1,2)
t_torque = sampling_time/no_of_sensors*(t_y-current_turn);
% y = y(2:end);
% t_torque = t_torque(2:end);
plot(t_torque,0.0032226562*filtfilt(b,a,y),LineWidth=2)
title('Torque from Sensor')
xlabel('Time (s)')
ylabel('Torque (Nm)')
grid on
% xlim([10 25])
xlim([0 10000])

subplot(3,1,3)
plot(sampling_time/no_of_sensors*(t_z-pressure_turn),1.6113281*filtfilt(b,a,z),LineWidth=2)
ylabel('Pressure (PSI)')
xlabel('Time (s)')
title('Pressure')
grid on
% xlim([10 25])
xlim([0 10000])

some_fig = gcf;
set(findobj(some_fig,'type','axes'),"FontSize",15)


% disp('Click two points on the plot to define the friction index range.');
% [friction_index, ~] = ginput(2); % Select two points (start and end)
% friction_index = find(t_speed >= friction_index(1) & t_speed <= friction_index(2)); % Get indices in time array

% figure(2)
% plot(t_speed(friction_index),speed(friction_index),LineWidth=2)
% xlabel('Time (ms)')
% ylabel('Speed (RPM)')
% title('Desired Speed Range')
% grid on
% 
% some_fig_2 = gcf;
% set(findobj(some_fig_2,'type','axes'),"FontSize",15)