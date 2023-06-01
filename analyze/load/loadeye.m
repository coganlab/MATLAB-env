function Eye = loadeye(file, Events, trials, field, bn, number, Scale, format)
%  LOADEYE loads eye position data
%
%  EYE = LOADEYE(FILE, EVENTS, TRIALS, FIELD, BN, NUMBER, SCALE)
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
%	    FORMAT  = String.  Defaults to 'short'
%
%
%   Outputs:    EYE  = [TRIAL,X/Y,TIME] Array. Eye position data.
%
%   Note:   If Scale is not input, loads data from file.seye.dat otherwise loads
%           data from file.eye.dat.
%

%  Written by:  Bijan Pesaran
%

if nargin < 8 || isempty(format)
    format = getFileFormat('Broker');
end

if ~isstr(field) error('FIELD needs to be a string'); end
if nargin < 6
    number = 1;
end
if nargin < 7
    Scale.Eye(1) = 1;
    Scale.EyeOffset(1) = 0;
    Scale.Eye(2) = 1;
    Scale.EyeOffset(2) = 0;
    Scale.Gradient = [1 0;0 1];
    Scale.Flag = [];
    fid = fopen([file '.seye.dat']);
    format = 'float';
    ss = 4;
elseif isempty(Scale)
    Scale.X(:,1) = [1,0];
    Scale.EyeOffset(1) = 0;
    Scale.Y(:,1) = [0,1];
    Scale.EyeOffset(2) = 0;
    Scale.Gradient = [1 0;0 1];
    Scale.Flag = 0;
    fid = fopen([file '.eye.dat']);
    if nargin < 8
        format = 'short';
    end
    ss = 2;
else
    fid = fopen([file '.eye.dat']);
    if nargin < 8
        format = 'short';
    end
    ss = 2;
end

bn = double(bn);
ntr = length(trials);
Eye = zeros(ntr,2,diff(bn));
if Scale.Gradient(1,1)==0
    Scale.Gradient(1,1) = Scale.Gradient(2,2);
end
if Scale.Gradient(2,2)==0
    Scale.Gradient(2,2) = Scale.Gradient(1,1);
end
gradient = Scale.Gradient^(-1);
%gradient
for i = 1:ntr
    at = getfield(Events,field,{trials(i),number});
    start = at+bn(1);
    fseek(fid,start.*ss.*2,'bof');
    ey = fread(fid,[2,diff(bn)],format);
    tmp(:,1) = gradient(1,1).*(ey(1,:) - Scale.EyeOffset(1)) + ...
        gradient(1,2).*(ey(2,:) - Scale.EyeOffset(2));
    tmp(:,2) = gradient(2,1).*(ey(1,:) - Scale.EyeOffset(1)) + ...
        gradient(2,2).*(ey(2,:) - Scale.EyeOffset(2));
    if isfield(Scale,'Theta')
        tmp = tmp*R(Scale.Theta);
    end
    Eye(i,:,1:size(tmp,1)) = tmp';
    if Scale.Flag
        ind = Eye(i,1,:)<0;
        Eye(i,1,ind) = 2*Eye(i,1,ind);
    end
end

fclose(fid);

Eye = squeeze(Eye);
