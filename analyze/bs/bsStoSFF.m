function SFFSession = bsStoSFF(SSession, FieldAreaLabel1,  FieldAreaLabel2)
%
%  bsStoSFF(SSession, FieldAreaLabel1,  FieldAreaLabel2)
%
% IN PROGRESS

FieldSession = loadField_Database;

SFF = StoSFF(SSession);
SFFArea2 = cell(1,length(SFF));
SFFArea3 = cell(1,length(SFF));

for iSFF = 1:length(SFF)
  SFFArea2{iSFF} = getBSArea_Field(FieldSession{SFF{iSFF}{6}(2)});
  SFFArea3{iSFF} = getBSArea_Field(FieldSession{SFF{iSFF}{6}(3)});
end

ind = [];
if iscell(FieldAreaLabel1)
    for iLabel = 1:length(FieldAreaLabel1)
        ind = [ind find(strcmp(SFFArea2,FieldAreaLabel1{iLabel}))];
    end
else
    ind = find(strcmp(SFFArea2,FieldAreaLabel1));
end

SFF = SFF(ind);
SFFArea3 = SFFArea3(ind);

if nargin > 2
    ind = [];
    if iscell(FieldAreaLabel2)
        for iLabel = 1:length(FieldAreaLabel2)
            ind = [ind2 find(strcmp(SFFArea3,FieldAreaLabel2{iLabel}))];
        end
    else
        ind = find(strcmp(SFFArea3,FieldAreaLabel2));
    end
end


if ~isempty(ind)
  SFFSession = SFF(ind);
else
  SFFSession = {};
  disp('No SpikeFieldField sessions')
end
