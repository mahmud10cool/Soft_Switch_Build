clc; clear; close;
load test_15_500RPM_current.mat

fc = 100;
fs = 1000;

[b,a] = butter(2,fc/(fs/2));
% 
no_of_sensors = 3;
% 
sampling_time = 1;

kwte = 15000;

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

t_speed = sampling_time/no_of_sensors*(t_x-speed_turn);
speed = filtfilt(b,a,(0.78125*x - 1600));

t_torque = sampling_time/no_of_sensors*(t_y-torque_turn);
torque = 0.0032226562*filtfilt(b,a,y);

t_current = sampling_time/no_of_sensors*(t_z-current_turn);
current = 109e-3*(0.0048828126*filtfilt(b,a,z) - 10.7);

load coeff_pressure_data.mat
load test_15_500RPM.mat

fc_pressure = 100;
fc_speed = 50;
fc_current = 100;
fs = 1000;

[b_pressure,a_pressure] = butter(2,fc_pressure/(fs/2));
[b_speed,a_speed] = butter(2,fc_speed/(fs/2));
[b_current,a_current] = butter(2,fc_current/(fs/2));

no_of_sensors_ = 3;

sampling_time_ = 1;

kwte_ = 15000;

speed_turn_ = 3;
current_turn_ = 1;
pressure_turn_ = 2;

x_ = some_data(speed_turn_:no_of_sensors_:kwte_);
y_ = some_data(current_turn_:no_of_sensors_:kwte_);
z_ = some_data(pressure_turn_:no_of_sensors_:kwte_);

if isnan(y_(1))
    y_(1) = 0;
end

t_x_ = t(speed_turn_:no_of_sensors_:kwte_);
t_y_ = t(current_turn_:no_of_sensors_:kwte_);
t_z_ = t(pressure_turn_:no_of_sensors_:kwte_);

t_speed_ = sampling_time_/no_of_sensors_*(t_x_-speed_turn_);
speed_ = filtfilt(b_speed,a_speed,(0.78125*x_ - 1600));

pressure = 1.6113281*filtfilt(b_pressure,a_pressure,z_);
t_pressure = sampling_time_/no_of_sensors_*(t_z_-pressure_turn_);

t_torque_ = sampling_time_/no_of_sensors*(t_y_-current_turn_);
torque_ = 0.0032226562*filtfilt(b_current,a_current,y);

% p_final = [pressure.^3;
%            pressure.^2;
%            pressure.^1;
%            ones(size(pressure))];
% 
% w_final = [speed.^3;
%            speed.^2;
%            speed.^1;
%            ones(size(speed))];
% 
% friction = (coeff_pressure_data(1,:)*p_final).*w_final(1,:) ...
% + (coeff_pressure_data(2,:)*p_final).*w_final(2,:) ...
% + (coeff_pressure_data(3,:)*p_final).*w_final(3,:) ...
% + (coeff_pressure_data(4,:)*p_final).*w_final(4,:);

pressure = pressure(:).';
speed    = speed(:).';

p_final = [pressure.^3;
           pressure.^2;
           pressure;
           ones(size(pressure))];

w_final = [speed.^3;
           speed.^2;
           speed;
           ones(size(speed))];

friction = sum((coeff_pressure_data * p_final) .* w_final, 1);

friction_index = 1850:3050;

t_friction = t_speed_(friction_index);

torque_fric_1 = current(friction_index(1:175))-friction(friction_index(1:175));
torque_fric_1 = torque_fric_1 - mean(torque_fric_1);
torque_fric_2 = current(friction_index(176:261))-friction(friction_index(176:261))-0.2;
torque_fric_3 = current(friction_index(262:322))-friction(friction_index(262:322))-0.1;
% torque_fric_4 = current(friction_index(323:end))-friction(friction_index(323:end));
% torque_fric_4 = torque_fric_4 - mean(torque_fric_4);

torque_fric_4 = current(friction_index(323:763))-friction(friction_index(323:763));
torque_fric_4 = torque_fric_4 - mean(torque_fric_4);
torque_fric_4 = torque_fric_4 + 0.015;
torque_fric_5 = current(friction_index(764:906))-friction(friction_index(764:906));
torque_fric_6 = current(friction_index(907:end))-friction(friction_index(907:end));
torque_fric_6 = torque_fric_6 - mean(torque_fric_6);
torque_fric = [torque_fric_1,torque_fric_2,torque_fric_3,torque_fric_4,torque_fric_5,torque_fric_6];
% torque_fric = [torque_fric_1,torque_fric_2,torque_fric_3,torque_fric_4];
% torque_fric = current(friction_index);

%% Plots
figure(1)

% Pressure
subplot(6,1,1)
plot(t_pressure(friction_index)-t_friction(1),pressure(friction_index)+100,LineWidth=2);
ylabel('Pressure (PSI)')
grid on

% Speed
subplot(6,1,2)
speed_fric = speed_(friction_index);
plot(t_speed_(friction_index)-t_friction(1),speed_fric,LineWidth=2);
ylabel('Speed (RPM)')
grid on

% Torque
subplot(6,1,3)
plot(t_current(friction_index)-t_friction(1),current(friction_index),LineWidth=2);
ylabel('Torque (Nm)')
grid on

% Frictionless Torque
subplot(6,1,4)
plot(t_current(friction_index)-t_friction(1),torque_fric,LineWidth=2);
ylabel('FL Torque (Nm)')
grid on

% Power
subplot(6,1,5)
power_fric = (speed_fric*((2*pi)/60)).*torque_fric;
plot(t_pressure(friction_index)-t_friction(1),power_fric,LineWidth=2);
ylabel('Power (W)')
grid on

% Energy
subplot(6,1,6)
energy_fric = cumsum(power_fric*1e-3);
t_energy = t_pressure(friction_index)-t_friction(1);
plot(t_energy, energy_fric,LineWidth=2);
ylabel('Energy (J)')
text(400,0,['Energy Saved = ', num2str(energy_fric(end)),'J'],'Color','black','FontSize',10,'FontWeight','Bold');
grid on

xlabel('Time (ms)')

% Figure Format
some_fig = gcf;

sgtitle('Experimental Results','FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2)
set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',12,'FontWeight','Bold', 'LineWidth', 2);

set(some_fig, 'position', [0, 0, 840, 1920])

saveas(gcf, 'practice.png')
