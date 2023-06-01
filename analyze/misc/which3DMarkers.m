function Markers = which3DMarkers(day)
%
% which3DMarkers determines which 3D markers have data 
%
%  Markers = which3DMarkers(day)
%
%  Day = String or Struct.  
%		If string, Trials is loaded.  
%		If struct, assumed to be Trials.
%

global MONKEYDIR

if ischar(day)
  Trials = dbSelectTrials(day);
elseif isstruct(day)
  Trials = day;
end
load([MONKEYDIR '/' Trials(1).Day '/' Trials(1).Rec ...
	'/rec' Trials(1).Rec '.Hand3D.mat']);

for iMarker = 1:length(Hand3D)
  flag(iMarker) = isempty(Hand3D{iMarker});
end

Markers = find(flag==0);

