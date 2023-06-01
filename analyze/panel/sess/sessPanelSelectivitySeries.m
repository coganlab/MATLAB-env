function SelSeries = sessPanelSelectivitySeries(Sess,CondParams,AnalParams)
%
%   SelSeries = sessPanelSelectivitySeries(Sess,CondParams,AnalParams)
%
%   Estimate differences between neural signals across two conditions.
% 
%   SESS       =  Cell array.  Session information
%   CONDPARAMS =  Parameter information for condition information
%   ANALPARAMS =  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
%   CondParams.sort    =   'STRING';
%   AnalParams(m,n).Field   =   String.  Alignment field
%   AnalParams(m,n).bn      =   Alignment time.

global MONKEYNAME

SelSeries = [];
SelSeries.Session = Sess;

Day = sessDay(Sess);
Sys = sessTower(Sess);
Ch = sessElectrode(Sess);
Contact = sessContact(Sess);
MonkeyDir = sessMonkeyDir(Sess);

switch sessType(Sess)
  case {'Spike'}
    TrialSess = Sess;
    Cl = sessCell(Sess);
   case {'Field'}
    TrialSess = Sess;
  case {'SpikeSpike'}
    TrialSess = splitSession(Sess);
    Cl = sessCell(TrialSess);
    TrialSess = TrialSess{2};
  case {'SpikeField'}
    TrialSess = splitSession(Sess);
    Cl = sessCell(TrialSess{1});
    TrialSess = TrialSess{2};
  case {'FieldField'}
    TrialSess = splitSession(Sess);
    TrialSess = TrialSess{2};
end

All_Trials = sessTrials(TrialSess);
TrialSess{1} = All_Trials;
    
Task = [];
for m=1:size(CondParams,1)
  for n=1:size(CondParams,2)
      
    CondName = CondParams(m,n).Name;
    TaskName = CondParams(m,n).Task;
    Task(m,n).Name = CondName;
    Task(m,n).Task = TaskName;

    % Which analyses to perform?
    if isfield(AnalParams,'doBaselineAnalysis')
      doBaselineAnalysis = AnalParams(m,n).doBaselineAnalysis;
    else
      doBaselineAnalysis = 0;    
    end
    if isfield(AnalParams,'doSpatialAnalysis')
      doSpatialAnalysis = AnalParams(m,n).doSpatialAnalysis;
    else
      doSpatialAnalysis = 0;    
    end
    if isfield(AnalParams,'doChoiceAnalysis')
      doChoiceAnalysis = AnalParams(m,n).doChoiceAnalysis;
    else
      doChoiceAnalysis = 0;   
    end
    if isfield(AnalParams,'doDiffAnalysis')
      doDiffAnalysis = AnalParams(m,n).doDiffAnalysis;
    else
      doDiffAnalysis = 0;
    end

    if(isfield(AnalParams,'wlen'))
        wlen = AnalParams(m,n).wlen;
    else
        wlen = 0.05;
    end
    if(isfield(AnalParams,'dn'))
        dn = AnalParams(m,n).dn;
    else
        dn = 0.01;
    end
    if(isfield(AnalParams,'bn'))
        bn = AnalParams(m,n).bn;
    else
        bn = [-3e2 3e2];
    end
    if(isfield(AnalParams,'baselineTime'))
        baselineTime = AnalParams(m,n).baselineTime;
    else
        baselineTime = -300; % defined with reference to TargsOn
    end
    if(isfield(AnalParams,'Fields'))
        Fields = AnalParams(m,n).Fields;
    else
        Fields = {'TargsOn','SaccStart'};
    end
    if(isfield(AnalParams,'nPerm'))
        nPerm = AnalParams(m,n).nPerm;
    else
        nPerm = 1e4;
    end
    if(isfield(AnalParams,'TargetIDs'))
        TargetIDs = AnalParams(m,n).TargetIDs;
    else
        TargetIDs = [ 1 2 ]; % Default to 2T choice task
    end
    if(isfield(AnalParams,'TargetLocations'))
        TargetLocations = AnalParams(m,n).TargetLocations;
    else
        TargetLocations = [ 1:8 ]; % Default to 8 target circular array
    end
    if(isfield(AnalParams,'rtCategories'))
        rtCategories = AnalParams(m,n).rtCategories;
    else
        rtCategories = [ 0 Inf ]; % (ms)
    end
    if(isfield(AnalParams,'choiceCategories'))
        choiceCategories = AnalParams(m,n).choiceCategories;
    else
        choiceCategories = [-1 0 1]; % [ eitherChoice chooseOut chooseIn ]
    end
    if(isfield(AnalParams,'excludeRewardBlockTrials'))
        excludeRewardBlockTrials = AnalParams(m,n).excludeRewardBlockTrials;
    else
        excludeRewardBlockTrials = [ 0 ];
    end
    if(isfield(AnalParams,'scaleFactor'))
        scaleFactor = AnalParams(m,n).scaleFactor;
    else
        scaleFactor = 100; % for storage efficiency, data will be multiplied by this number and cast to uint32
    end

    if isequal(sessType(Sess),'Field') | ...
       isequal(sessType(Sess),'SpikeField') | ...
       isequal(sessType(Sess),'FieldField')

      if(isfield(AnalParams,'fk'))
        fk = AnalParams(m,n).fk;
      else
          fk = 200;
      end
      if length(fk)==1; fk = [0,fk]; end

      if(isfield(AnalParams,'sampling_rate'))
          sampling_rate = AnalParams(m,n).sampling_rate;
      else
          sampling_rate = 1e3;
      end
      if(isfield(AnalParams,'dn'))
          dn = AnalParams(m,n).dn;
      else
          dn = 0.05;
      end
      if(isfield(AnalParams,'pad'))
          pad = AnalParams(m,n).pad;
      else
          pad = 2;
      end
      if(isfield(AnalParams,'tapers'))
          tapers = AnalParams(m,n).tapers;
      else
          tapers = [wlen,max(1/wlen,10)]; % [0.5,10];
      end
    
      N = tapers(1);
      if length(tapers)==3
          W = tapers(2)./tapers(1);
      else
          W = tapers(2);
      end
  
    end % if isequal(sessType(Sess),'Field')
    
    if isequal(sessType(Sess),'SpikeSpike')
      tau_epsp = AnalParams(m,n).tau_epsp;
      synchThresh = AnalParams(m,n).synchThresh;
      epspKernel = exp(-[0:ceil(4*tau_epsp)]/tau_epsp);
    end
    

%       for m=1:numel(SelAnalParams)
%         SelAnalParams(m).A = vmParams(1);
%         SelAnalParams(m).B = vmParams(2);
%         SelAnalParams(m).Kappa = vmParams(3);
%         SelAnalParams(m).ThetaHat = vmParams(4);
%         SelSelAnalParams(m).HighThreshPct = 0.5;
%         SelAnalParams(m).LowThreshPct = 0.2;
%         SelAnalParams(m).PrefTarget = prefTarget;
%       end  
      
    Tuning = [];
    TuningVM = [];
    TuningVM.Kappa = 1;
    Tuning.TuningVM = TuningVM;
    Tuning.TuningTrig = [];
    TuningAnalParams = [];

    if numel(TargetLocations)==1 & ...
       isfield(AnalParams,'ThetaHat') & isfield(AnalParams,'Kappa') & ...
       isfield(AnalParams,'HighThreshPct') & isfield(AnalParams,'LowThreshPct')
      TuningVM.ThetaHat = AnalParams(1).ThetaHat;
      TuningVM.Kappa = AnalParams(1).Kappa;
      Tuning.TuningVM = TuningVM;
      Theta = AnalParams(1).ThetaHat;
      TuningAnalParams.P = AnalParams(1).P;
      TuningAnalParams.A = AnalParams(1).A;
      TuningAnalParams.B = AnalParams(1).B;
      TuningAnalParams.ThetaHat = AnalParams(1).ThetaHat;
      TuningAnalParams.Kappa = AnalParams(1).Kappa;      
      TuningAnalParams.HighThreshPct = AnalParams(1).HighThreshPct;
      TuningAnalParams.LowThreshPct = AnalParams(1).LowThreshPct;
      TuningAnalParams.PrefTarget = AnalParams(1).PrefTarget;
    else
        
    % Assign an angle to each reference location in the visual field.
    thetaInc = (numel(TargetLocations)/2);
    Theta = [0:pi/thetaInc:pi -pi+pi/thetaInc:pi/thetaInc:-pi/thetaInc ]; % assign an angle to each target

    % Find the appropriate PDF threshold that partitions the circular domain into numel(TargetLocations) bins.
    % (i.e. choose so that each target range occupies 1/numel(TargetLocations) of the circular domain,
    % with the first location centered on phi = 0, in the right hemifield.)
    thetahat = 0;
    kappa = 1;
    [maxPDF thetahat] = circ_vmpdf(thetahat,thetahat,kappa); % find max PDF
    locDim = 100; % constraints the maximum number of target locations
    pdfCenters = [0:locDim-1]*2*pi/locDim;
    [p_test thetahat_test] = circ_vmpdf(pdfCenters,thetahat,kappa);
    minPDF = min(p_test);
    p_test = sort(p_test-minPDF);
    threshLoc = max(1,numel(p_test)-floor(locDim/numel(TargetLocations)));
    TuningAnalParams.HighThreshPct = p_test(threshLoc(1))/max(p_test);
    TuningAnalParams.LowThreshPct = TuningAnalParams.HighThreshPct - 0.005;
    
    end % if a RF is not specified
    
    
    % Initialize parameter matrices. Each row will contain a list of parameters for a given analysis.
    if doBaselineAnalysis
      baselineParams = [];
    end    
    if doSpatialAnalysis
      spatialParams = [];
    end
    if doChoiceAnalysis
      choiceParams = [];
    end  
    if doDiffAnalysis
      diffParams = [];
    end 
    
    % Load trials, but don't filter using sort conditions just yet.
    % We're going handle sorts later on a per-location basis
    altCondParams = CondParams(m,n);
    altCondParams.sort = [];
    Trials = Params2Trials(TrialSess,altCondParams);
    nTrials = numel(Trials);
    
    if doDiffAnalysis % Load trials for Diff condition?
      DiffCondParams = AnalParams(m,n).Diff;
      altDiffCondParams = DiffCondParams;
      altDiffCondParams.sort = [];
      DiffTrials = Params2Trials(TrialSess,altDiffCondParams);
      nDiffTrials = numel(DiffTrials);    
    end

    if nTrials>0
    
    for refTargetInd=1:numel(TargetIDs) % 0 = any target
      refTarget = TargetIDs(refTargetInd);
      for refLocationInd=1:numel(TargetLocations) % 0 = any location
        refLocation = TargetLocations(refLocationInd);
        
        doNonSpatialAnalysis = refLocation==0;
        
        if ~doNonSpatialAnalysis
          cur_choiceCategories = choiceCategories;
        else
          cur_choiceCategories = 1;  
        end
        
%         if refLocation~=0 % Perform a spatial analysis?
            
          % Define this region of the circular domain as a putative
          % response field and get TrialParams for this refLocation.
          
          if ~doNonSpatialAnalysis
            Tuning.TuningVM.ThetaHat = Theta(refLocation);
            Tuning.TuningTrig.Phi = Theta(refLocation);
            TrialParams = getTunedSessionTrialParams(Tuning,TuningAnalParams,Trials);
          else
            Tuning.TuningVM.ThetaHat = Theta(1);
            Tuning.TuningTrig.Phi = Theta(1);
            TrialParams = getTunedSessionTrialParams(Tuning,TuningAnalParams,Trials,1);
          end
          
          % For CenterOut trials, null direction is assigned rfCode = 0.
          % If we want to include these trials among those with no target
          % in refLocation, we need to change the code to -1.
          nonChoiceInd = find([Trials.Choice]==1);
          nullInd = find(TrialParams.ChosenTargetInRFCode(nonChoiceInd)==0);
          TrialParams.ChosenTargetInRFCode(nonChoiceInd(nullInd)) = -1;
          
          % Add chosenTargetInRFCode field to Trials and then apply sort filters.
          for k=1:numel(Trials)
            Trials(k).Index = k;
            Trials(k).chosenTargetInRFCode = TrialParams.ChosenTargetInRFCode(k);
          end
          TempTrials = Trials(find([Trials.chosenTargetInRFCode]~=-1));
          TempTrials = Params2Trials(TempTrials,CondParams(m,n));
          if numel(TempTrials)>0
            targetTrialInd = [TempTrials.Index];
          else
            targetTrialInd = []; 
          end

          if doDiffAnalysis % Filter trials for Diff condition?
            diff_targetTrialInd = [];
            DiffTrialParams = [];
            if numel(DiffTrials)>0
              if ~doNonSpatialAnalysis
                DiffTrialParams = getTunedSessionTrialParams(Tuning,TuningAnalParams,DiffTrials);
              else
                DiffTrialParams = getTunedSessionTrialParams(Tuning,TuningAnalParams,DiffTrials,1);
              end
              
              % For CenterOut trials, null direction is assigned rfCode = 0.
              % If we want to include these trials among those with no target
              % in refLocation, we need to change the code to -1.
              nonChoiceInd = find([DiffTrials.Choice]==1);
              nullInd = find(DiffTrialParams.ChosenTargetInRFCode(nonChoiceInd)==0);
              DiffTrialParams.ChosenTargetInRFCode(nonChoiceInd(nullInd)) = -1;            
              for k=1:numel(DiffTrials)
                DiffTrials(k).Index = k;
                DiffTrials(k).chosenTargetInRFCode = DiffTrialParams.ChosenTargetInRFCode(k);          
              end
              TempTrials = DiffTrials(find([DiffTrials.chosenTargetInRFCode]~=-1));
              TempTrials = Params2Trials(TempTrials,DiffCondParams);
              if numel(TempTrials)>0
                diff_targetTrialInd = [TempTrials.Index];
              end
              
            end % if numel(DiffTrials)>0
            
            
          end
          
          if doSpatialAnalysis %  Find trials when no target appears in refLocation?

            for k=1:numel(Trials)
              Trials(k).Index = k;
              Trials(k).chosenTargetInRFCode = single(TrialParams.ChosenTargetInRFCode(k)==-1) - 1; % invert RF codes
            end
            TempTrials = Trials(find([Trials.chosenTargetInRFCode]~=-1));
            TempTrials = Params2Trials(TempTrials,CondParams(m,n));
            if numel(TempTrials)>0
              noTargetTrialInd = [TempTrials.Index];
            else
              noTargetTrialInd = []; 
            end
            
            if doDiffAnalysis
              diff_noTargetTrialInd = [];
              if numel(DiffTrials)>0
                for k=1:numel(DiffTrials)
                  DiffTrials(k).Index = k;
                  DiffTrials(k).chosenTargetInRFCode = single(DiffTrialParams.ChosenTargetInRFCode(k)==-1) - 1; % invert RF codes
                end
                TempTrials = DiffTrials(find([DiffTrials.chosenTargetInRFCode]~=-1));
                TempTrials = Params2Trials(TempTrials,DiffCondParams);
                if numel(TempTrials)>0
                  diff_noTargetTrialInd = [TempTrials.Index];
                end
              end
              
            end

          end % if doSpatialAnalysis
          
          
          if numel(targetTrialInd)>1 % If there are trials with a target in refLocation...
                    
            % Prepare to apply reactionTime and excludeRewardBlockTrial constraints
            rtAll = TrialParams.ReactionTime;          
            rtTargetInRF = rtAll(targetTrialInd);
            rewardBlockTrial = TrialParams.RewardBlockTrial;
            rbtTargetInRF = rewardBlockTrial(targetTrialInd);

            if doDiffAnalysis
              diff_rtAll = [];
              diff_rtTargetInRF = [];
              diff_rewardBlockTrial = [];
              diff_rbtTargetInRF = [];
              if numel(DiffTrialParams)>0
                diff_rtAll = DiffTrialParams.ReactionTime;          
                diff_rtTargetInRF = diff_rtAll(diff_targetTrialInd);
                diff_rewardBlockTrial = DiffTrialParams.RewardBlockTrial;
                diff_rbtTargetInRF = diff_rewardBlockTrial(diff_targetTrialInd);
              end
            end
            
            if doSpatialAnalysis
              % Same as above, but now we select trials when refLocation is unoccupied
              rtNoTargetInRF = rtAll(noTargetTrialInd);       
              rbtNoTargetInRF = rewardBlockTrial(noTargetTrialInd);
              if doDiffAnalysis
                diff_rtNoTargetInRF = diff_rtAll(diff_noTargetTrialInd);        
                diff_rbtNoTargetInRF = diff_rewardBlockTrial(diff_noTargetTrialInd);
              end
            end
            
            
            % Note: In the following code, the "cur_" prefix denotes a
            % filtered version of the array specified by the root variable name.
            % "cur_" arrays are specific to the current Field iteration
            
            for fid=1:numel(Fields)
              fieldBn = bn;
              if size(bn,1)>=numel(Fields)
                fieldBn = bn(fid,:); % gives user the option to specify bn for each Field
              end
              
              switch sessType(Sess)
                case {'Field','SpikeField','FieldField'}

                  Lfp1 = [];
                  lfpKeepInd = [];
                  if numel(targetTrialInd)>1
                    switch sessType(Sess)
                      case 'Field'
                        Lfp1 =  trialLfp(Trials(targetTrialInd),Sys{1},Ch(1),Contact(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                        thresh1 = 6*std(Lfp1(:));
                        e1 = max(abs(Lfp1'));
                        lfpKeepInd = find(e1<thresh1);
                        Lfp1 = Lfp1(lfpKeepInd,:);                        
                      case 'SpikeField'
                        Lfp1 =  trialLfp(Trials(targetTrialInd),Sys{2}{1},Ch(2),Contact(2),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                        Spike1 =  trialSpike(Trials(targetTrialInd),Sys{1}{1},Ch(1),Contact(1),Cl(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                        Spike1 = sp2ts(Spike1,[0,diff(fieldBn)./sampling_rate+(N+dn),sampling_rate]);
                        thresh1 = 6*std(Lfp1(:));
                        e1 = max(abs(Lfp1'));
                        lfpKeepInd = find(e1<thresh1);
                        Lfp1 = Lfp1(lfpKeepInd,:);                        
                        Spike1 = Spike1(lfpKeepInd,:);
                      case 'FieldField'
                        Lfp1 =  trialLfp(Trials(targetTrialInd),Sys{1}{1},Ch(1),Contact(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                        Lfp2 =  trialLfp(Trials(targetTrialInd),Sys{2}{1},Ch(2),Contact(2),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                        thresh1 = 6*std(Lfp1(:));
                        e1 = max(abs(Lfp1'));
                        thresh2 = 6*std(Lfp2(:));
                        e2 = max(abs(Lfp2'));
                        lfpKeepInd = find(e1<thresh1|e2<thresh2);
                        Lfp1 = Lfp1(lfpKeepInd,:);
                        Lfp2 = Lfp2(lfpKeepInd,:);                        
                    end
                  end
                  cur_targetTrialInd = targetTrialInd(lfpKeepInd);
                  cur_rtTargetInRF = rtTargetInRF(lfpKeepInd);
                  cur_rbtTargetInRF = rbtTargetInRF(lfpKeepInd);
                  
                  if doDiffAnalysis
                    diff_Lfp1 = [];
                    lfpKeepInd = [];
                    if numel(diff_targetTrialInd)>1
                        
                      switch sessType(Sess)
                        case 'Field'
                          diff_Lfp1 =  trialLfp(DiffTrials(diff_targetTrialInd),Sys{1},Ch(1),Contact(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                          thresh1 = 6*std(diff_Lfp1(:));
                          e1 = max(abs(diff_Lfp1'));
                          lfpKeepInd = find(e1<thresh1);
                          diff_Lfp1 = diff_Lfp1(lfpKeepInd,:);                        
                        case 'SpikeField'
                          diff_Lfp1 =  trialLfp(DiffTrials(diff_targetTrialInd),Sys{2}{1},Ch(2),Contact(2),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                          diff_Spike1 =  trialSpike(DiffTrials(diff_targetTrialInd),Sys{1}{1},Ch(1),Contact(1),Cl(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                          diff_Spike1 = sp2ts(diff_Spike1,[0,diff(fieldBn)./sampling_rate+(N+dn),sampling_rate]);
                          thresh1 = 6*std(diff_Lfp1(:));
                          e1 = max(abs(diff_Lfp1'));
                          lfpKeepInd = find(e1<thresh1);
                          diff_Lfp1 = diff_Lfp1(lfpKeepInd,:);                        
                          diff_Spike1 = diff_Spike1(lfpKeepInd,:);
                        case 'FieldField'
                          diff_Lfp1 =  trialLfp(DiffTrials(diff_targetTrialInd),Sys{1}{1},Ch(1),Contact(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                          diff_Lfp2 =  trialLfp(DiffTrials(diff_targetTrialInd),Sys{2}{1},Ch(2),Contact(2),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                          thresh1 = 6*std(diff_Lfp1(:));
                          e1 = max(abs(diff_Lfp1'));
                          thresh2 = 6*std(diff_Lfp2(:));
                          e2 = max(abs(diff_Lfp2'));
                          lfpKeepInd = find(e1<thresh1|e2<thresh2);
                          diff_Lfp1 = diff_Lfp1(lfpKeepInd,:);
                          diff_Lfp2 = diff_Lfp2(lfpKeepInd,:);                        
                      end                        
                    end
                    cur_diff_targetTrialInd = diff_targetTrialInd(lfpKeepInd);                 
                    cur_diff_rtTargetInRF = diff_rtTargetInRF(lfpKeepInd);
                    cur_diff_rbtTargetInRF = diff_rbtTargetInRF(lfpKeepInd);
                  end
                  
                  
                  if doSpatialAnalysis
                    % determine baseline PSD
                    baseLfp1 = [];
                    if size(Lfp1,1)>0
                      baseInd = [ -fieldBn(1) + (N+dn)/2*sampling_rate + 1 ] + baselineTime;
                      switch sessType(Sess)
                        case 'Field'
                          baseLfp1 = Lfp1(:,baseInd + int32([-(N+dn)/2*sampling_rate:(N+dn)/2*sampling_rate])); 
                        case 'SpikeField'
                          baseLfp1 = Lfp1(:,baseInd + int32([-(N+dn)/2*sampling_rate:(N+dn)/2*sampling_rate]));                            
                          baseSpike1 = Spike1(:,baseInd + int32([-(N+dn)/2*sampling_rate:(N+dn)/2*sampling_rate]));
                        case 'FieldField'
                          baseLfp1 = Lfp1(:,baseInd + int32([-(N+dn)/2*sampling_rate:(N+dn)/2*sampling_rate]));
                          baseLfp2 = Lfp2(:,baseInd + int32([-(N+dn)/2*sampling_rate:(N+dn)/2*sampling_rate]));                            
                      end
                    end
                    Lfp1_noTarget = [];
                    lfpNoTargetKeepInd = [];
                    if numel(noTargetTrialInd)>1
                      switch sessType(Sess)
                        case 'Field'
                          Lfp1_noTarget =  trialLfp(Trials(noTargetTrialInd),Sys{1},Ch(1),Contact(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                          thresh1 = 6*std(Lfp1_noTarget(:));
                          e1 = max(abs(Lfp1_noTarget'));
                          lfpNoTargetKeepInd = find(e1<thresh1);
                          Lfp1_noTarget = Lfp1_noTarget(lfpNoTargetKeepInd,:);                        
                        case 'SpikeField'
                          Lfp1_noTarget =  trialLfp(Trials(noTargetTrialInd),Sys{2}{1},Ch(2),Contact(2),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                          Spike1_noTarget =  trialSpike(Trials(noTargetTrialInd),Sys{1}{1},Ch(1),Contact(1),Cl(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                          Spike1_noTarget = sp2ts(Spike1_noTarget,[0,diff(fieldBn)./sampling_rate+(N+dn),sampling_rate]);
                          thresh1 = 6*std(Lfp1_noTarget(:));
                          e1 = max(abs(Lfp1_noTarget'));
                          lfpNoTargetKeepInd = find(e1<thresh1);
                          Lfp1_noTarget = Lfp1_noTarget(lfpNoTargetKeepInd,:);                        
                          Spike1_noTarget = Spike1_noTarget(lfpNoTargetKeepInd,:);
                        case 'FieldField'
                          Lfp1_noTarget =  trialLfp(Trials(noTargetTrialInd),Sys{1}{1},Ch(1),Contact(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                          Lfp2_noTarget =  trialLfp(Trials(noTargetTrialInd),Sys{2}{1},Ch(2),Contact(2),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                          thresh1 = 6*std(Lfp1_noTarget(:));
                          e1 = max(abs(Lfp1_noTarget'));
                          thresh2 = 6*std(Lfp2_noTarget(:));
                          e2 = max(abs(Lfp2_noTarget'));
                          lfpNoTargetKeepInd = find(e1<thresh1|e2<thresh2);
                          Lfp1_noTarget = Lfp1_noTarget(lfpNoTargetKeepInd,:);
                          Lfp2_noTarget = Lfp2_noTarget(lfpNoTargetKeepInd,:);                        
                      end
                    end
                    cur_noTargetTrialInd = noTargetTrialInd(lfpNoTargetKeepInd);                     
                    cur_rtNoTargetInRF = rtNoTargetInRF(lfpNoTargetKeepInd);                  
                    cur_rbtNoTargetInRF = rbtNoTargetInRF(lfpNoTargetKeepInd);
                    
                    if doDiffAnalysis
                      diff_Lfp1_noTarget = [];
                      lfpNoTargetKeepInd = [];
                      if numel(diff_noTargetTrialInd)>1
                        switch sessType(Sess)
                          case 'Field'
                            diff_Lfp1_noTarget =  trialLfp(DiffTrials(diff_noTargetTrialInd),Sys{1},Ch(1),Contact(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                            thresh1 = 6*std(diff_Lfp1_noTarget(:));
                            e1 = max(abs(diff_Lfp1_noTarget'));
                            lfpNoTargetKeepInd = find(e1<thresh1);
                            diff_Lfp1_noTarget = diff_Lfp1_noTarget(lfpNoTargetKeepInd,:);                        
                          case 'SpikeField'
                            diff_Lfp1_noTarget =  trialLfp(DiffTrials(diff_noTargetTrialInd),Sys{2}{1},Ch(2),Contact(2),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                            diff_Spike1_noTarget =  trialSpike(DiffTrials(diff_noTargetTrialInd),Sys{1}{1},Ch(1),Contact(1),Cl(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                            diff_Spike1_noTarget = sp2ts(diff_Spike1_noTarget,[0,diff(fieldBn)./sampling_rate+(N+dn),sampling_rate]);
                            thresh1 = 6*std(diff_Lfp1_noTarget(:));
                            e1 = max(abs(diff_Lfp1_noTarget'));
                            lfpNoTargetKeepInd = find(e1<thresh1);
                            diff_Lfp1_noTarget = diff_Lfp1_noTarget(lfpNoTargetKeepInd,:);                        
                            diff_Spike1_noTarget = diff_Spike1_noTarget(lfpNoTargetKeepInd,:);
                          case 'FieldField'
                            diff_Lfp1_noTarget =  trialLfp(DiffTrials(diff_noTargetTrialInd),Sys{1}{1},Ch(1),Contact(1),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                            diff_Lfp2_noTarget =  trialLfp(DiffTrials(diff_noTargetTrialInd),Sys{2}{1},Ch(2),Contact(2),Fields{fid},[fieldBn(1)-(N+dn)/2*sampling_rate,fieldBn(2)+(N+dn)/2*sampling_rate], MonkeyDir);
                            thresh1 = 6*std(diff_Lfp1_noTarget(:));
                            e1 = max(abs(diff_Lfp1_noTarget'));
                            thresh2 = 6*std(diff_Lfp2_noTarget(:));
                            e2 = max(abs(diff_Lfp2_noTarget'));
                            lfpNoTargetKeepInd = find(e1<thresh1|e2<thresh2);
                            diff_Lfp1_noTarget = diff_Lfp1_noTarget(lfpNoTargetKeepInd,:);
                            diff_Lfp2_noTarget = diff_Lfp2_noTarget(lfpNoTargetKeepInd,:);                        
                        end
                      end
                      cur_diff_noTargetTrialInd = diff_noTargetTrialInd(lfpNoTargetKeepInd);                     
                      cur_diff_rtNoTargetInRF = diff_rtNoTargetInRF(lfpNoTargetKeepInd);                  
                      cur_diff_rbtNoTargetInRF = diff_rbtNoTargetInRF(lfpNoTargetKeepInd);
                    end
                  end

                case {'Spike','Multiunit','SpikeSpike'}
                  
                  cur_targetTrialInd = targetTrialInd;
                  cur_rtTargetInRF = rtTargetInRF;
                  cur_rbtTargetInRF = rbtTargetInRF;

                  Spike = [];
                  if numel(cur_targetTrialInd)>1
                    switch sessType(Sess)
                      case {'Spike','Multiunit'}
                        Spike1 =  trialSpike(Trials(cur_targetTrialInd),Sys{1},Ch,Contact(1),Cl,Fields{fid},fieldBn, MonkeyDir);
                      case 'SpikeSpike'
                        Spike1 =  trialSpike(Trials(cur_targetTrialInd),Sys{1}{1},Ch(1),Contact(1),Cl(1),Fields{fid},fieldBn, MonkeyDir);
                        Spike2 =  trialSpike(Trials(cur_targetTrialInd),Sys{2}{1},Ch(2),Contact(2),Cl(2),Fields{fid},fieldBn, MonkeyDir);                      
                    end
                  end
                  rateArray = zeros(numel(Spike1),diff(fieldBn)+1);
                  for spind=1:numel(Spike1)
                    switch sessType(Sess)
                      case {'Spike','Multiunit'}
                        rateArray(spind,max(1,round(Spike1{spind}))) = 1;
                      case 'SpikeSpike'
                        % calculate the synchrony rate
                        sp1 = zeros(1,diff(fieldBn)+1);
                        sp2 = sp1;
                        sp1(max(1,round(Spike1{spind}))) = 1;
                        sp2(max(1,round(Spike2{spind}))) = 1;
                        sp1 = min(1,conv(sp1,epspKernel,'same'));
                        sp2 = min(1,conv(sp2,epspKernel,'same'));
                        rateArray(spind,find((sp1+sp2)>synchThresh)) = 1; % find synchronous events
                    end
                    rateArray(spind,:) = conv(rateArray(spind,:),ones(1,wlen*1e3),'same');
                  end
                  sampleInd = [ 1:round(dn*1e3):size(rateArray,2) ]; % downsample time series in increments of dn                  
                  
                  if doDiffAnalysis
                    cur_diff_targetTrialInd = diff_targetTrialInd;
                    cur_diff_rtTargetInRF = diff_rtTargetInRF;
                    cur_diff_rbtTargetInRF = diff_rbtTargetInRF;
                    diff_Spike = [];
                    if numel(cur_diff_targetTrialInd)>1
                      switch sessType(Sess)
                        case {'Spike','Multiunit'}
                          diff_Spike1 =  trialSpike(DiffTrials(cur_diff_targetTrialInd),Sys{1},Ch,Contact(1),Cl,Fields{fid},fieldBn, MonkeyDir);
                        case 'SpikeSpike'
                          diff_Spike1 =  trialSpike(DiffTrials(cur_diff_targetTrialInd),Sys{1}{1},Ch(1),Contact(1),Cl(1),Fields{fid},fieldBn, MonkeyDir);
                          diff_Spike2 =  trialSpike(DiffTrials(cur_diff_targetTrialInd),Sys{2}{1},Ch(2),Contact(2),Cl(2),Fields{fid},fieldBn, MonkeyDir);                 
                      end
                    end
                    diff_rateArray = zeros(numel(diff_Spike1),diff(fieldBn)+1);
                    for spind=1:numel(diff_Spike1)
                      switch sessType(Sess)
                        case {'Spike','Multiunit'}
                          diff_rateArray(spind,max(1,round(diff_Spike1{spind}))) = 1;
                        case 'SpikeSpike'
                           % calculate the synchrony rate
                          sp1 = zeros(1,diff(fieldBn)+1);
                          sp2 = sp1;
                          sp1(max(1,round(diff_Spike1{spind}))) = 1;
                          sp2(max(1,round(diff_Spike2{spind}))) = 1;
                          sp1 = min(1,conv(sp1,epspKernel,'same'));
                          sp2 = min(1,conv(sp2,epspKernel,'same'));
                          diff_rateArray(spind,find((sp1+sp2)>synchThresh)) = 1; % find synchronous events
                      end
                      diff_rateArray(spind,:) = conv(diff_rateArray(spind,:),ones(1,wlen*1e3),'same');
                    end
                  end
                  
                  if doSpatialAnalysis
                    cur_noTargetTrialInd = noTargetTrialInd;
                    cur_rtNoTargetInRF = rtNoTargetInRF;
                    cur_rbtNoTargetInRF = rbtNoTargetInRF;
                    if isequal(Fields{fid},'TargsOn')
                      baseRate = rateArray(:,baselineTime-fieldBn(1)+1); % determine baseline firing rate
                    end
                    
                    % Load spike data for trials with no target in refLocation
                    Spike_noTarget = [];
                    if numel(cur_noTargetTrialInd)>1
                      switch sessType(Sess)
                        case {'Spike','Multiunit'}
                          Spike1_noTarget =  trialSpike(Trials(cur_noTargetTrialInd),Sys{1},Ch,Contact(1),Cl,Fields{fid},fieldBn, MonkeyDir);
                        case 'SpikeSpike'
                          Spike1_noTarget =  trialSpike(Trials(cur_noTargetTrialInd),Sys{1}{1},Ch(1),Contact(1),Cl(1),Fields{fid},fieldBn, MonkeyDir);
                          Spike2_noTarget =  trialSpike(Trials(cur_noTargetTrialInd),Sys{2}{1},Ch(2),Contact(2),Cl(2),Fields{fid},fieldBn, MonkeyDir);                          
                      end
                    end
                    
                    if ~doNonSpatialAnalysis                        
                    rateArray_noTarget = zeros(numel(Spike1_noTarget),diff(fieldBn)+1);
                    for spind=1:numel(Spike1_noTarget)
                      switch sessType(Sess)
                        case {'Spike','Multiunit'}
                          rateArray_noTarget(spind,max(1,round(Spike1_noTarget{spind}))) = 1;
                        case 'SpikeSpike'
                           % calculate the synchrony rate
                          sp1 = zeros(1,diff(fieldBn)+1);
                          sp2 = sp1;
                          sp1(max(1,round(Spike1_noTarget{spind}))) = 1;
                          sp2(max(1,round(Spike2_noTarget{spind}))) = 1;
                          sp1 = min(1,conv(sp1,epspKernel,'same'));
                          sp2 = min(1,conv(sp2,epspKernel,'same'));
                          rateArray_noTarget(spind,find((sp1+sp2)>synchThresh)) = 1; % find synchronous events
                      end
                      rateArray_noTarget(spind,:) = conv(rateArray_noTarget(spind,:),ones(1,wlen*1e3),'same');
                    end   
                    else
                      rateArray_noTarget = rateArray;  
                    end
                    
                    if doDiffAnalysis
                      cur_diff_noTargetTrialInd = diff_noTargetTrialInd;
                      cur_diff_rtNoTargetInRF = diff_rtNoTargetInRF;
                      cur_diff_rbtNoTargetInRF = diff_rbtNoTargetInRF;
                      diff_Spike1_noTarget = [];
                      diff_Spike2_noTarget = [];
                      if numel(cur_diff_noTargetTrialInd)>1
                        switch sessType(Sess)
                          case {'Spike','Multiunit'}
                            diff_Spike1_noTarget =  trialSpike(DiffTrials(cur_diff_noTargetTrialInd),Sys{1},Ch,Contact(1),Cl,Fields{fid},fieldBn, MonkeyDir);
                          case 'SpikeSpike'
                            diff_Spike1_noTarget =  trialSpike(DiffTrials(cur_diff_noTargetTrialInd),Sys{1}{1},Ch(1),Contact(1),Cl(1),Fields{fid},fieldBn, MonkeyDir);
                            diff_Spike2_noTarget =  trialSpike(DiffTrials(cur_diff_noTargetTrialInd),Sys{2}{1},Ch(2),Contact(2),Cl(2),Fields{fid},fieldBn, MonkeyDir);                 
                        end                        
                      end
                      
                      if ~doNonSpatialAnalysis                        
                      diff_rateArray_noTarget = zeros(numel(diff_Spike1_noTarget),diff(fieldBn)+1);
                      for spind=1:numel(diff_Spike1_noTarget)
                        switch sessType(Sess)
                          case {'Spike','Multiunit'}
                            diff_rateArray_noTarget(spind,max(1,round(diff_Spike1_noTarget{spind}))) = 1;
                          case 'SpikeSpike'
                             % calculate the synchrony rate
                            sp1 = zeros(1,diff(fieldBn)+1);
                            sp2 = sp1;
                            sp1(max(1,round(diff_Spike1_noTarget{spind}))) = 1;
                            sp2(max(1,round(diff_Spike2_noTarget{spind}))) = 1;
                            sp1 = min(1,conv(sp1,epspKernel,'same'));
                            sp2 = min(1,conv(sp2,epspKernel,'same'));
                            diff_rateArray_noTarget(spind,find((sp1+sp2)>synchThresh)) = 1; % find synchronous events
                        end
                        diff_rateArray_noTarget(spind,:) = conv(diff_rateArray_noTarget(spind,:),ones(1,wlen*1e3),'same');
                      end
                      else
                        diff_rateArray_noTarget = diff_rateArray;  
                      end
                      
                    end
                    
                  end % if doSpatialAnalysis
                  
                otherwise
                  % Need to implement spike-field and field-field coherence code
              end

              % Now apply reactionTime and excludeRewardBlockTrial constraints
              for rtInd=1:size(rtCategories,1)
                rtBn = rtCategories(rtInd,:);

                for rewardBlockInd=1:numel(excludeRewardBlockTrials)
                  excludeBlockTrials = excludeRewardBlockTrials(rewardBlockInd);

                  rtStatusTargetInRF = cur_rtTargetInRF>=rtBn(1)&cur_rtTargetInRF<rtBn(2);
                  rbtStatusTargetInRF = cur_rbtTargetInRF>excludeBlockTrials;
                  rtTargetInRFInd = find(rtStatusTargetInRF&rbtStatusTargetInRF);                  
                  chooseInRFInd = find(TrialParams.ChosenTargetInRFCode(cur_targetTrialInd)==1 & rtStatusTargetInRF & rbtStatusTargetInRF);
                  chooseOutRFInd = find(TrialParams.ChosenTargetInRFCode(cur_targetTrialInd)==0 & rtStatusTargetInRF & rbtStatusTargetInRF);
            
                  if doDiffAnalysis
                    diff_rtStatusTargetInRF = [];
                    diff_rbtStatusTargetInRF = [];
                    diff_rtTargetInRFInd = [];
                    diff_chooseInRFInd = [];
                    diff_chooseOutRFInd = [];
                    if numel(DiffTrialParams)>0
                      diff_rtStatusTargetInRF = cur_diff_rtTargetInRF>=rtBn(1)&cur_diff_rtTargetInRF<rtBn(2);
                      diff_rbtStatusTargetInRF = cur_diff_rbtTargetInRF>excludeBlockTrials;
                      diff_rtTargetInRFInd = find(diff_rtStatusTargetInRF&diff_rbtStatusTargetInRF);
                      diff_chooseInRFInd = find(DiffTrialParams.ChosenTargetInRFCode(cur_diff_targetTrialInd)==1 & diff_rtStatusTargetInRF & diff_rbtStatusTargetInRF);
                      diff_chooseOutRFInd = find(DiffTrialParams.ChosenTargetInRFCode(cur_diff_targetTrialInd)==0 & diff_rtStatusTargetInRF & diff_rbtStatusTargetInRF);
                    end
                  end
                  
                  if doSpatialAnalysis % Estimate selectivity for target in/out of refLocation?

                    rtStatusNoTargetInRF = cur_rtNoTargetInRF>=rtBn(1)&cur_rtNoTargetInRF<rtBn(2);
                    rbtStatusNoTargetInRF = cur_rbtNoTargetInRF>excludeBlockTrials;
                    rtNoTargetInRFInd = find(rtStatusNoTargetInRF&rbtStatusNoTargetInRF);
                    
                    if doDiffAnalysis
                      diff_rtStatusNoTargetInRF = cur_diff_rtNoTargetInRF>=rtBn(1)&cur_diff_rtNoTargetInRF<rtBn(2);
                      diff_rbtStatusNoTargetInRF = cur_diff_rbtNoTargetInRF>excludeBlockTrials;
                      diff_rtNoTargetInRFInd = find(diff_rtStatusNoTargetInRF&diff_rbtStatusNoTargetInRF);
                    end
                    
                    % User also has the option to estimate selectivity as a function of target choice
                    for choiceCatInd=1:numel(cur_choiceCategories)
                      choiceCat = cur_choiceCategories(choiceCatInd);
                      
                      switch choiceCat
                        case -1 % choose out of or into refLocation
                          choiceInd = rtTargetInRFInd;
                        case 0 % choose out of refLocation
                          choiceInd = chooseOutRFInd;
                        case 1 % choose into refLocation
                          choiceInd = chooseInRFInd;
                      end
                      
                      if doDiffAnalysis
                        switch choiceCat
                          case -1 % choose out of or into refLocation
                            diff_choiceInd = diff_rtTargetInRFInd;
                          case 0 % choose out of refLocation
                            diff_choiceInd = diff_chooseOutRFInd;
                          case 1 % choose into refLocation
                            diff_choiceInd = diff_chooseInRFInd;
                        end
                      end
                  
                      % Determine the appropriate parameter index for storing this spatial selectivity series
                      curSpatialParams = [ TargetIDs(refTargetInd) TargetLocations(refLocationInd) rtBn excludeBlockTrials choiceCat ];
                      [tf,spatialParamsInd] = ismember(curSpatialParams,spatialParams,'rows');
                      if ~tf % Have we analyzed this parameter set previously?
                        spatialParams = [ spatialParams; curSpatialParams ];
                        spatialParamsInd = size(spatialParams,1);
                      end
                  
                      switch sessType(Sess)
                        case {'Field','SpikeField','FieldField'}
                          refSpec = [];
                          testSpec = [];
                          f = [];                    
                          if numel(choiceInd)>1

                            switch sessType(Sess)
                              case 'Field'
                                [refSpec,f]  = tfspec(baseLfp1(choiceInd,:),tapers,sampling_rate,dn,fk,pad);
                                [testSpec,f] = tfspec(Lfp1(choiceInd,:),tapers,sampling_rate,dn,fk,pad);
                              case {'SpikeField','FieldField'}
                                numtrials = numel(choiceInd);
                                for k=1:2
                                  if k==1
                                    switch sessType(Sess)
                                      case 'SpikeField'
                                        [Data1k, f] = tfsp_proj(baseSpike1(choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                        [Data2k, f] = tfsp_proj(baseLfp1(choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                      case 'FieldField'
                                        [Data1k, f] = tfsp_proj(baseLfp1(choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                        [Data2k, f] = tfsp_proj(baseLfp2(choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                    end
                                  elseif k==2
                                    switch sessType(Sess)
                                      case 'SpikeField'
                                        [Data1k, f] = tfsp_proj(Spike1(choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                        [Data2k, f] = tfsp_proj(Lfp1(choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                      case 'FieldField'
                                        [Data1k, f] = tfsp_proj(Lfp1(choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                        [Data2k, f] = tfsp_proj(Lfp2(choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                    end
                                  end
                                  nwin = size(Data1k,2);  nfk = size(Data1k,4);  K = size(Data1k,3);
                                  Data1k = permute(Data1k, [1,3,2,4]);
                                  Data1k = reshape(Data1k, [numtrials*K, nwin, nfk]);
                                  Data2k = permute(Data2k, [1,3,2,4]);
                                  Data2k = reshape(Data2k, [numtrials*K, nwin, nfk]);            
                                  SData1 = Data1k.*conj(Data1k);
                                  SData2 = Data2k.*conj(Data2k);
                                  CrossSpec = Data1k.*conj(Data2k);
%                                   if nwin == 1
%                                     SData1 = SData1.'; SData2 = SData2.'; CrossSpec = CrossSpec.';
%                                   end
                                  Coh = CrossSpec./sqrt(SData1.*SData2);
                                  Coh(find(isnan(Coh))) = 0;
                                  if k==1
                                    refSpec = Coh;
                                  elseif k==2
                                    testSpec = Coh;
                                  end
                                end                                
                              otherwise
                            end % switch sessType(Sess)
                            
                            refBaseline = 0;
                            if size(baseLfp1,2)==int32(((N+dn)*sampling_rate + 1))
                               refBaseline = 1;
                               newRefSpec = zeros(size(testSpec));
                               for k=1:size(testSpec,2)
                                 newRefSpec(:,k,:) = sq(refSpec(:,1,:)); % check that you're indexing into middle time-point of refSpec correctly
                               end
                               refSpec = newRefSpec; clear newRefSpec;
                            end
                          end
                          % compare time-varying PSD to baseline when target is in refLocation
                          p = calcTimeSeriesPermutationTest(refSpec,testSpec,nPerm);
                          p = uint32(scaleFactor*p);
                          Task(m,n).f = f;
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).p = p;
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).N = uint32([ numel(choiceInd) numel(choiceInd) ]);
                          
                          refSeries_mean  = sq(mean(refSpec,1));
                          testSeries_mean = sq(mean(testSpec,1));
                          refSeries_stderr  = sq(std(refSpec,0,1))/(sqrt(size(refSpec,1))+eps);
                          testSeries_stderr = sq(std(testSpec,0,1))/(sqrt(size(testSpec,1))+eps);
                          if isequal(sessType(Sess),'Field')
                            refSeries_mean  = log10(refSeries_mean);
                            testSeries_mean = log10(testSeries_mean);
                            refSeries_stderr  = log10(refSeries_stderr);
                            testSeries_stderr = log10(testSeries_stderr);
                          end
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).refSeries_mean  = uint32(refSeries_mean*scaleFactor);
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).testSeries_mean = uint32(testSeries_mean*scaleFactor);
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).refSeries_stderr  = uint32(refSeries_stderr*scaleFactor);
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).testSeries_stderr = uint32(testSeries_stderr*scaleFactor);

                          
                          refSpec_noTarget = zeros(0,size(refSpec,2),size(refSpec,3));
                          if numel(rtNoTargetInRFInd)>1
                            % compare time-varying PSD with/without a target in refLocation
                            switch sessType(Sess)
                              case 'Field'
                                [refSpec_noTarget,f]  = tfspec(Lfp1_noTarget(rtNoTargetInRFInd,:),tapers,sampling_rate,dn,fk,pad);
                              case {'SpikeField','FieldField'}
                                numtrials = numel(rtNoTargetInRFInd);
                                switch sessType(Sess)
                                  case 'SpikeField'
                                    [Data1k, f] = tfspproj_pt(Spike1_noTarget(rtNoTargetInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                    [Data2k, f] = tfsp_proj(Lfp1_noTarget(rtNoTargetInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                  case 'FieldField'
                                    [Data1k, f] = tfsp_proj(Lfp1_noTarget(rtNoTargetInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                    [Data2k, f] = tfsp_proj(Lfp2_noTarget(rtNoTargetInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                end
                                nwin = size(Data1k,2);  nfk = size(Data1k,4);  K = size(Data1k,3);
                                Data1k = permute(Data1k, [1,3,2,4]);
                                Data1k = reshape(Data1k, [numtrials*K, nwin, nfk]);
                                Data2k = permute(Data2k, [1,3,2,4]);
                                Data2k = reshape(Data2k, [numtrials*K, nwin, nfk]);            
                                SData1 = Data1k.*conj(Data1k);
                                SData2 = Data2k.*conj(Data2k);
                                CrossSpec = Data1k.*conj(Data2k);
                                if nwin == 1
                                  SData1 = SData1.'; SData2 = SData2.'; CrossSpec = CrossSpec.';
                                end
                                Coh = CrossSpec./sqrt(SData1.*SData2);
                                Coh(find(isnan(Coh))) = 0;
                                refSpec_noTarget = Coh;                        
                              otherwise
                            end % switch sessType(Sess)
                            
                            if size(testSpec,1)==0
                              testSpec = zeros(0,size(refSpec_noTarget,2),size(refSpec_noTarget,3));
                            end
                          end
                          
                          if ~doNonSpatialAnalysis
                            p = calcTimeSeriesPermutationTest(refSpec_noTarget,testSpec,nPerm);
                            p = uint32(scaleFactor*p);
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).p = p;
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).N =  uint32([ numel(rtNoTargetInRFInd) numel(choiceInd) ]);
                          
                            refSeries_mean  = sq(mean(refSpec_noTarget,1));
                            testSeries_mean = sq(mean(testSpec,1));
                            refSeries_stderr  = sq(std(refSpec_noTarget,0,1))/(sqrt(size(refSpec_noTarget,1))+eps);
                            testSeries_stderr = sq(std(testSpec,0,1))/(sqrt(size(testSpec,1))+eps);
                            if isequal(sessType(Sess),'Field')
                              refSeries_mean  = log10(refSeries_mean);
                              testSeries_mean = log10(testSeries_mean);
                              refSeries_stderr  = log10(refSeries_stderr);
                              testSeries_stderr = log10(testSeries_stderr);
                            end
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).refSeries_mean  = uint32(refSeries_mean*scaleFactor);
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).testSeries_mean = uint32(testSeries_mean*scaleFactor);
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).refSeries_stderr  = uint32(refSeries_stderr*scaleFactor);
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).testSeries_stderr = uint32(testSeries_stderr*scaleFactor);
                          end
                          
                          if doDiffAnalysis
                            diff_testSpec = zeros(0,size(testSpec,2),size(testSpec,3));
                            diff_refSpec_noTarget = zeros(0,size(refSpec,2),size(refSpec,3));
                            if numel(diff_choiceInd)>1
                              
                              switch sessType(Sess)
                                case 'Field'
                                  [diff_testSpec,f] = tfspec(diff_Lfp1(diff_choiceInd,:),tapers,sampling_rate,dn,fk,pad);
                                case {'SpikeField','FieldField'}
                                  numtrials = numel(diff_choiceInd);
                                  switch sessType(Sess)
                                    case 'SpikeField'
                                      [Data1k, f] = tfspproj_pt(diff_Spike1(diff_choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                      [Data2k, f] = tfsp_proj(diff_Lfp1(diff_choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                    case 'FieldField'
                                      [Data1k, f] = tfsp_proj(diff_Lfp1(diff_choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                      [Data2k, f] = tfsp_proj(diff_Lfp2(diff_choiceInd,:), tapers, sampling_rate, dn, fk, pad);
                                  end
                                  nwin = size(Data1k,2);  nfk = size(Data1k,4);  K = size(Data1k,3);
                                  Data1k = permute(Data1k, [1,3,2,4]);
                                  Data1k = reshape(Data1k, [numtrials*K, nwin, nfk]);
                                  Data2k = permute(Data2k, [1,3,2,4]);
                                  Data2k = reshape(Data2k, [numtrials*K, nwin, nfk]);            
                                  SData1 = Data1k.*conj(Data1k);
                                  SData2 = Data2k.*conj(Data2k);
                                  CrossSpec = Data1k.*conj(Data2k);
                                  if nwin == 1
                                    SData1 = SData1.'; SData2 = SData2.'; CrossSpec = CrossSpec.';
                                  end
                                  Coh = CrossSpec./sqrt(SData1.*SData2);
                                  Coh(find(isnan(Coh))) = 0;
                                  diff_testSpec = Coh;                        
                                otherwise
                              end % switch sessType(Sess)
                            
                              if size(testSpec,1)==0
                                testSpec = zeros(0,size(diff_testSpec,2),size(diff_testSpec,3));
                              end
                            end
                            if numel(diff_rtNoTargetInRFInd)>1
                              
                              switch sessType(Sess)
                                case 'Field'
                                  [diff_refSpec_noTarget,f]  = tfspec(diff_Lfp1_noTarget(diff_rtNoTargetInRFInd,:),tapers,sampling_rate,dn,fk,pad);
                                case {'SpikeField','FieldField'}
                                  numtrials = numel(diff_rtNoTargetInRFInd);
                                  switch sessType(Sess)
                                    case 'SpikeField'
                                      [Data1k, f] = tfspproj_pt(diff_Spike1_noTarget(diff_rtNoTargetInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                      [Data2k, f] = tfsp_proj(diff_Lfp1_noTarget(diff_rtNoTargetInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                    case 'FieldField'
                                      [Data1k, f] = tfsp_proj(diff_Lfp1_noTarget(diff_rtNoTargetInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                      [Data2k, f] = tfsp_proj(diff_Lfp2_noTarget(diff_rtNoTargetInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                  end
                                  nwin = size(Data1k,2);  nfk = size(Data1k,4);  K = size(Data1k,3);
                                  Data1k = permute(Data1k, [1,3,2,4]);
                                  Data1k = reshape(Data1k, [numtrials*K, nwin, nfk]);
                                  Data2k = permute(Data2k, [1,3,2,4]);
                                  Data2k = reshape(Data2k, [numtrials*K, nwin, nfk]);            
                                  SData1 = Data1k.*conj(Data1k);
                                  SData2 = Data2k.*conj(Data2k);
                                  CrossSpec = Data1k.*conj(Data2k);
                                  if nwin == 1
                                    SData1 = SData1.'; SData2 = SData2.'; CrossSpec = CrossSpec.';
                                  end
                                  Coh = CrossSpec./sqrt(SData1.*SData2);
                                  Coh(find(isnan(Coh))) = 0;
                                  diff_refSpec_noTarget = Coh;
                                otherwise
                              end % switch sessType(Sess)
                              
                              if size(testSpec,1)==0
                                refSpec_noTarget = zeros(0,size(diff_refSpec_noTarget,2),size(diff_refSpec_noTarget,3));
                              end
                            end
                            
                            if ~doNonSpatialAnalysis
                              p = calcTimeSeriesPermutationTest(diff_refSpec_noTarget,refSpec_noTarget,nPerm);
                              p = uint32(scaleFactor*p);
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).p_noTarget = p;
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).N_noTarget =  uint32([ numel(diff_rtNoTargetInRFInd) numel(rtNoTargetInRFInd) ]);

                              refSeries_mean  = sq(mean(diff_refSpec_noTarget,1));
                              testSeries_mean = sq(mean(refSpec_noTarget,1));
                              refSeries_stderr  = sq(std(diff_refSpec_noTarget,0,1))/(sqrt(size(diff_refSpec_noTarget,1))+eps);
                              testSeries_stderr = sq(std(refSpec_noTarget,0,1))/(sqrt(size(refSpec_noTarget,1))+eps);
                              if isequal(sessType(Sess),'Field')
                                refSeries_mean  = log10(refSeries_mean);
                                testSeries_mean = log10(testSeries_mean);
                                refSeries_stderr  = log10(refSeries_stderr);
                                testSeries_stderr = log10(testSeries_stderr);
                              end
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).refSeries_mean_noTarget  = uint32(refSeries_mean*scaleFactor);
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).testSeries_mean_noTarget = uint32(testSeries_mean*scaleFactor);
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).refSeries_stderr_noTarget  = uint32(refSeries_stderr*scaleFactor);
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).testSeries_stderr_noTarget = uint32(testSeries_stderr*scaleFactor);
                            end
                            
                            p = calcTimeSeriesPermutationTest(diff_testSpec,testSpec,nPerm);
                            p = uint32(scaleFactor*p);
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).p = p;
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).N =  uint32([ numel(diff_choiceInd) numel(choiceInd) ]);
                            
                            refSeries_mean  = sq(mean(diff_testSpec,1));
                            testSeries_mean = sq(mean(testSpec,1));
                            refSeries_stderr  = sq(std(diff_testSpec,0,1))/(sqrt(size(diff_testSpec,1))+eps);
                            testSeries_stderr = sq(std(testSpec,0,1))/(sqrt(size(testSpec,1))+eps);
                            if isequal(sessType(Sess),'Field')
                              refSeries_mean  = log10(refSeries_mean);
                              testSeries_mean = log10(testSeries_mean);
                              refSeries_stderr  = log10(refSeries_stderr);
                              testSeries_stderr = log10(testSeries_stderr);
                            end
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).refSeries_mean  = uint32(refSeries_mean*scaleFactor);
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).testSeries_mean = uint32(testSeries_mean*scaleFactor);
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).refSeries_stderr  = uint32(refSeries_stderr*scaleFactor);
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).testSeries_stderr = uint32(testSeries_stderr*scaleFactor);

                          end
                          
                        case {'Spike','Multiunit','SpikeSpike'}
                                            
                          % compare time-varying rate to baseline when target is in refLocation
                          refData = zeros(0,numel(sampleInd));
                          testData = zeros(0,numel(sampleInd));
                          if numel(choiceInd)>1
                            refData = repmat(baseRate(choiceInd),1,numel(sampleInd));
                            testData = rateArray(choiceInd,sampleInd);
                          end
                          p = calcTimeSeriesPermutationTest(refData,testData,nPerm);
                          p = uint32(scaleFactor*p);
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).p = p;
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).N = uint32([ size(refData,1) size(testData,1) ]);

                          refSeries_mean  = sq(mean(refData,1));
                          testSeries_mean = sq(mean(testData,1));
                          refSeries_stderr  = sq(std(refData,0,1))/(sqrt(size(refData,1))+eps);
                          testSeries_stderr = sq(std(testData,0,1))/(sqrt(size(testData,1))+eps);
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).refSeries_mean  = uint32(refSeries_mean*scaleFactor);
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).testSeries_mean = uint32(testSeries_mean*scaleFactor);
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).refSeries_stderr  = uint32(refSeries_stderr*scaleFactor);
                          Task(m,n).baselineAnalysis(spatialParamsInd).Field(fid).testSeries_stderr = uint32(testSeries_stderr*scaleFactor);

                          
                          % compare time-varying rate with/without a target in refLocation
                          if ~doNonSpatialAnalysis
                            refData = zeros(0,numel(sampleInd));
                            testData = zeros(0,numel(sampleInd));
                            if size(rateArray_noTarget,1)>0
                              refData  = rateArray_noTarget(:,sampleInd);
                            end
                            if numel(choiceInd)>1
                              testData = rateArray(choiceInd,sampleInd); 
                            end
                            p = calcTimeSeriesPermutationTest(refData,testData,nPerm);
                            p = uint32(scaleFactor*p);
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).p = p;
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).N =  uint32([ size(refData,1) size(testData,1) ]);
                          
                            refSeries_mean  = sq(mean(refData,1));
                            testSeries_mean = sq(mean(testData,1));
                            refSeries_stderr  = sq(std(refData,0,1))/(sqrt(size(refData,1))+eps);
                            testSeries_stderr = sq(std(testData,0,1))/(sqrt(size(testData,1))+eps);
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).refSeries_mean  = uint32(refSeries_mean*scaleFactor);
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).testSeries_mean = uint32(testSeries_mean*scaleFactor);
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).refSeries_stderr  = uint32(refSeries_stderr*scaleFactor);
                            Task(m,n).spatialAnalysis(spatialParamsInd).Field(fid).testSeries_stderr = uint32(testSeries_stderr*scaleFactor);
                          end
                          
                          if doDiffAnalysis
                            diff_refData = zeros(0,numel(sampleInd));
                            diff_testData = zeros(0,numel(sampleInd));
                            if size(diff_rateArray_noTarget,1)>0
                              diff_refData  = diff_rateArray_noTarget(:,sampleInd);
                            end
                            if numel(diff_choiceInd)>1
                              diff_testData = diff_rateArray(diff_choiceInd,sampleInd); 
                            end
                            
                            if ~doNonSpatialAnalysis
                              p = calcTimeSeriesPermutationTest(diff_refData,refData,nPerm);
                              p = uint32(scaleFactor*p);
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).p_noTarget = p;
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).N_noTarget =  uint32([ size(diff_refData,1) size(refData,1) ]);

                              refSeries_mean  = sq(mean(diff_refData,1));
                              testSeries_mean = sq(mean(refData,1));
                              refSeries_stderr  = sq(std(diff_refData,0,1))/(sqrt(size(diff_refData,1))+eps);
                              testSeries_stderr = sq(std(refData,0,1))/(sqrt(size(refData,1))+eps);
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).refSeries_mean_noTarget  = uint32(refSeries_mean*scaleFactor);
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).testSeries_mean_noTarget = uint32(testSeries_mean*scaleFactor);
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).refSeries_stderr_noTarget  = uint32(refSeries_stderr*scaleFactor);
                              Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).testSeries_stderr_noTarget = uint32(testSeries_stderr*scaleFactor);
                            end
                            
                            p = calcTimeSeriesPermutationTest(diff_testData,testData,nPerm);
                            p = uint32(scaleFactor*p);
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).p = p;
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).N =  uint32([ size(diff_testData,1) size(testData,1) ]);
                            
                            refSeries_mean  = sq(mean(diff_testData,1));
                            testSeries_mean = sq(mean(testData,1));
                            refSeries_stderr  = sq(std(diff_testData,0,1))/(sqrt(size(diff_testData,1))+eps);
                            testSeries_stderr = sq(std(testData,0,1))/(sqrt(size(testData,1))+eps);
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).refSeries_mean  = uint32(refSeries_mean*scaleFactor);
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).testSeries_mean = uint32(testSeries_mean*scaleFactor);
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).refSeries_stderr  = uint32(refSeries_stderr*scaleFactor);
                            Task(m,n).diffAnalysis(spatialParamsInd).Field(fid).testSeries_stderr = uint32(testSeries_stderr*scaleFactor);

                          end
                          
                        otherwise
                          % Need to implement spike-field coherence code

                      end % switch sessType(Sess)
                    end % for choiceCatCode

                  end % if doSpatialAnalysis
                
                
                  if doChoiceAnalysis & ~doNonSpatialAnalysis % Estimate selectivity for choice in/out of refLocation?
                
                    % Determine the appropriate parameter index for storing this choice selectivity series
                    curChoiceParams = [ TargetIDs(refTargetInd) TargetLocations(refLocationInd) rtBn excludeBlockTrials ];
                    [tf,choiceParamsInd] = ismember(curChoiceParams,choiceParams,'rows');
                    if ~tf % Have we analyzed this parameter set previously?
                      choiceParams = [ choiceParams; curChoiceParams ];
                      choiceParamsInd = size(choiceParams,1);
                    end
                  
                    switch sessType(Sess)
                      case {'Field','SpikeField','FieldField'}
                        refSpec = [];
                        testSpec = [];
                        f = [];
                        if numel(chooseInRFInd)>1 & numel(chooseOutRFInd)>1
                          
                          switch sessType(Sess)
                            case 'Field'
                              [refSpec,f]  = tfspec(Lfp1(chooseOutRFInd,:),tapers,sampling_rate,dn,fk,pad);
                              [testSpec,f] = tfspec(Lfp1(chooseInRFInd,:),tapers,sampling_rate,dn,fk,pad);
                            case {'SpikeField','FieldField'}
                              for k=1:2
                                if k==1
                                  numtrials = numel(chooseOutRFInd);                                    
                                  switch sessType(Sess)
                                    case 'SpikeField'
                                      [Data1k, f] = tfspproj_pt(Spike1(chooseOutRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                      [Data2k, f] = tfsp_proj(Lfp1(chooseOutRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                    case 'FieldField'
                                      [Data1k, f] = tfsp_proj(Lfp1(chooseOutRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                      [Data2k, f] = tfsp_proj(Lfp2(chooseOutRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                  end
                                elseif k==2
                                  numtrials = numel(chooseInRFInd);                                    
                                  switch sessType(Sess)
                                    case 'SpikeField'
                                      [Data1k, f] = tfspproj_pt(Spike1(chooseInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                      [Data2k, f] = tfsp_proj(Lfp1(chooseInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                    case 'FieldField'
                                      [Data1k, f] = tfsp_proj(Lfp1(chooseInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                      [Data2k, f] = tfsp_proj(Lfp2(chooseInRFInd,:), tapers, sampling_rate, dn, fk, pad);
                                  end
                                end
                                nwin = size(Data1k,2);  nfk = size(Data1k,4);  K = size(Data1k,3);
                                Data1k = permute(Data1k, [1,3,2,4]);
                                Data1k = reshape(Data1k, [numtrials*K, nwin, nfk]);
                                Data2k = permute(Data2k, [1,3,2,4]);
                                Data2k = reshape(Data2k, [numtrials*K, nwin, nfk]);            
                                SData1 = Data1k.*conj(Data1k);
                                SData2 = Data2k.*conj(Data2k);
                                CrossSpec = Data1k.*conj(Data2k);
                                if nwin == 1
                                  SData1 = SData1.'; SData2 = SData2.'; CrossSpec = CrossSpec.';
                                end
                                Coh = CrossSpec./sqrt(SData1.*SData2);
                                Coh(find(isnan(Coh))) = 0;
                                if k==1
                                  refSpec = Coh;
                                elseif k==2
                                  testSpec = Coh;
                                end
                              end                                
                            otherwise
                          end % switch sessType(Sess)
                          
                        end % if numel(chooseInRFInd)>1 & numel(chooseOutRFInd)>1
                        p = calcTimeSeriesPermutationTest(refSpec,testSpec,nPerm);
                        p = uint32(scaleFactor*p);
                        Task(m,n).f = f;
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).p = p;
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).N = uint32([ numel(chooseOutRFInd) numel(chooseInRFInd) ]);

                        refSeries_mean  = sq(mean(refSpec,1));
                        testSeries_mean = sq(mean(testSpec,1));
                        refSeries_stderr  = sq(std(refSpec,0,1))/(sqrt(size(refSpec,1))+eps);
                        testSeries_stderr = sq(std(testSpec,0,1))/(sqrt(size(testSpec,1))+eps);
                        if isequal(sessType(Sess),'Field')
                          refSeries_mean  = log10(refSeries_mean);
                          testSeries_mean = log10(testSeries_mean);
                          refSeries_stderr  = log10(refSeries_stderr);
                          testSeries_stderr = log10(testSeries_stderr);
                        end
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).refSeries_mean  = uint32(refSeries_mean*scaleFactor);
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).testSeries_mean = uint32(testSeries_mean*scaleFactor);
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).refSeries_stderr  = uint32(refSeries_stderr*scaleFactor);
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).testSeries_stderr = uint32(testSeries_stderr*scaleFactor);
                        
                      case {'Spike','Multiunit','SpikeSpike'}        
                        refData = zeros(0,numel(sampleInd));
                        testData = zeros(0,numel(sampleInd));
                        if numel(chooseOutRFInd)>1
                          refData  = rateArray(chooseOutRFInd,sampleInd);
                        end
                        if numel(chooseInRFInd)>1
                          testData = rateArray(chooseInRFInd,sampleInd);
                        end
                        p = calcTimeSeriesPermutationTest(refData,testData,nPerm);
                        p = uint32(scaleFactor*p);
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).p = p;
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).N = uint32([ size(refData,1) size(testData,1) ]);
                    
                        refSeries_mean  = sq(mean(refData,1));
                        testSeries_mean = sq(mean(testData,1));
                        refSeries_stderr  = sq(std(refData,0,1))/(sqrt(size(refData,1))+eps);
                        testSeries_stderr = sq(std(testData,0,1))/(sqrt(size(testData,1))+eps);
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).refSeries_mean  = uint32(refSeries_mean*scaleFactor);
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).testSeries_mean = uint32(testSeries_mean*scaleFactor);
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).refSeries_stderr  = uint32(refSeries_stderr*scaleFactor);
                        Task(m,n).choiceAnalysis(choiceParamsInd).Field(fid).testSeries_stderr = uint32(testSeries_stderr*scaleFactor);

                      otherwise
                        % Need to implement spike-field coherence code

                    end % switch sessType(Sess)
                  end % if doChoiceAnalysis

                end % for rewardBlockInd=1:numel(excludeRewardBlockTrials)
              end % for rtCat            
            end % for fid 
          end % if numel(targetTrialInd)>0
          
%         else
%           % This is a non-spatial analysis. Analyze selectivity for specific targets.
%           % (Need to implement non-spatial selectivity analysis)          
%         end % if refLocation ~=0

      end % for refLocationInd=1:numel(TargetLocations)
    end % for refTargetInd=1:numel(TargetIDs)
    
    end % if nTrials>0
    
    if doSpatialAnalysis
      Task(m,n).spatialParams = spatialParams;
    end
    if doChoiceAnalysis
      Task(m,n).choiceParams = choiceParams; 
    end

    Task(m,n).nTrials = nTrials;

    if doDiffAnalysis
      Task(m,n).nDiffTrials = nDiffTrials; 
    end

  end % for n=1:size(CondParams,2)
end % for m=1:size(CondParams,1)

SelSeries.Task = Task;
SelSeries.TuningAnalParams = TuningAnalParams;

