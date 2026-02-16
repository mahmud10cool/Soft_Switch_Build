% Get the first set of data.  Just use random coordinates for this demo.
n1 = 10
x1 = sort(rand(1, n1), 'ascend');
y1 = rand(1, n1);
% Get the second set of data.  Just use random coordinates for this demo.
n2 = 15
x2 = sort(rand(1, n2), 'ascend');
y2 = rand(1, n2);
% Now we have our data and we can begin.
% Get the length of the first set of data.
length1 = length(x1);
% Get the length of the second set of data.
length2 = length(x2);
% Merge the two x axes.
x = sort([x1, x2], 'ascend');
% Get new y1 values by interpolating the y value
% at the newly added x2 coordinates
y1New = interp1(x1, y1, x);
% Get new y2 values by interpolating the y value
% at the newly added x1 coordinates
y2New = interp1(x2, y2, x);
% Plot things:
plot(x1, y1, 'rd-', 'LineWidth', 14);
hold on;
plot(x2, y2, 'bo-', 'LineWidth', 14);
plot(x, y1New, 'm*-', 'LineWidth', 2);
plot(x, y2New, 'c*-', 'LineWidth', 2);
legend('Set 1', 'Set2', 'Interpolated set 1', 'Interpolated set 2');
grid on;
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);