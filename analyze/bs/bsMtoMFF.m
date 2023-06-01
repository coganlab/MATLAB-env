function MFFSession = bsMtoMFF(MSession, FieldAreaLabel1,  FieldAreaLabel2)
%
%  bsMtoMFF(MSession, FieldAreaLabel1,  FieldAreaLabel2)
%

FieldSession = loadField_Database;

MFF = MtoMFF(MSession);
MFFArea2 = cell(1,length(MFF));
MFFArea3 = cell(1,length(MFF));

for iMFF = 1:length(MFF)
  MFFArea2{iMFF} = getBSArea_Field(FieldSession{MFF{iMFF}{6}(2)});
  MFFArea3{iMFF} = getBSArea_Field(FieldSession{MFF{iMFF}{6}(3)});
end

ind = [];
if iscell(FieldAreaLabel1)
    for iLabel = 1:length(FieldAreaLabel1)
        ind = [ind find(strcmp(MFFArea2,FieldAreaLabel1{iLabel}))];
    end
else
    ind = find(strcmp(MFFArea2,FieldAreaLabel1));
end

MFF = MFF(ind);
MFFArea3 = MFFArea3(ind);

if nargin > 2
    ind = [];
    if iscell(FieldAreaLabel2)
        for iLabel = 1:length(FieldAreaLabel2)
            ind = [ind2 find(strcmp(MFFArea3,FieldAreaLabel2{iLabel}))];
        end
    else
        ind = find(strcmp(MFFArea3,FieldAreaLabel2));
    end
end


if ~isempty(ind)
  MFFSession = MFF(ind);
else
  MFFSession = {};
  disp('No MultiunitFieldField sessions')
end
