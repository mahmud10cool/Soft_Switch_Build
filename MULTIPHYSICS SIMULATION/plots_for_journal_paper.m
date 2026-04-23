clc; clear; close all;

T_sim = 1;

soft_sim = sim("soft_switch_new_simulation.slx");
t_soft = soft_sim.tout;
input_energy = soft_sim.Input_Energy.Data;
output_energy = soft_sim.Output_Energy.Data;
pump_loss = soft_sim.Pump_Losses.Data;
regen = soft_sim.Regen.Data;
elec_loss = soft_sim.Elec_Losses.Data;
throttling_loss = soft_sim.Throttling_Loss.Data;
work = soft_sim.Work.Data;
prv_open = soft_sim.PRV_Opening.Data;
ssv_open = soft_sim.SSV_Opening.Data;

normal_sim = sim("no_soft_switch_sim.slx");
t_norm = normal_sim.tout;
input_energy_norm = normal_sim.Input_Energy.Data;
output_energy_norm = normal_sim.Output_Energy.Data;
work_norm = normal_sim.Work.Data;
throttling_loss_norm = normal_sim.Throttling_Loss.Data;
prv_open_norm = normal_sim.PRV_Opening.Data;

%% Plots
figure(1)
subplot(4,4,1)
plot(t_soft, input_energy, t_norm, input_energy_norm, LineWidth=2)
xlabel('Time (s)')
ylabel('Input Energy (J)')
grid on
