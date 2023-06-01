function SFSession = bsStoSF(SSession, FieldAreaLabel)
%
%  bsStoSF(SSession, FieldAreaLabel)
%

FieldSession = loadField_Database;

SF = StoSF(SSession);
SFArea2 = cell(1,length(SF));

for iSF = 1:length(SF)
  SFArea2{iSF} = getBSArea_Field(FieldSession{SF{iSF}{6}(2)});
end

ind = [];
if iscell(FieldAreaLabel)
    for iLabel = 1:length(FieldAreaLabel)
        ind = [ind find(strcmp(SFArea2,FieldAreaLabel{iLabel}))];
    end
else
    ind = find(strcmp(SFArea2,FieldAreaLabel));
end

if ~isempty(ind)
  SFSession = SF(ind);
else
  SFSession = {};
  disp('No SpikeField sessions')
end
