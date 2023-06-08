function elfp = loadelfp(file, Events, trials, field, bn, CH)
%  LOADELFP loads median filtered lfp data 
%
%  ELFP = LOADELFP(FILE, EVENTS, TRIALS, FIELD, BN, CH)
%
%  Inputs:  FILE    = String.  Lfp data file prefix.
%           EVENTS  = Structure.  Trial events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = Scalar.  Event to align data to.
%           BN      = Vector.  Time to start and stop loading data.
%           CH      = Scalar.  Number of recording channels
%           Note:  Times should be ms.
%
%   Outputs:    ELFP  = [TRIAL,CH,TIME] Array. Median filtered lfp data.
%

%  Written by:  Bijan Pesaran
%


FS = 5e3;
if ~ischar(field); error('FIELD needs to be a string'); end
if nargin < 6; CH = 2; end

fid = fopen([file '.elfp.dat']);
format = 'float=>single';
ss = 4;
bn = double(bn);
ntr = length(trials);
%disp(num2str(ntr));
elfp = zeros(ntr,CH,diff(bn)*FS./1e3);

%Events.StartOn(trials)
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

  elfp(i,:,1:size(h,2)) = h;
end
size(elfp);
fclose(fid);
% 
% if CH==1 || ntr == 1
%     mlfp = squeeze(mlfp);
% end
