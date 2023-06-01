function [cfc freq_pha, freq_amp] = sessCrossFrequencyPhaseAmplitude(Sess,CondParams, AnalParams)
%
%   [cfc] = sessCrossFrequencyPhaseAmplitude(Sess,CondParams, AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%   CondParams.conds   =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.Delay   =  Vector. Select trials according to delay interval (ms).
%                    Delay = [DelayStart,DelayStop].
%   CondParams.IntervalName = 'STRING';
%   CondParams.IntervalDuration = [min,max]
%                       IntervalDuration is either in ms or proportions
%                       if min and max are between 0 and 1 IntervalDuration
%                       is a proportion, otherwise a time duration in ms.
%                       For example
%                         IntervalDuration = [0,500] sums time duration
%                         IntervalDuration = [0,0.5] sums fastest 50% of
%                           intervals
%   
%   
%   Refer to tfwavelet for the choice of frequency parameters
%   AnalParams.bw_pha       = Scalar. Smoothing for the phase frequencies in fractional octaves.  Defaults to 0.75
%   AnalParams.freq_pha     = Vector. Frequencies for deriving phase. Defaults to 2.^[1:1/4:5]
%   AnalParams.bw_amp       = Scalar. Smoothing for the phase frequencies in fractional octaves.  Defaults to 0.5
%   AnalParams.freq_amp     = Vector. Frequencies for deriving phase. Defaults to 2.^[3:1/4:8]
%   AnalParams.nperm        = Scalar. Number of permutations to estimate noise CFC
%
%   Output
%   cfc                     = Cross frequency phase to amplitude coupling.
%
%   See Canolty et al. 2006, Science for a detailed description of the
%   measure. abs(cfc) gives the cross frequency coupling strength. The
%   coupling strength can be interpreted as a z-score resulting from a
%   random perumtation test. Only positive coupling scores are
%   interpretable and coupling scores greater than ~1.64 would be
%   significant at p < 0.05, one-tailed and uncorrected for multiple
%   testing at all phase-amplitude pairs. angle(cfc) results in the phase
%   angle of the coupling.


if(isfield(AnalParams,'bw_pha')); phapar.bw = AnalParams.bw_pha; else; phapar.bw = 0.75; end
if(isfield(AnalParams,'freq_pha')); phapar.foi = AnalParams.freq_pha; else; phapar.foi = 2.^[1:1/4:5]; end
if(isfield(AnalParams,'bw_amp')); amppar.bw = AnalParams.bw_amp; else; amppar.bw = 0.5; end
if(isfield(AnalParams,'freq_amp')); amppar.foi = AnalParams.freq_amp; else; amppar.foi = 2.^[3:1/4:8]; end
if(isfield(AnalParams,'nperm')); nperm = AnalParams.nperm; else nperm = 1e3; end
if(isfield(AnalParams,'sampling_rate')); sampling_rate = AnalParams.sampling_rate; else sampling_rate = 1e3; end

if(~isfield(CondParams,'Task')); CondParams.Task = 'DelReachSaccade'; end
if(~isfield(CondParams,'conds')); CondParams.conds = {[]}; end
if(isfield(CondParams,'bn')); bn = CondParams.bn; else; bn = [0,1e3]; end
if(isfield(CondParams,'Field')); Field = CondParams.Field; else; Field = 'TargsOn';end
if(~isfield(CondParams,'Delay')); CondParams.Delay = [0,5e3]; end

% Secondary output
freq_pha = phapar.foi;
freq_amp = amppar.foi;

nphafreq = numel(phapar.foi);
nampfreq = numel(amppar.foi);


Task = CondParams.Task;
if ischar(Task) && ~isempty(Task)
    NewTask{1} = {Task}; Task = NewTask;
elseif iscell(Task)
    for iTaskComp = 1:length(Task)
        if ~iscell(Task{iTaskComp})
            NewTask(iTaskComp) = {Task(iTaskComp)};
        else
            NewTask(iTaskComp) = Task(iTaskComp);
        end
    end
    Task = NewTask;
end


% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    All_Trials = sessTrials(Sess);
end

disp('Running Params2Trials');
All_Trials = Params2Trials(All_Trials,CondParams);

if(~iscell(All_Trials))
    Trials{1} = All_Trials;
else
    Trials = All_Trials;
end

Type= getSessionType(Sess);

disp([num2str(length(Trials{1})) ' Trials'])

for iTaskComp = 1:length(Trials)
    ntrials = length(Trials{iTaskComp});
    if factorial(ntrials) >= nperm
        TaskString = [];
        for iTaskPool = 1:length(Task{iTaskComp})
            TaskString = [TaskString Task{iTaskComp}{iTaskPool} ' '];
        end
        switch Type
            case 'Field'
                fprintf('Calculating CFC for %s\nPhase Frequencies: %.2fHz to %.2fHz\nAmplitude Frequencies: %.2fHz to %.2fHz\n',TaskString,phapar.foi(1),phapar.foi(end),amppar.foi(1),amppar.foi(end))
                % Recording information
                Sys = sessTower(Sess);
                Ch = sessElectrode(Sess);
		        Contact = sessContact(Sess);
                
                % Find out about the parameters for the phase frequency transform
                wp_pha = tfwavelet([],sampling_rate,phapar,1);
                wp_amp = tfwavelet([],sampling_rate,amppar,1);
                
                % Adjust the data limits to conform to wavelet properties:
                % add half an analysis window to start and beginnincg
                bn_adj = [bn(1)-floor(wp_pha.timewin(1)/2*sampling_rate) bn(2)+ceil(wp_pha.timewin(1)/2*sampling_rate)];
                               
                % Retrieve data
                Lfp = trialLfp(Trials{iTaskComp}, Sys, Ch, Contact, Field, bn_adj);
                ntr = size(Lfp,1);
                
                % Subtract evoked potential
                Lfp = Lfp - repmat(sum(Lfp),size(Lfp,1),1);
                
                % The window centers should have the identical samples
                nshift = round(wp_amp.timewin(end)/2.*sampling_rate); % shift according to highest frequency
                noff = ceil(wp_pha.timewin(1)/2.*sampling_rate); % inset according to lowest frequency
                win_centers = noff+1:nshift:size(Lfp,2)-(noff+1);
                nsections = numel(win_centers);
                ntime = nsections.*ntrials;
                
                phapar.win_centers = win_centers;
                amppar.win_centers = win_centers;
                clear win_centers
                
                % Wavelet transform for the phase frequencies
                fprintf('Phase Frequency Transform\n')
                [wp_pha, pha] = tfwavelet(Lfp,sampling_rate,phapar);

                % Wavelet transform of for the amplitude frequencies
                fprintf('Amplitude Frequency Transform\n')
                [wp_amp, amp] = tfwavelet(Lfp,sampling_rate,amppar);
                
                % Memory allocation
                tmp_cfc = nan(nphafreq,nampfreq,'single');
                tmp_cfc_m = nan(nphafreq,nampfreq,'single');
                tmp_cfc_s = nan(nphafreq,nampfreq,'single');
                
                bincount=0;
                for iph = 1:nphafreq
                    for iamp = 1:nampfreq
                        if amppar.foi(iamp)>=2.*phapar.foi(iph)
                            % cross frequency coupling
                            tmp_cfc(iph,iamp) = squeeze(sum(sum(abs(amp(:,:,iamp)).*exp((1i.*angle(pha(:,:,iph)))),2)))./ntime;

                            % resample distribution
                            cfc_perm = zeros(nperm,1);
                            
%                             rand('seed',1)
                            for iperm=1:nperm
                                [dummy permidx] = sort(rand(1,ntr));
                                cfc_perm(iperm) = abs(sum(sum(abs(amp(:,:,iamp)).*exp((1i.*angle(pha(permidx,:,iph)))),2))./ntime);
                            end
                            [m s] = normfit(cfc_perm);
                            tmp_cfc_m(iph,iamp) = m;
                            tmp_cfc_s(iph,iamp) = s;
                            clear m s
                        end
                        bincount=bincount+1;
                        if mod(bincount./(nphafreq.*nampfreq)*100,1)==0
                            fprintf('\r%.1f Percent',bincount./(nphafreq.*nampfreq)*100)
                        end
                    end
                end        
                
                % Conversion to complex coupling strength
                tmp = (abs(tmp_cfc)-tmp_cfc_m)./tmp_cfc_s;
                cfc{iTaskComp} = tmp.*(1i.*angle(tmp_cfc));
                clear tmp*
            otherwise 
                warning('Not a Field session')
        end
    else
        warning(sprintf('Too few trials for desired permutations\n%d Trials, %d Permutations\n Not calculating CFC for %s\n',length(Trials{1}),nperm,TaskString))
        cfc{iTaskComp}=[];
    end
end