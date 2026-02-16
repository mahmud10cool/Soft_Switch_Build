clc; clear; close all;

simulation = sim("soft_switch_new_simulation.slx");
t = simulation.tout;

% ====== Signals ======
Ein = simulation.Input_Energy.Data;

W   = simulation.Work.Data;
Eo  = simulation.Output_Energy.Data;
Tl   = simulation.Throttling_Loss.Data;
Es  = simulation.Stored_Energy.Data;
Ek  = simulation.Kinetic_Energy.Data;
Pl = simulation.Pump_Losses.Data;

% ====== Energies ======
Ein   = Ein(end);

Ework = W(end);
Eout  = Eo(end);
Eloss = Tl(end);
Estor = Es(end);
Ekin  = Ek(end);
Epumploss = Pl(end);

innerEnergies = [Eloss, Ekin, Epumploss];
innerNames    = {'Throttling Loss','Kinetic', 'Pump Losses'};

innerEnergies = max(innerEnergies, 0);
Eo = max(Eo, 0);

innerFrac = innerEnergies / max(sum(innerEnergies), eps);
innerPct  = 100 * innerFrac;   % percent of input energy

%% All plot related things

% ====== Colors ======
outerColor  = "#013220";
innerColors = lines(numel(innerFrac)); % inner pie colors

% ====== Plot ======
figure; hold on;
axis equal off;

% -------- Outer Ring --------
pOuter = pie(1);
scalePie(pOuter, 1.0);

for i = 1:numel(pOuter)
    if isgraphics(pOuter(i),'patch')
        pOuter(i).FaceColor = outerColor;
    elseif isgraphics(pOuter(i),'text')
        pOuter(i).Visible = 'off';
    end
end

text(0, 0.9, ...
    sprintf(' %.0f%%\n(%.2f J))', 100, sum(innerEnergies)), ...
    'Color', 'w', ...
    'FontSize', 12, ...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center');

% -------- Inner Pie --------
pInner = pie(innerFrac);
scalePie(pInner, 0.8);

patchIdx = 1;
textIdx  = 1;

for i = 1:numel(pInner)
    if isgraphics(pInner(i),'patch')
        pInner(i).FaceColor = innerColors(patchIdx,:);
        patchIdx = patchIdx + 1;

    elseif isgraphics(pInner(i),'text')
        % Label: Name (Energy J, Percent%)
        pInner(i).String = sprintf('%.2f%%\n(%.2f J)', innerPct(textIdx), innerEnergies(textIdx));

        pInner(i).Color = 'w';      % ONLY pie text is white
        pInner(i).FontSize = 12;
        pInner(i).FontWeight = "bold";

        textIdx = textIdx + 1;
    end
end

% ====== Legend (percent + energy too) ======
legendLabels = [{sprintf('No Soft-switch Throttling Loss')},arrayfun(@(k) innerNames{k}, 1:numel(innerNames), 'UniformOutput', false)];

leg = legend(legendLabels, 'Location','southoutside');
title(leg, "Type of Loss:")
leg.FontSize = 14;

titl = title('Energy Loss Breakdown');
titl.FontSize = 16;
titl.Position(2) = titl.Position(2) + 0.08;   % increase vertical spacing

% ====== Helper Function ======
function scalePie(p, r)
    for i = 1:numel(p)
        if isgraphics(p(i),'patch')
            p(i).XData = p(i).XData * r;
            p(i).YData = p(i).YData * r;
        elseif isgraphics(p(i),'text')
            p(i).Position(1:2) = p(i).Position(1:2) * 0.5 * r;
        end
    end
end
