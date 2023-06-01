function [Rate] = trialRate(Trials,sys,ch,contact,cl,field,bn,number)
%  trialRate loads spike rate data from a channel for a trial
%
%  [Rate] = TRIALRATE(TRIALS, SYS, CH, CONTACT, CL, FIELD, BN, NUMBER)
%
%  Inputs:	TRIALS = Trials data structure
%           SYS = Scalar/String.  System/Chamber to load data for ie 1 or 'F'
%	    CH	= Scalar.  Channel to load data for.
%               = or Vector [Depth, +/- Depth and Peak spike value] 
%               = or Floating point number in which spikes will be loaded
%               depending on peak values
%	    CONACT = Scalar.  Contact to load data for.
%           CL  = Scalar.  Cell to load data for.
%          	FIELD   = Scalar.  Event to align data to.
%         	BN      = Vector.  Time to start and stop loading data.
%          	NUMBER   = Scalar.  Field number to align data to.
%
%  Outputs:	Rate	= [Trial,Time]. Spike rate data for cell events on electrode.
%
%   Note:  Assumes system <-> chamber assignment is the same for all trials
%
global MONKEYDIR

if nargin < 2 || isempty(sys); sys = 1; end
if nargin < 3 || isempty(ch); ch = 1; end
if nargin < 4 || isempty(contact); contact = 1; end
if nargin < 5 || isempty(cl); cl = 1; end
if nargin < 6 || isempty(field); field = 'TargsOn'; end
if nargin < 7 || isempty(bn); bn = [-500,500]; end
if nargin < 8; number = 1; end

if iscell(contact) contact = contact{1}; end

olddir = pwd;

if ischar(sys)
    sysnum = findSys(Trials,sys);
end
mtch = getChannelIndex(Trials(1),sys,ch,contact);
ntr = length(Trials);

if length(number)==1
    number = repmat(number,ntr,1);
end
load_peaks = 0;
if(iscell(cl))
    cl = cl{1};
end
if(length(cl) == 3)
    load_peaks = 1;
    cl = cl(3);
elseif(mod(cl,1) ~= 0)
   load_peaks = 1;    
end
ntr = length(Trials);
Rate = zeros(1,ntr);
Recs = getRec(Trials);
day = Trials(1).Day;
recs = dayrecs(Trials(1).Day);
nRecs = length(recs);
for iRecs = 1:nRecs
    rec = recs{iRecs};
    Tr = find(strcmp(Recs,rec));
    nTr = length(Tr);
    if nTr
        disp(['Loading up ' num2str(nTr) ' trials']);
        disp(['Loading from ' day ' recording ' rec]);
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.Events.mat']);
        if(load_peaks)
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.pk.mat']);
        end
        
        if ~exist([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'],'file')
           makeClu(day,rec,sys); 
        end
        
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat']);
       
        if isempty(clu{mtch})
            tmp = pk(:,1);
            tmp(:,2) = 1;
            clu{mtch} = tmp;
            save([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'],'clu');
        end
        
        for iTr = 1:nTr
            tr = Tr(iTr);
            subtrial = Trials(tr).Trial;
            num = number(tr);
            if(load_peaks)
                %disp('Loading up data based on spike peak amplitudes');
                Spike_tmp = loadpeak(pk,clu,Events,subtrial,field,bn,num,mtch);
                tmp = Spike_tmp{1};
                if ~isempty(tmp)
                    % Positive or negative going spikes
                    if(mean(tmp(:,2) < 0))
                        ind = find(tmp(:,2) < cl);
                    else
                        ind = find(tmp(:,2) > cl);
                    end
                    if ind
                          Rate(tr) = length(ind)./diff(bn).*1e3;
                    end
                else
                    Rate(tr) = 0;
                end
            else
                Spike_tmp = loadspike(clu,Events,subtrial,...
                    field,bn,num,mtch);
                tmp = Spike_tmp{1};
                if ~isempty(tmp)
                    ind = find(tmp(:,2)==cl);
                    if ind
                        Rate(tr) = length(ind)./diff(bn).*1e3;
                    end
                else
                    Rate(tr) = 0;
                end
            end
        end
    end
end

cd(olddir);
