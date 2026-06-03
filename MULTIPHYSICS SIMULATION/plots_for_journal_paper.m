clc; clear; close all;

T_sim = 0.5;

soft_sim = sim("soft_switch_new_simulation.slx");
t_soft = soft_sim.tout;
input_energy = soft_sim.Input_Energy.Data;
hyd_in_energy = soft_sim.Hydraulic_Input.Data;
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
Px_chamber = soft_sim.Px.Data;
Pdesired = soft_sim.Pdes.Data;
omega_rot = soft_sim.omega.Data;
regen_torque = soft_sim.regen_torque.Data;

normal_sim = sim("no_soft_switch_sim.slx");
t_norm = normal_sim.tout;
input_energy_norm = normal_sim.Input_Energy.Data;
output_energy_norm = normal_sim.Output_Energy.Data;
work_norm = normal_sim.Work.Data;
throttling_loss_norm = normal_sim.Throttling_Loss.Data;
prv_open_norm = normal_sim.PRV_Opening.Data;

%% Plots
figure(1)

subplot(5,1,1)
yyaxis left
h_left = plot(t_soft, Px_chamber, 'b-', ...
              t_soft, Pdesired, 'r-', ...
              'LineWidth', 2);
ylabel('Pressure (Pa)')


% yyaxis right
% h_right = plot(t_soft, prv_open, 'c--', ...
%                t_soft, ssv_open, 'm--', ...
%                'LineWidth', 2);
% ylabel('Valve Opening')
% 
% ylim([min(prv_open) 1.2*max(prv_open)])

all_handles = [h_left(:)];
labels = {'Chamber', 'Desired'};
legend(all_handles, labels, 'Location', 'best')
% 
% xlabel('Time (s)')
grid on
% title('Pressure vs. Time')
hold off

subplot(5,1,2)
% yyaxis left
h_left_2 = plot(t_soft, omega_rot, 'b-', 'LineWidth', 2);
ylabel('Rotational Speed (rads^{-1})')

yyaxis right
h_right_2 = plot(t_soft, regen_torque, 'r-', 'LineWidth', 2);
ylabel('Torque (Nm)')
% 
all_handles_2 = [h_left_2(:), h_right_2(:)];
labels = {'Speed', 'Torque'};
legend(all_handles_2, labels, 'Location', 'best')

% xlabel('Time (s)')
grid on
% title('Speed and Torque vs. Time')
hold off

% Subplot 1: Input Energy
subplot(5,1,3)
hold on

% yyaxis left
h_left = plot(t_soft, input_energy, 'b-', ...
              t_norm, input_energy_norm, 'r-', ...
              'LineWidth', 2);
ylabel('Input Energy (J)')

ylim([min(input_energy_norm) 1.2*max(input_energy_norm)])

% yyaxis right
% h_right = plot(t_soft, prv_open, 'c--', ...
%                t_soft, ssv_open, 'm--', ...
%                'LineWidth', 2);
% ylabel('Valve Opening')
% 
% ylim([min(prv_open) 1.2*max(prv_open)])
% 
all_handles = [h_left(:)];
labels = {'Soft-Switch', 'Normal'};
legend(all_handles, labels, 'Location', 'best')

% xlabel('Time (s)')
grid on
% title('Input Energy vs. Time')
hold off

% Subplot 4: Throttling Loss
subplot(5,1,4)
hold on

% yyaxis left
% h_left = plot(t_soft, throttling_loss, 'b-', ...
%               t_norm, throttling_loss_norm, 'r-', ...
%               t_soft, kinetic_energy, 'g-', ...
%               'LineWidth', 2);
% ylabel('Throttling Loss (J)')

h_left = plot(t_soft, throttling_loss, 'b-', ...
              t_norm, throttling_loss_norm, 'r-', ...
              t_soft, -regen, 'g-', ...
              t_soft, (pump_loss+elec_loss), 'm-', ...
              'LineWidth', 2);
ylabel('Throttling Loss (J)')

ylim([min(throttling_loss_norm) 1.2*max(throttling_loss_norm)])
% 
% yyaxis right
% h_right = plot(t_soft, prv_open, 'c--', ...
%                t_soft, ssv_open, 'm--', ...
%                'LineWidth', 2);
% ylabel('Valve Opening')
% 
% ylim([min(prv_open) 1.2*max(prv_open)])

all_handles = [h_left(:)];
% labels = {'Soft-Switch', 'Normal','Kinetic Energy'};
labels = {'Soft-Switch', 'Normal','Regen', 'Pump + Motor Losses'};
legend(all_handles, labels, 'Location', 'best')

grid on
% title('Throttling Loss vs. Time')
hold off

subplot(5,1,5)
h_right = plot(t_soft, prv_open, 'k-', ...
               t_soft, ssv_open, 'k--', ...
               'LineWidth', 2);
ylabel('Valve Position')

ylim([min(prv_open) 1.2*max(prv_open)])

all_handles = [h_right(:)];
labels = {'PRV', 'SSV'};
legend(all_handles, labels, 'Location', 'best')

grid on
xlabel('Time (s)')

sgtitle('Soft-Switch vs. Normal System Energy Comparison for One Switch', ...
        'FontSize', 14, ...
        'FontWeight', 'bold')

% Format all axes
all_axes = findall(gcf, 'Type', 'axes');
set(all_axes, ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'LineWidth', 1.2);

% Format all legends
all_legends = findall(gcf, 'Type', 'legend');
set(all_legends, ...
    'FontSize', 10, ...
    'FontWeight', 'bold');

x0 = 50;
y0 = 50;
width = 900;
height = 900;
set(gcf,'position',[x0,y0,width,height])

saveas(gcf, 'parameters_vs_time.png')


%% Pie Charts
figure(2)
% Subplot 3: Nested Energy Distribution Chart
subplot(1,2,2)
cla
hold on
axis equal
axis off
xlim([-2.4 2.4])
ylim([-2.0 2.2])

% Final energy values for soft-switch case
E_input        = input_energy(end);
E_hyd_in       = hyd_in_energy(end);
E_regen        = regen(end);

E_work         = work(end);
E_throt        = throttling_loss(end);
E_pump_loss    = pump_loss(end);
E_elec_loss    = elec_loss(end);
E_kinetic      = kinetic_energy(end);
E_stored       = stored_energy(end);

% Outer ring: input energy + regen
outer_vals   = abs([E_hyd_in]);
outer_labels = {'Input'};

% Inner pie: work + stored + losses + KE
inner_vals   = abs([(E_work + E_stored), E_throt, E_regen, E_pump_loss, E_elec_loss]);
inner_labels = {'Work', 'Throttling', 'Regen', 'Pump Losses', 'E-Motor Losses'};

% Radii
inner_pie_radius = 1.0;
outer_ring_r1    = 1.0;
outer_ring_r2    = 1.5;

% Colors
outer_colors = [
    0.20 0.45 0.85
];

inner_colors = [
    0.95 0.65 0.20
    0.90 0.35 0.30
    0.25 0.80 0.20
    0.55 0.35 0.75
    0.40 0.80 0.80
];

% Draw shapes first
solidPieOnly(inner_vals, inner_pie_radius, inner_colors);
donutRingOnly(outer_vals, outer_ring_r1, outer_ring_r2, outer_colors);

% Draw labels and leader lines after the shapes
addPieOutsideLabels(inner_vals, inner_pie_radius, inner_colors, inner_labels, 1.85);
addDonutOutsideLabels(outer_vals, outer_ring_r2, outer_colors, outer_labels, 2.25);

% plot([-1.5 -10.15], [0 0], ...
%     '-', 'Color', 'k', 'LineWidth', 1.5);
% 

title('Soft-Switch Energy Distribution', ...
      'Units', 'normalized', ...
      'Position', [0.5, 1.12, 0])

hold off

% Subplot 4: Work Comparison
subplot(1,2,1)
cla
hold on
axis equal
axis off
xlim([-2.4 2.4])
ylim([-2.0 2.2])


% Final energy values for soft-switch case
E_input_norm   = input_energy_norm(end);

E_work_norm    = work_norm(end);
E_throt   = throttling_loss_norm(end);

% Outer ring: input energy + regen
outer_vals_norm   = abs([E_input_norm]);
outer_labels = {'Input'};

% Inner pie: work + stored + losses + KE
inner_vals_norm   = abs([E_work_norm, E_throt]);
inner_labels = {'Work', 'Throttling'};

% Radii
inner_pie_radius = 1.0;
outer_ring_r1    = 1.0;
outer_ring_r2    = 1.5;

% Colors
outer_colors = [
    0.20 0.45 0.85
];

inner_colors = [
    % 0.95 0.65 0.20
    0.90 0.35 0.30
];

% Draw shapes first
solidPieOnly(inner_vals_norm, inner_pie_radius, inner_colors);
donutRingOnly(outer_vals_norm, outer_ring_r1, outer_ring_r2, outer_colors);

% Draw labels and leader lines after the shapes
addPieOutsideLabels(inner_vals_norm, inner_pie_radius, inner_colors, inner_labels, 1.85);
addDonutOutsideLabels(outer_vals_norm, outer_ring_r2, outer_colors, outer_labels, 2.25);

% plot([-1.5 -10.15], [0 0], ...
%     '-', 'Color', 'k', 'LineWidth', 1.5);
% 

title('Normal Switching Energy Distribution', ...
      'Units', 'normalized', ...
      'Position', [0.5, 1.12, 0])

hold off

sgtitle('Soft-Switch vs. Normal System Energy Comparison for One Switch', ...
        'FontSize', 14, ...
        'FontWeight', 'bold')

% Format all axes
all_axes = findall(gcf, 'Type', 'axes');
set(all_axes, ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'LineWidth', 1.2);

% Format all legends
all_legends = findall(gcf, 'Type', 'legend');
set(all_legends, ...
    'FontSize', 10, ...
    'FontWeight', 'bold');

% % Format all subplot titles
% all_titles = findall(gcf, 'Type', 'text');
% set(all_titles, ...
%     'FontWeight', 'bold');



%% Helper Functions

function h = solidPieOnly(vals, radius, colors)

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

function h = donutRingOnly(vals, r_inner, r_outer, colors)

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

function addPieOutsideLabels(vals, radius, colors, labels, r_text)

    vals = vals(:);
    vals = abs(vals);
    total = sum(vals);

    if total == 0
        return
    end

    frac = vals / total;
    theta_edges = [0; cumsum(frac) * 2*pi];

    for i = 1:length(vals)

        theta_mid = 0.5 * (theta_edges(i) + theta_edges(i+1));

        % Start point on slice edge
        x_edge = radius * cos(theta_mid);
        y_edge = radius * sin(theta_mid);

        % Text box location
        x_text = r_text * cos(theta_mid);
        y_text = r_text * sin(theta_mid);

        percent = 100 * frac(i);

        % Alignment
        if cos(theta_mid) >= 0
            hAlign = 'left';
        else
            hAlign = 'right';
        end

        % Leader line in slice color
        plot([x_edge x_text], [y_edge y_text], ...
            '-', 'Color', colors(i,:), 'LineWidth', 1.5);

        % Text box with matching color
        text(x_text, y_text, ...
            sprintf('%s\n%.1f%%', labels{i}, percent), ...
            'HorizontalAlignment', hAlign, ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 9, ...
            'FontWeight', 'bold', ...
            'Color', colors(i,:), ...
            'BackgroundColor', 'w', ...
            'EdgeColor', colors(i,:), ...
            'Margin', 4);
    end
end

function addDonutOutsideLabels(vals, r_outer, colors, labels, r_text)

    vals = vals(:);
    vals = abs(vals);
    total = sum(vals);

    if total == 0
        return
    end

    frac = vals / total;
    theta_edges = [0; cumsum(frac) * 2*pi];

    for i = 1:length(vals)

        theta_mid = 0.5 * (theta_edges(i) + theta_edges(i+1));

        % Start point on donut outer edge
        x_edge = r_outer * cos(theta_mid);
        y_edge = r_outer * sin(theta_mid);

        % Text box location
        x_text = r_text * cos(theta_mid);
        y_text = r_text * sin(theta_mid);

        percent = 100 * frac(i);

        % Alignment
        if cos(theta_mid) >= 0
            hAlign = 'left';
        else
            hAlign = 'right';
        end

        % Leader line in slice color
        plot([x_edge x_text], [y_edge y_text], ...
            '-', 'Color', colors(i,:), 'LineWidth', 1.5);

        % Text box with matching color
        text(x_text, y_text, ...
            sprintf('%s\n%.1f%%', labels{i}, percent), ...
            'HorizontalAlignment', hAlign, ...
            'VerticalAlignment', 'middle', ...
            'FontSize', 9, ...
            'FontWeight', 'bold', ...
            'Color', colors(i,:), ...
            'BackgroundColor', 'w', ...
            'EdgeColor', colors(i,:), ...
            'Margin', 4);
    end
end