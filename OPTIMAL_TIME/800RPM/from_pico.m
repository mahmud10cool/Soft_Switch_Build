clc; clear; close all;

s = serialport("COM6", 115200);  % Replace with your port
some_data = zeros(1, 90000);  % Predefined array for faster processing

for i = 1:length(some_data)
    some_data(i) = str2double(readline(s));  % Read and convert each line
    time_string = ['Time Elapsed: ', num2str(i/3000),' s'];
    disp(i)
end

t = 1:length(some_data);

save test_5_800RPM.mat some_data t