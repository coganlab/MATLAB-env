function comedi_audio = trialComediAudio(Trials, field, bn)
%
%  comedi_audio = trialComediAudio(Trials, field, bn)
%
%  Inputs:	TRIALS = Data structure.  Trial information for Subject
%		FIELD = String. Alignment field from Trials.
%		BN = 	Two element array.  Start and stop time in ms aligned to FIELD.
%
%  Outputs:	COMEDI_AUDIO = Array.  One channel audio data for each trial aligned to FIELD
%

global experiment NYUMCDIR

%COMEDI_FS = experiment.processing.comedi.audio.sample_rate;
COMEDI_FS=10000;
comedi_audio = zeros(length(Trials),diff(bn)*COMEDI_FS/1e3);
for iTrial = 1:length(Trials)
  Subject = Trials(iTrial).Subject; Day = Trials(iTrial).Day; 
  Rec = Trials(iTrial).Rec; FilenamePrefix = Trials(iTrial).FilenamePrefix;
  file_name = [NYUMCDIR '/' Subject '/' Day '/' Rec '/' FilenamePrefix];
  if isfile([file_name '.cleancomedi_audio.dat'])
    file_type = 'cleancomedi_audio';
  elseif isfile([file_name '.comedi_audio.dat'])
      file_type = 'comedi_audio';
  elseif isfile([file_name '.comedi.dat'])
    file_type = 'comedi';
  end
  file_name = [file_name '.' file_type '.dat']; %#ok<AGROW>
  starttime_in_ms = floor(Trials(iTrial).(field)./30) + bn(1);
  stoptime_in_ms = floor(Trials(iTrial).(field)./30) + bn(2);
  startsamp = starttime_in_ms.*(COMEDI_FS./1e3)+1;
  stopsamp = stoptime_in_ms.*(COMEDI_FS./1e3);
  temp1=ntools_load_int(file_type,file_name,startsamp,stopsamp);
  %comedi_audio(iTrial,:) = ntools_load_int(file_type,file_name,startsamp,stopsamp);
  comedi_audio(iTrial,:)=temp1(2,:);
end

