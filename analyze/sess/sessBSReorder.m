function NewSession = sessBSReorder(Session,Areas)

%   Session = sessBSReorder(Session,Areas)
%   Takes a session and the areas in the order the session should be
%   Returns the reordered session

SessType = getSessionType(Session);
Area = getBSArea(Session);
NArea = length(Area);

switch SessType
    case {'Spike','Multiunit','Field'}
        orders = {[1]};
    case {'SpikeField','MultiunitField','SpikeMultiunit','FieldSpike','FieldMultiunit','MultiunitSpike'}
        orders = {[1 2]};
    case {'FieldField', 'SpikeSpike','MultiunitMultiunit'}
        orders = {[1 2], [2 1]};
    case {'SpikeMultiunitField','SpikeFieldMultiunit','MultiunitSpikeField','MultiunitFieldSpike','FieldMultiunitSpike','FieldSpikeMultiunit'}
        orders = {[1 2 3]};
    case {'SpikeSpikeField','MultiunitMultiunitField','FieldFieldSpike','FieldFieldMultiunit','MultiunitMultiunitSpike','SpikeSpikeMultiunit'}
        orders = {[1 2 3], [2 1 3]};
    case {'SpikeFieldField','MultiunitFieldField','FieldSpikeSpike','FieldMultiunitMultiunit','SpikeMultiunitMultiunit','MultiunitSpikeSpike'}
        orders = {[1 2 3], [1 3 2]};
    case {'FieldSpikeField','FieldMultiunitField','SpikeFieldSpike','MultiunitFieldMultiunit','SpikeMultiunitSpike','MultiunitSpikeMultiunit'}
        orders = {[1 2 3], [3 2 1]};
    case {'FieldFieldField','SpikeSpikeSpike','MultiunitMultiunitMultiunit'}
        orders = {[1 2 3], [1 3 2], [2 1 3], [2 3 1], [3 1 2], [3 2 1]};
end

order = [];
for iOrder = 1:length(orders)
    tmporder = orders{iOrder};
    for ilength = 1:NArea
        correct(ilength) = sum(strcmp(Area{tmporder(ilength)},Areas{ilength}));
    end
    if sum(correct) == length(correct) && isempty(order)
        order = tmporder;
    end
end

NewSession = sessReorder(Session,order);

% SSess = splitSession(Session);
% 
% for iArea = 1:NArea
%     mySess{iArea} = SSess{order(iArea)};
% end
% 
% NewSession = createSession(mySess);

end

