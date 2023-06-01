function raw = loadraw(file, Events, trials, field, bn, CH, FS, format)
%
%  raw = loadraw(file, Events, trials, field, bn, CH, FS, format)
%
%
%   Inputs:  file = String.  Defines file to be loaded
%                               with name [file '.raw.dat']
global ss
if ~ischar(field); error('FIELD needs to be a string'); end

fid = fopen([file '.raw.dat']);
if nargin < 8
    format = 'short';
end
switch format
    case 'ushort'
        ss = 2;
    case 'float'
        ss = 4;
end

format = 'int16';

bn = double(bn);
ntr = length(trials);
raw = zeros(ntr,CH,diff(bn)*FS./1e3,'single');

if strcmp(field,'PulseStarts')
    pulse = 0;
    for i = 1:ntr
        pulseTimes = Events.PulseStarts{trials(i)};
        for iPulse = 1:length(pulseTimes)
            pulse = pulse + 1;
            at = pulseTimes(iPulse);
            start = at+bn(1);
            pos = start.*ss.*CH*FS./1e3;
            status = fseek(fid,pos,'bof');
            if status < 0; ferror(fid); end
            h = fread(fid,[CH,diff(bn)*FS./1e3],[format '=>single']);
            raw(pulse,:,1:size(h,2)) = h;
        end
    end
else
    for i = 1:ntr
        at = getfield(Events,field,{trials(i),1});
        start = at+bn(1);
        pos = start.*ss.*CH*FS./1e3;
        status = fseek(fid,pos,'bof');
        if status < 0; ferror(fid); end
        h = fread(fid,[CH,diff(bn)*FS./1e3],[format '=>single']);
        raw(i,:,1:size(h,2)) = h;
    end
end

fclose(fid);
raw = sq(raw);
