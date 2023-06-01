function [Joy, target_states] = intJoyTarget(segs,day,rec,state,bn, OFFSET)
% intJoyTarget    loads joystick and target state for the given time segments
%
%  [JOY, target_states] = intJoyTarget(segs,DAY,REC, state, BN)
%
%  Inputs:	
%               SEGS    = 2xN Matrix. N = number of segments.
%                       N(1,:) = starting positions
%                       N(2,:) = lengths
%            	STATE   = String.  STATE to align data to.
%                   Defaults to 'TargOn'
%            	BN      = Vector.  Time to start and stop loading data.
%                   Defaults to [-500,1500].
%
%  Outputs:	Joy{i}	= [STATES,2,TIME] joystick data
%           target_states{i} = [1, STATE] state of target at each timestep
%           Joy and target_states are cell arrays of size N
%
global MONKEYDIR;

CH = 2;
FS = 1e3;

if nargin < 3; state = 'Move'; end
if nargin < 4; bn = [-500,1500]; end

olddir = pwd;

load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
format = [Rec.BinaryDataFormat '=>single'];
ss = 2;
bn = double(bn);
load([MONKEYDIR '/' day '/' rec '/rec' rec '.State.mat']);
fid = fopen([MONKEYDIR '/' day '/' rec '/rec' rec '.joy.dat']);
StateTimes = getfield(State,state);

nstate = length(StateTimes);
%Joy = zeros(nstate,2,diff(bn)*FS./1e3,'single')-1e4;
%h = zeros(2,diff(bn)*FS./1e3,'single');

done = 0;
ridx = 1;
midx = 1;
idx = 1;
er = 1;
while ~done
try
  m = round(State.Move(midx));
  r = round(State.Rest(ridx));
  if m < r
    o = m;
    midx = midx + 1;
  else
    o = r;
    ridx = ridx + 1;
  end

  if er && o == r  
    obs(idx) = r+OFFSET;
    er = ~er;
    idx = idx + 1;
  end
  if ~er && o == m
    obs(idx) = m;
    er = ~er;
    idx = idx + 1;
  end
catch
done = 1;
end
end

obs_size = segs(end,1) + segs(end,2);

all_states = ones(1,max(obs(end),obs_size));
obs = [1 obs];
rest = 0;
for i=1:length(obs)-1
    if rest
        all_states(obs(i):obs(i+1)) = 1;
    else
        all_states(obs(i):obs(i+1)) = 2;
    end 
    rest = ~rest;
end


for i=1:size(segs,1)
    target_states{i} = all_states(segs(i,1):segs(i,1)+segs(i,2)-1);


    start = round(segs(i,1));
    pos = start.*ss.*CH.*FS./1e3;
    stat = fseek(fid,pos,'bof');
    len = segs(i,2);
    
    ferror(fid);
    if stat==0
        h = fread(fid,[CH,len.*FS./1e3],format);
        Joy{i} = h;
    end
end
fclose(fid);

Joy = sq(Joy);
cd(olddir);
