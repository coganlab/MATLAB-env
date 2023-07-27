function norm_data = iqrnorm(data)
quant_5 = prctile(data,5);
quant_95 = prctile(data,95);
norm_data = (data - quant_5) / ( quant_95 - quant_5 );
end