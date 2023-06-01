function spike = loadspike(file, Events, trials, field, bn, number,ch)
%  LOADSPIKE loads spike data 
%
%  SPIKE = LOADSPIKE(FILE, EVENTS, TRIALS, FIELD, BN, NUMBER,CH)
%
%  Inputs:  FILE    = String.  Recording file prefix.  Can also be clu cell array.
%           EVENTS  = Structure.  Trial events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = Scalar.  Event to align data to.
%           BN      = Vector.  Time to start and stop loading data in ms.
%           NUMBER   = Scalar.  Field number to align data to.
%           CH      =  Vector.  Channels to load data from
%
%           Note:  Times should be in ms.
%
%   Outputs:   SPIKE  = {TRIAL,CH} Cell array. Spike times and clusters.
%

%  Written by:  Bijan Pesaran
%

FS = 1e3;

if ~ischar(field); error('FIELD needs to be a string'); end
if nargin < 6; number = 1; end
if nargin < 7; ch = [1:3]; end

bn = double(bn);
nTr = length(trials);
nCh = length(ch);
spike = cell(nTr,nCh);

if ischar(file); load([file '.clu.mat']); else clu = file; end

if strcmp(field,'PulseStarts')
    pulse = 0;
    for iTr = 1:nTr
        pulseTimes = Events.PulseStarts{trials(iTr)};
        for iPulse = 1:length(pulseTimes)
            pulse = pulse + 1;
            at = pulseTimes(iPulse);
            start = at+bn(1);
            stop = start+diff(bn)*FS./1e3;
            for iCh = 1:nCh
                if ~isempty(clu{ch(iCh)})
                    timestamps = clu{ch(iCh)}(:,1)-start;
                    clid = clu{ch(iCh)}(:,2);
                    ind = find(timestamps > 0 & timestamps < diff(bn));
                    spike{pulse,iCh} = [timestamps(ind) clid(ind)];
                end
            end
        end
    end
else
    
    for iTr = 1:nTr
        at = getfield(Events,field,{trials(iTr),number});
        start = at+bn(1);
        stop = start+diff(bn)*FS./1e3;
%         if trials(iTr)==100;keyboard;end
        for iCh = 1:nCh
            if ~isempty(clu{ch(iCh)})
                timestamps = clu{ch(iCh)}(:,1)-start;
                clid = clu{ch(iCh)}(:,2);
                ind = find(timestamps > 0 & timestamps < diff(bn));
                spike{iTr,iCh} = [timestamps(ind) clid(ind)];
            end
        end
    end
end
spike = sq(spike);
