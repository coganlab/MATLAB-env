function clfp = loadclfp(file, Events, trials, field, bn, CH)
%  LOADCLFP loads clean filtered lfp data 
%
%  CLFP = LOADCLFP(FILE, EVENTS, TRIALS, FIELD, BN, CH)
%
%  Inputs:  FILE    = String.  Lfp data file prefix.
%           EVENTS  = Structure.  Trial events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = Scalar.  Event to align data to.
%           BN      = Vector.  Time to start and stop loading data.
%           CH      = Scalar.  Number of recording channels
%           Note:  Times should be ms.
%
%   Outputs:    CLFP  = [TRIAL,CH,TIME] Array. Clean filtered lfp data.
%

%  Written by:  Bijan Pesaran
%

FS = 1e3;
if ~ischar(field); error('FIELD needs to be a string'); end
if nargin < 6; CH = 2; end

fid = fopen([file '.clfp.dat']);
ss = 4;
format = 'float=>single';
bn = double(bn);
ntr = length(trials);
%disp(num2str(ntr));
clfp = zeros(ntr,CH,diff(bn)*FS./1e3);

%Events.StartOn(trials)
if strcmp(field,'PulseStarts')
    pulse = 0;
    for i = 1:ntr
        pulseTimes = Events.PulseStarts{trials(i)};
        for iPulse = 1:length(pulseTimes)
            pulse = pulse + 1;
            at = round(pulseTimes(iPulse));
            start = at+bn(1);
            pos = start.*ss.*CH*FS./1e3;
            status = fseek(fid,pos,'bof');
            if status < 0; ferror(fid); end
            h = fread(fid,[CH,diff(bn)*FS./1e3],format);
            clfp(pulse,:,1:size(h,2)) = h;
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
        
        clfp(i,:,1:size(h,2)) = h;
    end
end
fclose(fid);
% 
% if CH==1 || ntr == 1
%     mlfp = squeeze(mlfp);
% end
