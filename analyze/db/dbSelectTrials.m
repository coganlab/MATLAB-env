function Trials = dbSelectTrials(day, rec, MonkeyDir)
%DBSELECTTRIALS determines trials that satisfy a set of criteria
%
%  Trials = dbSelectTrials(DAY, REC)
%
%   Inputs:     DAY     =   Cell array.  Day(s) to select.  ie {'020824','020825'}
%               REC     =   Cell array.  Recordings to select. ie
%               {'001','002'}.  Defaults to all recordings.
%
%   Outputs:    TRIALS  =   Data structure. Selected trials.
%

global MONKEYDIR

disp(['Selecting trials for specific day: ' day]);

if nargin < 2
    rec = dayrecs(day); 
end
if iscell(rec)
    tmp_rec = rec{1};
else
    tmp_rec = rec;
end
if nargin < 3 || isempty(MonkeyDir)
    MonkeyDir = MONKEYDIR;
end

if exist([MonkeyDir '/' day '/' tmp_rec '/rec' tmp_rec '.experiment.mat'],'file');
    Experiment = loadExperiment(day,[],MonkeyDir);
    if isMocapExperiment(Experiment)
        Trials = dbMocapDatabase(day, MonkeyDir);
    elseif isPlexonExperiment(Experiment)
        Trials = dbPlexondatabase(day);
    else
        Trials = dbdatabase(day,MonkeyDir);
    end
else
    Trials = dbdatabase(day,MonkeyDir);
end

disp([ num2str(length(Trials)) ' Trials']);

if ~isempty(Trials)
    if nargin > 1
        if ~iscell(rec) rec = {rec}; end
        nRec = length(rec);
        disp('Selecting trials for specific recordings')
        Recs = getRec(Trials);
        ind = [];
        for iRec = 1:nRec
            ind = [ind find(strcmp(Recs,rec{iRec}))];
        end
        if ~isempty(ind)
            Trials = Trials(ind);
            disp([' ... ' num2str(length(Trials)) ' trials']);
        else
            disp([' ... 0 trials']);
            Trials = [];
            return;
        end
    end 
end