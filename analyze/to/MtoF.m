function FinalSession = MtoF(InputSession, Chamber, Ch)
%
%   Session = MtoF(InputSession, Chamber, Ch)
%

if nargin < 2; Chamber = []; end
if nargin < 3; Ch = []; end
Session = {};
MF_Sessions = MtoMF(InputSession,Chamber);
    
ProjectDir = sessProjectDir(InputSession);

FieldSession = loadField_Database(ProjectDir);
for iS = 1:length(MF_Sessions)
    SN = sessNumber(MF_Session{iS})
    Session{iS} = FieldSession{SN(2)};
end

ind = 0;
FinalSession = {};
% FinalSession = Session;
if ~isempty(Session) && ~isempty(Ch)
    for iS = 1:length(Session)
        Channel = sessElectrode(Session{iS});
        if Channel == Ch
            ind = ind+1;
            FinalSession{ind} = Session{iS};
        end
    end
else
    FinalSession = Session;
end
% 
 if ~isempty(FinalSession)
     disp([num2str(length(FinalSession)) ' Multiunit Sessions']);
 else
     disp('No Multiunit Sessions');
 end
