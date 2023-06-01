function mua = loadmua(file, Events, trials, field, bn, CH)
%  LOADCLFP loads mua filtered data (mua.dat), see procMUA
%
%  MUA = LOADMUA(FILE, EVENTS, TRIALS, FIELD, BN, CH)
%
%  Inputs:  FILE    = String.  mua data file prefix.
%           EVENTS  = Structure.  Trial events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = Scalar.  Event to align data to.
%           BN      = Vector.  Time to start and stop loading data.
%           CH      = Scalar.  Number of recording channels
%           FS      = Scalar. Sampling rate
%           Note:  Times should be ms.
%
%   Outputs:    MUA  = [TRIAL,CH,TIME] Array. filtered mua data.
%

% based on loadclfp written by Bijan Pesaran
% David Hawellek 14/01

FS = 1e3;
if ~ischar(field); error('FIELD needs to be a string'); end
if nargin < 6; CH = 2; end


fid = fopen([file '.mua.dat']);
ss = 4;
format = 'float=>single';
bn = double(bn);
ntr = length(trials);
mua = zeros(ntr,CH,diff(bn)*FS./1e3);
if strcmp(field,'PulseStarts')
    pulse = 0;
    for i = 1:ntr
        pulseTimes = Events.PulseStarts{trials(i)};
        for iPulse = 1:length(pulseTimes)
            pulse = pulse + 1;
            at = round(pulseTimes(iPulse));
            start = at+bn(1);
            pos = start.*ss.*CH*FS;
            status = fseek(fid,pos,'bof');
            if status < 0; ferror(fid); end
            h = fread(fid,[CH,diff(bn)*FS./1e3],format);
            mua(pulse,:,1:size(h,2)) = h;
        end
    end
else
    for i = 1:ntr
        at = getfield(Events,field,{trials(i),1});
        start = at + bn(1);
        pos = start.*ss.*CH*FS./1e3;
        status = fseek(fid,pos,'bof');
        if status < 0
            ferror(fid)
            file
            pos
        end
        h = fread(fid, [CH,diff(bn)*FS./1e3], format);
        mua(i,:,1:size(h,2)) = h;
    end
end
fclose(fid);
