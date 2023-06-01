function Rec = loadRec(day,rec, MonkeyDir)
%
%   Rec = loadRec(day,rec, MonkeyDir)
%
%   INPUTS: DAY = String.  Recording day
%           REC = String.  Recording number.
%               Defaults to first recording of the day.
%
%   OUTPUTS: Rec = Data structure. Rec data structure.

global MONKEYDIR
if nargin < 3 || isempty(MonkeyDir)
    MonkeyDir = MONKEYDIR;
end
if nargin < 2 || isempty(rec)
    rec = dayrecs(day, MonkeyDir); 
    rec = rec{1}; 
end
RecFile = [MonkeyDir '/' day '/' rec '/rec' rec '.Rec.mat'];
if exist(RecFile, 'file')
    load(RecFile);
else
    disp([RecFile ' does not exist']);
    Rec = struct([]);
end