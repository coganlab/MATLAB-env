function [Coh,S1,S2,f] = sessShuffleCoherency(Sess,CondParams, AnalParams, NPERM)
%
% Shuffles the trials for the second session 
% Computes 1e4 coherencies to create a null coherece distribution
%   [Coh,S1,S2,f,t,Data] = sessShuffleCoherency(Sess,CondParams, AnalParams)
% 
%   removed t and Data from output because I dont know how to write them
%   into matlab pool.
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.Delay   =  Vector. Select trials according to delay interval (ms).
%                    Delay = [DelayStart,DelayStop].
%   CondParams.IntervalName = 'STRING';
%   CondParams.IntervalDuration = [min,max]
%                       IntervalDuration is either in ms or proportions
%                       if min and max are between 0 and 1 IntervalDuration
%                       is a proportion, otherwise a time duration in ms.
%                       For example
%                         IntervalDuration = [0,500] means time duration
%                         IntervalDuration = [0,0.5] means fastest 50% of
%                           intervals
%
%   AnalParams.tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test
%
% NPERM = number of permutations.  Defaults to 1e4

if(isfield(AnalParams,'fk'))
    fk = AnalParams.fk;
else
    fk = 200;
end
if(isfield(AnalParams,'sampling_rate'))
    sampling_rate = AnalParams.sampling_rate;
else
    sampling_rate = 1e3;
end
if(isfield(AnalParams,'dn'))
    dn = AnalParams.dn;
else
    dn = 0.05;
end
if(isfield(AnalParams,'pad'))
    pad = AnalParams.pad;
else
    pad = 2;
end
if(isfield(AnalParams,'tapers'))
    tapers = AnalParams.tapers;
else
    tapers = [0.5,5];
end

if(~isfield(CondParams,'Task'))
    CondParams.Task = 'MemoryReachSaccade';
end

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

if(~isfield(CondParams,'conds'))
    CondParams.conds = {[]};
end
if(isfield(CondParams,'bn'))
    bn = CondParams.bn;
else
    bn = [-1e3,2e3];
end
if(isfield(CondParams,'Field'))
    Field = CondParams.Field;
else
    Field = 'TargsOn';
end

if(~isfield(CondParams,'Delay'))
    CondParams.Delay = [0,5e3];
end

if nargin < 4
NPERM = 1e4;
end

% This handles Trials in Sess{1} instead of Day.
% if isstruct(Sess{1})
%     All_Trials = Sess{1};
% else
    All_Trials = sessTrials(Sess);
% end

disp('Running Params2Trials');
All_Trials = Params2Trials(All_Trials,CondParams);

% if(~iscell(All_Trials))
%     Trials{1} = All_Trials;
% else
    Trials = All_Trials;
% end


nTr = 1:length(Trials);
Type= getSessionType(Sess);

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

t = [bn(1):dn*sampling_rate:bn(2)];

disp([num2str(length(Trials)) ' Trials'])

if length(Trials) > 3
    
    
    %         disp(['Calculating ' Type ' coherency with N = ' ...
    %             num2str(N) ' and W = ' num2str(W) ' for ' ...
    %             TaskString ' using  ' num2str(length(Trials{iTaskComp})) ' Trials']);
    
    
    switch Type
        case 'FieldField'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
	    Contact = sessContact(Sess);
            Lfp1 = trialLfp(Trials, Sys{1}, Ch(1), Contact(1), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            Lfp2 = trialLfp(Trials, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            
            
            % and now to permute...
            if matlabpool('size')
                Coh = cell(NPERM, length(nTr));
                f = zeros(NPERM, length(nTr));
                S1 = cell(NPERM, length(nTr));
                S2 = cell(NPERM, length(nTr));
                Data.Sess1 = zeros(NPERM, length(Sess1));
                
                for iPerm = 1:NPERM
                    
                    shuffleTrials = shuffle(nTr);
                    shuffleSess = Lfp2(shuffleTrials,:);
                    
                    parfor iTaskComp = 1:length(nTr)
                        
                        tic; [Coh{iTaskComp},f,S1{iTaskComp},S2{iTaskComp}] = ...
                            tfcoh(Lfp1, shuffleSess,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
                        
                    end
                    
                end
            else
                Coh = cell(NPERM, length(nTr), length(Sess1));
                f = zeros(NPERM, length(nTr));
                S1 = cell(NPERM, length(nTr));
                S2 = cell(NPERM, length(nTr));
                %             Data.Sess1 = zeros(NPERM, length(Sess1));
                
                for iPerm = 1:NPERM
                    
                    shuffleTrials = shuffle(nTr);
                    shuffleSess = Lfp2(shuffleTrials,:);
                    
                    for iTaskComp = 1:length(nTr)
                        
                        tic; [Coh{iTaskComp},f,S1{iTaskComp},S2{iTaskComp}] = ...
                            tfcoh(Lfp1, shuffleSess,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
                        
                    end
                    
                end
            end
            
        case 'SpikeField'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
	    Contact = sessContact(Sess);
            if ~iscell(Sess{5})
                Cl = Sess{5}(1);
            elseif iscell(Sess{5})
                Cl = Sess{5}{1}(1);
            end
            
            
            Spike = trialSpike(Trials, Sys{1}, Ch(1), Contact(1), Cl, Field{1}, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
            Lfp = trialLfp(Trials, Sys{2}, Ch(2), Contact(2), Field{1}, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            
            % and now to permute...
            if matlabpool('size')
                Coh = cell(NPERM, length(nTr));
                f = zeros(NPERM, length(nTr));
                S1 = cell(NPERM, length(nTr));
                S2 = cell(NPERM, length(nTr));
                %Data.Sess1 = zeros(NPERM, length(Sess1));
                
                for iPerm = 1:NPERM
                    
                    shuffleTrials = shuffle(nTr);
                    shuffleSess = Lfp(shuffleTrials,:);
                    
                    parfor iTaskComp = 1:length(nTr)
                        
                        tic; [Coh{iPerm,iTaskComp},f,S1{iPerm,iTaskComp},S2{iPerm,iTaskComp}] = ...
                            tfcoh_ptx(Spike, shuffleSess,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
                        
                    end
                    
                end
            else
                Coh = cell(NPERM, length(nTr), length(Sess1));
                f = zeros(NPERM, length(nTr));
                S1 = cell(NPERM, length(nTr));
                S2 = cell(NPERM, length(nTr));
                %             Data.Sess1 = zeros(NPERM, length(Sess1));
                
                for iPerm = 1:NPERM
                    
                    shuffleTrials = shuffle(nTr);
                    shuffleSess = Lfp(shuffleTrials,:);
                    
                    for iTaskComp = 1:length(nTr)
                        
                        tic; [Coh{iTaskComp},f,S1{iTaskComp},S2{iTaskComp}] = ...
                            tfcoh_ptx(Spike, shuffleSess,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
                        
                    end
                    
                end
            end
            
            
        case 'MultiunitField'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
	    Contact = sessContact(Sess);
            Multiunit = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), 1, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            Lfp = trialLfp(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            Multiunit = sp2ts(Multiunit,[0,diff(bn)./1e3+N,1e3]);
            [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
                tfcoh_ptx(Lfp,Multiunit,[N,W],sampling_rate,dn,fk,pad,0.05,11);
            Data.Multiunit = Multiunit;
            Data.Lfp = Lfp;
        case 'SpikeFieldField'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
            Cl = sessCell(Sess);
	    Contact = sessContact(Sess);
            tic
            Spike = trialSpike(Trials, Sys{1}, Ch(1), Contact(1), Cl, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            Lfp1 = trialLfp(Trials, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            Lfp2 = trialLfp(Trials, Sys{3}, Ch(3), Contact(3), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            Lfp = Lfp1-Lfp2; clear Lfp1 Lfp2
            Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
            [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp}] = ...
                tfcoh_ptx(Lfp,Spike,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
        case 'MultiunitFieldField'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
	    Contact = sessContact(Sess);
            Cl = Sess{5}(1);
            tic
            Spike = trialSpike(Trials, Sys{1}, Ch(1), Contact(1), Cl, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            Lfp1 = trialLfp(Trials, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            Lfp2 = trialLfp(Trials, Sys{3}, Ch(3), Contact(3), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            Lfp = Lfp1-Lfp2; clear Lfp1 Lfp2
            Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
            [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp}] = ...
                tfcoh_ptx(Lfp,Spike,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
        case 'FieldFieldField'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
	    Contact = sessContact(Sess);
            tic
            Lfp1 = trialLfp(Trials, Sys{1}, Ch(1), Contact(1), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            Lfp2 = trialLfp(Trials, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            Lfp3 = trialLfp(Trials, Sys{3}, Ch(3), Contact(3), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
            Lfp = Lfp2-Lfp3; clear Lfp2 Lfp3
            [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp}] = ...
                tfcoh(Lfp1,Lfp,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
        case 'SpikeSpike'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
	    Contact = sessContact(Sess);
            Cl = sessCell(Sess);
            tic
            Spike1 = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Cl{1}, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            Spike2 = trialSpike(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Cl{2}, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
            Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
            [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
                tfcoh_pt(Spike1,Spike2,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
        case 'SpikeMultiunit'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
	    Contact = sessContact(Sess);
            Cl = sessCell(Sess);
            tic
            Spike1 = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact(1), Cl{1}, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            Spike2 = trialSpike(Trials{iTaskComp}, Sys{2}, Ch(2), Contact(2), Cl{2}, Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
            Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
            [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
                tfcoh_pt(Spike1,Spike2,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
        case 'MultiunitMultiunit'
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            Cl = sessCell(Sess);
            tic
            Spike1 = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Cl{1}, Contact(1), Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            Spike2 = trialSpike(Trials{iTaskComp}, Sys{2}, Ch(2), Cl{2}, Contact(2), Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
            Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
            Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
            [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
                tfcoh_pt(Spike1,Spike2,[N,W],sampling_rate,dn,fk,pad,0.05,11); toc
    end
    
else
    nt = N*sampling_rate + diff(bn);
    Dn = dn*sampling_rate;
    Nn = N*sampling_rate;
    if length(fk) == 1; fk = [0,fk]; end
    nf = max(256, pad*2^nextpow2(Nn+1));
    nfk = floor(fk./sampling_rate.*nf);
    
    nwin = floor((nt-Nn)./Dn);           % calculate the number of windows
    S1 = {single(zeros(nwin,diff(nfk)))};
    S2 = {single(zeros(nwin,diff(nfk)))};
    Coh = {single(zeros(nwin,diff(nfk)))};
    f=0;
end

if length(Trials)==1
    Coh = Coh{1}; S1 = S1{1}; S2 = S2{1};
end
