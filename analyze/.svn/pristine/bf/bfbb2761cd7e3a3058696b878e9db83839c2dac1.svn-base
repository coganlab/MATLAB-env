function SFSession = bsFtoSF(FSession, SpikeAreaLabel)
%
%  bsFtoSF(FSession, SpikeAreaLabel)
%


SpikeSession = loadSpike_Database;

SF = FtoSF(FSession);
SFArea1 = cell(1,length(SF));

for iSF = 1:length(SF)
   tmp = sessBSArea(SpikeSession{SF{iSF}{6}(1)});
   SFArea1{iSF} = tmp{1}{1};
end

ind = find(strcmp(SFArea1,SpikeAreaLabel));

if ~isempty(ind)
  SFSession = SF(ind);
else
  SFSession = {};
end
