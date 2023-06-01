function FieldSession = extractFieldSession(Session)
%
%  FieldSession = extractFieldSession(Session)
%

global MONKEYDIR

if length(Session{5}) == 1
    if ~iscell(Session{5})
        if Session{5} > 100
            FieldSession = Session;
        end
    elseif iscell(Session{5})
        if Session{5}{1}(1) > 100
            FieldSession = Session;
        end
    end
elseif length(Session{5}) == 2
    if Session{5}{1}(1) > 100
        FieldSessionNum = Session{6}(1);
    else
        FieldSessionNum = Session{6}(2);
    end
    load([MONKEYDIR '/mat/Field_Session.mat']);
    FieldSession = Session{FieldSessionNum};
end
end

