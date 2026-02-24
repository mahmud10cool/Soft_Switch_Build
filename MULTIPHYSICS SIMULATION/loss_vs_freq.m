clc; clear; %close all;

run param_file.m

%% Start simulation here and take data
param.zeta = 1;
% opening_ratio = 2;

wn_size = 15;
wn = logspace(3,6,wn_size);

xdot_size = 7;
xdot = linspace(0,6e-2,xdot_size);

open_ratio_size = 6;
open_ratio_array = logspace(0,5,open_ratio_size);

Loss = NaN(wn_size,xdot_size,open_ratio_size);
Vx_final = NaN(wn_size,xdot_size,open_ratio_size);
PX_final = NaN(wn_size,xdot_size,open_ratio_size);

for i = 1:wn_size
    for j = 1:xdot_size
        for k = 1:open_ratio_size
            param.wn = wn(i);
            param.xdot = xdot(j);
            opening_ratio = open_ratio_array(k);

            x_sim = sim("soft_switch_new_simulation_4.slx");

            Loss(i,j,k) = x_sim.Loss.Data(end);
            Vx_final(i,j,k) = x_sim.Vx.Data(end);
            PX_final(i,j,k) = x_sim.PX.Data(end);
        end
    end
end

switching_time = 1./(wn*2);

%% Plot code here
% I think I am going to just a 2D plot. 
% 3D plots don't show what I want it to show.

% plot(switching_time)