function dbSaveTrials(Subject, Day, Task)
%
%  dbSaveTrials(Subject, Day, Task)
%
%  Inputs:  Subject = String.  Subject name ie 'NY159'
%	    Day     = String.
%	    Task    = String.
%			Defaults to 'Speech_CovertOvert'
%

global NYUMCDIR

if nargin < 3 || isempty(Task) Task = 'Speech_CovertOvert'; end

if ~isdir([NYUMCDIR '/' Subject '/' Day '/mat'])
  mkdir([NYUMCDIR '/' Subject '/' Day '/mat'])
end
if isfile([NYUMCDIR '/' Subject '/' Day '/mat/Trials.mat'])
    delete([NYUMCDIR '/' Subject '/' Day '/mat/Trials.mat']);
end
Trials = dbTrials(Subject, Day, Task);

save([NYUMCDIR '/' Subject '/' Day '/mat/Trials.mat'],'Trials');
