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

            x_sim = sim("soft_switch_new_simulation_2.slx");

            Loss(i,j,k) = x_sim.Loss.Data(end);
            Vx_final(i,j,k) = x_sim.Vx.Data(end);
            PX_final(i,j,k) = x_sim.PX.Data(end);
        end
    end
end

switching_time = 1./(wn*2);

%% Plots
[WN,XDOT,OR] = meshgrid(wn,xdot,open_ratio_array);

X = log10(WN(:));     % log because wn is logspace
Y = XDOT(:);
Z = Loss(:);

K = convhull(X,Y,Z);

figure
trisurf(K,X,Y,Z,'FaceAlpha',0.3)
xlabel('log10(\omega_n)')
ylabel('xdot')
zlabel('Loss')


% j = 7;
% 
% [Ts, OR] = meshgrid(switching_time, open_ratio_array);
% Loss_slice = squeeze(Loss(:,j,:));
% 
% figure
% surf(Ts, OR, Loss_slice')
% set(gca,'XScale','log','YScale','log')
% shading interp
% xlabel('Switching Time')
% ylabel('Opening Ratio')
% zlabel('Loss')
% colorbar
% view(135,30)


% Loss2 = squeeze(Loss(:,1,:));
% [OR, Tsw] = meshgrid(open_ratio_array(1:3), switching_time*1e3);
% 
% figure;
% surf(OR, Tsw, Loss2);
% xlabel('Opening ratio');
% ylabel('Switching time (s)');
% zlabel('Loss');
% set(gca,'YScale','log'); % switching_time is also log-spaced here
% % set(gca,'Ydir', 'reverse')
% grid on;

% open_area_ratio_ind = 4;
% 
% figure;
% plot(switching_time*1e3, squeeze(Loss(:,:,open_area_ratio_ind)), 'o-', LineWidth=3);
% xlabel('Switching Time (ms)')
% ylabel('Loss (J)')
% grid on
% str = ['Throttling Losses vs. Switching Time ', 'A_{valve(max)} = ' ...
%         , num2str(open_ratio_array(open_area_ratio_ind)*param.max_Avt)];
% title(str)
% 
% set(gca,'FontSize',16,'FontWeight','bold','LineWidth',1.5)
% 
% labels = arrayfun(@(v) sprintf('$%.3f$', v), ...
%                   xdot, 'UniformOutput', false);
% 
% lgd = legend(labels,'Interpreter','latex','Location','northwest');
% lgd.FontWeight = 'bold';
% lgd.Title.String = '$Speed~of~the~piston:$';
% lgd.Title.Interpreter = 'latex';
% lgd.Title.FontWeight = 'bold';