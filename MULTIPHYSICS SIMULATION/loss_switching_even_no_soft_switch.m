clc; clear; close all;

T_sim = 0.25;

normal_sim = sim("no_soft_switch_sim.slx");

Px = normal_sim.Px.Data;
Pdes = normal_sim.Pdes.Data;
flow = normal_sim.valve_flow.Data;