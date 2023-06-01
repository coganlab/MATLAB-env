function Towers = sessTower(Sessions)
% Return the Tower fields from an array of Sessions
%
%   Towers = sessTower(Sessions)
%


if ~iscell(Sessions{1})
    Sessions = {Sessions};
end
%if iscell(Towers); Towers = Towers{1}; end

Towers = {};
for iSess = 1:length(Sessions)
    nComponent = length(Sessions{iSess}{6});
    for iComponent = 1:nComponent
        if iscell(Sessions{iSess}{3})
            a = Sessions{iSess}{3}{iComponent};
            if iscell(a)
                Towers{iSess,iComponent} = a{1};
            else
                Towers{iSess,iComponent} = a;
            end
        else
            Towers{iSess,iComponent} = Sessions{iSess}{3};
        end
    end
end

%if sum(size(Towers))==2; Towers = Towers{1,1}; end