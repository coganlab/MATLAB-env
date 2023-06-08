function Session = FtoM(InputSession,Chamber, Ch)
%
%   Session = FtoM(InputSession,Chamber, Ch)
%

if nargin < 2; Chamber = []; end
if nargin < 3; Ch = []; end

MF_Sessions = FtoMF(InputSession, Chamber, Ch);
Session =[];
for iS = 1:length(MF_Sessions)
    Session{iS} = MFtoM(MF_Sessions{iS});
end

disp([num2str(length(Session)) ' Multiunit ' Chamber ' Sessions']);
