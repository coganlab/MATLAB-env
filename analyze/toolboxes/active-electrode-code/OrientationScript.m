
% orientation script
clc

fileList = ['I:\jviventi\2010-05-19 Cat Experiment\done\test_28_demux.mat'; ...
    'I:\jviventi\2010-05-19 Cat Experiment\done\test_30_demux.mat'; ...
    'I:\jviventi\2010-05-19 Cat Experiment\done\test_31_demux.mat'; ...
    'I:\jviventi\2010-05-19 Cat Experiment\done\test_32_demux.mat'; ...
    'I:\jviventi\2010-05-19 Cat Experiment\done\test_33_demux.mat'; ...
    'I:\jviventi\2010-05-19 Cat Experiment\done\test_34_demux.mat'];


for i = 1:size(fileList,1)
    
    filename = fileList(i,:);
    load(filename);
    [avg_eps,count,x] = multiplexed_ep(data, 1, 1, numRow, numCol, numChan, Fs);
    iso = OrientationColormap(avg_eps, count, filename, numRow, numCol, numChan, Fs, 1.0, 1.7);
end