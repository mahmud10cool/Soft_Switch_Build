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
subplot(2,2,1)
hold on % Ensure new plots don't clear old ones

% Left Side
yyaxis left
h_left = plot(t_soft, input_energy, 'b-', t_norm, input_energy_norm, 'r-', 'LineWidth', 2);
ylabel('Input Energy (J)')

% Right Side
yyaxis right
h_right = plot(t_soft, prv_open, 'g--', t_soft, ssv_open, 'm--', 'LineWidth', 2);
ylabel('Valve Opening')

% Combine all handles into one legend
% h_left and h_right are arrays; combine them into a single column vector
all_handles = [h_left; h_right];
labels = {'Soft-Switch', 'Normal', 'PRV Opening', 'SSV Opening'};
legend(all_handles, labels, 'Location', 'best') %

xlabel('Time (s)')
grid on
title('Input Energy vs. Time')
hold off

subplot(2,2,2)
% Plot Throttling Loss
yyaxis left
h_left = plot(t_soft, throttling_loss, 'b-', t_norm, throttling_loss_norm, 'r-', 'LineWidth', 2);
ylabel('Throttling Loss (J)')

% Right Side
yyaxis right
h_right = plot(t_soft, prv_open, 'g--', t_soft, ssv_open, 'm--', 'LineWidth', 2);
ylabel('Valve Opening')

% Combine all handles into one legend
% h_left and h_right are arrays; combine them into a single column vector
all_handles = [h_left; h_right];
labels = {'Soft-Switch', 'Normal', 'PRV Opening', 'SSV Opening'};
legend(all_handles, labels, 'Location', 'best') %

xlabel('Time (s)')
grid on
title('Throttling Loss vs. Time')
hold off

subplot(2,2,3)
cla
hold on
axis equal
axis off

% Final energy values for soft-switch case
E_input = input_energy(end);
E_regen = regen(end);

E_work  = work(end);
E_throt = throttling_loss(end);
E_pump  = pump_loss(end);
E_elec  = elec_loss(end);

% Use absolute values in case some signals are stored negative
outer_vals = abs([E_input, E_regen]);
inner_vals = abs([E_work, E_throt, E_pump, E_elec]);

outer_labels = {'Input Energy', 'Regen'};
inner_labels = {'Work', 'Throttling Loss', 'Pump Loss', 'Elec Motor Loss'};

% Radii
inner_pie_radius = 1;   % solid inner pie
outer_ring_r1    = 1;   % inner radius of outer donut
outer_ring_r2    = 1.2;   % outer radius of outer donut

% Colors
outer_colors = [
    0.20 0.45 0.85
    0.20 0.70 0.35
];

inner_colors = [
    0.25 0.60 0.90
    0.90 0.35 0.30
    0.95 0.65 0.20
    0.55 0.35 0.75
];

% Draw inner solid pie
h_inner = solidPie(inner_vals, inner_pie_radius, inner_colors);

% Draw outer donut ring
h_outer = donutRing(outer_vals, outer_ring_r1, outer_ring_r2, outer_colors);

title('Soft-Switch Energy Distribution', ...
      'Units', 'normalized', ...
      'Position', [0.5, 1.08, 0])

legend([h_outer(:); h_inner(:)], ...
       [outer_labels, inner_labels], ...
       'Location', 'best')

hold off




















function h = solidPie(vals, radius, colors)

    vals = vals(:);
    vals = abs(vals);
    total = sum(vals);

    if total == 0
        h = gobjects(length(vals),1);
        return
    end

    frac = vals / total;
    theta_edges = [0; cumsum(frac) * 2*pi];
    h = gobjects(length(vals),1);

    for i = 1:length(vals)
        theta = linspace(theta_edges(i), theta_edges(i+1), 120);

        x = [0, radius*cos(theta), 0];
        y = [0, radius*sin(theta), 0];

        h(i) = patch(x, y, colors(i,:), ...
            'EdgeColor', 'w', ...
            'LineWidth', 1.5);
    end
end


function h = donutRing(vals, r_inner, r_outer, colors)

    vals = vals(:);
    vals = abs(vals);
    total = sum(vals);

    if total == 0
        h = gobjects(length(vals),1);
        return
    end

    frac = vals / total;
    theta_edges = [0; cumsum(frac) * 2*pi];
    h = gobjects(length(vals),1);

    for i = 1:length(vals)
        theta = linspace(theta_edges(i), theta_edges(i+1), 120);

        x_outer = r_outer*cos(theta);
        y_outer = r_outer*sin(theta);

        x_inner = r_inner*cos(fliplr(theta));
        y_inner = r_inner*sin(fliplr(theta));

        x = [x_outer, x_inner];
        y = [y_outer, y_inner];

        h(i) = patch(x, y, colors(i,:), ...
            'EdgeColor', 'w', ...
            'LineWidth', 1.5);
    end
end