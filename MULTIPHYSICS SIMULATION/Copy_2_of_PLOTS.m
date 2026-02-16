%% Plotting the simulink plots
clc; clear; close;

T_sim = 0.06;

%% Parameters
% param = struct();
% 
% % Volume of chambers 
% param.V1_0 = 1e-3;
% param.V2_0 = 20e-6;
% 
% % Pressure rails
% param.P_H = 20e6;
% param.P_M = 10e6;
% param.P_L = 101325;
% 
% % Valve things
% param.max_Avt = 0.5*0.25*pi*(20e-3)^2;
% param.Cd = 0.6;
% 
% % Fluid properties
% param.beta = 1.8e9;
% param.rho = 870;
% param.air = 0;
% 
% air_array = [0, 0.1, 0.5, 1, 2.5, 5]*1e-2;
% 
% % Electric motor stuff
% param.Kt = 70.5e-3;
% param.Ke = 70.5e-3;
% param.J_elec = 1530e-7;
% 
% % Pump things
% J_hyd_array = [246, 550, 3000, 9620, 11200]*1e-7;
% hyd_D_array = [0.4, 0.8, 1.61, 3.13, 6.29]*1e-6;
% 
% param.J_hyd = 3000e-7;
% param.hyd_D = 1.61e-6;    % In cc/rev
% 
% % Simulation time
% T = 1;
% param.on_time = 0;
% 
% % Linear Actuator Piston
% param.Acap = 0.0045;
% 
% % Valve Dynamics
% param.wn = 50*2*pi;
% param.zeta = 1;
% 
% % Velocity of the piston
% xdot_array = [0, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1, 1];
% 
% % Initializing some arrays
% settling_time = zeros(size(air_array));
% Regen_to_input = zeros(size(air_array));

%% Energy conversion plots

simulation = sim("Copy_2_of_trial_with_intermediate_tanks.slx");

t = simulation.tout*1e3;
Regen = simulation.Regen.Data;
KE = simulation.KE.Data;
P1 = simulation.P1.Data;
T_elec = simulation.T_elec.Data;
omega = simulation.omega.Data;
mech_power = simulation.mech_power.Data;
Regen_power = simulation.Regen_power.Data;
Losses = simulation.Losses.Data;
displacement = simulation.x.Data;
velocity = simulation.xdot.Data;
Energy_In = simulation.Energy_In.Data;
Time_settle = simulation.Time_settle.Data;

%% Plots
figure(1)

subplot(3,2,1)
plot(t, P1*1e-6*145.038, 'b', LineWidth=3)
title('A: Pressure in Linear Actuator Chamber')
xlabel('Time (ms)')
ylabel('Pressure (PSI)')
yticks([250 500 750 1000 1250 1500 1750])
yticklabels({250, 'P_M = 500', 750, 1000, 1250, 'P_H = 1500', 1750});
grid on

subplot(3,2,2)
plot(t, omega*(60/(2*pi)), 'b', LineWidth=3)
xlabel('Time (ms)')
ylabel('Speed (RPM)')
title('B: Speed of the Rotors')
grid on

subplot(3,2,5)
plot(t, KE, 'r', t, Regen, 'g', LineWidth=3)
legend('Kinetic Energy', 'Energy Regenerated')
xlabel('Time (ms)')
ylabel('Energy (J)')
title('E: Energy Regeneration')
grid on

subplot(3,2,4)
plot(t, mech_power*1e-3, 'r', t, Regen_power*1e-3, 'g', LineWidth=3)
title('D: Power')
xlabel('Time (ms)')
ylabel('Power (kW)')
legend('Mechanical', 'Regen')
grid on

subplot(3,2,3)
plot(t, T_elec*(1/80e-3), 'm', LineWidth=3)
title('C: Regenerated Electric Current')
xlabel('Time (ms)')
ylabel('Current (A)')
grid on

subplot(3,2,6)
plot(t, Losses, 'm', LineWidth=3)
title('F: Throttling Losses')
xlabel('Time (ms)')
ylabel('Energy (J)')
grid on

% subplot(4,2,7)
% plot(t, displacement, LineWidth=3)
% title('Piston Displacement')
% xlabel('Time (ms)')
% ylabel('Displacement (m)')
% grid on
% 
% subplot(4,2,8)
% plot(t, velocity, LineWidth=3)
% title('Piston Velocity')
% xlabel('Time (ms)')
% ylabel('Velocity (m/s)')
% grid on

some_fig = gcf;

% sgtitle('PI Controller','FontName','Arial','FontSize',18,'FontWeight','Bold', 'LineWidth', 2)
% set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2);

% set(some_fig, 'position', [0, 0, 1920, 1080])

% figure(2)
% V1 = param.V1_0 + param.Acap*displacement;
% plot(V1*1e6, P1*1e-6, LineWidth=3);
% title('Pressure vs. Volume')
% xlabel('Volume (cc)')
% ylabel('Pressure (MPa')
% grid on
