
samples_per_cycle = 500;    %sampling rate 500k/s, 1 ms per acq cycle
number_osr = 2;     % reshape by number of averages
data_start_sample = 5;
numRow = 32;
numCol = 1;
Fs = 500;

data = ConvertedData.Data.MeasuredData(3).Data;
data = reshape(data,samples_per_cycle,[]);                    % reshape to one period of data
data = data(data_start_sample:data_start_sample+number_osr*numRow-1,:);       % select only data during readout period
data = reshape(data,number_osr,numRow,[]);                 % reshape to 3d with first dimension are the samples to average
data = squeeze(mean(data,1));                       % average the extra samples

data2 = ConvertedData.Data.MeasuredData(4).Data;
data2 = reshape(data2,samples_per_cycle,[]);                    % reshape to one period of data
data2 = data2(data_start_sample:data_start_sample+number_osr*numRow-1,:);       % select only data during readout period
data2 = reshape(data2,number_osr,numRow,[]);                 % reshape to 3d with first dimension are the samples to average
data2 = squeeze(mean(data2,1));                       % average the extra samples

data = [data ; data2];