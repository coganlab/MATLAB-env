function plottrigtimes(trigTimes, yVal, color)
if nargin < 3
    color = 'r';
end

Y = zeros(1,numel(trigTimes));
Y = Y + yVal;

hold on;
scatter(trigTimes, Y, 'filled', 'markerfacecolor', color);

for t = 1:numel(trigTimes)
    text(trigTimes(t), yVal, num2str(t));
end

end