function dsplfp = loaddsplfp(file, Events, trials, field, bn, CH)
%  LOADDSPLFP loads spike denoised filtered lfp data 
%
%  DSPLFP = LOADDSPLFP(FILE, EVENTS, TRIALS, FIELD, BN, CH)
%
%  Inputs:  FILE    = String.  Lfp data file prefix.
%           EVENTS  = Structure.  Trial events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = Scalar.  Event to align data to.
%           BN      = Vector.  Time to start and stop loading data.
%           CH      = Scalar.  Number of recording channels
%           Note:  Times should be ms.
%
%   Outputs:    DSPLFP  = [TRIAL,CH,TIME] Array. Spike denoised filtered lfp data.
%

%  Written by:  Bijan Pesaran
%


FS = 1e3;
if ~ischar(field); error('FIELD needs to be a string'); end
if nargin < 6; CH = 2; end

fid = fopen([file '.dsplfp.dat']);
format = 'float=>single';
ss = 4;
bn = double(bn);
ntr = length(trials);
%disp(num2str(ntr));
clfp = zeros(ntr,CH,diff(bn)*FS./1e3);

%Events.StartOn(trials)
if strcmp(field,'PulseStarts')
    pulse = 0;
    for i = 1:ntr
        pulseTimes = Events.PulseStarts{trials(i)}*1e3;
        for iPulse = 1:length(pulseTimes)
            pulse = pulse + 1;
            at = pulseTimes(iPulse);
            start = at+bn(1);
            pos = start.*ss.*CH*FS./1e3;
            status = fseek(fid,pos,'bof');
            if status < 0; ferror(fid); end
            h = fread(fid,[CH,diff(bn)*FS./1e3],format);
            dsplfp(pulse,:,1:size(h,2)) = h;
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
        
        dsplfp(i,:,1:size(h,2)) = h;
    end
end
fclose(fid);
% 
% if CH==1 || ntr == 1
%     mlfp = squeeze(mlfp);
% end
