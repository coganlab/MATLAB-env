function preProcess_LineFilter(Task)
% Task is a structure with .Name = Task Name

global BOX_DIR
global RECONDIR
global TASK_DIR
global experiment
global DUKEDIR
%BOX_DIR='C:\Users\gcoga\Box';
%RECONDIR=DirStruct.RECONDIR;%'C:\Users\gcoga\Box\ECoG_Recon';

%addpath(genpath([BOX_DIR '\CoganLab\Scripts\']));

TASK_DIR=Task.Directory;
%TASK_DIR=([BOX_DIR '\CoganLab\D_Data\' Task.Name]);
DUKEDIR=TASK_DIR;


% Populate Subject file
Subject = popTaskSubjectData(Task);

nSubj = length(Subject);

for iSN = 1:nSubj
    currentSubject = Subject(iSN);

    if ((~isempty(currentSubject.Rec)  && currentSubject.Rec(1).lineNoiseFiltered == 0))
        iSN
        experiment = load([TASK_DIR '/' currentSubject.Name '/mat/experiment.mat']);
        experiment = experiment.experiment;
        trials = load([TASK_DIR '/' currentSubject.Name '/' currentSubject.Date '/mat/Trials.mat']);
        Trials = trials.Trials;

        % linefilter if not already done
        for iR = 1:length(currentSubject.Rec)
            if currentSubject.Rec(iR).lineNoiseFiltered == 0
                ntools_procCleanIEEG([TASK_DIR '/' currentSubject.Name '/' ...
                    currentSubject.Date '/00' num2str(iR) ...
                    '/' currentSubject.Rec(iR).fileNamePrefix]);
            end
        end
    end
end


