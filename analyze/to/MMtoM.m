function Session = MMtoM(InputSession,Chamber)
%
%   Session = MMtoM(InputSession,Chamber)
%
%	Chamber is the ID for the session to be linked to
%

Session = loadMultiunit_Database;

SessNum = [];
MultiunitChamber = InputSession{3}{1};
if (strcmp(MultiunitChamber,Chamber) || ...
        (strcmp(MultiunitChamber(1:2),Chamber(1:2)) && ...
        strcmp(MultiunitChamber(end),Chamber(end))))
    SessNum = InputSession{6}(1);
end

MultiunitChamber = InputSession{3}{2};
if (strcmp(MultiunitChamber,Chamber) || ...
        (strcmp(MultiunitChamber(1:2),Chamber(1:2)) && ...
        strcmp(MultiunitChamber(end),Chamber(end))))
    SessNum = [SessNum,InputSession{6}(2)];
end

if length(SessNum)==1
    Session = Session{SessNum};
else
    Session = Session(SessNum);
end
disp([num2str(length(SessNum)) ' Multiunit sessions'])
