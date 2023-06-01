function Data = sessVonMisesTuningCurve(Sess, CondParams, AnalParams)
%
% Data = sessVonMisesTuningCurve(Sess, CondParams, AnalParams)
%
% MLE fit for univariate Von Mises function tuning curve to firing rate data.
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.sort = 1,N cell.  N sort criteria
%                               For each sort criterion sort is a 1,2 cell
%                                   sort{i}{1} = String. Sort criterion name.
%                                       Names are fields in Trials or
%                                       calcNAME functions.
%                                   sort{i}{2} = [1,1] or [1,2] Scalar.  Sort
%                                                   criterion values
%   CondParams.shuffle  0/1 Shuffle trial ordering
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
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.bn      =   Alignment time.
%   AnalParams.Brange  = Two element scalar.  Range of amplitude of
%   vonmises function.  Defautls to [0,5];
%   AnalParams.AngleType = String.  Variable name for angle to be
%   calculated.  Like 'EyeTargetAngle' or 'HandTargetAngle';
%
%   Data               =  Data structure containing parameters and confidence interval
%			  of Von Mises tuning curve,
%			  Constant Poisson tuning curve,
%			  and p-value for Likelihood-ratio test between them.
%


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

if(isfield(AnalParams,'bn'))
    bn = AnalParams.bn;
elseif isfield(CondParams,'bn')
    bn = CondParams.bn;
else
    bn = [0,500];
end
if(isfield(AnalParams,'Field'))
    Field = AnalParams.Field;
elseif isfield(CondParams,'Field')
    Field = CondParams.Field;
else
    Field = 'TargsOn';
end

if(isfield(AnalParams,'doBaselineComparison'))
  doBaselineComparison = AnalParams.doBaselineComparison;
else
  doBaselineComparison = 0;
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

options = statset('mlecustom');
options.GradObj = 'on';
options.MaxIter = 2e3;
options.MaxFunEvals = 4e3;

if length(Trials{1}) > 3
    for iTaskComp = 1:length(Trials)
        TaskString = [];
        disp([num2str(length(Trials{iTaskComp})) ' Trials'])
        for iTaskPool = 1:length(Task{iTaskComp})
            TaskString = [TaskString Task{iTaskComp}{iTaskPool} ' '];
        end
        disp(['Calculating ' Type ' Von Mises Tuning Curve for ' ...
            TaskString ' using  ' num2str(length(Trials{iTaskComp})) ' Trials']);
        switch Type
            case {'Spike','Multiunit'}
                Sys = sessTower(Sess);
                Ch = sessElectrode(Sess);
                Contact = sessContact(Sess);
                Cl = sessCell(Sess);
                Rate = trialRate(Trials{iTaskComp}, Sys{1}, Ch, Contact, Cl, Field, bn);
                
                if doBaselineComparison
                  BaseRate = trialRate(Trials{iTaskComp}, Sys{1}, Ch, Contact, Cl, 'TargsOn', [-300 0]);
                end
        end
        
        % xi are the locations of the data samples in radians.
        if ~isfield(AnalParams,'AngleType');
            if Trials{iTaskComp}(1).Saccade
                TargetAngle = calcEyeTargetAngle(Trials{iTaskComp});
            elseif Trials{iTaskComp}(1).Reach
                TargetAngle = calcHandTargetAngle(Trials{iTaskComp});
            end
        else
            AngleType = AnalParams.AngleType;
            cmd = ['TargetAngle = calc' AngleType '(Trials{iTaskComp});'];
            eval(cmd);
        end
        
        
        % Construct a negative log likelihood function for each xi
        nloglf_alt = @(params,data,cens,freq) nloglfVonMisesPoisson(params,data,cens,freq,TargetAngle);
        nloglf_null = @(params,data,cens,freq) nloglfConstantPoisson(params,data,cens,freq,TargetAngle);
        
        % Choose parameter starting points
        Astart = median(Rate)
        Bstart = 1;
        Brange = [ 0 Inf ];
        
        % This (initial) approach to finding inverted tuning curves is basically useless.
        % The Poisson distribution has a long tail, so posDiff always ends up greater than negDiff.
        % A single outlier biases the comparison.
        posDiff = max(Rate)-Astart;
        negDiff = Astart-min(Rate);
        if negDiff>posDiff Bstart = -1; Brange = [ -Inf 0 ]; end

        % This is a more rigorous (albeit computationally intensive) approach to
        % finding inverted tuning curves.
        if doBaselineComparison
          % Identify inverted tuning curves by applying constraints from (Wang et al, PNAS 2004)
          % - the unit must be inhibited in response to at least 1 target
          % - the unit must not be excited by any of the remaining targets
          % These criteria are tested by comparing target-specific
          % responses to the baseline firing rate.
          Target = [ Trials{iTaskComp}.Target ];
          p = zeros(1,8);
          for k=1:8
            tInd = find(Target==k);
            p(k) = calcTimeSeriesPermutationTest(BaseRate',Rate(tInd)',1e3);
          end
          posDiffTotal = numel(find(p<0.05));
          negDiffTotal = numel(find(p>0.95));
          if negDiffTotal>0 & posDiffTotal==0 Bstart = -1; Brange = [ -Inf 0 ]; end          
        end        
        
        Kstart = 1;
        S = Rate*sin(TargetAngle');
        C = Rate*cos(TargetAngle');
        Mustart = atan2(S,C); % trigonometric moment
        if Bstart < 0
            if Mustart < 0 Mustart = Mustart+pi; elseif Mustart > 0; Mustart = Mustart-pi; end
        end
        Bstart 
        Mustart
       % Brange
        [phat_alt,pci_alt] = mle(Rate,'nloglf',nloglf_alt,'options',options,...
            'lowerbound',[0 Brange(1) 0 -pi],'upperbound',[Inf Brange(2) Inf pi],...
            'start',[Astart Bstart Kstart Mustart]);
        phat_alt
        Astart = mean(Rate);
        %Pretty unnecessary since Astart is the MLE of lambda for constant poisson model
        [phat_null,pci_null] = mle(Rate,'nloglf',nloglf_null,'options',options,...
            'lowerbound',[0],'upperbound',[Inf],...
            'start',[Astart]);
        
	[phat_alt,pci_alt] = mle(Rate,'nloglf',nloglf_alt,'options',options,...
        'lowerbound',[0 Brange(1) 0 -pi],'upperbound',[Inf Brange(2) Inf pi],...
        'start',[Astart Bstart Kstart Mustart]);

	Astart = mean(Rate);
	%Pretty unnecessary since Astart is the MLE of lambda for constant poisson model
	[phat_null,pci_null] = mle(Rate,'nloglf',nloglf_null,'options',options,...
	        'lowerbound',[0],'upperbound',[Inf],...
	        'start',[Astart]);

	val_alt = nloglfVonMisesPoisson(phat_alt,Rate,[],[],TargetAngle);
	val_null = nloglfConstantPoisson(phat_null,Rate,[],[],TargetAngle);
	D = 2*(val_null-val_alt);

	p = 1 - chi2cdf(real(D),3);

        Data(iTaskComp).phat_alt = phat_alt;
        Data(iTaskComp).pci_alt = pci_alt;
        Data(iTaskComp).phat_null = phat_null;
        Data(iTaskComp).pci_null = pci_null;
        Data(iTaskComp).p = p;
        Data(iTaskComp).Rate = Rate;
        Data(iTaskComp).TargetAngle = TargetAngle;
        xi = linspace(-pi,pi,100);
        Data(iTaskComp).Fit.Rate = fnVonMises(xi, phat_alt);
        Data(iTaskComp).Fit.Angle = xi;
        
        bins{1}(1,:) = [-pi./8,pi./8];
        bins{2}(1,:) = [pi./8,3*pi./8];
        bins{3}(1,:) = [3*pi./8,5*pi./8];
        bins{4}(1,:) = [5*pi./8,7*pi./8];
        bins{5}(1,:) = [7*pi./8,pi];
        bins{5}(2,:) = [-pi,-7*pi./8];
        bins{6}(1,:) = [-7*pi./8,-5*pi./8];
        bins{7}(1,:) = [-5*pi./8,-3*pi./8];
        bins{8}(1,:) = [-3*pi./8,-pi./8];
        x = [0, pi./4, pi./2, 3.*pi./4, pi, -3*pi./4, -pi./2, -pi./4];
        Data(iTaskComp).Obs.Rate = calcTuningCurve(Data(iTaskComp).TargetAngle, Data(iTaskComp).Rate, bins);
        Data(iTaskComp).Obs.Angle = x;
        Data(iTaskComp).CondParams = CondParams;
        Data(iTaskComp).AnalParams = AnalParams;
    end
else 
    Data = NaN; 
end
