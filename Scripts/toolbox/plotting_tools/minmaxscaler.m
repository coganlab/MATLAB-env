function norm_data = minmaxscaler(data)
norm_data = (data - min(data)) / ( max(data) - min(data) );
end