function Session = FtoF(InputSession,Chamber)
%
%   Session = FtoF(InputSession,Chamber)
%

if nargin < 2; Chamber = []; end

Session = cell(0,0);
InputNum = InputSession{6};
FF_Sessions = FtoFF(InputSession,Chamber);
if ~isempty(FF_Sessions)
    SN = getSessionNumbers(FF_Sessions);
    OutputNum = unique(setdiff(SN(:),InputNum));
    Session = loadField_Database;
    Session = Session(OutputNum);
    disp([num2str(length(Session)) ' Field Sessions']);
end
