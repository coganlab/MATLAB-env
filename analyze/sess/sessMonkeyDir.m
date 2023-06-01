function MonkeyDir = sessMonkeyDir(Sessions)
% Return the MonkeyDir field from an array of Sessions
%
%   MonkeyDir = sessMonkeyDir(Sessions,'/vol/sas2a/')
%


if ~iscell(Sessions{1})
    if length(Sessions)==7 || length(Sessions)==8
        MonkeyDir = Sessions{7};
    else
        MonkeyDir = Sessions{5};
    end
else
    if length(Sessions{1})==7 || length(Sessions{1})==8
        for iSess = 1:length(Sessions)
            MonkeyDir{iSess} = Sessions{iSess}{7};
        end
    else
        for iSess = 1:length(Sessions)
            MonkeyDir{iSess} = Sessions{iSess}{5};
        end
    end
end
