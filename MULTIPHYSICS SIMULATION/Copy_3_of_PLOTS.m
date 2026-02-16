%% Plotting the simulink plots
clc; clear; close;

T_sim = 0.4;

%% Energy conversion plots

simulation = sim("Copy_2_of_SIMSCAPE_SIM_PROTOTYPE.slx");
simulation2 = sim("Copy_8_of_SIMSCAPE_SIM_PROTOTYPE.slx");

t = simulation.tout*1e3;
P1 = simulation.P1.Data;
Energy_In = simulation.Energy_In.Data;
Work_Out = simulation.Work_Out.Data;
Stored = simulation.Stored.Data;
Losses = simulation.Losses.Data;

t2 = simulation2.tout*1e3;
P1_2 = simulation2.P1.Data;
Losses_2 = simulation2.Losses.Data;
Energy_In_2 = simulation2.Energy_In.Data;
KE = simulation2.KE.Data;
Regen_Elec = simulation2.Regen_Elec.Data;
Regen_Mech = simulation2.Regen_Mech.Data;
Hyd_Energy_In = simulation2.Hyd_Energy_In.Data;
Work_Out_2 = simulation2.Work_Out.Data;
Stored_2 = simulation2.Stored.Data;
switching_big = simulation2.S_big.Data*1e3;
switching_small = simulation2.S_small.Data*1e3;

%% Plots
figure(1)

% subplot(2,2,1)
% plot(t, P1*1e-6, 'b', t2, P1_2*1e-6, 'r', LineWidth=3)
% title('A: Pressure in Linear Actuator Chamber')
% xlabel('Time (ms)')
% ylabel('Pressure (MPa)')
% yticks([2, 3, 3.5, 4, 5, 6, 7, 8])
% yticklabels({2, 3, 'P_M = 3.5', 4, 5, 6,'P_H = 7',8});
% legend('Normal', 'With Soft Switch')
% grid on

colororder({'k', 'k'})

subplot(2,2,1)

eff_in_2 = Hyd_Energy_In + Regen_Elec + KE(1) - (KE);
plot(t, Energy_In, 'b', t2, eff_in_2, 'r', LineWidth=3)
title('A: Effective Energy Input')

xlabel('Time (ms)')
ylabel('Energy (J)')

yyaxis right
plot(t2,switching_small, 'g--', t2,switching_big, 'm--', LineWidth=2);
ylabel('Spool Opening (mm)')
% legend('Normal', 'With Soft Switch', 'Soft-Switch Valve Opening', 'Pressure Rail Valve Opening')

grid on


subplot(2,2,2)
plot(t, Work_Out, 'b', t2, Work_Out_2, 'r', LineWidth=3)
title('B: Output Work')
% legend('Normal', 'With Soft Switch')
xlabel('Time (ms)')
ylabel('Energy (J)')

yyaxis right
plot(t2,switching_small, 'g--', t2,switching_big, 'm--', LineWidth=2);
ylabel('Spool Opening (mm)')
% legend('Normal', 'With Soft Switch', 'Soft-Switch Valve Opening', 'Pressure Rail Valve Opening')

grid on

subplot(2,2,3)
Loss_1 = Energy_In - Work_Out-Stored;
Loss_2 = eff_in_2-Work_Out_2-Stored_2;
plot(t, Loss_1,'b', t2, Loss_2, 'r', LineWidth=3);
title('C: Total Losses')
% legend('Normal', 'With Soft Switch')
xlabel('Time (ms)')
ylabel('Energy (J)')

yyaxis right
plot(t2,switching_small, 'g--', t2,switching_big, 'm--', LineWidth=2);
ylabel('Spool Opening (mm)')
% legend('Normal', 'With Soft Switch', 'Soft-Switch Valve Opening', 'Pressure Rail Valve Opening')

grid on

% colororder({'k', '#808080'})
subplot(2,2,4)
Loss_2_t = interp1(Loss_2,linspace(1,numel(Loss_2),numel(Loss_1)))';
plot(t, Loss_1-Loss_2_t, 'r', LineWidth=3);
title('D: Energy Saved')
% legend('With Soft Switch')
xlabel('Time (ms)')
ylabel('Energy (J)')

yyaxis right
plot(t2,switching_small, 'g--', t2,switching_big, 'm--', LineWidth=2);
ylabel('Spool Opening (mm)')
% legend('Normal', 'With Soft Switch', 'Soft-Switch Valve Opening', 'Pressure Rail Valve Opening')

grid on

some_fig = gcf;

sgtitle('Multi-Physics Simulation (Simscape)','FontName','Arial','FontSize',18,'FontWeight','Bold', 'LineWidth', 2)
set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2);

% set(some_fig, 'position', [0, 0, 1920, 1080])
