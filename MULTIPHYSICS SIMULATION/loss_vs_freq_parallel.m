clc; clear; % close all;

run param_file_loss_vs_freq.m

%% Simulation setup

T_sim = 0.25;

model = "Copy_of_no_soft_switch_sim";
load_system(model)

param.zeta = 1;

wn_size = 30;
wn = logspace(1.4,5,wn_size);

xdot_size = 5;
xdot = linspace(0,4e-2,xdot_size);

open_ratio_array = [100];
open_ratio_size = length(open_ratio_array);

total_cases = wn_size * xdot_size * open_ratio_size;

%% Create simulation inputs for parsim

simIn(total_cases) = Simulink.SimulationInput(model);

case_count = 0;

for i = 1:wn_size
    for j = 1:xdot_size
        for k = 1:open_ratio_size

            case_count = case_count + 1;

            temp_param = param;
            temp_param.wn = wn(i);
            temp_param.xdot = xdot(j);
            temp_param.zeta = 1;
            temp_param.piston_freq = 100;
            temp_param.open_ratio = open_ratio_array(k);

            simIn(case_count) = Simulink.SimulationInput(model);

            simIn(case_count) = simIn(case_count).setVariable("param", temp_param);

            % Safer way to set simulation time
            simIn(case_count) = simIn(case_count).setModelParameter( ...
                "StopTime", num2str(T_sim));

        end
    end
end

%% Run simulations in parallel

simOut = parsim(simIn, ...
    "ShowProgress", "on", ...
    "TransferBaseWorkspaceVariables", "on");

%% Extract results

Loss = NaN(wn_size, xdot_size, open_ratio_size);
Vx_final = NaN(wn_size, xdot_size, open_ratio_size);
PX_final = NaN(wn_size, xdot_size, open_ratio_size);

case_count = 0;

for i = 1:wn_size
    for j = 1:xdot_size
        for k = 1:open_ratio_size

            case_count = case_count + 1;

            Loss(i,j,k) = simOut(case_count).Throttling_Loss.Data(end);
            Vx_final(i,j,k) = simOut(case_count).Vx.Data(end);
            PX_final(i,j,k) = simOut(case_count).Px.Data(end);

        end
    end
end

disp("Simulation sweep complete.")

%% Plot code

switching_time = 1./(wn*2);

open_ratio_index = 1;

figure(1)
h = plot(switching_time, squeeze(Loss(:,:,open_ratio_index)), LineWidth=2);

yticks([2, 2.363, 3, 4, 5, 6, 7])

xlabel('Switching Time (s)')
ylabel('Loss (J)')
grid on

lgd = legend(arrayfun(@(v) sprintf('%.3g', v), xdot, ...
    'UniformOutput', false), Location="northwest");

title(lgd, '$\dot{x}_{max}$', 'Interpreter','latex');

some_fig = gcf;

some_string = ['Throttling Loss vs. Switching Time',' (A_{v, max} = ', ... 
    num2str(open_ratio_array(open_ratio_index)*param.max_Avt*1e4),'cm^2)'];

sgtitle(some_string,'FontName','Arial','FontSize',18,'FontWeight',...
    'Bold', 'LineWidth', 2)

set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',15,...
'FontWeight','Bold', 'LineWidth', 2);

ax = gca;

ylab = string(ax.YTickLabel);
ylab(2) = "\color{red}" + ylab(2);

ax.YTickLabel = ylab;
ax.TickLabelInterpreter = 'tex';

saveas(gcf, 'loss_vs_freq.png')