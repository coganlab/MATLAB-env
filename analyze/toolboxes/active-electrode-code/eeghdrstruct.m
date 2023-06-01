function hdr = EEGHdrStruct;

% EEGHDRSTRUCT - default structure for EEG files
%       npts - number of data points
%       rate - sampling rate
%       nchan - number of channels
%       sens - sensitivity (uV/bit)
%       stime - start time of file
%       sdate - start date of file
%       labels - channel labels
%       hdrtype - type of header: TAG, BNI, END
%       nextfile - next file in a sequence, if applicable
%       events - annotated events
%       mpgfile - mpeg file, if applicable

%   CREATED: 4/25/2004 (SDC)
%   MODIFIED: 4/26/2004 (SDC)

hdr = struct('npts',[],'rate',[],'nchan',[],'sens',[],'datevec',[],...
    'labels',[],'hdrtype',[],'nextfile',[],'events',[],'mpginfo',[],'hdrbytes',[],'etime',[],'montage',[]);