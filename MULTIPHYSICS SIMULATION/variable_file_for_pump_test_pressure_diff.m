clc; clear; close;

T_sim = 0.1;
P_initial = 1e6;
D = 0.8e-6;
DelP_array = (0.25:0.1:22)*1e6;

Nominal_vel = 1000;
P_drop = 21;

Qout_final = NaN(size(DelP_array));
omega_in_final = NaN(size(DelP_array));

Torque_in_final = NaN(size(DelP_array));
DelP_out_final = NaN(size(DelP_array));

string1 = 'Percentage Complete: ';

omega = 1000*(pi/30);

for i = 1:length(DelP_array)

    DelP = DelP_array(i);

    pump_sim = sim("Copy_of_test_pump.slx");

    t = pump_sim.tout;

    Qout_final(i) = pump_sim.Qout.Data(end);
    omega_in_final(i) = pump_sim.omega_in.Data(end);
    
    Torque_in_final(i) = pump_sim.Torque_in.Data(end);
    DelP_out_final(i) = pump_sim.DelP_out.Data(end);

    string2 = [string1, num2str(100*i/length(DelP_array))];
    disp(string2);
    
end

Qin = (D/(2*pi))*omega_in_final;
efficiency_vol = Qout_final./Qin;

Torque_out = (D/(2*pi))*DelP_out_final;
efficiency_mech = Torque_out./Torque_in_final;

%% Main plot
figure(1)
hold on;
plot(DelP_out_final*1e-6, efficiency_vol*100, LineWidth=3, Color='#00C4FE');
plot(DelP_out_final*1e-6, 100*efficiency_mech.*efficiency_vol, LineWidth=3, Color='r');
ylim([20 100])
xlim([0 DelP_out_final(end)*1e-6])
yticks(20:10:100);
xlabel('Pressure (MPa)')
ylabel('Efficiency (%)')
% title('Efficiency vs Pressure')
lgd = legend('Volumetric Efficiency', 'Total Efficiency');
lgd.Location = "southeast";
grid on
set(gca,'Color','#CCFFCC', LineWidth=2, GridColor='k', GridAlpha=0.6, FontWeight='bold')
hold off;

set(gcf, 'position', [0, 0, 500, 275])

% figure(2)
% plot(DelP_out_final*1e-6, efficiency_mech*100, LineWidth=2);
% yticks([20 40 60 80 100]);
% xlabel('Pressure (MPa)')
% ylabel('Mechanical Efficiency (%)')
% title('Pump Mechanical Efficiency vs Pressure')
% grid on
% 
% figure(3)
% plot(DelP_out_final*1e-6, 100*efficiency_mech.*efficiency_vol, LineWidth=2);
% xticks([20 40 60 80 100]);
% xlabel('Pressure (MPa)')
% ylabel('Overall Efficiency (%)')
% title('Overall Efficiency vs Pressure')
% grid on