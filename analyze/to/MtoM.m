function Session = MtoM(InputSession,Chamber)
%
%   Session = MtoM(InputSession,Chamber)
%

if nargin < 2; Chamber = []; end

ProjectDir = sessProjectDir(InputSession);

Session = cell(0,0);
InputNum = InputSession{6};
MM_Sessions = MtoMM(InputSession,Chamber);
if ~isempty(MM_Sessions)
    SN = getSessionNumbers(MM_Sessions);
    OutputNum = unique(setdiff(SN(:),InputNum));
    Session = loadMultiunit_Database(ProjectDir);
    Session = Session(OutputNum);
    disp([num2str(length(Session)) ' Multiunit Sessions']);
end