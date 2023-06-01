function tsdata = mocapcell2ts(mocapcelldata)
%
%  TSDATA = MOCAPCELL2TS(CELLDATA)
%

nTr = size(mocapcelldata,1);
nId = size(mocapcelldata,2);

for iTr = 1:nTr
    for iId = 1:nId
        data = mocapcelldata{iTr,iId}(2:end,:);
        nT = size(data,2);
        tsdata(iTr,iId,:,1:nT) = data;
    end
end