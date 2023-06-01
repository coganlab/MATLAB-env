function [marker, marker_names] = loadMarker(file, Events, trials, field, bn, marker_type, markers)
%  LOADMARKER loads marker data 
%
%  [Marker, MarkerNames] = LOADMARKER(FILE, EVENTS, TRIALS, FIELD, BN, MARKER_TYPE, MARKERS)
%
%  Inputs:  FILE    = String.  Recording file prefix.  Can also be hand3d cell array.
%           EVENTS  = Structure.  Trial events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = Scalar.  Event to align data to.
%           BN      = Vector or array.  Time to start and stop loading data in ms.
%			Can enter a different set of times for each trial. ie size(bn) = [Ntr,2];
%           MARKER_TYPE = String ('Body','Wand').  Defaults to 'Body'
%           MARKERS      = Cell.  Marker channels to load data from
%
%           Note:  Times should be in ms.
%
%   Outputs:   MARKER  = Marker number, (X,Y,Z), Time
%               MARKERNAMES = Cell array of marker names for requested
%               markers
%
%  Written by:  Yan Wong
%

global experiment MARKER_TYPE_LIST

marker_names = {};

if nargin < 4; field = 'TargsOn'; end
if nargin < 5; bn = [1,1000]; end
if nargin < 6; marker_type = 'Body'; end

number = 1;

if ischar(file)
    if(length(marker_type))
        disp(['loading ' file '.' marker_type '.Marker.mat']);
        load([file '.' marker_type '.Marker.mat']);
        load([file '.' marker_type '.marker_names.mat']);
        if nargin < 7
            ch = 1:length(marker_names);
        else
            ch = find(ismember(marker_names,markers));
            marker_names = marker_names(ch);
        end
    end
else
    Marker = file;  % Being called from trialMarker.m
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


if(~length(marker_type))
    ntr = length(trials); nch = length(ch);
    if length(bn)==2 bn = repmat(bn,ntr,1); end
    marker = cell(ntr, nch);
    for iTr = 1:ntr
        at = getfield(Events,field,{trials(iTr),number}); % in ms
        start = at + bn(iTr,1); %  in ms
        for iCh = 1:nch
            marker_tmp = Marker{ch(iCh)};
            if ~isempty(marker_tmp)
                timestamps = marker_tmp(1,:)-start;  % in ms
                ind = (timestamps > 0) & (timestamps <= diff(bn(iTr,:)));
                marker_data = marker_tmp(2:4,ind);
                marker{iTr,iCh} = [timestamps(ind); marker_data];
            end
        end
    end
else
    ntr = length(Events.Trial);    nch = length(ch);
    if length(bn)==2 bn = repmat(bn,ntr,1); end
    marker = cell(ntr, nch);
    event_time_stamp = Events.(field);% 
    for iTr = 1:ntr
        at = event_time_stamp(iTr); % in ms
        start = at + bn(iTr,1); %  in ms
        for iCh = 1:nch
            marker_tmp = Marker{ch(iCh)};
            if ~isempty(marker_tmp)
                timestamps = marker_tmp(1,:)-start;  % in ms
                ind = (timestamps > 0) & (timestamps <= diff(bn(iTr,:)));
                marker_data = marker_tmp(2:4,ind);
                marker{iTr,iCh} = [timestamps(ind); marker_data];
            end
        end
    end 
end
