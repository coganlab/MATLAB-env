function Hand = loadhnd(file, Events, trials, field, bn, number, Scale, format)
%  LOADHND loads hand position data 
%
%  HAND = LOADHND(FILE, EVENTS, TRIALS, FIELD, BN, NUMBER, SCALE,FORMAT)
%
%  Inputs:  FILE    = String.  Hand position data file prefix.
%           EVENTS  = Structure.  Trial events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = Scalar.  Event to align data to.
%           BN      = Vector.  Time to start and stop loading data.
%           NUMBER   = Scalar.  Field number to align data to.
%           SCALE   = Structure.  Conversion from AD units to degrees
%
%   Outputs:    HAND  = [TRIAL,X/Y,TIME] Array. Hand position data.
%

%  Written by:  Bijan Pesaran
%

global experiment

if nargin < 8 || isempty(format)
  format = getFileFormat('Broker');
end

if ~isstr(field) error('FIELD needs to be a string'); end
if nargin < 6
    number = 1;
end
if isempty(Scale) || nargin < 7
    Scale.Hand(1) = 1; 
    Scale.HandOffset(1) = 0; 
    Scale.Hand(2) = 1; 
    Scale.HandOffset(2) = 0; 
    Scale.Gradient = [1 0;0 1];
    fid = fopen([file '.hnd.dat']);
    ss = 2;
else
    fid = fopen([file '.hnd.dat']);
    ss = 2;
end
bn = double(bn);
ntr = length(trials);
Hand = zeros(ntr,2,diff(bn));

for i = 1:ntr
  at = getfield(Events,field,{trials(i),number});
  start = at+bn(1);
  fseek(fid,start.*ss.*2,'bof');
  h = fread(fid,[2,diff(bn)],format);
  tmp = (h-repmat(Scale.HandOffset',1,size(h,2)))';
%     keyboard
  if Scale.Gradient(1,1)==0
    Scale.Gradient(1,1)=Scale.Gradient(2,2);
  end
  if Scale.Gradient(2,2)==0
    Scale.Gradient(2,2)=Scale.Gradient(1,1);
  end
  tmp = tmp*Scale.Gradient^(-1);
  if isfield(Scale,'Theta')
      tmp = tmp*R(Scale.Theta);
  end
  Hand(i,:,1:size(tmp,1)) = tmp';
%   Hand(i,1,:) = (h(1,:)-Scale.HandOffset(1)).*Scale.Hand(1);
%   Hand(i,2,:) = (h(2,:)-Scale.HandOffset(2)).*Scale.Hand(2);
end

fclose(fid);

Hand = sq(Hand);
