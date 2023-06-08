function Session = StoS(InputSession,Chamber,Ch)
%
%   Session = StoS(InputSession,Chamber,Ch)
%

if nargin < 2; Chamber = []; end
if nargin < 3; Ch = []; end
Session = {};

InputNum = InputSession{6};
SS_Sessions = StoSS(InputSession,Chamber,Ch);

for iS = 1:length(SS_Sessions)
    SpSess = splitSession(SS_Sessions{iS});
    if SpSess{1}{6} == InputNum
        Session{iS} = SpSess{2};
    else
        Session{iS} = SpSess{1};
    end
end


%if ~isempty(Session)
%    disp([num2str(length(Session)) ' Spike Sessions']);
%else
%    disp('No Spike Sessions');
%end


% Session = cell(0,0);
% InputNum = InputSession{6};
% SS_Sessions = StoSS(InputSession,Chamber);
% if ~isempty(SS_Sessions)
%     SN = getSessionNumbers(SS_Sessions);
%     OutputNum = unique(setdiff(SN(:),InputNum));
%     Session = loadSpike_Database;
%     Session = Session(OutputNum);
%     disp([num2str(length(Session)) ' Spike Sessions']);
% end