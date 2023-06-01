function ieeg = trialIEEG(Trials, ch, field, bn)
%
%  ieeg = trialIEEG(Trials, ch, field, bn)
%
%   bn is in ms
global experiment 
global DUKEDIR
load([DUKEDIR filesep Trials(1).Subject '/mat/experiment.mat']);

IEEG_FS = experiment.processing.ieeg.sample_rate;
ieeg = zeros(length(Trials),length(ch),floor(diff(bn)*IEEG_FS./1e3),'single');
%pause
for iTrial = 1:length(Trials)
    Subject = Trials(iTrial).Subject; Day = Trials(iTrial).Day; 
    Rec = Trials(iTrial).Rec; FilenamePrefix = Trials(iTrial).FilenamePrefix;
    file_name = fullfile(DUKEDIR, Subject, Day, Rec, FilenamePrefix);
  
 
    if isfile([file_name '.cleanieeg.dat'])
        file_type = 'cleanieeg';              
    elseif isfile([file_name '.ieeg.dat'])
        file_type = 'ieeg';
    elseif isfile([file_name '.low.nspike.dat'])
        file_type='low.nspike';
    else
        error("data not found")
    end
  
    file_name = [file_name '.' file_type '.dat']; %#ok<AGROW>
    starttime_in_ms = Trials(iTrial).(field)./30 + bn(1);
    stoptime_in_ms = Trials(iTrial).(field)./30 + bn(2);
    startsamp = floor(starttime_in_ms./1e3.*IEEG_FS) + 1;
    stopsamp = floor(stoptime_in_ms./1e3.*IEEG_FS);
    tmp = ntools_load_int(file_type,file_name,startsamp,stopsamp);
    ieeg(iTrial,:,1:min(size(tmp,2),end)) = tmp(ch,1:min(end,size(ieeg,3)));
    %display(iTrial)
end

ieeg = squeeze(ieeg);