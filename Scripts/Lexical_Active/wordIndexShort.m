function wordList=wordIndexShort(trialInfo)

soundDirW = 'C:\Psychtoolbox_Scripts\Lexical_Repeat\stim\wordsR\';
soundDirNW= 'C:\Psychtoolbox_Scripts\Lexical_Repeat\stim\nonwordsR\';
soundValsWords=[];
dirValsW=dir(soundDirW);
for iS=3:length(dirValsW)
    soundNameW=dirValsW(iS).name;
    soundValsWords{iS-2}.sound=audioread([soundDirW soundNameW]);
    soundValsWords{iS-2}.name=soundNameW;
end

soundValsNonWords=[];
dirValsNW=dir(soundDirNW);
for iS=3:length(dirValsNW)
    soundNameNW=dirValsNW(iS).name;
    soundValsNonWords{iS-2}.sound=audioread([soundDirNW soundNameNW]);
    soundValsNonWords{iS-2}.name=soundNameNW;
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
    