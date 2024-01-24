function makeTrials_GL(subject, date)
% Creates the Trials.mat file for GlobalLocal data
%
% Args:
%   subject (str): subject ID
%   date (str): the date that the task was run
%
% Returns:
%
arguments
    subject
    date
end

global RECONDIR
subj_dir = fullfile(RECONDIR, '..', 'CoganLab', 'D_Data', 'GlobalLocal', subject);

%edf file
edf_filename = [subj_dir filesep subject ' ' date ' COGAN_GLOBALLOCAL.EDF'];
h = edfread_fast(edf_filename);

%behavioral file
t = readtable([subj_dir filesep 'Trials.csv']);

% remove any break trials
t = t(strcmp(t.logType,'task'),:);

%trigger file
load([subj_dir filesep 'trigTimes.mat']);

Trials = struct();
for A=1:height(t)

    % sub info
    Trials(A).Subject= t.subject_ID(1);
    Trials(A).Rec='001';
    Trials(A).Day=date;
    Trials(A).FilenamePrefix =[subject '_GlobalLocal_' date];

    % block and trial info
    Trials(A).trial=A;
    Trials(A).block = t.absBlockN(A);
    Trials(A).blockType=t.blockType{A};
    Trials(A).congruency=t.congruency{A};
    Trials(A).switchType=t.switchType{A};
    if strcmp(t.blockType{A},'A')
        Trials(A).percSwitch = 25;
        Trials(A).percIncongruent = 75;
    elseif strcmp(t.blockType{A},'B')
        Trials(A).percSwitch = 75;
        Trials(A).percIncongruent = 75;
    elseif strcmp(t.blockType{A},'C')
        Trials(A).percSwitch = 25;
        Trials(A).percIncongruent = 25;
    elseif strcmp(t.blockType{A},'D')
        Trials(A).percSwitch = 75;
        Trials(A).percIncongruent = 25;
    end

    % timing and codes
    Trials(A).stimulus = trigTimes(A) * 30000 / h.frequency(1);
    Trials(A).response=Trials(A).stimulus + (t.RT(A) / 1000 * 30000);
    Trials(A).RT = t.RT(A);
    Trials(A).acc = t.acc(A);
    Trials(A).stimulusCode=1;
    Trials(A).responseCode=26;

    % other
    Trials(A).Noisy=0;
    if t.partResponded(A)
        Trials(A).NoResponse=0;
    else
        Trials(A).NoResponse=1;
    end
end
save(fullfile(subj_dir, date, 'mat', 'Trials.mat'), 'Trials');
end