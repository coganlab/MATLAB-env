function Contacts = sessContact(Sessions)
% Return the Contact fields from an array of Sessions
%
%   Contacts = sessContact(Sessions)
%
%  Always returns a cell. This is because for laminar probes we need a vector of contacts.
%

if ~iscell(Sessions{1})  %  Processing single session
    tmp = Sessions{4};
    if iscell(tmp)
        if iscell(tmp{1})  % Electrode entry is always a scalar
            %  If this happens, we have {elec,contact} format
            nComponent = length(tmp);
            for iComponent = 1:nComponent
                Contacts{iComponent} = tmp{iComponent}{2};
            end
        else % single component {elec,contact} format.
            Contacts{1} = tmp{2};
        end
    else  % No contact specified.
        nComponent = length(tmp);
        for iComponent = 1:nComponent
            Contacts{iComponent} = 1;
        end
    end
else
    for iSess = 1:length(Sessions)  %  Processing array of sessions
        tmp = Sessions{iSess}{4};
        if iscell(tmp)
            if iscell(tmp{1})  % Electrode entry is always a scalar
                %  If this happens, we have {elec,contact} format
                nComponent = length(tmp);
                for iComponent = 1:nComponent
                    Contacts{iSess,iComponent} = tmp{2};
                end
            else % single component {elec,contact} format.
                Contacts{iSess,1} = tmp{2};
            end
        else  % No contact specified.
            nComponent = length(tmp);
            for iComponent = 1:nComponent
                Contacts{iSess,iComponent} = 1;
            end
        end
    end
end
