function Markerset = sessMocapMarkerset(Session, ObjectType)
%
%  Markerset = sessMocapMarkerset(Session, ObjectType)
%
% Returns the markerset used to to capture the object.
%
%  Inputs:  Session
%  	    ObjectType = 'Body' or 'Wand'.
%		Defaults to 'Body'
%
%  Outputs: Markerset
%

if nargin < 2
  ObjectType = 'Body';
end

if ~iscell(Session{1})
  Session = {Session};
end

nSess = length(Session);
for iSess = 1:nSess
  day = sessDay(Session{iSess});
  rec = sessRec(Session{iSess});
  MONKEYDIR = sessMonkeyDir(Session{iSess});
  
  load([MONKEYDIR '/' day '/' rec{1} '/rec' rec{1} '.experiment.mat']);
  ind = find(ismember(experiment.software.markerfiles, ObjectType));
  Markerset{iSess} = experiment.software.markerset{ind};
end
