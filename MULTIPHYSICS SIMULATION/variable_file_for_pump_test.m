clc; clear; close;

T_sim = 0.1;
P_initial = 1e6;
D = 0.8e-6;

Nominal_vel = 1000;
P_drop = 21;

omega_array = (100:50:3000)*(pi/30);
Qout_final = NaN(size(omega_array));
omega_in_final = NaN(size(omega_array));

Torque_in_final = NaN(size(omega_array));
DelP_out_final = NaN(size(omega_array));

string1 = 'Percentage Complete: ';

DelP = 21e6;

for i = 1:length(omega_array)
    omega = omega_array(i);
    pump_sim = sim("test_pump.slx");

    t = pump_sim.tout;

    Qout_final(i) = pump_sim.Qout.Data(end);
    omega_in_final(i) = pump_sim.omega_in.Data(end);
    
    Torque_in_final(i) = pump_sim.Torque_in.Data(end);
    DelP_out_final = pump_sim.DelP_out.Data(end);

    string2 = [string1, num2str(100*i/length(omega_array))];
    disp(string2);
    
end

Qin = (D/(2*pi))*omega_in_final;
efficiency_vol = Qout_final./Qin;

Torque_out = (D/(2*pi))*DelP_out_final;
efficiency_mech = Torque_out./Torque_in_final;

%% Main plot
figure(1)
plot(omega_in_final*(30/pi), efficiency_vol*100, LineWidth=2);
xlabel('Speed (RPM)')
ylabel('Volumetric Efficiency (%)')
title('Pump Volumetric Efficiency vs Speed')
xlim([100 3000])
xticks([100, 500:500:3000])
grid on

some_fig = gcf;

% sgtitle('Multi-Physics Simulation (Simscape)','FontName','Arial','FontSize',18,'FontWeight','Bold', 'LineWidth', 2)
set(findobj(some_fig,'type','axes'),'FontName','Arial','FontSize',15,'FontWeight','Bold', 'LineWidth', 2);

figure(2)
plot(omega_in_final*(30/pi), efficiency_mech*100, LineWidth=2);
xlabel('Speed (RPM)')
ylabel('Mechanical Efficiency (%)')
title('Pump Mechanical Efficiency vs Speed')
xlim([100 3000])
xticks([100, 500:500:3000])
grid on

figure(3)
plot(omega_in_final*(30/pi), 100*efficiency_mech.*efficiency_vol, LineWidth=2);
xlabel('Speed (RPM)')
ylabel('Overall Efficiency (%)')
title('Overall Efficiency vs Speed')
xlim([100 3000])
xticks([100, 500:500:3000])
grid on

