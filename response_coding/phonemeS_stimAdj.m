function phonemeS_stimAdj

cue_events=readcell('cue_events.txt');
StimAdjFilename='PhonemeSequencingStimStarts.txt';
stimAdj=readcell(StimAdjFilename);
fid=fopen('cue_events_Adjust.txt','w');

adjustCheck=zeros(length(cue_events),1);
for iTrials=1:length(cue_events)
    cue_eventsStim1=cue_events{iTrials,3};
    cue_eventsStimIdx=strfind(cue_eventsStim1,'_');
    cue_eventsStim=cue_eventsStim1(cue_eventsStimIdx+1:end-4);
    
    stimAdjIdx=0;
    for iS=1:length(stimAdj)
        if strcmp(cue_eventsStim,stimAdj{iS,1});
            stimAdjIdx=iS;
        end
    end
    adjustCheck(iTrials)=stimAdjIdx;
    cue_eventsStart=cue_events{iTrials,1}+stimAdj{stimAdjIdx,2};
    cue_eventsEnd=cue_events{iTrials,2}+stimAdj{stimAdjIdx,2};
   % fwrite(fid, sprintf('%f\t%f\t%d_%s\n',cue_eventsStart,cue_eventsEnd,cue_eventsStim1));
    fwrite(fid, sprintf('%f\t%f\t%s\n',cue_eventsStart,cue_eventsEnd,cue_eventsStim1));

end
fclose(fid);
%save('cue_events_Adjust.txt','cue_events');

        


