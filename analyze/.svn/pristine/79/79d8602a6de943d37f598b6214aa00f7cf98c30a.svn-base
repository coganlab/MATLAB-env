function [hand3d, marker_names] = loadHand3D(file, Events, trials, field, bn, marker_set, markers)
%  LOADHAND3D loads hand3D data 
%
%  [Hand3D, MarkerNames] = LOADHAND3D(FILE, EVENTS, TRIALS, FIELD, BN, MARKER_SET, MARKERS)
%
%  Inputs:  FILE    = String.  Recording file prefix.  Can also be hand3d cell array.
%           EVENTS  = Structure.  Trial events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = Scalar.  Event to align data to.
%           BN      = Vector or array.  Time to start and stop loading data in ms.
%			Can enter a different set of times for each trial. ie size(bn) = [Ntr,2];
%           MARKER_SET = String ('named','unnamed', 'all')
%           MARKERS      = Cell.  Marker channels to load data from
%
%           Note:  Times should be in ms.
%
%   Outputs:   HAND3D  = Marker number, (X,Y,Z), Time
%               MARKERNAMES = Cell array of marker names for requested
%               markers
%
%  Written by:  Yan Wong
%

global experiment 

marker_names = {};

if nargin < 4; field = 'TargsOn'; end
if nargin < 5; bn = [1,1000]; end
if nargin < 6; marker_set = ''; end
if nargin < 7; markers = whichMarkerNames(marker_set); end

number = 1;

if ischar(file)
    if(length(marker_set))
    disp(['loading ' file '.' marker_set '.Hand3D.mat']);
        load([file '.' marker_set '.Hand3D.mat']);    
        load([file '.' marker_set '.marker_names.mat']);    
        ch = find(ismember(marker_names,markers));
    else
        disp(['Loading ' file '.Hand3D.mat']);
        load([file '.Hand3D.mat']);
        marker_names = {}; % Not sure here either - marker_set shoud be defined.
        ch = 1;
    end
else
    Hand3D = file;  % Being called from trialHand3D.m
    ch = markers;
end

if ~exist('experiment','var') || isempty(experiment)
  disp(['loading ' file '.experiment.mat']);
  load([file '.experiment.mat']);
end

% PhaseSpaceSampleRate = getSampleRate('PhaseSpace');

% acquisition = experiment.hardware.acquisition;
% acquisitiontype = cell(1,length(acquisition));
% [acquisitiontype{:}] = deal(acquisition.type)
% PhaseSpaceHardware = find(ismember(acquisitiontype,'PhaseSpace'));
% PhaseSpaceSampleRate = acquisition(PhaseSpaceHardware).samplingrate;
% PhaseSpaceFormat = acquisition(PhaseSpaceHardware).data_format;


if(~length(marker_set))
    ntr = length(trials); nch = length(ch);
    if length(bn)==2 bn = repmat(bn,ntr,1); end
    hand3d = cell(ntr, nch);
    for iTr = 1:ntr
        at = getfield(Events,field,{trials(iTr),number}); % in ms
        start = at + bn(iTr,1); %  in ms
        for iCh = 1:nch
            hand_tmp = Hand3D{ch(iCh)};
            if ~isempty(hand_tmp)
                timestamps = hand_tmp(1,:)-start;  % in ms
                ind = (timestamps > 0) & (timestamps < diff(bn(iTr,:)));
                hand_data = hand_tmp(2:4,ind);
                hand3d{iTr,iCh} = [timestamps(ind); hand_data];
            end
        end
    end
else
    ntr = length(Events.Trial);    nch = length(ch)
    if length(bn)==2 bn = repmat(bn,ntr,1); end
    hand3d = cell(ntr, nch);
    event_time_stamp = Events.(field);% 
    for iTr = 1:ntr
        at = event_time_stamp(iTr); % in ms
        start = at + bn(iTr,1); %  in ms
        for iCh = 1:nch
            hand_tmp = Hand3D{ch(iCh)};
            if ~isempty(hand_tmp)
                timestamps = hand_tmp(1,:)-start;  % in ms
                ind = (timestamps > 0) & (timestamps <= diff(bn(iTr,:)));
                hand_data = hand_tmp(2:4,ind);
                hand3d{iTr,iCh} = [timestamps(ind); hand_data];
            end
        end
    end 
end
