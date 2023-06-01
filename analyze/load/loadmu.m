function mu = loadmu(file, Events, trials, field, bn, CH, FS)
%
%  mu = loadmu(file, Events, trials, field, bn, CH, FS)
%
%
%   Inputs:  file = String.  Defines file to be loaded
%                               with name [file '.mu.dat']

if ~ischar(field); error('FIELD needs to be a string'); end

if exist([file '.cmu.dat'],'file')
  fid = fopen([file '.cmu.dat']);
else
  fid = fopen([file '.mu.dat']);
end

format = 'short=>single';
ss = 2;
bn = double(bn);
ntr = length(trials);
mu = zeros(ntr,CH,diff(bn)*FS./1e3,'single');

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
            h = fread(fid,[CH,diff(bn)*FS./1e3],format);
            mu(pulse,:,1:size(h,2)) = h;
        end
    end
else
    for i = 1:ntr
        at = getfield(Events,field,{trials(i),1});
        start = at+bn(1);
        pos = start.*ss.*CH*FS./1e3;
        status = fseek(fid,pos,'bof');
        if status < 0; ferror(fid); end
        h = fread(fid,[CH,diff(bn)*FS./1e3],format);
        mu(i,:,1:size(h,2)) = h;
    end
end

fclose(fid);
mu = sq(mu);
