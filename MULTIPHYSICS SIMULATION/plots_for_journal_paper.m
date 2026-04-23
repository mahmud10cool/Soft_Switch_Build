clc; clear; close all;

T_sim = 1;

soft_sim = sim("soft_switch_new_simulation.slx");

input_energy = soft_sim.Input_Energy.Data;
output_energy = soft_sim.Output_Energy.Data;
pump_loss = soft_sim.Pump_Losses.Data;
regen = some_sime.Regen.Data;
elec_loss = soft_sim.Elec_Losses.Data;
throttling_loss = soft_sim.Throttling_Loss.Data;
work = soft_sim.Work.Data;

normal_sim = sim("no_soft_switch_sim.slx");
input_energy_norm = normal_sim.Input_Energy.Data;
output_energy_norm = normal_sim.Output_Energy.Data;
work_norm = normal_sim.Work.Data;
throttling_loss_norm = normal_sim.Throttling_Loss.Data;
