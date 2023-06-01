function [Mlfp, segs] = intMlfp(day,rec,sys,ch,state,bn,method)
%  intMlfp loads intervals of Mlfp data 

global MONKEYDIR;

load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
FS = 1e3;

if nargin < 3; sys = 'P'; end
if nargin < 5; state = 'Move'; end
if nargin < 6; bn = [-500,1500]; end
if nargin < 7; if length(ch)==1 method = 1; else method = 0; end; end

sysnum = find(strcmp(Rec.MT,sys));
CH = Rec.Ch(sysnum);

olddir = pwd;
format = 'float=>single';
ss = 4;
bn = double(bn);
nch = length(ch);
load([MONKEYDIR '/' day '/' rec '/rec' rec '.State.mat']);
fid = fopen([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.mlfp.dat']);
StateTimes = round(getfield(State,state));

nstate = length(StateTimes);
%Mlfp = zeros(nstate,length(ch),diff(bn)*FS./1e3,'single')-1e4;
%h = zeros(1,diff(bn)*FS./1e3,'single');


%at = StateTimes(iState);
%start = at + bn(1);
%pos = start.*ss.*CH*FS./1e3;
%stat = fseek(fid,pos,'bof');
%ferror(fid);
%
%if stat == 0
%    h = fread(fid,[CH,length*FS./1e3],format);
%    Mlfp(segidx,:) = h(ch,:);
%end
%disp DONE
%
%keyboard
%


MAX_STATE_TIME = 10000;
segidx = 1;
len = 0;
seg_start = 0;
seg_end = 0;
dStateTimes = diff(StateTimes);
last_state = length(StateTimes) - 1;
Mlfp = [];
for iState = 1:last_state
    at = StateTimes(iState);
    if at + bn(1) < 1
	continue
    end
    if seg_start ==0
        seg_start = iState;
else
    if dStateTimes(iState) > MAX_STATE_TIME
        seg_end = iState;
    end
    if iState == last_state
        seg_end = iState;
    end
    if seg_end
        start = StateTimes(seg_start) + bn(1);
        pos = start.*ss.*CH*FS./1e3;
        fin = StateTimes(seg_end) + bn(2);
        len = fin - start;
        if method == 0
            stat = fseek(fid,pos,'bof');
            ferror(fid);
            if stat==0
                [h,c] = fread(fid,[CH,len*FS./1e3],format);
                len = c;
                Mlfp{segidx} = h(ch,:);
            end
        else
            for ic = 1:nch
                stat = fseek(fid,pos + (ch(ic)-1)*ss,'bof');
                if stat == 0
                    [h,c] = fread(fid,[1,len*FS./1e3],format,(CH-1)*ss);
                    len = c;
                    Mlfp{segidx} = h;
                end
            end
        end
        segs(segidx,:) = [start len];
        segidx = segidx  + 1;
        seg_end = 0;
        seg_start = 0;
    end 
end
    
end

fclose(fid);



Mlfp = sq(Mlfp);
cd(olddir);
