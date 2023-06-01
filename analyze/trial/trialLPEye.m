function [E] = trialLPEye(Trials,field,bn,number,flag,MonkeyDir)
%  TRIALLPEYE loads lowpass Eye position data for a trial
%
%  [E] = TRIALLPEYE(TRIALS, FIELD, BN, NUMBER, FLAG)
%
%  Inputs:	    TRIALS = Trials data structure
%            	FIELD   = Scalar.  Event to align data to.
%            	BN      = Vector.  Time to start and stop loading data.
%            	NUMBER   = Scalar.  Field number to align data to.
%               FLAG    = Scalar.  1/0 raw/scaled.  Defaults to 0=scaled.
%               MONKEYDIR = String.
%
%  Outputs:	E	= [TRIAL,X/Y,TIME]. Eye position data
%

global MONKEYDIR


disp('LowPass Eye data');

% flag = 0;
if nargin < 4 number = 1; end
if nargin < 5 flag = 0; end
if nargin < 6 || isempty(MonkeyDir); MonkeyDir = MONKEYDIR; end
nTrials = length(Trials);

if length(number)==1 number = repmat(number,nTrials,1); end

E = zeros(nTrials,2,diff(bn));

Day = getDay(Trials);
Days = unique(Day);
nDays = length(unique(Day));
disp([num2str(nDays) ' day(s)']);

for iDay = 1:nDays
    day = Days{iDay};
    disp(['Day: ' day]);
    Recs = dayrecs(day);
    nRecs = length(Recs);
    DayTrials = find(strcmp(Day,day));
    ntr = length(DayTrials);
    clear cRec;
    [cRec{1:ntr}] = deal(Trials(DayTrials).Rec);
    
    for iRecs = 1:nRecs
        rec = Recs{iRecs};
        Tr = find(strcmp(cRec,rec));
        nTr = length(Tr);
        if nTr
            disp(['Loading up ' num2str(nTr) ' trials']);
            
            disp(['Loading from ' day ' recording ' rec]);
            load([MonkeyDir '/' day '/' rec '/rec' rec '.Events.mat']);
            if ~flag
                disp(' ... Loading scaled data');
                if isfile([MonkeyDir '/' day '/' rec '/rec' rec '.EyeScale.mat'])
                    load([MonkeyDir '/' day '/' rec '/rec' rec '.EyeScale.mat']); 
                else 
                    EyeScale = [];        
                end
            else
                EyeScale = [];        
            end
            for iTr = 1:nTr
                tr = Tr(iTr);
                subtrial = Trials(DayTrials(tr)).Trial;
                num = number(DayTrials(tr));
                E(DayTrials(tr),:,:) = loadlpeye([MonkeyDir '/' day '/' rec '/rec' rec],Events,subtrial,field,bn,num,EyeScale);
            end
        end
    end
    
    E = sq(E);
end

