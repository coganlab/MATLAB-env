function Session = FFtoF(InputSession,Chamber)
%
%   Session = FFtoF(InputSession,Chamber)
%
%	Chamber is the ID for the session to be linked to
%

ProjectDir = sessProjectDir(Session);

Session = loadField_Database(ProjectDir);

SessNum = [];
FieldChamber = InputSession{3}{1};
if strcmp(FieldChamber,Chamber) || ...
        (strcmp(FieldChamber(1:2),Chamber(1:2)) && ...
        strcmp(FieldChamber(end),Chamber(end))))
    SessNum = InputSession{6}(1);
end

FieldChamber = InputSession{3}{2};
if (strcmp(FieldChamber,Chamber) || ...
        (strcmp(FieldChamber(1:2),Chamber(1:2)) && ...
        strcmp(FieldChamber(end),Chamber(end))))
    SessNum = [SessNum,InputSession{6}(2)];
end

if length(SessNum)==1
    Session = Session{SessNum};
else
    Session = Session(SessNum);
end
disp([num2str(length(SessNum)) ' Field sessions'])
