
clear; clc; close all;

%% Load friction map
load coeff_pressure_data.mat

%% Some Important Parameters
somethin = 15;
length_somethin = length(somethin);
file_names = strings(size(somethin));
file_name = strings(size(somethin));

fc = 10;
fs = 1000;

[b,a] = butter(2,fc/(fs/2));

no_of_sensors = 3;

sampling_time = 1;

kwte = 12000;

speed_turn = 3;
current_turn = 1;
pressure_turn = 2;

x = NaN(length(somethin),kwte/3);
y = NaN(length(somethin),kwte/3);
z = NaN(length(somethin),kwte/3);

t_x = NaN(length(somethin),kwte/3);
t_y = NaN(length(somethin),kwte/3);
t_z = NaN(length(somethin),kwte/3);

pressure = NaN(length(somethin),kwte/3);
speed = NaN(length(somethin),kwte/3);
current = NaN(length(somethin),kwte/3);

t_pressure = NaN(length(somethin),kwte/3);
t_speed = NaN(length(somethin),kwte/3);
t_current = NaN(length(somethin),kwte/3);

time_indices = cell(1, length_somethin); % Store indices for each graph

t_1_all = cell(1, length_somethin); % Store normalized time for each graph
min_length_t1 = inf; % Initialize variable to track max time range


%% Loading and Saving Data

for i=1:length(somethin)
    
    file_names(i) = ['test_',num2str(somethin(i)),'_1000RPM.mat'];
    file_name(i) = [num2str(somethin(i)),'ms'];
    
    load(file_names(i));

    x(i,:) = some_data(speed_turn:no_of_sensors:kwte);
    y(i,:) = some_data(current_turn:no_of_sensors:kwte);
    z(i,:) = some_data(pressure_turn:no_of_sensors:kwte);

    if isnan(y(i,1))
        y(i,1) = 0;
    end

    t_x(i,:) = t(speed_turn:no_of_sensors:kwte);
    t_y(i,:) = t(current_turn:no_of_sensors:kwte);
    t_z(i,:) = t(pressure_turn:no_of_sensors:kwte);

    speed(i,:) = filtfilt(b,a,(0.78125*x(i,:) - 1600));
    current(i,:) = 0.0032226562*filtfilt(b,a,y(i,:));
    pressure(i,:) = 1.6113281*filtfilt(b,a,z(i,:));

    t_speed(i,:) = sampling_time/no_of_sensors*(t_x(i,:)-speed_turn);
    t_current(i,:) = sampling_time/no_of_sensors*(t_y(i,:)-current_turn);
    t_pressure(i,:) = sampling_time/no_of_sensors*(t_z(i,:)-pressure_turn);

    figure(1)
    plot(t_pressure(i,:),pressure(i,:),LineWidth=2, DisplayName=file_name(i))
    ylabel('Pressure (PSI)')
    xlabel('Time (s)')
    title('Pressure')
    grid on
    % xlim([10 25])
    % hold on
    legend show

    % Activate only the speed subplot before taking input
    disp('Click two points on the speed graph to define the friction index range.');
    [friction_index, ~] = ginput(2);

    % Extract indices for the selected time range
    time_indices{i} = find(t_pressure(i,:) >= friction_index(1) & t_pressure(i,:) <= friction_index(2));

    % Normalize time (start from zero)
    t_1_all{i} = t_pressure(i, time_indices{i}) - t_pressure(i, time_indices{i}(1));

    % Keep track of the maximum time duration across all datasets
    min_length_t1 = min(min_length_t1, max(t_1_all{i}));
end

%% Extracting the useful data and interpolating to make same size
num_cols = int64(min_length_t1); % Choose a fixed number of interpolation points
t_common = linspace(0, min_length_t1, num_cols);
dt = t_common(2)-t_common(1);

% Predefine output matrices
speed_optimal_time = zeros(length_somethin, num_cols);
current_optimal_time = zeros(length_somethin, num_cols);
pressure_optimal_time = zeros(length_somethin, num_cols);

power_recovery = zeros(length_somethin,num_cols);
energy_recovery = zeros(length_somethin,num_cols);

friction = zeros(length_somethin,num_cols);

torque_without_friction = zeros(length_somethin,num_cols);

adjustment = zeros(size(somethin));

% Second loop: Interpolate data using the common t_common
for i = 1:length(somethin)
    [speed_optimal_time(i,:), current_optimal_time(i,:), pressure_optimal_time(i,:)] = appendOptTimeData(...
        i, time_indices{i}, t_1_all{i}, speed, current, pressure, t_common);


    p_final = [pressure_optimal_time(i,:).^3;
               pressure_optimal_time(i,:).^2;
               pressure_optimal_time(i,:).^1;
               ones(1,num_cols)];

    w_final = [speed_optimal_time(i,:).^3;
               speed_optimal_time(i,:).^2;
               speed_optimal_time(i,:).^1;
               ones(1,num_cols)];

    friction(i,:) = (coeff_pressure_data(1,:)*p_final).*w_final(1,:) ...
    + (coeff_pressure_data(2,:)*p_final).*w_final(2,:) ...
    + (coeff_pressure_data(3,:)*p_final).*w_final(3,:) ...
    + (coeff_pressure_data(4,:)*p_final).*w_final(4,:);

    torque_without_friction(i,:) = current_optimal_time(i,:)-friction(i,:);
    adjustment(i) = mean(torque_without_friction(i,1:100));
    torque_without_friction(i,:) =  torque_without_friction(i,:) - adjustment(i);

    power_recovery(i,:) = (2*pi/60)*speed_optimal_time(i,:) .* torque_without_friction(i,:);
    energy_recovery(i,:) = cumsum(power_recovery(i,:)*dt*1e-3);

    figure(1)
    subplot(6,1,1)
    plot(t_common,pressure_optimal_time(i,:),LineWidth=2,DisplayName=file_name(i))
    xlabel('Time')
    ylabel('Pressure')
    grid on
    hold on
    legend show

    subplot(6,1,2)
    plot(t_common,speed_optimal_time(i,:),LineWidth=2,DisplayName=file_name(i))
    xlabel('Time')
    ylabel('Speed')
    grid on
    hold on
    legend show

    subplot(6,1,3)
    plot(t_common,current_optimal_time(i,:),LineWidth=2,DisplayName=file_name(i))
    xlabel('Time')
    ylabel('Torque')
    grid on
    hold on
    legend show

    subplot(6,1,4)
    plot(t_common,torque_without_friction(i,:),LineWidth=2,DisplayName=file_name(i))
    xlabel('Time')
    ylabel('Frictionless Torque')
    grid on
    hold on
    legend show

    subplot(6,1,5)
    plot(t_common,power_recovery(i,:),LineWidth=2,DisplayName=file_name(i))
    xlabel('Time')
    ylabel('Power')
    grid on
    hold on
    legend show

    subplot(6,1,6)
    plot(t_common,energy_recovery(i,:),LineWidth=2,DisplayName=file_name(i))
    xlabel('Time')
    ylabel('Energy')
    grid on
    hold on
    legend show
end

%% Last Figure
figure(3)
% hold on
switch_times = somethin;
plot(switch_times,energy_recovery(:,end),'o-',LineWidth=3);
xlabel('Switching Time')
ylabel('Energy Recovered')
grid on
title('Energy Savings vs Switching Time')

some_fig = gcf;

set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2);

set(some_fig, 'position', [0, 0, 1920, 1080])

savefig('Important_Figure_2')