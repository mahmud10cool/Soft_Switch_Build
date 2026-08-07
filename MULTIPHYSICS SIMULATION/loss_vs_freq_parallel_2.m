clc;
clear;
% close all;

run param_file_loss_vs_freq.m

%% Simulation setup

T_sim = 0.25;

model = "Copy_of_no_soft_switch_sim";
load_system(model)

param.zeta = 1;

% Natural-frequency sweep
wn_size = 30;
wn = logspace(1.4, 5, wn_size);

% Fixed piston speed
xdot_fixed = 0.04;   % m/s

% Valve-opening-ratio sweep
% Modify these values as needed
open_ratio_array = [1, 10, 100, 1000, 10000];
open_ratio_size = length(open_ratio_array);

total_cases = wn_size * open_ratio_size;

%% Create simulation inputs for parsim

simIn(total_cases) = Simulink.SimulationInput(model);

case_count = 0;

for i = 1:wn_size
    for k = 1:open_ratio_size

        case_count = case_count + 1;

        temp_param = param;

        temp_param.wn = wn(i);
        temp_param.xdot = xdot_fixed;
        temp_param.zeta = 1;
        temp_param.piston_freq = 100;
        temp_param.open_ratio = open_ratio_array(k);

        simIn(case_count) = Simulink.SimulationInput(model);

        simIn(case_count) = simIn(case_count).setVariable( ...
            "param", temp_param);

        simIn(case_count) = simIn(case_count).setModelParameter( ...
            "StopTime", num2str(T_sim));

    end
end

%% Run simulations in parallel

simOut = parsim(simIn, ...
    "ShowProgress", "on", ...
    "TransferBaseWorkspaceVariables", "on");

%% Extract results

Loss     = NaN(wn_size, open_ratio_size);
Vx_final = NaN(wn_size, open_ratio_size);
PX_final = NaN(wn_size, open_ratio_size);

case_count = 0;

for i = 1:wn_size
    for k = 1:open_ratio_size

        case_count = case_count + 1;

        Loss(i,k) = ...
            simOut(case_count).Throttling_Loss.Data(end);

        Vx_final(i,k) = ...
            simOut(case_count).Vx.Data(end);

        PX_final(i,k) = ...
            simOut(case_count).Px.Data(end);

    end
end

disp("Simulation sweep complete.")

%% Plot throttling loss

switching_time = 1./(2*wn);

figure(1)
clf

plot(switching_time, Loss, ...
    "LineWidth", 2);

xlabel("Switching Time (s)")
ylabel("Throttling Loss (J)")
grid on

% Legend showing opening-ratio values
legend_labels = arrayfun( ...
    @(v) sprintf("%g", v), ...
    open_ratio_array, ...
    "UniformOutput", false);

lgd = legend(legend_labels, ...
    "Location", "northwest");

title(lgd, "Opening Ratio");

sgtitle( ...
    sprintf("Throttling Loss vs. Switching Time ($\\dot{x}=%.3f$ m/s)", ...
    xdot_fixed), ...
    "Interpreter", "latex", ...
    "FontName", "Arial", ...
    "FontSize", 18, ...
    "FontWeight", "bold");

some_fig = gcf;

set(findobj(some_fig, "Type", "axes"), ...
    "FontName", "Arial", ...
    "FontSize", 15, ...
    "FontWeight", "bold", ...
    "LineWidth", 2);

saveas(gcf, "loss_vs_switching_time_opening_ratio.png")