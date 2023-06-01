function Session = MtoS(InputSession,Chamber,Ch)
%
%   Session = MtoS(InputSession,Chamber,Ch)
%

if nargin < 2; Chamber = []; end
if nargin < 3; Ch = []; end
Session = {};

SM_Sessions = MtoSM(InputSession,Chamber,Ch);

for iS = 1:length(SM_Sessions)
    Session{iS} = SMtoS(SM_Sessions{iS});
end

%if ~isempty(Session)
%    disp([num2str(length(Session)) ' Spike Sessions']);
%else
%    disp('No Spike Sessions');
%end