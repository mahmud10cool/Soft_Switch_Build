clc; clear; close;

T_sim = 0.1;

rpm_speed_array = 100:100:1600;
current = NaN(size(rpm_speed_array));

for iii = 1:length(rpm_speed_array)
    rpm_speed = rpm_speed_array(iii);
    x12 = sim("Copy_7_of_SIMSCAPE_SIM_PROTOTYPE.slx");
    current_data = x12.current.Data;
    current(iii) = current_data(end);
end

%% Plots
figure(1)
hold on
scatter(rpm_speed_array, current, LineWidth=2);
plot(rpm_speed_array, current, LineWidth=2);
xlim([0 1600])
xlabel('Speed (RPM)')
ylabel('Current (A)')
title('Current vs. Speed Graph')
grid on
hold off

some_fig = gcf;

set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2);

