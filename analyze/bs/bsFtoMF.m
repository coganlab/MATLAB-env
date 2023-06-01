function MFSession = bsFtoMF(FSession, MultiunitAreaLabel)
%
%  bsFtoMF(FSession, MultiunitAreaLabel)
%

MultiunitSession = loadMultiunit_Database;

MF = FtoMF(FSession);
MFArea1 = cell(1,length(MF));

for iMF = 1:length(MF)
  MFArea1{iMF} = getBSArea_Multiunit(MultiunitSession{MF{iMF}{6}(1)});
end

ind = find(strcmp(MFArea1,MultiunitAreaLabel));

if ~isempty(ind)
  MFSession = MF(ind);
else
  MFSession = {};
end
