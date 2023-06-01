function [p,pMax] = getParamFileIndex(pFileRoot,CondParams,AnalParams)

%  [p,pMax] = getParamFileIndex(CONDPARAMS,ANALPARAMS)
%  
%  Determines if parameters have already been used in an earlier analysis. 
%  If so, returns the index of the corresponding p-file. If not, p = 0;
%  Returns the index of the last-saved p-file as pMax.
%  
%  PFILEROOT = STRING Path and root filename of p-files to inspect
%  CONDPARAMS = CondParams structure
%  ANALPARAMS = AnalParams structure

p = 0;
pMax = 0;
for pind = 1:1000
    paramFile = dir([pFileRoot '.p' num2str(pind) '.mat']);
    if ~isempty(paramFile)
        load([pFileRoot '.p' num2str(pind) '.mat']);
        pMax = pind;
        CondParams2 = Params.CondParams;
        AnalParams2 = Params.AnalParams;
        [condSame] = calcCompareStructures(CondParams,CondParams2);
        [analSame] = calcCompareStructures(AnalParams,AnalParams2);
        if condSame && analSame && exist([pFileRoot '.d' num2str(pind) '.mat'],'file');
            p = pind;
        end
    else
        return;
    end
end
