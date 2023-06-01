function FFSession = bsFtoFF(FSession, FieldAreaLabel)
%
%  bsFtoMF(FSession, MultiunitAreaLabel)
%

FieldSession = loadField_Database;

FF = FtoFF(FSession);
FFArea1 = cell(1,length(FF));

for iFF = 1:length(FF)
  FFArea1{iFF} = getBSArea_Field(FieldSession{FF{iFF}{6}(1)});
end

ind = find(strcmp(FFArea1,FieldAreaLabel));

if ~isempty(ind)
  FFSession = FF(ind);
else
  FFSession = {};
end



