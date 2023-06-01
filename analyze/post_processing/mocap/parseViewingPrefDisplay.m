function [events,data] = parseViewingPrefDisplay(day,rec)
%function events = parseViewingPrefDisplay(day,rec)
%
%   parseViewingPrefDisplay(day,rec)
%
global MONKEYDIR

olddir = pwd;

recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end
for iNum = num(1):num(2)
    fid = fopen([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.display.dat']);
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.experiment.mat']);
    SAMPLING =  experiment.hardware.acquisition(1).samplingrate./1e3;
    FORMAT = experiment.hardware.acquisition(1).data_format;
    
    data = fread(fid,[inf],FORMAT); fclose(fid);
    switch FORMAT
        case 'short'
            newdata = zeros(size(data))+2048;
            newdata(data>2500)=4095;
            data = newdata; clear newdata
    end
    [n,x] = hist(data,200);
    [a,b] = sort(n,'descend');
    levels = x(b(1:2));
    switch FORMAT
        case 'ushort'
            midlevel = 4e4;
        case 'short'
            midlevel = 3e3;
    end
    if max(levels) < midlevel
        disp('No display state changes')
        events = [];
    else
        fd = zeros(1,length(data));
        fd(find(data > 1.1*mean(levels)))=1; 
        events = find(abs(diff(fd))); 
    end
end

end

