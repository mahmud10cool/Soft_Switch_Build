clc; clear; close;
load test_15_500RPM_current.mat

fc = 10;
fs = 1000;

[b,a] = butter(2,fc/(fs/2));

no_of_sensors = 3;

sampling_time = 1;

kwte = 90000;

speed_turn = 3;
torque_turn = 1;
current_turn = 2;

x = some_data(speed_turn:no_of_sensors:kwte);
y = some_data(torque_turn:no_of_sensors:kwte);
z = some_data(current_turn:no_of_sensors:kwte);

if isnan(y(1))
    y(1) = 0;
end

t_x = t(speed_turn:no_of_sensors:kwte);
t_y = t(torque_turn:no_of_sensors:kwte);
t_z = t(current_turn:no_of_sensors:kwte);


figure(1)

% subplot(3,1,1)
% subplot(2,1,1)
t_speed = sampling_time/no_of_sensors*(t_x-speed_turn);
speed = filtfilt(b,a,(0.78125*x - 1600));
% plot(1e-3*t_speed, speed,LineWidth=2)
% title('Speed from ESCON')
% ylabel('Speed (RPM)')
% xlabel('Time (s)')
% grid on
% 
% % subplot(3,1,2)
% subplot(2,1,2)
% hold on
t_torque = sampling_time/no_of_sensors*(t_y-torque_turn);
torque = 0.0032226562*filtfilt(b,a,y);
% plot(1e-3*t_torque,torque,LineWidth=2)
% % title('Torque from Sensor')
% xlabel('Time (s)')
% ylabel('Torque (Nm)')
% grid on
% % xlim([10 25])

% subplot(3,1,3)
t_current = sampling_time/no_of_sensors*(t_z-current_turn);
current = 109e-3*(0.0048828126*filtfilt(b,a,z) - 10.7);
plot(t_current,current,LineWidth=2)
ylabel('Torque (Nm)')
xlabel('Time (s)')
% title('Torque from torque')
grid on
% xlim([10 25])

% legend('From Sensor', 'From torque')
some_fig = gcf;

sgtitle('Actual Experiment','FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2)
set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2);

set(some_fig, 'position', [0, 0,900, 750])


disp('Click two points on the plot to define the friction index range.');
[friction_index, ~] = ginput(2); % Select two points (start and end)
friction_index = find(t_current >= friction_index(1) & t_current <= friction_index(2)); % Get indices in time array

%% Found the right thing

figure(2)
subplot(2,1,1)
t_f_speed = t_speed(friction_index);
t_speed_adjust = t_f_speed - t_f_speed(1);
plot(t_speed_adjust,speed(friction_index),LineWidth=2)
xlabel('Time (ms)')
ylabel('Speed (RPM)')
grid on
xlim([0 1100])

subplot(2,1,2)
hold on
t_f_torque = t_torque(friction_index);
t_torque_adjust = t_f_torque - t_f_torque(1);
plot(t_torque_adjust,torque(friction_index),LineWidth=2)
xlabel('Time (ms)')
ylabel('Torque (Nm)')
xlim([0 1100])

t_f_current = t_current(friction_index);
t_current_adjust = t_f_current - t_f_current(1);
plot(t_current_adjust,current(friction_index),LineWidth=2)
xlabel('Time (ms)')
ylabel('Torque (Nm)')
title('Desired Torque Range')
grid on
xlim([0 1100])

some_fig = gcf;

sgtitle('Experimental Results','FontName','Arial','FontSize',18,'FontWeight','Bold', 'LineWidth', 2)
set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2);

set(some_fig, 'position', [0, 0, 1920, 1080])
