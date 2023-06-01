function [marker, markernames] = trialMarker(Trials, marker_type, markernames, field, bn)
%  TRIALMARKER loads marker data for markername for a trial
%
%  [MARKER, MARKERNAMES] = TRIALMARKER(TRIALS, MARKER_TYPE, MARKERNAMES, FIELD, BN)
%
%  Inputs:	TRIALS = Trials data structure
%           MARKER_TYPE = String ('Wand','Body'). Defaults to 'Body'.
%           MARKERNAMES = String.  marker to load data for.
%                       Defaults to all
%          	FIELD   = Scalar.  Event to align data to.
%                       Defaults to 'ReachStart'
%         	BN      = Vector or array.  Time to start and stop loading data.
%                       Can enter a different set of times for each trial. ie size(bn) = [Ntr,2];
%                       Defaults to [-500,500];

%  Outputs:	MARKER	= {TRIAL,MARKER}. MARKER data for a specific set of markers for
%                                         a subset of trials.
%

global MONKEYDIR experiment MARKER_TYPE_LIST
if nargin < 2 marker_type = 'Body'; end
if nargin < 3 
  typeid = find(ismember(MARKER_TYPE_LIST,marker_type));
  marker_set = Trials(1).MarkerSet{typeid};
  markernames = whichMarkerNames(marker_set); 
end
if nargin < 4 field = 'ReachStart'; end
if nargin < 5 bn = [-500,500]; end

if ischar(markernames) markernames = {markernames}; end
olddir = pwd;

ntr = length(Trials);
nmarker = length(markernames);
if length(bn)==2 bn = repmat(bn,ntr,1); end

marker = cell(ntr,nmarker);

Recs = getRec(Trials);
DayRecs = unique(Recs);

%  Assume all data from the same day
day = Trials(1).Day;
for iRec = 1:length(DayRecs)
    Tr_ind = find(ismember(Recs,DayRecs{iRec}));
    rec = DayRecs{iRec};
    subtrial = [Trials(Tr_ind).Trial];
    cd([MONKEYDIR '/' day '/' rec]);
    if(length(marker_type))
        load(['rec' rec '.' marker_type '.Marker.mat']);    
        load(['rec' rec '.' marker_type '.marker_names.mat']);    
        ch = find(ismember(marker_names,markernames));
    end
    load(['rec' rec '.experiment.mat'])
    load(['rec' rec '.MocapEvents.mat']);
    marker_tmp = loadMarker(Marker, MocapEvents, subtrial, field, bn(Tr_ind,:), marker_type, ch);
    marker(Tr_ind,:) = marker_tmp;
end
cd(olddir);
