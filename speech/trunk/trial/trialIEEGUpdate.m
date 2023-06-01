function [ieeg,ieegAll,trigOnset] = trialIEEGUpdate(Trials, ch, field,file_type, bn)
%
%  ieeg = trialIEEG(Trials, ch, field, bn)
%
%   bn is in ms
global experiment DUKEDIR
ieegAll = [];
trigOnset = [];
if(strcmp(file_type,'ieeg'))
IEEG_FS = experiment.processing.ieeg.sample_rate;
end
if(strcmp(file_type,'spike'))
IEEG_FS = experiment.processing.spike.sample_rate;
end

ieeg = zeros(length(Trials),length(ch),round(diff(bn)*IEEG_FS./1e3),'single');
%ieeg = [];
%pause

for iTrial = 1:length(Trials)
    
  Subject = Trials(iTrial).Subject; Day = Trials(iTrial).Day; 
  Rec = Trials(iTrial).Rec; FilenamePrefix = Trials(iTrial).FilenamePrefix;
  file_name = [DUKEDIR '/' Subject '/' Day '/' Rec '/' FilenamePrefix];
  
 
  if isfile([file_name '.cleanieeg.dat'])
    file_type = 'cleanieeg';              
  elseif isfile([file_name '.ieeg.dat'])
    file_type = 'ieeg';
  elseif isfile([file_name '.low.nspike.dat'])
      file_type='low.nspike';
  end
%file_type = 'ieeg';
  %  file_name
  file_name = [file_name '.' file_type '.dat']; %#ok<AGROW>
  trigOnsTemp = floor((Trials(iTrial).(field)./30)./1e3.*IEEG_FS);
  if(isempty(trigOnsTemp))
      trigOnset(iTrial) = nan;
  else
  trigOnset(iTrial)=trigOnsTemp;
  end
  
  if(~isnan(trigOnset(iTrial)))
      
  starttime_in_ms = Trials(iTrial).(field)./30 + bn(1);
  stoptime_in_ms = Trials(iTrial).(field)./30 + bn(2);
  startsamp = floor(starttime_in_ms./1e3.*IEEG_FS) + 1;
  stopsamp = floor(stoptime_in_ms./1e3.*IEEG_FS);
 
  tmp = ntools_load_int(file_type,file_name,startsamp,stopsamp);
  size(tmp)
  ieeg(iTrial,:,1:min(size(tmp,2),end)) = tmp(ch,1:min(size(ieeg,3),end));
  
  end
  %display(iTrial)
end
% tmp = ntools_load_int(file_type,file_name,[],[]);
% ieegAll = tmp(ch,1:end);
% ieeg = sq(ieeg);
% ieegAll = squeeze(ieegAll);