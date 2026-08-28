clc; clear; close;
load coeff_pressure_data.mat
load test_5_800RPM.mat

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

subplot(3,1,1)
t_speed = sampling_time/no_of_sensors*(t_x-speed_turn);
speed = filtfilt(b_speed,a_speed,(0.78125*x - 1600));
plot(t_speed, speed,LineWidth=2)
title('Speed from ESCON')
ylabel('Speed (RPM)')
xlabel('Time (ms)')
grid on
xlim([0 10000])


subplot(3,1,3)
pressure = 1.6113281*filtfilt(b_pressure,a_pressure,z);
t_pressure = sampling_time/no_of_sensors*(t_z-pressure_turn);
plot(t_pressure,pressure,LineWidth=2)
ylabel('Pressure (PSI)')
xlabel('Time (ms)')
title('Pressure')
grid on
% xlim([10 25])
xlim([0 10000])


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

p_final = [pressure.^3;
           pressure.^2;
           pressure.^1;
           ones(size(pressure))];

w_final = [speed.^3;
           speed.^2;
           speed.^1;
           ones(size(speed))];

friction = (coeff_pressure_data(1,:)*p_final).*w_final(1,:) ...
+ (coeff_pressure_data(2,:)*p_final).*w_final(2,:) ...
+ (coeff_pressure_data(3,:)*p_final).*w_final(3,:) ...
+ (coeff_pressure_data(4,:)*p_final).*w_final(4,:);


subplot(3,1,2)
hold on
t_torque = sampling_time/no_of_sensors*(t_y-current_turn);
torque = 0.0032226562*filtfilt(b_current,a_current,y);
plot(t_torque,torque,LineWidth=2)
frictionless_torque = torque-friction+0.05;
plot(t_torque,frictionless_torque,LineWidth=2)
title('Torque from Sensor')
xlabel('Time (ms)')
ylabel('Torque (Nm)')
grid on
% xlim([10 25])
xlim([0 10000])

some_fig = gcf;
set(findobj(some_fig,'type','axes'),"FontSize",15)


power_recovery = speed.*(frictionless_torque);

figure(2)
subplot(2,1,1)
plot(t_pressure,power_recovery,LineWidth=2)
xlabel('Time (ms)')
ylabel('Power (W)')
grid on
xlim([0 10000])

dt = (t_pressure(2)-t_pressure(1))*1e-3;

subplot(2,1,2)
energy_recovery = cumsum(power_recovery*dt);
plot(t_pressure,energy_recovery,LineWidth=2)
xlabel('Time (ms)')
ylabel('Energy (J)')
grid on
xlim([0 10000])
