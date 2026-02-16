clc; clear; close;

T_sim = 0.1;
P_initial = 1e6;
D = 0.8e-6;
DelP = (5)*1e6;

Nominal_vel_array = 500:50:3000;
P_drop_array = 15:1:25;

Qout_final = NaN(length(Nominal_vel_array), length(P_drop_array));
omega_in_final = NaN(length(Nominal_vel_array), length(P_drop_array));
    
Torque_in_final = NaN(length(Nominal_vel_array), length(P_drop_array));
DelP_out_final = NaN(length(Nominal_vel_array), length(P_drop_array));

omega = 1000*(pi/30);

for i = 1:length(Nominal_vel_array)

    Nominal_vel = Nominal_vel_array(i);

    for j = 1:length(P_drop_array)

        P_drop = P_drop_array(j);

        pump_sim = sim("Copy_of_test_pump.slx");

        t = pump_sim.tout;

        Qout_final(i,j) = pump_sim.Qout.Data(end);
        omega_in_final(i,j) = pump_sim.omega_in.Data(end);
    
        Torque_in_final(i,j) = pump_sim.Torque_in.Data(end);
        DelP_out_final(i,j) = pump_sim.DelP_out.Data(end);

    end
end

Qin = (D/(2*pi))*omega_in_final;
efficiency_vol = Qout_final./Qin;

Torque_out = (D/(2*pi))*DelP_out_final;
efficiency_mech = Torque_out./Torque_in_final;

%% Main plot
[X, Y] = ndgrid(Nominal_vel_array, P_drop_array);
surf(X,Y, efficiency_mech)
xlabel('Nominal Speed (RPM)')
ylabel('Nominal Pressure Drop (MPa)')
zlabel('Efficiency (%)')
