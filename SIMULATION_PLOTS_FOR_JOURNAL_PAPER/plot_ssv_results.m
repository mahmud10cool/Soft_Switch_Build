%% Plot saved SSV results (no simulation is run)
% Put this script beside soft_switch_results.mat and click Run.
% Inputs: pressure [Pa], flow [m^3/s], omega [rad/s], torque [N*m],
%         power [W], energy [J]. Original flow signs are preserved.
% All extracted signals must share the t_soft time vector.
clc; clear; close all;
run param_file_2.m

script_dir = fileparts(mfilename('fullpath'));
mat_file = fullfile(script_dir, 'soft_switch_valve_2.mat');
time_in_ms = false; % Set true ONLY if t_soft was saved in milliseconds.

if ~isfile(mat_file)
    [filename, folder] = uigetfile('*.mat', 'Select saved simulation results');
    if isequal(filename, 0)
        return
    end
    mat_file = fullfile(folder, filename);
end

names = {'t_soft','qP','qA','qB','qT','pA','pP','pT','pX', ...
    'throttling_loss_SSV','throttle_power_SSV','ssv_open', ...
    'Px_chamber','omega_rot','pump_torque'};
S = load(mat_file, names{:});
for k = 1:numel(names)
    name = names{k};
    assert(isfield(S, name), 'Missing variable in MAT file: %s', name);
    assert(isnumeric(S.(name)) && isvector(S.(name)), ...
        '%s must be a numeric vector.', name);
    values = S.(name);
    S.(name) = values(:);
end
n = numel(S.t_soft);
assert(n >= 2 && all(isfinite(S.t_soft)) && all(diff(S.t_soft) >= 0) ...
    && S.t_soft(end) > S.t_soft(1), 't_soft must increase over the run.');
for k = 2:numel(names)
    assert(numel(S.(names{k})) == n, ...
        '%s does not match t_soft. Export signals on a common time grid.', names{k});
end

t = S.t_soft;
if time_in_ms
    t = t / 1000;
end
t_ms = t;
rpm = S.omega_rot * 60 / (2*pi);
flow_scale = 60000; % m^3/s -> L/min
lw = 1.5;
ax = gobjects(6, 1);

%% Calculate power loss through each SSV orifice
% Use the same param values as the saved simulation.

x = max(-1, min(1, S.ssv_open));
db = 0.02;

f = max(0, min(1, (abs(x) - db)/(1 - db)));

center   = abs(x) <= db;
positive = x > db;
negative = x < -db;

% Opening area of each passage [m^2]
A_PA = param.max_Avt .* f .* positive;
A_BT = param.max_Avt .* f .* positive;

A_PB = param.max_Avt .* f .* negative;
A_AT = param.max_Avt .* f .* negative;

A_PT = param.max_Avt .* double(center);
A_AB = param.max_Avt .* double(center);

% Pressures [Pa]
PA = S.pA;
PP = S.pP;
PT = S.pT;
PB = S.pX;  % Valid if pX is the pressure fed to the SSV's PB input.
% Otherwise use the separately logged B-port pressure.

% Pressure differences [Pa]
dP_PA = PP - PA;
dP_PB = PP - PB;
dP_AT = PA - PT;
dP_BT = PB - PT;
dP_PT = PP - PT;
dP_AB = PA - PB;

% Signed internal orifice flows [m^3/s]
orifice_flow = @(A, dP) param.Cd .* A .* sign(dP) ...
    .* sqrt((2/param.rho) .* abs(dP));

Q_PA = orifice_flow(A_PA, dP_PA);
Q_PB = orifice_flow(A_PB, dP_PB);
Q_AT = orifice_flow(A_AT, dP_AT);
Q_BT = orifice_flow(A_BT, dP_BT);
Q_PT = orifice_flow(A_PT, dP_PT);
Q_AB = orifice_flow(A_AB, dP_AB);

% Power dissipated through each orifice [W]
% loss_PA = abs(Q_PA) .* abs(dP_PA);
% loss_PB = abs(Q_PB) .* abs(dP_PB);
% loss_AT = abs(Q_AT) .* abs(dP_AT);
% loss_BT = abs(Q_BT) .* abs(dP_BT);
% loss_PT = abs(Q_PT) .* abs(dP_PT);
% loss_AB = abs(Q_AB) .* abs(dP_AB);

loss_PA = Q_PA .* dP_PA;
loss_PB = Q_PB .* dP_PB;
loss_AT = Q_AT .* dP_AT;
loss_BT = Q_BT .* dP_BT;
loss_PT = Q_PT .* dP_PT;
loss_AB = Q_AB .* dP_AB;

SSV_power_calc = loss_PA + loss_PB + loss_AT ...
    + loss_BT + loss_PT + loss_AB;

%% Figure 1: valve command/position, pressures, and flows
f1 = figure('Name','SSV hydraulic signals','Color','w', ...
    'Position',[60 60 1100 850]);
tiledlayout(f1,3,2,'TileSpacing','compact','Padding','compact');

ax(1) = nexttile;
plot(t_ms,S.ssv_open,'k','LineWidth',lw);
ylabel('SSV position'); ylim([-1.15 1.15]); yticks([-1 0 1]); xlabel('Time (ms)');
title('SSV opening');

ax(2) = nexttile;
plot(t_ms,[S.pA S.pP S.pT S.pX]/1e6,'LineWidth',lw);
hold on
pressure_labels = {'P_A','P_P','P_T','P_X'};
% pX and Px_chamber often contain the same chamber pressure. Avoid
% hiding identical traces; plot both only when their values differ.
if ~isequaln(S.pX,S.Px_chamber)
    plot(t_ms,S.Px_chamber/1e6,'k--','LineWidth',lw);
    pressure_labels{end+1} = 'P_{X,chamber}';
end
ylabel('Pressure (MPa)'); title('Port and chamber pressures'); xlabel('Time (ms)');
legend(pressure_labels,'Location','best');

ax(3) = nexttile;
plot(t_ms,[S.qP S.qA S.qB S.qT]*flow_scale,'LineWidth',lw);
yline(0,':','HandleVisibility','off');
ylabel('Flow (L/min)'); xlabel('Time (ms)');
title('Signed SSV port flows');
legend('Q_P','Q_A','Q_B','Q_T','Location','best');

% %% Figure 2: shaft response and valve dissipation
% f2 = figure('Name','SSV shaft response and losses','Color','w', ...
%     'Position',[120 80 1100 850]);
% tiledlayout(f2,3,1,'TileSpacing','compact','Padding','compact');

ax(4) = nexttile;
yyaxis left
h_speed = plot(t_ms,rpm,'b','LineWidth',lw);
ylabel('Speed (rpm)');
yyaxis right
h_torque = plot(t_ms,S.pump_torque,'r','LineWidth',lw);
ylabel('Pump torque (N m)'); xlabel('Time (ms)');
title('Shaft speed and pump torque');
legend([h_speed h_torque],{'Speed','Pump torque'},'Location','best');

ax(5) = nexttile;
plot(t_ms,S.throttle_power_SSV,'Color',[0.85 0.33 0.1],'LineWidth',lw);
yline(0,':','HandleVisibility','off');
ylabel('Power (W)'); title('SSV throttling power'); xlabel('Time (ms)');
ylim([-0.5, 10])

ax(6) = nexttile;
plot(t_ms,S.throttling_loss_SSV,'b','LineWidth',lw);
ylabel('Energy (J)'); xlabel('Time (ms)');
title('Cumulative SSV throttling loss');

% Zoom/pan in time on any panel updates both figures.
for k = 1:numel(ax)
    grid(ax(k),'on'); box(ax(k),'on');
    set(ax(k),'FontSize',11,'LineWidth',1);
    xlim(ax(k),[t_ms(1) t_ms(end)]);
end
linkaxes(ax,'x');

% Optional: export the figures beside the MAT file.
% exportgraphics(f1,fullfile(fileparts(mat_file),'SSV_hydraulics.png'),'Resolution',300);
% exportgraphics(f2,fullfile(fileparts(mat_file),'SSV_losses.png'),'Resolution',300);

%% Figure 2
figure(2); clf;
tiledlayout(3,1,'TileSpacing','compact','Padding','compact');

% Power loss through each orifice
ax_loss = nexttile;

colors = lines(6);

% Cumulative energy loss through each orifice [J]
loss_energy = cumtrapz(t_ms(:)/1000, ...
    [loss_PA(:) loss_PB(:) loss_AT(:) ...
    loss_BT(:) loss_PT(:) loss_AB(:)]);

yyaxis left
h = plot(t_ms, loss_energy, 'LineWidth', lw);

for k = 1:6
    set(h(k), 'Color', colors(k,:), ...
        'LineStyle', '-', 'Marker', 'none');
end

ax_loss.YAxis(1).Color = 'k';
ylabel('Energy loss (J)');
xlabel('Time (ms)');
title('Cumulative SSV energy loss through each orifice');

yyaxis right
plot(t_ms, S.ssv_open, 'k', 'LineWidth', lw);
ylabel('SSV position');
ylim([-1.2 1.2]);
yticks([-1 0 1]);
ax_loss.YAxis(2).Color = 'k';

title('SSV loss through each orifice');
legend('P-A','P-B','A-T','B-T','P-T','A-B','SSV position', ...
    'Location','best');
grid on;

% Signed pressure difference across each orifice
ax_dp = nexttile;

yyaxis left
h = plot(t_ms, [dP_PA dP_PB dP_AT dP_BT dP_PT dP_AB]/1e6, ...
    'LineWidth', lw);

for k = 1:6
    set(h(k), 'Color', colors(k,:), 'LineStyle', '-', 'Marker', 'none');
end
ax_dp.YAxis(1).Color = 'k';

yyaxis right
plot(t_ms, S.ssv_open, 'k', 'LineWidth', lw);
ylabel('SSV position');
ylim([-1.2 1.2]);
yticks([-1 0 1]);
ax_dp.YAxis(2).Color = 'k';

xlabel('Time (ms)');
title('Pressure difference across each orifice');
legend('P_P-P_A','P_P-P_B','P_A-P_T', ...
    'P_B-P_T','P_P-P_T','P_A-P_B','SSV position', ...
    'Location','best');
grid on;

% linkaxes([ax_loss ax_dp],'x');

% Signed flow through each SSV orifice
ax_flow = nexttile;

yyaxis left
h = plot(t_ms, ...
    [Q_PA Q_PB Q_AT Q_BT Q_PT Q_AB] * flow_scale, ...
    'LineWidth', lw);

for k = 1:6
    set(h(k), 'Color', colors(k,:), ...
        'LineStyle', '-', 'Marker', 'none');
end

ax_flow.YAxis(1).Color = 'k';
ylabel('Flow (L/min)');
yline(0,':','HandleVisibility','off');

yyaxis right
plot(t_ms, S.ssv_open, 'k', 'LineWidth', lw);
ylabel('SSV position');
ylim([-1.2 1.2]);
yticks([-1 0 1]);
ax_flow.YAxis(2).Color = 'k';

xlabel('Time (ms)');
title('Signed flow through each SSV orifice');

legend('P-A','P-B','A-T','B-T','P-T','A-B','SSV position', ...
    'Location','best');

grid on;

linkaxes([ax_loss ax_dp ax_flow],'x');

%% Figure 3: A-B Orifice Only
figure(3); clf;
tiledlayout(3,1,'TileSpacing','compact','Padding','compact');

color_AB = colors(6,:);

% 1. Cumulative A-B energy loss
ax_AB_loss = nexttile;

yyaxis left
plot(t_ms, loss_energy(:,6), ...
    'Color',color_AB,'LineWidth',lw);
ylabel('Energy loss (J)');
ax_AB_loss.YAxis(1).Color = 'k';

% yyaxis right
% plot(t_ms,S.ssv_open,'k','LineWidth',lw);
% ylabel('SSV position');
% ylim([-1.2 1.2]);
% yticks([-1 0 1]);
% ax_AB_loss.YAxis(2).Color = 'k';

title('Cumulative A-B throttling loss');
legend('A-B energy loss','SSV position','Location','best');
grid on;

% 2. Pressure difference across A-B
ax_AB_dp = nexttile;

yyaxis left
plot(t_ms,dP_AB/1e6, ...
    'Color',color_AB,'LineWidth',lw);
ylabel('Pressure difference (MPa)');
ax_AB_dp.YAxis(1).Color = 'k';
% ylim([-0.5, 0.5])

% yyaxis right
% plot(t_ms,S.ssv_open,'k','LineWidth',lw);
% ylabel('SSV position');
% ylim([-1.2 1.2]);
% yticks([-1 0 1]);
% ax_AB_dp.YAxis(2).Color = 'k';

title('A-B pressure difference (P_A - P_B)');
legend('P_A - P_B','SSV position','Location','best');
grid on;

% 3. Signed flow through A-B
ax_AB_flow = nexttile;

yyaxis left
plot(t_ms,Q_AB*flow_scale, ...
    'Color',color_AB,'LineWidth',lw);
ylabel('Flow (L/min)');
yline(0,':','HandleVisibility','off');
ax_AB_flow.YAxis(1).Color = 'k';

% yyaxis right
% plot(t_ms,S.ssv_open,'k','LineWidth',lw);
% ylabel('SSV position');
% ylim([-1.2 1.2]);
% yticks([-1 0 1]);
% ax_AB_flow.YAxis(2).Color = 'k';

xlabel('Time (ms)');
title('Signed A-B orifice flow');
legend('Q_{AB}','SSV position','Location','best');
grid on;

% Link x-axes
linkaxes([ax_AB_loss ax_AB_dp ax_AB_flow],'x');