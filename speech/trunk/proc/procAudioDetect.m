function Trials = procAudioDetect(Trials,Task)
%
%  Trials = procAudioDetect(Trials,Task)
%
%  Task = 'Speech_CovertOvert' by Default;
%

global experiment

if nargin < 2 || isempty(Task); Task = 'Speech_CovertOvert'; end

PROP = 0.6;

switch Task
  case 'Speech_CovertOvert'
    audio_Auditory = trialComediAudio(Trials,'Auditory',[0,600]);
    audio_Go = trialComediAudio(Trials,'Go',[500,1.75e3]);
    N = size(audio_Go,2);  ms = N./1.25e3;
    for iTrial = 1:length(Trials)
        if experiment.processing.comedi.audio.sample_rate == 1e4
            data = mtfilter(audio_Auditory(iTrial,:),[0.01,2000],1e3*ms,1000+2000);
        else
            data = audio_Auditory(iTrial,:);
        end
      envelope = abs(hilbert(data));
      smooth_audio = smooth(envelope,5*ms);
      sd = std(smooth_audio(5*ms:100*ms));
      smooth_audio = smooth_audio - sum(smooth_audio(1:50*ms))./50./ms;
      m = max(smooth_audio);
      if Trials(iTrial).Manual.AuditoryStart == 0
          Onset_sample = find(smooth_audio > PROP*m,1,'first');
          Onset_sample = find(smooth_audio(1:Onset_sample)<6*sd,1,'last');
          Onset_in_ms = Onset_sample./ms;
          Trials(iTrial).AuditoryStart = Trials(iTrial).Auditory + 30*Onset_in_ms;
      else
          Onset_sample = (Trials(iTrial).AuditoryStart - Trials(iTrial).Auditory)./30*ms;
      end
      if Trials(iTrial).Manual.AuditoryStop == 0
          Max_sample = find(smooth_audio(Onset_sample:end)<3*sd,1,'first');
          Offset_sample = find(smooth_audio(Onset_sample:Onset_sample+Max_sample) > 10*sd,1,'last');
          Offset_in_ms = Offset_sample./ms;
          Trials(iTrial).AuditoryStop = Trials(iTrial).AuditoryStart + 30*Offset_in_ms;
      end
%       data = mtfilter(audio_Go(iTrial,:),[0.01,2000],1e3*ms,1000+2000);
      data = audio_Go(iTrial,:);
      envelope = abs(hilbert(data));
      smooth_audio = smooth(envelope,5*ms);
      sd = std(smooth_audio(5*ms:100*ms));
      smooth_audio = smooth_audio - sum(smooth_audio(1:50*ms))./50./ms;
      m = max(smooth_audio);
      if m > 5e3  %  If there is a response
          if Trials(iTrial).Manual.ResponseStart == 0
              Onset_sample = find(smooth_audio > PROP*m,1,'first');
              Onset_sample = find(smooth_audio(1:Onset_sample)<6*sd,1,'last');
              Onset_in_ms = Onset_sample./ms;
              Trials(iTrial).ResponseStart = Trials(iTrial).Go + 30*500 + 30*Onset_in_ms;
          else
              Onset_sample = (Trials(iTrial).ResponseStart - Trials(iTrial).Go)./30*ms - 500*ms;
          end
          if Trials(iTrial).Manual.ResponseStart == 0 && Trials(iTrial).ResponseStart
              Max_sample = find(smooth_audio(Onset_sample:end)<3*sd,1,'first');
              Offset_sample = find(smooth_audio(Onset_sample:Onset_sample+Max_sample) > 10*sd,1,'last');
              Offset_in_ms = Offset_sample./ms;
              Trials(iTrial).ResponseStop = Trials(iTrial).ResponseStart + 30*Offset_in_ms;
          end
      else
          Onset_in_ms = 0; Offset_in_ms = 0;
          Trials(iTrial).ResponseStop = Trials(iTrial).Go;
          Trials(iTrial).ResponseStart = Trials(iTrial).Go;
      end
      
      
    end
end

