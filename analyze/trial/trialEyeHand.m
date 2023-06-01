function [E, H] = trialEyeHand(Trials, field, bn, number, flag)
%  TRIALEYEHAND loads Hand and Eye position data for a trial
%
%  [E,H] = TRIALEYEHAND(TRIALS, FIELD, BN, NUMBER, FLAG)
%
%  Inputs:	    TRIALS = Trials data structure
%            	FIELD   = Scalar.  Event to align data to.
%            	BN      = Vector.  Time to start and stop loading data.
%            	NUMBER   = Scalar.  Field number to align data to.
%               FLAG    = Scalar.  1/0 raw/scaled
%                           Defaults to raw.
%
%  Outputs:	E	= [TRIAL,X/Y,TIME]. Eye position data
%

global MONKEYDIR experiment

olddir = pwd;

if nargin < 4 || isempty(number); number = 1; end
if nargin < 5 || isempty(flag); flag = 1; end

nTrials = length(Trials);
if nargout == 2; H = zeros(nTrials,2,diff(bn)); end
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
            cd([MONKEYDIR '/' day '/' rec]);
            load(['rec' rec '.Events.mat']);

            if isfield(experiment,'hardware')
                format = getFileFormat('Broker');
            elseif isfile(['rec' rec '.experiment.mat'])
                load(['rec' rec '.experiment.mat'])
                format = getFileFormat('Broker');
            elseif isfile(['rec' rec '.Rec.mat']);
                load(['rec' rec '.Rec.mat']);
                if ~isfield(Rec,'BinaryDataFormat')
                    Rec.BinaryDataFormat = 'short';
                end
                format = Rec.BinaryDataFormat;
            end
            
            if ~flag
                disp(' ... Loading scaled data');
                if nargout == 2
                    if isfile(['rec' rec '.HandScale.mat'])
                        load(['rec' rec '.HandScale.mat']); 
                    else
                        HandScale = [];
                    end
                end
                if isfile(['rec' rec '.EyeScale.mat'])
                    load(['rec' rec '.EyeScale.mat']); 
                else 
                    EyeScale = [];        
                end
            else
                EyeScale = [];        
                HandScale = [];
            end
            for iTr = 1:nTr
                tr = Tr(iTr);
                subtrial = Trials(DayTrials(tr)).Trial;
                if nargout == 2
                    H(DayTrials(tr),:,:) = loadhnd(['rec' rec], Events, subtrial, ...
                        field, bn, number, HandScale, format);
                end
                E(DayTrials(tr),:,:) = loadeye(['rec' rec], Events, subtrial, ...
                    field, bn, number, EyeScale, format);
            end
        end
    end
    
    if nargout == 2 H = sq(H); end
    E = sq(E);
end

cd(olddir);
