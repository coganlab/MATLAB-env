% dumpKARMA(outfileroot, neuralData, observedState, s,r, gamma, C)
% drop in replacement for parfitKARMA.m that writes csv files for
% online decoder training.  first argument defines the path and
% filename root for the outfile files, which are written as:
%
% outfileroot.neural_offline.txt and outfileroot.joints_offline.txt
%
% does not yet package up the parameters yet, they must be
% manually changed in the source to the decoder/host
%
function dumpKARMA(outfileroot, neuralData, observedState, s,r, gamma, C)

outfileneural = [outfileroot '.neural_offline.txt'];
outfileobs    = [outfileroot '.joints_offline.txt'];

fid = fopen(outfileneural, 'w');
fprintf(fid,'%d\n%d\n', size(neuralData,1), size(neuralData,2));
fclose(fid);

fid = fopen(outfileobs, 'w');
fprintf(fid,'%d\n%d\n', size(observedState,1), size(observedState,2));
fclose(fid);


dlmwrite([outfileroot '.neural_offline.txt'], neuralData, '-append', 'precision', '%.6f');
dlmwrite([outfileroot '.joints_offline.txt'], observedState, '-append', 'precision', '%.6f');



