% top level wrapper for preProcess workflow

global BOX_DIR
global RECONDIR
%global TASK_DIR
% BOX_DIR='C:\Users\gbc8\Box'
% RECONDIR='C:\Users\gbc8\Box\ECoG_Recon';
Task=[];
Task.Name='Phoneme_Sequencing';%'LexicalDecRepDelay';
%Task.Name='SentenceRep';
%Task.Name='LexicalDecRepNoDelay'
%Task.Name='Neighborhood_Sternberg';
%Task.Name='LexicalDecRepDelay';


Task.Directory=([BOX_DIR '/CoganLab/D_Data/' Task.Name]);

Task.Outlier.Field='Auditory'; % this is used to define the field for outlier channel removals
%Task.Outlier.Field='FirstStimAuditory';+++
preProcess_LineFilter(Task);
preProcess_ChannelOutlierRemoval(Task);
preProcess_ResponseCoding; % -> Trials.mat
% preProcess_Specgrams
% indiv task stats mat files

