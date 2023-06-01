function MFSession = bsMtoMF(MSession, FieldAreaLabel)
%
%  bsMtoMF(MSession, FieldAreaLabel)
%

FieldSession = loadField_Database;

MF = MtoMF(MSession);
MFArea2 = cell(1,length(MF));

for iMF = 1:length(MF)
  MFArea2{iMF} = getBSArea_Field(FieldSession{MF{iMF}{6}(2)});
end

ind = [];
if iscell(FieldAreaLabel)
    for iLabel = 1:length(FieldAreaLabel)
        ind = [ind find(strcmp(MFArea2,FieldAreaLabel{iLabel}))];
    end
else
    ind = find(strcmp(MFArea2,FieldAreaLabel));
end

if ~isempty(ind)
  MFSession = MF(ind);
else
  MFSession = {};
end
