function procMocapTrialsToEvents(day)
%
%  procMocapTrialsToEvents(day, recs)
%

global MONKEYDIR

if nargin < 2 recs = dayrecs(day); end

trials = dbSelectTrials(day);

for iTr = 1:length(trials)
   rec_num(iTr) = str2num(trials(iTr).Rec); 
end


for iRec = 1:length(recs)
    tmp = fieldnames(trials);
    
    for iField = 1:length(tmp)
        Events.(tmp{iField}) = [trials(rec_num == iRec).(tmp{iField})]';
    end
    
    rec = recs{iRec};
    disp(['Saving : rec' rec '.Events.mat']);
    save([MONKEYDIR '/' day '/' rec '/rec' rec '.Events.mat'],'Events');
end

