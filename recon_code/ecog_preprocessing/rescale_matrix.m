function result = rescale_matrix(data, minVal, maxVal)

if nargin < 2
    minVal = -1.0;
    maxVal = 1.0;
end

min_data = min(data);
max_data = max(data);

result = minVal + (maxVal - minVal)/(max_data - min_data)*(data-min_data);
% https://math.stackexchange.com/questions/914823/shift-numbers-into-a-different-range

end