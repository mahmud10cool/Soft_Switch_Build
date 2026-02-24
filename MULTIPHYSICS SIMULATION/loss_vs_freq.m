clc; clear; %close all;

run param_file.m

%% Start simulation here and take data
param.zeta = 1;
% opening_ratio = 2;

wn_size = 20;
wn = logspace(2,6,wn_size);

xdot_size = 7;
xdot = linspace(0,6e-2,xdot_size);

open_ratio_size = 6;
open_ratio_array = [1, 5, 10, 20, 50, 100, 500];

Loss = NaN(wn_size,xdot_size,open_ratio_size);
Vx_final = NaN(wn_size,xdot_size,open_ratio_size);
PX_final = NaN(wn_size,xdot_size,open_ratio_size);

for i = 1:wn_size
    for j = 1:xdot_size
        for k = 1:length(open_ratio_array)
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

h = plot(switching_time, squeeze(Loss(:,:,4)));
xlabel('Switching Time (s)')
ylabel('Loss (J)')

grid on

% Create legend labels using xdot values
legend_labels = arrayfun(@(v) ...
    sprintf('$\\dot{x}_{max} = %.3g$', v), ...
    xdot, ...
    'UniformOutput', false);

legend(legend_labels, ...
    'Interpreter','latex', ...
    'Location','best');