function Eye = loadlpeye(file, Events, trials, field, bn, number, Scale)
%  LOADEYE loads lowpass eye position data 
%
%  EYE = LOADLPEYE(FILE, EVENTS, TRIALS, FIELD, BN, NUMBER, SCALE)
%
%  Inputs:  FILE    = String.  Eye position data file prefix.
%           EVENTS  = Structure.  Trial events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = String.  Event field to align data to.
%                       ie 'TargsOn'
%           BN      = Vector.  Time to start and stop loading data 
%                       aligned to field. In ms.
%           NUMBER   = Scalar.  Field number to align data to.
%                       Defaults to 1.
%           SCALE   = Structure.  Conversion from AD units to degrees.
%                       Defaults to 1.
%
%   Outputs:    EYE  = [TRIAL,X/Y,TIME] Array. Eye position data.
%
%   Note:   If Scale is not input, loads data from file.seye.dat otherwise loads 
%           data from file.eye.dat.
%

%  Written by:  Bijan Pesaran
%


if ~ischar(field) error('FIELD needs to be a string'); end
if nargin < 6; number = 1; end
if nargin < 7 
    Scale.Eye(1) = 1; 
    Scale.EyeOffset(1) = 0; 
    Scale.Eye(2) = 1; 
    Scale.EyeOffset(2) = 0; 
    Scale.Gradient = [1 0;0 1];
    Scale.Flag = [];
    fid = fopen([file '.lp.seye.dat']);
    format = 'float';
    ss = 4;
elseif length(Scale)==0
    Scale.X(:,1) = [1,0]; 
    Scale.EyeOffset(1) = 0; 
    Scale.Y(:,1) = [0,1]; 
    Scale.EyeOffset(2) = 0; 
    Scale.Gradient = [1 0;0 1];
    Scale.Flag = 0;
    fid = fopen([file '.lp.eye.dat']);
    format = 'float';
    ss = 4;
else
    fid = fopen([file '.lp.eye.dat']);
    format = 'float';
    ss = 4;
end

if nargin < 8 flag = 0; end

bn = double(bn);
ntr = length(trials);
Eye = zeros(ntr,2,diff(bn));

for i = 1:ntr
  at = getfield(Events,field,{trials(i),number});
  start = at+bn(1);
  fseek(fid,start.*ss.*2,'bof');
  ey = fread(fid,[2,diff(bn)],format);
  tmp = (ey-repmat(Scale.EyeOffset',1,size(ey,2)))';
  if Scale.Gradient(1,1)==0
    Scale.Gradient(1,1) = Scale.Gradient(2,2);
  end
  if Scale.Gradient(2,2)==0
    Scale.Gradient(2,2) = Scale.Gradient(1,1);
  end
  tmp = tmp*Scale.Gradient^(-1);
  if isfield(Scale,'Theta')
      tmp = tmp*R(Scale.Theta);
  end
  Eye(i,:,1:size(tmp,1)) = tmp';
  if Scale.Flag
    ind = find(Eye(i,1,:)<0);
    Eye(i,1,ind) = 2*Eye(i,1,ind);
  end
end

fclose(fid);

Eye = squeeze(Eye);
