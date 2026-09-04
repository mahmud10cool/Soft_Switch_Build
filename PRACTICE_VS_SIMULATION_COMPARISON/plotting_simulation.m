clc; clear; close all;

T_sim = 1.2;

soft_sim = sim("simulation.slx");

t_soft = soft_sim.tout;
t_soft = t_soft*1e3;

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

%% Friction Calculations
load coeff_pressure_data.mat

pressure = 0.000145038*Px_chamber(:).';
speed    = (60/(2*pi))*omega_rot(:).';

p_final = [pressure.^3;
           pressure.^2;
           pressure;
           ones(size(pressure))];

w_final = [speed.^3;
           speed.^2;
           speed;
           ones(size(speed))];

friction = sum((coeff_pressure_data * p_final) .* w_final, 1);
friction = friction.';

%% Plots
figure(1)

% Pressure
subplot(6,1,1)
plot(t_soft, Px_chamber*0.000145038, 'LineWidth', 2);
ylabel('Pressure (PSI)')
grid on

% Speed
subplot(6,1,2)
plot(t_soft, omega_rot*(60/(2*pi)), 'LineWidth', 2);
ylabel('Speed (RPM)')
grid on

% FL Torque
subplot(6,1,3)
plot(t_soft, regen_torque+friction, 'LineWidth', 2);
ylabel('Torque (Nm)')
grid on

% Torque
subplot(6,1,4)
plot(t_soft, regen_torque, 'LineWidth', 2);
ylabel('FL Torque (Nm)')
grid on

% Power
subplot(6,1,5)
plot(t_soft, regen_torque.*omega_rot,'LineWidth',2);
ylabel('Power (W)');
grid on

% Energy
subplot(6,1,6)
plot(t_soft, regen, 'LineWidth', 2);
ylabel('Energy (J)')
text(400,0,['Energy Saved = ', num2str(regen(end)),'J'],'Color','black','FontSize',10,'FontWeight','Bold');
grid on

xlabel('Time (ms)')

% Figure Format
some_fig = gcf;

sgtitle('Simulation Results','FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2)
set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',12,'FontWeight','Bold', 'LineWidth', 2);

set(some_fig, 'position', [0, 0, 840, 1920])

saveas(gcf, 'simulation.png')

% Input Energy
% subplot(6,1,4)
% hold on
% plot(t_soft, input_energy, 'b-', 'LineWidth', 2);
% ylabel('Input Energy (J)')
% grid on

figure(2)
% Switch Timing
h_right = plot(t_soft, prv_open, 'k-', ...
               t_soft, ssv_open, 'k--', ...
               'LineWidth', 2);
ylabel('Valve Position')
ylim([min(prv_open) 1.2*max(prv_open)])
all_handles = [h_right(:)];
labels = {'PSV', 'SSV'};
legend(all_handles, labels, 'Location', 'best')
grid on


