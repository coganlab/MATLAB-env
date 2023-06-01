function Session = StoF(InputSession,Chamber,Ch)
%
%   Session = StoF(InputSession,Chamber,Ch)
%

if nargin < 2; Chamber = []; end
if nargin < 3; Ch = []; end
Session = {};

SF_Sessions = StoSF(InputSession,Chamber,Ch);
    
for iS = 1:length(SF_Sessions)
    Session{iS} = SFtoF(SF_Sessions{iS});
end

%if ~isempty(Session)
%    disp([num2str(length(Session)) ' Field Sessions']);
%else
%    disp('No Field Sessions');
%end
