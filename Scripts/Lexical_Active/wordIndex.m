function wordList=wordIndex(trialInfo)
global BOX_DIR
%soundDirW = 'C:\Psychtoolbox_Scripts\Lexical_Repeat\stim\words\';
%soundDirNW= 'C:\Psychtoolbox_Scripts\Lexical_Repeat\stim\nonwords\';
% soundDirW = 'G:\Scripts\Lexical_Active\stim\words\';
% soundDirNW= 'G:\Scripts\Lexical_Active\stim\nonwords\';
soundDirW=[BOX_DIR '\CoganLab\Scripts\Lexical_Active\stim\words\'];
soundDirNW=[BOX_DIR '\CoganLab\Scripts\Lexical_Active\stim\nonwords\'];
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

for iS=1:length(dirValsNW)
    soundNameNW=dirValsNW(iS).name;
    soundValsNonWords{iS}.sound=audioread([soundDirNW soundNameNW]);
    soundValsNonWords{iS}.name=soundNameNW;
end

for  iTrials=1:length(trialInfo);
    tmpS=trialInfo{iTrials}.sound;
    for iW=1:length(soundValsWords);
        tmpWordList(iW)=strcmp(tmpS,soundValsWords{iW}.name);
    end
   
   if sum(tmpWordList>0);
       wordList(iTrials)=1;
   else
       wordList(iTrials)=0;
   end
   clear tmpWordList
end
    