clc; clear;

run param_file.m

T_sim = 0.25;

model = "Copy_of_no_soft_switch_sim";
load_system(model)
set_param(model, "FastRestart", "on")

param.zeta = 1;

wn_size = 20;
wn = logspace(2,6,wn_size);

xdot_size = 7;
xdot = linspace(0,6e-2,xdot_size);

open_ratio_array = [100, 1000, 10000];
open_ratio_size = length(open_ratio_array);

Loss = NaN(wn_size,xdot_size,open_ratio_size);
Vx_final = NaN(wn_size,xdot_size,open_ratio_size);
PX_final = NaN(wn_size,xdot_size,open_ratio_size);

total_cases = wn_size * xdot_size * open_ratio_size;
case_count = 0;

for i = 1:wn_size
    for j = 1:xdot_size
        for k = 1:open_ratio_size

            param.wn = wn(i);
            param.xdot = xdot(j);
            opening_ratio = open_ratio_array(k);

            x_sim = sim(model);

            Loss(i,j,k) = x_sim.Throttling_Loss.Data(end);
            Vx_final(i,j,k) = x_sim.Vx.Data(end);
            PX_final(i,j,k) = x_sim.Px.Data(end);

            case_count = case_count + 1;
            percent_complete = 100 * case_count / total_cases;

            if mod(case_count,10) == 0 || case_count == total_cases
                fprintf('\rProgress: %.1f%% complete', percent_complete);
            end
        end
    end
end

fprintf('\nSimulation sweep complete.\n')

set_param(model, "FastRestart", "off")