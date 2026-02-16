%% Plotting the simulink plots
clc; clear; close;

T_sim = 1.0;

%% Run Simulation
simulation = sim("Copy_6_of_SIMSCAPE_SIM_PROTOTYPE.slx");

%% Data Collected
t = simulation.tout*1e3;
KE = simulation.KE.Data;
P1 = simulation.P1.Data;
T_elec_2 = simulation.T_elec_2.Data;
omega = simulation.omega.Data;
mech_power = simulation.mech_power.Data;
Regen_Mech = simulation.Regen_Mech.Data;
Regen_Elec = simulation.Regen_Elec.Data;
Regen_power_Mech = simulation.Regen_power_Mech.Data;
Regen_power_Elec = simulation.Regen_power_Elec.Data;
Stored = simulation.Stored.Data;
Throttling_Losses = simulation.Throttling_Losses.Data;
Pump_Losses = simulation.Pump_Losses.Data;
Work_out = simulation.Work_Out.Data;
Hyd_Energy_In = simulation.Hyd_Energy_In.Data;
elec_motor_losses = simulation.elec_motor_losses.Data;
% displacement = simulation.x.Data;
% velocity = simulation.xdot.Data;
% Energy_In = simulation.Energy_In.Data;
% Time_settle = simulation.Time_settle.Data;
S_big = simulation.S_big.Data;
S_small = simulation.S_small.Data;

%% Plots 1
figure(1)

subplot(3,1,1)
hold on
plot(t, P1*1e-6*145.038, 'b', LineWidth=3)
title('A: Pressure in Linear Actuator Chamber')
xlabel('Time (ms)')
ylabel('Pressure (PSI)')
yticks([0 250 500 750 1000 1250 1500 1750])
yticklabels({0, 250, 'P_M = 500', 750, 1000, 1250, 'P_H = 1500', 1750});
grid on

subplot(3,1,2)
plot(t, omega*(60/(2*pi)), 'b', LineWidth=2)
xlabel('Time (ms)')
ylabel('Speed (RPM)')
title('B: Speed of the Rotors')
grid on

subplot(3,1,3)
plot(t, S_big,'g',  t, S_small, 'm', LineWidth=2)
xlabel('Time (ms)')
ylabel('Stroke (m)')
title('C: Position of Switch')
legend('Pressure-rail Valve', 'Soft-switch Valve')
grid on

% subplot(3,2,3)
% plot(t(3:end), -T_elec_2(3:end), 'm', LineWidth=3)
% title('C: Torque Applied to Pump')
% xlabel('Time (ms)')
% ylabel('Torque (Nm)')
% grid on

% subplot(3,2,4)
% %t(3:end), mech_power(3:end)*1e-3, 'r', 
% plot(t(3:end), mech_power(3:end)*1e-3, 'r', t(3:end), -Regen_power_Elec(3:end)*1e-3,'g',  LineWidth=3)
% title('D: Power')
% xlabel('Time (ms)')
% ylabel('Power (kW)')
% legend('Mechanical', 'Regenerated')
% grid on

% subplot(3,2,5)
% plot(t, KE, 'r', t, -Regen_Elec, 'g', LineWidth=3)
% legend('Kinetic Energy', 'Energy Regenerated')
% xlabel('Time (ms)')
% ylabel('Energy (J)')
% title('E: Energy Regeneration')
% grid on

% subplot(3,2,6)
% plot(t, Throttling_Losses, 'm', LineWidth=3)
% title('F: Throttling Losses')
% xlabel('Time (ms)')
% ylabel('Energy (J)')
% grid on
some_fig = gcf;

sgtitle('Multi-Physics Simulation (Simscape)','FontName','Arial','FontSize',18,'FontWeight','Bold', 'LineWidth', 2)
set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2);

set(some_fig, 'position', [0, 0, 1920, 1080])

%% Stored Energy
% figure(2)
% plot(t,Stored,'b', LineWidth=3);
% title('Compressed Energy','FontName','Arial','FontSize',18,'FontWeight','Bold', 'LineWidth', 2)
% xlabel('Time (ms)')
% ylabel('Energy (J)')
% grid on
% 
% some_fig_2 = gcf;
% 
% set(findobj(some_fig_2,'type','axes'),'FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2);
% 
% set(some_fig_2, 'position', [0, 0, 960, 540])

%% Energy Consumption Pie Chart
% Pie chart RGB color combinations
% list_clr_inp = {'maroon', [0.6 0 0];
%     'navy', [0 0 0.6];
%     'red', [1 0 0];
%     'blue', [0 0 1];
%     'green', [0 1 0]};
% 
% list_clr_out = {'orange', [1 0.6 0];
%     'denim', [0 0.6 1];
%     'gold', [0.6, 0.4, 0];
%     'teal', [0, 0.2, 0.4];
%     'violet', [0.4, 0, 0.4];
%     'moss', [0, 0.4, 0.2];
%     'grey', [0.4, 0.4, 0.4]};
% 
% % Chart properties variables 
% fs = 14; % font size
% inps = 1; % input chart size
% outs = 1; % output chart size
% 
% 
% % In this order: Work Out, Throttling, KE, Regen, Stored
% label_out = [ "Throttling Losses",  "Pump Losses", "Electric Motor Losses"];
% data_out = [Throttling_Losses(end) + Stored(end), Pump_Losses(end), elec_motor_losses(end)];
% 
% label_inp = ["Hydraulic Energy In", "Electrical Energy In"];
% data_inp = [ Hyd_Energy_In(end), Regen_Elec(end)];
% 
% 
% figure(3)
% tiledlayout(1,2)
% 
% nexttile
% pie_inp = pie(data_inp);
% for j = 2:2:2*length(label_inp)
%     % change size of pie chart
%     pie_inp(j-1).Vertices = pie_inp(j-1).Vertices*inps;
% 
%     % move label position
%     pie_inp(j).Position = pie_inp(j).Position*0.5;
% 
%     % modify chart colors
%     set(pie_inp(j-1), 'FaceColor', list_clr_inp{j/2,2})
% 
%     % modify chart labels
%     set(pie_inp(j), 'FontSize',fs, 'FontWeight','bold', 'Color','white')
% end
% 
% title('Energy In', FontSize=21)
% legend(label_inp, location="southoutside", orientation='vertical', FontSize=14)
% 
% nexttile
% pie_out = pie(data_out);
% for k = 2:2:2*length(label_out)
%     % change size of pie chart
%     pie_out(k-1).Vertices = pie_out(k-1).Vertices*outs;
% 
%     % move label position
%     pie_out(k).Position = pie_out(k).Position*0.5;
% 
%     % modify chart colors
%     set(pie_out(k-1), 'FaceColor', list_clr_out{k/2,2})
% 
%     % modify chart labels
%     set(pie_out(k), 'FontSize',fs, 'FontWeight','bold', 'Color','white')
% end
% 
% title('Energy Out', FontSize=21)
% legend(label_out, location="southoutside", orientation='vertical', FontSize=14)