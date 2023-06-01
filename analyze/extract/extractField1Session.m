function FieldSession = extractField1Session(Session)
%
%  FieldSession = extractField1Session(Session)
%

if length(Session{5}) == 2
        if Session{5}{1}(1) > 100
           FieldSessionNum = Session{6}(1);
	   Session = loadField_Database;
	   FieldSession = Session{FieldSessionNum};
	end
end

