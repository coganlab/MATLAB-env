function AveLR = averageLR(LR)
%
%  AveLR = averageLR(LR)
%

number_of_sessions = length(LR);

min_num_trials = size(LR{1},1);
length_of_accum = size(LR{1},2);
for iSess = 1:number_of_sessions
    min_num_trials = min(min_num_trials,size(LR{iSess},1));
end

AveLR = zeros(min_num_trials,length_of_accum);
for iSess = 1:number_of_sessions
    AveLR = AveLR + LR{iSess}(1:min_num_trials,:);
end

AveLR = AveLR./number_of_sessions;