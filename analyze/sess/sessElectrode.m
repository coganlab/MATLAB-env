function Electrode = sessElectrode(Sessions)
% Return the Electrode fields from an array of Sessions
%
%   Electrode = sessElectrode(Sessions)
%


if ~iscell(Sessions{1})
    tmp = Sessions{4};
    if iscell(tmp)
        if iscell(tmp{1})  % Electrode entry is always a scalar
            %  If this happens, we have multicomponent {elec,contact} format
            nComponent = length(tmp);
            for iComponent = 1:nComponent
                Electrode(iComponent) = tmp{iComponent}{1};
            end
        else % single component {elec,contact} format.
            Electrode(1) = tmp{1};
        end
    else  % No contact specified.
        nComponent = length(tmp);
        for iComponent = 1:nComponent
            Electrode(iComponent) = tmp(iComponent);
        end
    end
else
    for iSess = 1:length(Sessions)
        tmp = Sessions{iSess}{4};
        if iscell(tmp)
            if iscell(tmp{1})  % Electrode entry is always a scalar
                %  If this happens, we have {elec,contact} format
                %  or multiple parts! 
                nComponent = length(tmp);
                for iComponent = 1:nComponent
                    Electrode(iSess,iComponent) = tmp{iComponent}{1};
                end
            else % single component {elec,contact} format.
                Electrode(iSess,1) = tmp{1}(1); %Is this right?
            end
        else  % No contact specified.
            nComponent = length(tmp);
            for iComponent = 1:nComponent
                Electrode(iSess,iComponent) = tmp(iComponent);
            end
        end
    end
end
