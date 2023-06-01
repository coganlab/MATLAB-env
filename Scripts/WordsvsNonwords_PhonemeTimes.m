% labDrive='E:\Box Sync\CoganLab\';
% filename=[labDrive 'acoustic_phoneme\TimingInfo.xlsx'];
filename = 'C:\Users\sd355\Downloads\TimingInfo.xlsx';
[wordPhonemeTimes,wordPhonemeCat,wordPhonemeRaw]=xlsread(filename,1,'A3:M86');
[nonwordPhonemeTimes,nonwordPhonemeCat,nonwordPhonemeRaw]=xlsread(filename,2,'A3:M86');
[tmp,phonemeNames,tmp2]=xlsread(filename,3,'A3:A41');
[tmp,phonemeExamples,tmp2]=xlsread(filename,3,'B3:B41');

wordTokens={};
nonwordTokens={};
for iToken=1:84
    wordTokens{iToken}.Name=wordPhonemeCat{iToken};
    for iPhoneme=1:5;
    wordTokens{iToken}.Phoneme{iPhoneme}.Name=wordPhonemeCat{iToken,iPhoneme+1};
    wordTokens{iToken}.Phoneme{iPhoneme}.Onset=wordPhonemeTimes(iToken,iPhoneme);
    wordTokens{iToken}.Phoneme{iPhoneme}.Duration=wordPhonemeTimes(iToken,iPhoneme+1)-wordPhonemeTimes(iToken,iPhoneme);
    end
    
    nonwordTokens{iToken}.Name=nonwordPhonemeCat{iToken};
    for iPhoneme=1:5;
    nonwordTokens{iToken}.Phoneme{iPhoneme}.Name=nonwordPhonemeCat{iToken,iPhoneme+1};
    nonwordTokens{iToken}.Phoneme{iPhoneme}.Onset=nonwordPhonemeTimes(iToken,iPhoneme);
    nonwordTokens{iToken}.Phoneme{iPhoneme}.Duration=nonwordPhonemeTimes(iToken,iPhoneme+1)-nonwordPhonemeTimes(iToken,iPhoneme);
    end
end

pCounterWord=zeros(39,1);
pDurationWord=zeros(39,1);
pCounterNonword=zeros(39,1);
pDurationNonword=zeros(39,1);
for iToken=1:84
    for iPhoneme=1:5;
        for iP=1:39;
            if strcmp(wordTokens{iToken}.Phoneme{iPhoneme}.Name,phonemeNames{iP})
                pDurationWord(iP,pCounterWord(iP)+1)=wordTokens{iToken}.Phoneme{iPhoneme}.Duration;
                pCounterWord(iP)=pCounterWord(iP)+1;
            end
             if strcmp(nonwordTokens{iToken}.Phoneme{iPhoneme}.Name,phonemeNames{iP})
                pDurationNonword(iP,pCounterNonword(iP)+1)=nonwordTokens{iToken}.Phoneme{iPhoneme}.Duration;
                pCounterNonword(iP)=pCounterNonword(iP)+1;
             end
        end
    end
end

pDurationAvgWord=sum(pDurationWord,2)./pCounterWord;
ii=isnan(pDurationAvgWord);
pDurationAvgWord(ii)=0;

pDurationAvgNonword=sum(pDurationNonword,2)./pCounterNonword;
ii=isnan(pDurationAvgNonword);
pDurationAvgNonword(ii)=0;

                
      