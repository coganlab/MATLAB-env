function Session = FtoS(InputSession,Chamber, Ch)
%
%   Session = FtoS(InputSession,Chamber, Ch)
%

if nargin < 2; Chamber = []; end
if nargin < 3; Ch = []; end

SF_Sessions = FtoSF(InputSession, Chamber, Ch);
Session =[];
for iS = 1:length(SF_Sessions)
    Session{iS} = SFtoS(SF_Sessions{iS});
end

disp([num2str(length(Session)) ' Spike ' Chamber ' Sessions']);
