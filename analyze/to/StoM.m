function Session = StoM(InputSession,Chamber,Ch)
%
%   Session = StoM(InputSession,Chamber,Ch)
%

if nargin < 2; Chamber = []; end
if nargin < 3; Ch = []; end
Session = {};

SM_Sessions = StoSM(InputSession,Chamber,Ch);

for iS = 1:length(SM_Sessions)
    Session{iS} = SMtoM(SM_Sessions{iS});
end

%if ~isempty(Session)
%    disp([num2str(length(Session)) ' Multiunit Sessions']);
%else
%    disp('No Multiunit Sessions');
%end