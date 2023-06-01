function SSFFSession = bsStoSSFF(SSession, SpikeAreaLabel1,  FieldAreaLabel2,  FieldAreaLabel3)
%

if nargin < 3
    FieldAreaLabel2 = [];
    FieldAreaLabel3 = [];
end

if nargin < 4
FieldAreaLabel3 = [];
end

if isempty(FieldAreaLabel2) && ~isempty(FieldAreaLabel3)
    FieldAreaLabel2 = FieldAreaLabel3;
    FieldAreaLabel3 = [];
end
    
SNum = SSession{6};    

SpikeSession = loadSpike_Database;
FieldSession = loadField_Database;

SSFF = StoSSFF(SSession);
SSFFArea2 = cell(1,length(SSFF));
SSFFArea3 = cell(1,length(SSFF));
SSFFArea4 = cell(1,length(SSFF));

for iSSFF = 1:length(SSFF)
    Nums = SSFF{iSSFF}{6};
    Areas = getBSArea(SSFF{iSSFF});
    SSFFArea2(iSSFF) = Areas(find(Nums(1:2) ~= SNum));
    SSFFArea3(iSSFF) = Areas(3);
    SSFFArea4(iSSFF) = Areas(4);
end

ind = [];
if ~isempty(SpikeAreaLabel1) && isempty(FieldAreaLabel2) && isempty(FieldAreaLabel3) 
    if iscell(SpikeAreaLabel1)
        for iLabel = 1:length(SpikeAreaLabel1)
            ind = [ind find(strcmp(SSFFArea2,SpikeAreaLabel1{iLabel}))];
        end
    else
        ind = find(strcmp(SSFFArea2,SpikeAreaLabel1));
    end
end

if isempty(SpikeAreaLabel1) && ~isempty(FieldAreaLabel2) && isempty(FieldAreaLabel3)
    if iscell(FieldAreaLabel2)
        for iLabel = 1:length(FieldAreaLabel2)
            ind = [ind unique([find(strcmp(SSFFArea3,FieldAreaLabel2{iLabel})),find(strcmp(SSFFArea4,FieldAreaLabel2{iLabel}))])];
        end
    else
        ind = unique([find(strcmp(SSFFArea3,FieldAreaLabel2{iLabel})),find(strcmp(SSFFArea4,FieldAreaLabel2{iLabel}))]);
    end
end

if ~isempty(SpikeAreaLabel1) && ~isempty(FieldAreaLabel2) && isempty(FieldAreaLabel3)  
    ind1 = [];
    ind2 = [];
    if iscell(SpikeAreaLabel1)
        for iLabel = 1:length(SpikeAreaLabel1)
            ind1 = [ind1 find(strcmp(SSFFArea2,SpikeAreaLabel1{iLabel}))];
        end
    else
        ind1 = find(strcmp(SSFFArea2,SpikeAreaLabel1));
    end
    if iscell(FieldAreaLabel2)
        for iLabel = 1:length(FieldAreaLabel2)
            ind2 = [ind2 unique([find(strcmp(SSFFArea3,FieldAreaLabel2{iLabel})),find(strcmp(SSFFArea4,FieldAreaLabel2{iLabel}))])];
        end
    else
        ind2 = unique([find(strcmp(SSFFArea3,FieldAreaLabel2{iLabel})),find(strcmp(SSFFArea4,FieldAreaLabel2{iLabel}))]);
    end
    ind = intersect(ind1,ind2);
end

if isempty(SpikeAreaLabel1) && ~isempty(FieldAreaLabel2) && ~isempty(FieldAreaLabel3)
    if strcmp(FieldAreaLabel2,FieldAreaLabel3)
    ind2 = [];
    ind3 = [];
    if iscell(FieldAreaLabel2)
        for iLabel = 1:length(FieldAreaLabel2)
            ind2 = [ind2, find(strcmp(SSFFArea3,FieldAreaLabel2{iLabel}))];
        end
    else
        ind2 = find(strcmp(SSFFArea3,FieldAreaLabel2{iLabel}));
    end
    if iscell(FieldAreaLabel3)
        for iLabel = 1:length(FieldAreaLabel3)
            ind3 = [ind3, find(strcmp(SSFFArea4,FieldAreaLabel3{iLabel}))];
        end
    else
        ind3 = find(strcmp(SSFFArea4,FieldAreaLabel3{iLabel}));
    end
    ind = intersect(ind3,ind2);
    
    else   
    ind2 = [];
    ind3 = [];
    if iscell(FieldAreaLabel2)
        for iLabel = 1:length(FieldAreaLabel2)
            ind2 = [ind2 unique([find(strcmp(SSFFArea3,FieldAreaLabel2{iLabel})),find(strcmp(SSFFArea4,FieldAreaLabel2{iLabel}))])];
        end
    else
        ind2 = unique([find(strcmp(SSFFArea3,FieldAreaLabel2{iLabel})),find(strcmp(SSFFArea4,FieldAreaLabel2{iLabel}))]);
    end
    if iscell(FieldAreaLabel3)
        for iLabel = 1:length(FieldAreaLabel3)
            ind3 = [ind3 unique([find(strcmp(SSFFArea3,FieldAreaLabel3{iLabel})),find(strcmp(SSFFArea3,FieldAreaLabel3{iLabel}))])];
        end
    else
        ind3 = unique([find(strcmp(SSFFArea3,FieldAreaLabel3{iLabel})),find(strcmp(SSFFArea4,FieldAreaLabel3{iLabel}))]);
    end
    ind = intersect(ind3,ind2);
    end
end

if ~isempty(SpikeAreaLabel1) && ~isempty(FieldAreaLabel2) && ~isempty(FieldAreaLabel3)
    if strcmp(FieldAreaLabel2,FieldAreaLabel3)
        ind1 = [];
        ind2 = [];
        ind3 = [];
        if iscell(SpikeAreaLabel1)
            for iLabel = 1:length(SpikeAreaLabel1)
                ind1 = [ind1 find(strcmp(SSFFArea2,SpikeAreaLabel1{iLabel}))];
            end
        else
            ind1 = find(strcmp(SSFFArea2,SpikeAreaLabel1));
        end
        if iscell(FieldAreaLabel2)
            for iLabel = 1:length(FieldAreaLabel2)
                ind2 = [ind2, find(strcmp(SSFFArea3,FieldAreaLabel2{iLabel}))];
            end
        else
            ind2 = find(strcmp(SSFFArea3,FieldAreaLabel2{iLabel}));
        end
        if iscell(FieldAreaLabel3)
            for iLabel = 1:length(FieldAreaLabel3)
                ind3 = [ind3, find(strcmp(SSFFArea4,FieldAreaLabel3{iLabel}))];
            end
        else
            ind3 = find(strcmp(SSFFArea4,FieldAreaLabel3{iLabel}));
        end
        ind = intersect(ind3,ind2);
        
    else
        ind1 = [];
        ind2 = [];
        ind3 = [];
        if iscell(SpikeAreaLabel1)
            for iLabel = 1:length(SpikeAreaLabel1)
                ind1 = [ind1 find(strcmp(SSFFArea2,SpikeAreaLabel1{iLabel}))];
            end
        else
            ind1 = find(strcmp(SSFFArea2,SpikeAreaLabel1));
        end
        if iscell(FieldAreaLabel2)
            for iLabel = 1:length(FieldAreaLabel2)
                ind2 = [ind2, find(strcmp(SSFFArea3,FieldAreaLabel2{iLabel})),find(strcmp(SSFFArea4,FieldAreaLabel2{iLabel}))];
            end
            ind2 = unique(ind2);
        else
            ind2 = unique(find(strcmp(SSFFArea3,FieldAreaLabel2)),find(strcmp(SSFFArea4,FieldAreaLabel2)));
        end
        if iscell(FieldAreaLabel3)
            for iLabel = 1:length(FieldAreaLabel3)
                ind3 = [ind3, find(strcmp(SSFFArea3,FieldAreaLabel3{iLabel})),find(strcmp(SSFFArea4,FieldAreaLabel3{iLabel}))];
            end
            ind3 = unique(ind3);
        else
            ind3 = unique(find(strcmp(SSFFArea3,FieldAreaLabel3{iLabel})),find(strcmp(SSFFArea4,FieldAreaLabel3{iLabel})));
        end
        ind = intersect(ind3,ind2);
        ind = intersect(ind, ind1);
    end
end


if ~isempty(ind)
  SSFFSession = SSFF(ind);
else
  SSFFSession = {};
  disp('No SpikeSpikeFieldField sessions')
end
