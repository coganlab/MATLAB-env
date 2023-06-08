function procBlackrock(day, rec, fileTag)

% converts blackrock files into lab format
%input: day - recording day (string)
%       rec - recording number (string, e.g. '001'). If no input or empty,
%       defaults to processing all recordings
%       fileTag - file extension for blackrock files (default: '.ns6')

global MONKEYDIR

if nargin < 3 
    fileTag = '.ns6';
elseif isempty(filetag)
    fileTag = '.ns6';
end


disp('in procBlackrock')

tmp = dir([MONKEYDIR '/' day '/0*']);
[recs{1:length(tmp)}] = deal(tmp.name);
tmp = dir([MONKEYDIR '/' day '/1*']);
[recs{end:end+length(tmp)-1}] = deal(tmp.name);
tmp = dir([MONKEYDIR '/' day '/2*']);
[recs{end:end+length(tmp)-1}] = deal(tmp.name);
nRecs = length(recs);


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
    %cd([MONKEYDIR '/' day '/' recs{iRec}]);
    recDir = [MONKEYDIR, '/', day, '/', recs{iRec}, '/'];
    
    Raw = [];
    load([recDir, 'rec' recs{iRec} '.experiment.mat'])
    if isfile([recDir, 'rec' recs{iRec} fileTag])
        Raw = dir([recDir, 'rec' recs{iRec} fileTag]);
        proc_raw_file_exists = 0;
        nMicrodrives = length(experiment.hardware.microdrive);
        for iMicrodrive = 1:nMicrodrives % use exp defn file?
            label = experiment.hardware.microdrive(iMicrodrive).name;
            if isfile([recDir, 'rec' recs{iRec} '.' label '.raw.dat'])
                display([recDir, 'rec' recs{iRec} '.' label '.raw.dat already processed']);
                proc_raw_file_exists = 1;
            end
        end
        if ~proc_raw_file_exists
            if ~isempty(Raw)
                disp('Processing Matlab dat files')
                disp(['Running preprocBlackrock on ' recDir]);
                preprocBlackrock(day, recs{iRec}, experiment, fileTag);
            end
        elseif ~isfile(['rec' recs{iRec} fileTag])
            disp(['No raw file found.  Cannot process.'])
        end
    end
end