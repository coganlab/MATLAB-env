function recs=dayrecs(day, MonkeyDir)
%
%   recs=dayrecs(day, MonkeyDir)
%
global MONKEYDIR

if nargin < 2 || isempty(MonkeyDir)
    MonkeyDir = MONKEYDIR;
end

if iscell(day), day = day{1}; end
tmp = dir([MonkeyDir '/' day '/0*']);
for i = 1:9
 tmp = [tmp;dir([MonkeyDir '/' day '/' num2str(i) '*'])];
end

if ~isempty(tmp)
    [recs{1:length(tmp)}] = deal(tmp.name);
else
    recs = {};
end
