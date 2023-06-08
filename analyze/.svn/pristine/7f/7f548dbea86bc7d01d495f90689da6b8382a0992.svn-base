function hand3d = trialHand3D(Trials, field, bn, marker_set, markernames)
%  TRIALHAND3D loads Hand3D data for markername for a trial
%
%  HAND3D = TRIALHAND3D(TRIALS, FIELD, BN, MARKER_SET, MARKERNAMES)
%
%  Inputs:	TRIALS = Trials data structure
%          	FIELD   = Scalar.  Event to align data to.
%                       Defaults to 'ReachStart'
%         	BN      = Vector or array.  Time to start and stop loading data.
%                       Can enter a different set of times for each trial. ie size(bn) = [Ntr,2];
%                       Defaults to [-500,500];
%           MARKER_SET = String ('named','unnamed', 'all')
%           MARKERNAMES = String.  marker to load data for.
%                       Defaults to all
%
%  Outputs:	HAND3D	= {TRIAL,MARKER}. HAND3D data for a specific set of markers for
%                                         a subset of trials.
%

global MONKEYDIR experiment

if nargin < 2 field = 'ReachStart'; end
if nargin < 3 bn = [-500,500]; end
if nargin < 4 marker_set = ''; end
if nargin < 5 markernames = 1; end


olddir = pwd;

%oldrec = ''; oldday = '';
ntr = length(Trials);
nmarker = length(markernames);
if length(bn)==2 bn = repmat(bn,ntr,1); end

hand3d = cell(ntr,nmarker);

Recs = getRec(Trials);
DayRecs = unique(Recs);

%  Assume all data from the same day
day = Trials(1).Day;
for iRec = 1:length(DayRecs)
    Tr_ind = find(ismember(Recs,DayRecs{iRec}));
    rec = DayRecs{iRec};
    subtrial = [Trials(Tr_ind).Trial];
    cd([MONKEYDIR '/' day '/' rec]);
    if(length(marker_set))
        load([file '.' marker_set '.Hand3D.mat']);    
        ch = find(ismember(marker_names,markernames));
    else
        load(['rec' rec '.Hand3D.mat'])
        ch = 1:size(Hand3D,1);
    end
    load(['rec' rec '.experiment.mat'])
    load(['rec' rec '.MocapEvents.mat']);
    hand3d_tmp = loadHand3D(Hand3D, MocapEvents, subtrial, field, bn(Tr_ind,:), marker_set, ch);
    hand3d(Tr_ind,:) = hand3d_tmp;
end
cd(olddir);
