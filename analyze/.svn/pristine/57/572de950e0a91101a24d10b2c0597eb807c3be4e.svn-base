function spike = loadpeak(file, clufile, Events, trials, field, bn, number,ch)
%  LOADPEAK loads spike data 
%
%  SPIKE = LOADPEAK(FILE, CLUFILE, EVENTS, TRIALS, FIELD, BN, NUMBER,CH)
%
%  Inputs:  FILE    = String.  Recording file prefix.  Can also be pk cell array.
%           EVENTS  = Structure.  Trial events data structure.
%           TRIALS  = Vector.  Trials to load data for.
%           FIELD   = Scalar.  Event to align data to.
%           BN      = Vector.  Time to start and stop loading data in ms.
%           NUMBER   = Scalar.  Field number to align data to.
%           CH      =  Vector.  Channels to load data from
%
%           Note:  Times should be in ms.
%
%   Outputs:   SPIKE  = {TRIAL,CH} Cell array. Spike times and peakvalues.
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

if ischar(file); load([file '.pk.mat']); else pk = file; end
if ischar(clufile); load([file '.clu.mat']); else clu = clufile; end

for iTr = 1:nTr
    at = getfield(Events,field,{trials(iTr),number});
    start = at+bn(1);
    stop = start+diff(bn)*FS./1e3;
    for iCh = 1:nCh
        if ~isempty(pk{ch(iCh)})
            clu1ind = find(clu{ch(iCh)}(:,2) == 1);
            pktrial = pk{ch(iCh)}(clu1ind,:);
            timestamps = pktrial(:,1)-start;
            peakvalues = pktrial(:,2);
            ind = find(timestamps > 0 & timestamps < diff(bn));
            spike{iTr,iCh} = [timestamps(ind) peakvalues(ind)];
        end
    end
end
spike = sq(spike);
