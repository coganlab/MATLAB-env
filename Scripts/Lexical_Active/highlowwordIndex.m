function condList=highlowwordIndex(trialInfo)
%GoogleDriveDir = 'C:\Users\gcoga\Google Drive\';
GoogleDriveDir = 'G:\'
load([GoogleDriveDir 'Scripts\Lexical_Active\HLWNW.mat'])
soundDirW = [GoogleDriveDir 'Scripts\Lexical_Active\stim\words\'];
soundDirNW= [GoogleDriveDir 'Scripts\Lexical_Active\stim\nonwords\'];
soundValsWords=[];
dirValsW=dir(soundDirW);
rIdx=[];
counter=0;
for iS=1:length(dirValsW);
    if strcmp(dirValsW(iS).name,'.')
        rIdx(counter+1)=iS;
        counter=counter+1;
    elseif strcmp(dirValsW(iS).name,'..')
        rIdx(counter+1)=iS;
        counter=counter+1;
       elseif strcmp(dirValsW(iS).name,'desktop.ini')
        rIdx(counter+1)=iS;
        counter=counter+1;   
    end
end
dirValsW(rIdx)=[];
for iS=1:length(dirValsW)
    soundNameW=dirValsW(iS).name;
    soundValsWords{iS}.sound=audioread([soundDirW soundNameW]);
    soundValsWords{iS}.name=soundNameW;
end

soundValsNonWords=[];
dirValsNW=dir(soundDirNW);
rIdx=[];
counter=0;
for iS=1:length(dirValsNW);
    if strcmp(dirValsNW(iS).name,'.')
        rIdx(counter+1)=iS;
        counter=counter+1;
    elseif strcmp(dirValsNW(iS).name,'..')
        rIdx(counter+1)=iS;
        counter=counter+1;
       elseif strcmp(dirValsNW(iS).name,'desktop.ini')
        rIdx(counter+1)=iS;
        counter=counter+1;   
    end
end
dirValsNW(rIdx)=[];


for  iTrials=1:length(trialInfo);
    tmpS=trialInfo{iTrials}.sound;
    tmpC=trialInfo{iTrials}.cue;
    for iW=1:length(HW);
        tmpHWList(iW)=strcmp(tmpS,strcat(HW{iW},'.wav'));
    end
    
    for iW=1:length(LW);
        tmpLWList(iW)=strcmp(tmpS,strcat(LW{iW},'.wav'));
    end
    
    for iW=1:length(HNW);
        tmpHNWList(iW)=strcmp(tmpS,strcat(HNW{iW},'.wav'));
    end
    
    for iW=1:length(LNW);
        tmpLNWList(iW)=strcmp(tmpS,strcat(LNW{iW},'.wav'));
    end
    
    if sum(tmpHWList==1) && strcmp(tmpC,'Yes/No')
        condList(iTrials)=1;
    elseif sum(tmpLWList==1) && strcmp(tmpC,'Yes/No')
        condList(iTrials)=2;
    elseif sum(tmpHNWList==1) && strcmp(tmpC,'Yes/No')
        condList(iTrials)=3 ;
    elseif sum(tmpLNWList==1) && strcmp(tmpC,'Yes/No')
        condList(iTrials)=4;
        
    elseif sum(tmpHWList==1) && strcmp(tmpC,'Repeat')
        condList(iTrials)=5;
    elseif sum(tmpLWList==1) && strcmp(tmpC,'Repeat')
        condList(iTrials)=6;
    elseif sum(tmpHNWList==1) && strcmp(tmpC,'Repeat')
        condList(iTrials)=7 ;
    elseif sum(tmpLNWList==1) && strcmp(tmpC,'Repeat')
        condList(iTrials)=8;
    end
    
end
    