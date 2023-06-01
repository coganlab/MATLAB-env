function State = loadstate(file, Events, trials, field, bn, format, FS)
%  LOADSTATE loads analog state data 
%
%  STATE = LOADSTATE(FILE, EVENTS, TRIALS, FIELD, BN, FORMAT, FS)
%
%  Inputs:  FILE    = String.  Analog state data file prefix.
%           EVENTS  = Structure.  Trial events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = Scalar.  Event to align data to.
%           BN      = Vector.  Time to start and stop loading data.
%	    FORMAT  = String.  Data format
%	    FS
%
%   Outputs:    STATE = [TRIAL,TIME] Array. Analog state data.
%

%  Written by:  Bijan Pesaran
%

global experiment

if nargin < 6 || isempty(format)
  format = getFileFormat('Broker');
end
ss = 2;

if ~isstr(field) error('FIELD needs to be a string'); end
bn = double(bn);
ntr = length(trials);
State = zeros(ntr,diff(bn));

fid = fopen([file '.state.dat']);
for i = 1:ntr
  at = getfield(Events,field,{trials(i),1});
  start = at+bn(1);
  fseek(fid,start.*ss*FS./1e3,'bof');
  tmp = fread(fid,[1,diff(bn)*FS./1e3],format);
  State(i,1:size(tmp,2)) = tmp;
end

fclose(fid);

