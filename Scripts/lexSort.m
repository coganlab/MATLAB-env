function condIdx = lexSort(trialInfo)

% 1 = high word dec
% 2 = low word dec
% 3 = high nonword dec
% 4 = low nonword dec
% 5 = high word rep
% 6 = low word rep
% 7 = high nonword rep
% 8 = low nonword rep

global BOX_DIR
tokenDir=[BOX_DIR '\CoganLab\acoustic_phoneme'];

highWordDir=dir([tokenDir '/highwords']);
highWordDir=highWordDir(3:end);
for iW=1:length(highWordDir)
    highWords{iW}=highWordDir(iW).name;
end

highNonwordDir=dir([tokenDir '/highnonwords']);
highNonwordDir=highNonwordDir(3:end);
for iW=1:length(highNonwordDir)
    highNonwords{iW}=highNonwordDir(iW).name;
end

lowWordDir=dir([tokenDir '/lowwords']);
lowWordDir=lowWordDir(3:end);
for iW=1:length(lowWordDir)
    lowWords{iW}=lowWordDir(iW).name;
end

lowNonwordDir=dir([tokenDir '/lownonwords']);
lowNonwordDir=lowNonwordDir(3:end);
for iW=1:length(lowNonwordDir)
    lowNonwords{iW}=lowNonwordDir(iW).name;
end




for iTrials=1:length(trialInfo)
    cond=[];
    tVal=[];
    if strcmp(trialInfo{iTrials}.cue,'Yes/No')
        cond=1;
    elseif strcmp(trialInfo{iTrials}.cue,'Repeat')
        cond=2;
    end
    token=trialInfo{iTrials}.sound;
    
    for iW=1:length(highWordDir)
        if strcmp(token,highWords{iW})
            tVal=1;
        else
            tVal=0;
        end
        if cond==1 && tVal==1
            condIdx(iTrials)=1;
        elseif cond==2 && tVal==1
            condIdx(iTrials)=5;
        end
    end
    
    for iW=1:length(lowWordDir)
        if strcmp(token,lowWords{iW})
            tVal=1;
        else
            tVal=0;
        end
        if cond==1 && tVal==1
            condIdx(iTrials)=2;
        elseif cond==2 && tVal==1
            condIdx(iTrials)=6;
        end
    end
    
    for iW=1:length(highNonwordDir)
        if strcmp(token,highNonwords{iW})
            tVal=1;
        else
            tVal=0;
        end
        if cond==1 && tVal==1
            condIdx(iTrials)=3;
        elseif cond==2 && tVal==1
            condIdx(iTrials)=7;
        end
    end
    
    for iW=1:length(lowNonwordDir)
        if strcmp(token,lowNonwords{iW})
            tVal=1;
        else
            tVal=0;
        end
        if cond==1 && tVal==1
            condIdx(iTrials)=4;
        elseif cond==2 && tVal==1
            condIdx(iTrials)=8;
        end
    end
    
end

   
   
      
   
   
   
   