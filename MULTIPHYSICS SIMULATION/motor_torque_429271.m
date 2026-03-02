function [tau_out, tau_em]= motor_torque_429271(iq, omega)
%#codegen
% maxon 429271 (from your table)
Kt = 0.109;            % N*m/A  (109 mNm/A)
B  = 1.16e-4;          % N*m*s/rad  (estimated from no-load current)

% Electromagnetic torque (FOC-style)
tau_em = Kt * iq;

% Viscous friction (effective losses)
tau_f  = B * omega;

% Output torque to the load
tau_out = tau_em - tau_f;
end