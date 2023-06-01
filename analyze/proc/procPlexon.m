function procPlexon(day, rec)

% converts .plx files into lab format

global MONKEYDIR

disp('in procPlexon')
try
    tmp = dir([MONKEYDIR '/' day '/rec0*']);
    [recs{1:length(tmp)}] = deal(tmp.name);
    tmp = dir([MONKEYDIR '/' day '/rec1*']);
    [recs{end:end+length(tmp)-1}] = deal(tmp.name);
    tmp = dir([MONKEYDIR '/' day '/rec2*']);
    [recs{end:end+length(tmp)-1}] = deal(tmp.name);
    for iRec = 1:length(recs)
        recording = recs{iRec};
        recs{iRec} = recording(4:6);
    end
    nRecs = length(recs);
    
    for iRec = 1:length(recs)
        cd([MONKEYDIR '/' day]);
        if ~isdir(recs{iRec})
            disp(['moving rec' recs{iRec}])
            eval(['!mkdir ' recs{iRec}])
            eval(['!mv ' 'rec' recs{iRec} '.plx ' recs{iRec}])
            eval(['!mv ' 'rec' recs{iRec} '.experiment.mat ' recs{iRec}])
        end
    end
catch
    tmp = dir([MONKEYDIR '/' day '/0*']);
    [recs{1:length(tmp)}] = deal(tmp.name);
    tmp = dir([MONKEYDIR '/' day '/1*']);
    [recs{end:end+length(tmp)-1}] = deal(tmp.name);
    tmp = dir([MONKEYDIR '/' day '/2*']);
    [recs{end:end+length(tmp)-1}] = deal(tmp.name);
    nRecs = length(recs);
end

if nargin < 2 || isempty(rec)
    num = [1,str2num(recs{end})];
elseif ischar(rec)
    recs = {rec};
elseif length(rec)==1
    recs = {rec};
else
    disp('rec is no good');
end

for iRec = 1:length(recs)
    cd([MONKEYDIR '/' day '/' recs{iRec}]);
    Raw = [];
    load(['rec' recs{iRec} '.experiment.mat'])
    if isfile(['rec' recs{iRec} '.plx'])
        Raw = dir(['rec' recs{iRec} '.plx']);
        proc_raw_file_exists = 0;
        nMicrodrives = length(experiment.hardware.microdrive);
        for iMicrodrive = 1:nMicrodrives % use exp defn file?
            label = experiment.hardware.microdrive(iMicrodrive).name;
            if isfile(['rec' recs{iRec} '.' label '.raw.dat'])
                display(['rec' recs{iRec} '.' label '.raw.dat already processed']);
                proc_raw_file_exists = 1;
            end
        end
        if ~proc_raw_file_exists
            if ~isempty(Raw)
                disp('Processing Matlab dat files')
                disp(['Running preprocPlexon on ' MONKEYDIR '/' day '/' recs{iRec}]);
                preprocPlexon(recs{iRec}, experiment);
            end
        elseif ~isfile(['rec' recs{iRec} '.raw.dat'])
            disp(['No raw file found.  Cannot process.'])
        end
    end
end