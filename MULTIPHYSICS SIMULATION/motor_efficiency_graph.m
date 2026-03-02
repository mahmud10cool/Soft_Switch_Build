clear; clc; close all;

%% Motor parameters (429271)
V  = 36;                % Nominal voltage [V]
Kt = 0.109;             % Torque constant [Nm/A]
R  = 0.522;             % Phase-to-phase resistance [Ohm]
I0 = 0.348;             % No-load current [A]
n0 = 3120;              % No-load speed [rpm]

%% Derived quantities
w0 = n0 * 2*pi/60;      % No-load speed [rad/s]

% Estimate viscous friction coefficient from no-load losses
T_loss0 = Kt * I0;              % Loss torque at no-load
B = T_loss0 / w0;               % Viscous friction coefficient

%% Torque range (0 to near stall)
T_stall = Kt * (V/R);           % Approx stall torque
T = linspace(0, 0.95*T_stall, 500);

%% Preallocate
eff = zeros(size(T));
speed = zeros(size(T));

for k = 1:length(T)

    % Required current for that torque
    I = T(k)/Kt + I0;  % include no-load current offset
    
    % Speed from DC motor equation:
    % V = I*R + Ke*w  (Ke ≈ Kt in SI units)
    w = (V - I*R)/Kt;
    
    % Mechanical power
    P_mech = T(k) * w;
    
    % Electrical input power
    P_in = V * I;
    
    % Efficiency
    eff(k) = P_mech / P_in;
    
    speed(k) = w * 60/(2*pi); % rpm
end

%% Plot Efficiency vs Torque
figure
plot(T, eff*100, 'LineWidth', 2)
xlabel('Torque (N·m)')
ylabel('Efficiency (%)')
title('Efficiency vs Torque – Maxon 429271')
grid on
ylim([0 100])

%% Plot Speed vs Torque (sanity check)
figure
plot(T, speed, 'LineWidth', 2)
xlabel('Torque (N·m)')
ylabel('Speed (rpm)')
title('Speed vs Torque – Maxon 429271')
grid on