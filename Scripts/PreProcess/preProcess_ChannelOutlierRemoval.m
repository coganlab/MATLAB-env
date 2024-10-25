function preProcess_ChannelOutlierRemoval(Task,options)
% Task is a structure with .Name = Task Name
arguments
    Task
    options.subjNum = []
end
global BOX_DIR
global RECONDIR
global TASK_DIR
global experiment
global DUKEDIR
%BOX_DIR=DirStruct.BOX_DIR;%'C:\Users\gcoga\Box';
%RECONDIR=DirStruct.RECONDIR;%'C:\Users\gcoga\Box\ECoG_Recon';

%addpath(genpath([BOX_DIR '\CoganLab\Scripts\']));

TASK_DIR=Task.Directory;
%TASK_DIR=([BOX_DIR '\CoganLab\D_Data\' Task.Name]);
DUKEDIR=TASK_DIR;


% Populate Subject file
Subject = popTaskSubjectData(Task);

if(isempty(options.subjNum))
    subjIds = 1:length(Subject);
else
    subjIds = options.subjNum;
end

for iSN=subjIds
    load([TASK_DIR '/' Subject(iSN).Name '/mat/experiment.mat']);
    load([TASK_DIR '/' Subject(iSN).Name '/' Subject(iSN).Date '/mat/Trials.mat'])
   
    % find bad channels based on 
    if (~isempty(Subject(iSN).Rec))
        if ~exist([TASK_DIR '/' Subject(iSN).Name '/badChannels.mat'])
            badChannels = channelOutlierRemoval(Subject(iSN),Task,Trials,Task.Outlier.Field);
            save([TASK_DIR '/' Subject(iSN).Name '/badChannels.mat'],'badChannels');
            Subject(iSN).badChannels=badChannels;
        end    
    end
end

