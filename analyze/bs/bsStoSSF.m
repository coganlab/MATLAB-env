function SSFSession = bsStoSSF(SSession, SpikeAreaLabel1,  FieldAreaLabel2)
%

SpikeSession = loadSpike_Database;
FieldSession = loadField_Database;

SSF = StoSSF(SSession);
SSFArea2 = cell(1,length(SSF));
SSFArea3 = cell(1,length(SSF));

for iSSF = 1:length(SSF)
  SSFArea2(iSSF) = getBSArea(SpikeSession{SSF{iSSF}{6}(2)});
  SSFArea3{iSSF} = getBSArea_Field(FieldSession{SSF{iSSF}{6}(3)});
end

ind = [];
if iscell(SpikeAreaLabel1)
    for iLabel = 1:length(SpikeAreaLabel1)
        ind = [ind find(strcmp(SSFArea2,SpikeAreaLabel1{iLabel}))];
    end
else
    ind = find(strcmp(SSFArea2,SpikeAreaLabel1));
end

SSF = SSF(ind);
SSFArea3 = SSFArea3(ind);

if nargin > 2
    ind = [];
    if iscell(FieldAreaLabel2)
        for iLabel = 1:length(FieldAreaLabel2)
            ind = [ind find(strcmp(SSFArea3,FieldAreaLabel2{iLabel}))];
        end
    else
        ind = find(strcmp(SSFArea3,FieldAreaLabel2));
    end
end


if ~isempty(ind)
  SSFSession = SSF(ind);
else
  SSFSession = {};
  disp('No SpikeSpikeField sessions')
end
