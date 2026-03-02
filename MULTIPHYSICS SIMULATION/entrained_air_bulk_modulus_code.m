clc; clear; close all;

%% Testing the bulk modulus vs. pressure

run param_file.m

P_atmospheric = 1e5;  % Atmospheric pressure in Pascals
alpha = 0.01;          % Example value for alpha
P = linspace(1e5,3*param.P_H,30);  % Pressure range from atmospheric to 10 MPa
param.gamma = 1.4;

beta_mix = NaN(size(P));

for i = 1:length(P)
    Px = P(i);
    Pg=Px-P_atmospheric;   % Gauge pressure
    r=Px/P_atmospheric;    % Pressure ratio
    e=exp(Pg/param.beta); 
    rv=(1./e+alpha*r.^(-1/param.gamma))/(1+alpha);      %Volume ratio
    
    beta_mix(i) = rv*(1+alpha)/(1/(e*param.beta)+...
               alpha/(param.gamma*P_atmospheric*r^(1/param.gamma+1)));
end

% Plots here
hold on
plot(P*1e-6, beta_mix*1e-9, 'o-', LineWidth=2)
xline(param.P_M*1e-6)
xline(param.P_L*1e-6)
xline(param.P_H*1e-6)
hold off
xlabel('Pressure (MPa)')
ylabel('Bulk Modulus (GPa)')
grid on
