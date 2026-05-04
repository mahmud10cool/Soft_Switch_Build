clc; clear; %close all;

run param_file.m

T_sim = 0.25;

param.wn = 1000;
param.xddot = 0e-3;
param.open_ratio = 1;
param.valve_buffer = 0;
param.initial_stroke = 0;

x_sim = sim("Copy_of_no_soft_switch_sim.slx");

Loss = x_sim.Throttling_Loss.Data(end);
Vx_final = x_sim.Vx.Data(end);
PX_final = x_sim.Px.Data(end);

disp(Loss)
disp(Vx_final)
disp(PX_final)

% %% Start simulation here and take data
% param.zeta = 1;
% % opening_ratio = 2;
% 
% wn_size = 20;
% wn = logspace(2,6,wn_size);
% 
% xdot_size = 7;
% xdot = linspace(0,6e-2,xdot_size);
% 
% open_ratio_array = [100, 1000, 10000];
% open_ratio_size = length(open_ratio_array);
% 
% Loss = NaN(wn_size,xdot_size,open_ratio_size);
% Vx_final = NaN(wn_size,xdot_size,open_ratio_size);
% PX_final = NaN(wn_size,xdot_size,open_ratio_size);
% 
% total_cases = wn_size * xdot_size * length(open_ratio_array);
% case_count = 0;
% 
% for i = 1:wn_size
%     for j = 1:xdot_size
%         for k = 1:length(open_ratio_array)
%             param.wn = wn(i);
%             param.xdot = xdot(j);
%             opening_ratio = open_ratio_array(k);
% 
%             x_sim = sim("Copy_of_no_soft_switch_sim.slx");
% 
%             Loss(i,j,k) = x_sim.Throttling_Loss.Data(end);
%             Vx_final(i,j,k) = x_sim.Vx.Data(end);
%             PX_final(i,j,k) = x_sim.Px.Data(end);
% 
%             case_count = case_count + 1;
%             percent_complete = 100 * case_count / total_cases;
% 
%             fprintf('Progress: %.1f%% complete\n', percent_complete);
%         end
%     end
% end
% 
% switching_time = 1./(wn*2);
% 
% %% Plot code here
% % I think I am going to just a 2D plot. 
% % 3D plots don't show what I want it to show.
% 
% open_ratio_index = 1;
% 
% figure(1)
% h = plot(switching_time, squeeze(Loss(:,:,open_ratio_index)), LineWidth=2);
% xlabel('Switching Time (s)')
% ylabel('Loss (J)')
% 
% grid on
% 
% % Create legend labels using xdot values
% % legend_labels = arrayfun(@(v) ...
% %     sprintf('$\\dot{x}_{max} = %.3g$', v), ...
% %     xdot, ...
% %     'UniformOutput', false);
% 
% % lgd =  legend(legend_labels, ...
% %      'Interpreter','latex', ...
% %      'Location','northwest');
% 
% lgd = legend(arrayfun(@(v) sprintf('%.3g', v), xdot, ...
%     'UniformOutput', false), Location="northwest");
% 
% title(lgd, '$\dot{x}_{max}$', 'Interpreter','latex');
% 
% some_fig = gcf;
% 
% % some_string = ['Throttling Loss vs. Switching Time',' (A_{v}(t) = ', ... 
% %     num2str(open_ratio_array(open_ratio_index)*param.max_Avt*1e4),'cm^2)'];
% % 
% % sgtitle(some_string,'FontName','Arial','FontSize',18,'FontWeight',...
% %     'Bold', 'LineWidth', 2)
% % set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',15,...
% %     'FontWeight','Bold', 'LineWidth', 2);