function seegElecs = getSeegElecs(subj,fileDir)
% fileDir='H:\Box Sync\CoganLab\D_Data\Environmental_Sternberg';
% subj='D35'
load([fileDir '/' subj '/mat/experiment.mat']);

seegElecs=[];
counterD=0;
 tmp=find(isletter(experiment.channels(1).name));
    chanPrefix=experiment.channels(1).name(tmp);
seegElecs(1).Name=chanPrefix;
%seegElecs(1).Number=1;
seegElecs(1).elecNumber=1;
for iChan=2:length(experiment.channels)
    tmp=find(isletter(experiment.channels(iChan).name));
    chanPrefix=experiment.channels(iChan).name(tmp);
if strcmp(seegElecs(counterD+1).Name,chanPrefix)
 %   seegElecs(counterD+1).Number=seegElecs(counterD+1).Number+1;
    seegElecs(counterD+1).elecNumber=cat(1,seegElecs(counterD+1).elecNumber,iChan);
else
    counterD=counterD+1;
    tmp=find(isletter(experiment.channels(iChan).name));
    chanPrefix=experiment.channels(iChan).name(tmp);
    seegElecs(counterD+1).Name=chanPrefix;
  %  seegElecs(counterD+1).Number=seegElecs(counterD+1).Number+1;
    seegElecs(counterD+1).elecNumber=cat(1,seegElecs(counterD+1).elecNumber,iChan);
end
end
    

