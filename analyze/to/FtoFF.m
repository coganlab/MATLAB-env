function Session = FtoFF(InputSession,Chamber)
%
%   Session = FtoFF(InputSession,Chamber)
%

if nargin < 2; Chamber = []; end

ProjectDir = sessProjectDir(InputSession);

Session = loadFieldField_Database(ProjectDir);

Ind = [];
for iSess = 1:length(Session)
    Field1SessNum = Session{iSess}{6}(1);
    Field2SessNum = Session{iSess}{6}(2);
    Field1Chamber = Session{iSess}{3}{1};
    Field2Chamber = Session{iSess}{3}{2};
    if ~isempty(Chamber)
        if (Field1SessNum == InputSession{6}(1) && ...
                (strcmp(Field2Chamber,Chamber) || ...
                (strcmp(Field2Chamber(1:2),Chamber(1:2)) && ...
                strcmp(Field2Chamber(end),Chamber(end))))) || ...
                (Field2SessNum == InputSession{6}(1) && ...
                (strcmp(Field1Chamber,Chamber) || ...
                (strcmp(Field1Chamber(1:2),Chamber(1:2)) && ...
                strcmp(Field1Chamber(end),Chamber(end)))))
            Ind = [Ind,iSess];
        end
    else
        if (Field1SessNum == InputSession{6}(1)) || (Field2SessNum == InputSession{6}(1))
            Ind = [Ind,iSess];
        end
    end
end

Session = Session(Ind);
disp([num2str(length(Session)) ' Field-Field ' Chamber ' sessions']);
