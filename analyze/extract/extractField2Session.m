function FieldSession = extractField2Session(Session)
%
%  FieldSession = extractField2Session(Session)
%

if length(Session{5}) == 2
    if Session{5}{2}(1) > 100
        FieldSessionNum = Session{6}(2);
        Session = loadField_Database;
        FieldSession = Session{FieldSessionNum};
    end
end

