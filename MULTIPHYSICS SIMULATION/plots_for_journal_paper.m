clc; clear; close all;

T_sim = 0.5;

soft_sim = sim("soft_switch_new_simulation.slx");
t_soft = soft_sim.tout;
input_energy = soft_sim.Input_Energy.Data;
output_energy = soft_sim.Output_Energy.Data;
pump_loss = soft_sim.Pump_Losses.Data;
regen = soft_sim.Regen.Data;
kinetic_energy = soft_sim.Kinetic_Energy.Data;
elec_loss = soft_sim.Elec_Losses.Data;
throttling_loss = soft_sim.Throttling_Loss.Data;
work = soft_sim.Work.Data;
stored_energy = soft_sim.Stored_Energy.Data;
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

% Subplot 1: Input Energy
subplot(2,2,1)
hold on

yyaxis left
h_left = plot(t_soft, input_energy, 'b-', ...
              t_norm, input_energy_norm, 'r-', ...
              'LineWidth', 2);
ylabel('Input Energy (J)')

yyaxis right
h_right = plot(t_soft, prv_open, 'g--', ...
               t_soft, ssv_open, 'm--', ...
               'LineWidth', 2);
ylabel('Valve Opening')

all_handles = [h_left(:); h_right(:)];
labels = {'Soft-Switch', 'Normal', 'PRV Opening', 'SSV Opening'};
legend(all_handles, labels, 'Location', 'best')

xlabel('Time (s)')
grid on
title('Input Energy vs. Time')
hold off

% Subplot 2: Throttling Loss
subplot(2,2,2)
hold on

yyaxis left
h_left = plot(t_soft, throttling_loss, 'b-', ...
              t_norm, throttling_loss_norm, 'r-', ...
              'LineWidth', 2);
ylabel('Throttling Loss (J)')

yyaxis right
h_right = plot(t_soft, prv_open, 'g--', ...
               t_soft, ssv_open, 'm--', ...
               'LineWidth', 2);
ylabel('Valve Opening')

all_handles = [h_left(:); h_right(:)];
labels = {'Soft-Switch', 'Normal', 'PRV Opening', 'SSV Opening'};
legend(all_handles, labels, 'Location', 'best')

xlabel('Time (s)')
grid on
title('Throttling Loss vs. Time')
hold off

% Subplot 3: Nested Energy Distribution Chart
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
E_kinetic = kinetic_energy(end);
E_stored = stored_energy(end);

% Outer ring: input energy + regen
outer_vals = abs([E_input, E_regen]);
outer_labels = {'Input', 'Regen'};

% Inner pie: work + losses
inner_vals = abs([E_work+E_stored, E_throt, E_pump, E_elec, E_kinetic]);
inner_labels = {'Work', 'Throttling', 'Pump', 'E-Motor Losses', 'KE'};

% Radii
inner_pie_radius = 1;
outer_ring_r1    = 1;
outer_ring_r2    = 1.5;

% Colors
outer_colors = [
    0.20 0.45 0.85
    0.20 0.70 0.35
];

inner_colors = [
    0.25 0.80 0.20
    0.90 0.35 0.30
    0.95 0.65 0.20
    0.55 0.35 0.75
    0.40 0.80 0.80
];

% Draw inner solid pie with labels and percentages
solidPieWithOutsideLabels(inner_vals, inner_pie_radius, inner_colors, inner_labels);

% Draw outer donut ring with labels and percentages
donutRingWithOutsideLabels(outer_vals, outer_ring_r1, outer_ring_r2, outer_colors, outer_labels);

title('Soft-Switch Energy Distribution', ...
      'Units', 'normalized', ...
      'Position', [0.5, 1.15, 0])

hold off

% Subplot 4: Work Comparison
subplot(2,2,4)
plot(t_soft, work, 'b-', ...
     t_norm, work_norm, 'r-', ...
     'LineWidth', 2)

ylabel('Work (J)')
xlabel('Time (s)')
legend('Soft-Switch', 'Normal', 'Location', 'best')
grid on
title('Work vs. Time')


function h = solidPieWithOutsideLabels(vals, radius, colors, labels)

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

        % Mid-angle of slice
        theta_mid = 0.5 * (theta_edges(i) + theta_edges(i+1));

        % Point on slice edge
        x_edge = radius * cos(theta_mid);
        y_edge = radius * sin(theta_mid);

        % Label box location outside pie
        r_text = 2 * radius;
        x_text = r_text * cos(theta_mid);
        y_text = r_text * sin(theta_mid);

        percent = 100 * frac(i);

        % Leader line
        plot([x_edge x_text], [y_edge y_text], 'k-', 'LineWidth', 1);

        % Alignment
        if cos(theta_mid) >= 0
            hAlign = 'left';
        else
            hAlign = 'right';
        end

        % Text box
        text(x_text, y_text, ...
            sprintf('%s\n%.1f%%', labels{i}, percent), ...
            'HorizontalAlignment', hAlign, ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 9, ...
            'FontWeight', 'bold', ...
            'BackgroundColor', 'w', ...
            'EdgeColor', 'k', ...
            'Margin', 4);
    end
end

function h = donutRingWithOutsideLabels(vals, r_inner, r_outer, colors, labels)

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

        % Mid-angle of slice
        theta_mid = 0.5 * (theta_edges(i) + theta_edges(i+1));

        % Point on outer edge
        x_edge = r_outer * cos(theta_mid);
        y_edge = r_outer * sin(theta_mid);

        % Label box location outside donut
        r_text = 1.25 * r_outer;
        x_text = r_text * cos(theta_mid);
        y_text = r_text * sin(theta_mid);

        percent = 100 * frac(i);

        % Leader line
        plot([x_edge x_text], [y_edge y_text], 'k-', 'LineWidth', 1);

        % Alignment
        if cos(theta_mid) >= 0
            hAlign = 'left';
        else
            hAlign = 'right';
        end

        % Text box
        text(x_text, y_text, ...
            sprintf('%s\n%.1f%%', labels{i}, percent), ...
            'HorizontalAlignment', hAlign, ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 9, ...
            'FontWeight', 'bold', ...
            'BackgroundColor', 'w', ...
            'EdgeColor', 'k', ...
            'Margin', 4);
    end
end