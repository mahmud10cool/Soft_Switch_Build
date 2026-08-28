function [speed_interp, current_interp, pressure_interp] = appendOptTimeData(...
    row_idx, time_index, t_normal, speed, current, pressure, t_common)
    
    % Extract corresponding data
    speed_temp = speed(row_idx, time_index);
    current_temp = current(row_idx, time_index);
    pressure_temp = pressure(row_idx, time_index);
    
    % Interpolate all data to fit t_common
    speed_interp = interp1(t_normal, speed_temp, t_common);
    current_interp = interp1(t_normal, current_temp, t_common);
    pressure_interp = interp1(t_normal, pressure_temp, t_common);
end