function [ Series ] = sessFieldSeries(Session,CondParams,AnalParams);

%  sessFieldSeries(SESSION,CONDPARAMS,ANALPARAMS);
%  
%  Calculates task/field-specific Field time series for unit in Session.
%  
%  SESSION = Metadata for unit.
%  CONDPARAMS = Task and Field conditions to analyze.
%  ANALPARAMS = Analysis parameters.

Series = [];

Day = sessDay(Session);
Sys = sessTower(Session);
Ch = sessElectrode(Session);
Contact = sessContact(Session);
% Cl = sessCell(Session);

AllTrials = [];
if isstruct(Session{1})
  AllTrials = Session{1};
  Day = AllTrials(1).Day;
else
  AllTrials = dbdatabase(Day);
end

     Session{1} = AllTrials;
  
     Task = [];
     for k=1:size(CondParams,1)
       for j=1:size(CondParams,2)
        try
           Trials = Params2Trials(Session, CondParams(k,j));
        catch
           % no trials found during the specified task condition
          Trials = [];
        end
         
         % Get indexes for qualifying trials
         trialIndex = zeros(1,length(Trials));
         for t=1:length(Trials)
           tLoc = find(Trials(t).Trial==[AllTrials.Trial]);
           for r=1:length(tLoc)
             if isequal(Trials(t).Day,AllTrials(tLoc(r)).Day) & ...
                isequal(Trials(t).Rec,AllTrials(tLoc(r)).Rec)
               trialIndex(t) = tLoc(r);
               break;
             end
           end
         end
      
         Task(k,j).Name = CondParams(k,j).Name;
         Task(k,j).Task = CondParams(k,j).Task;
         if isfield(CondParams,'sort')
           Task(k,j).sort = CondParams(k,j).sort;
         end
         Task(k,j).Trial = uint16(trialIndex');
         
         if length(Trials)>0
         
          % Store some trial metadata for faster analysis
          Task(k,j).Success = [Trials.Success]';
          if sum(Task(k,j).Success)==0
            Task(k,j).AbortState = [Trials.AbortState]';
          end
          Task(k,j).Go = [Trials.Go]';
          Task(k,j).SaccStart = [Trials.SaccStart]';
          Task(k,j).SaccadeAq = [Trials.SaccadeAq]';
          Task(k,j).SaccStop = [Trials.SaccStop]';
          Task(k,j).Target = [Trials.Target]';
          try
          Task(k,j).SaccadeChoiceContinuousLocation = reshape([Trials.SaccadeChoiceContinuousLocation],2,numel(trialIndex))';
          Task(k,j).UnchosenTargetContinuousLocation = reshape([Trials.UnchosenTargetContinuousLocation],2,numel(trialIndex))';
          Task(k,j).BrightDist = reshape([Trials.BrightDist],4,numel(trialIndex))';
          Task(k,j).RewardVolumeDist = reshape([Trials.RewardVolumeDist],2,numel(trialIndex))';
          Task(k,j).TargetLuminanceVals = reshape([Trials.TargetLuminanceVals],2,numel(trialIndex))';
          Task(k,j).RewardVolumeVals = reshape([Trials.RewardVolumeVals],2,numel(trialIndex))';        
          Task(k,j).RewardBlockTrial  = int16([Trials.RewardBlockTrial]');
          catch
            % this information is not available in a small subset of sessions
            % where LabView text files were lost/corrupted/not saved.
          end
          
  % specify target coordinates for MemorySaccade and DelSaccade trials.
  targetLocation = [ 12 0; 12 10; 2 10; -8 10; -8 0; -8 -10; 2 -10; 12 -10];
  
  [E_obs_trial,H] = trialEyeHand(Trials,'SaccStop',[0 20],[],0);
  
  if size(E_obs_trial,3)<size(E_obs_trial,2) % occurs if only one trial
    E_obs_trial = permute(E_obs_trial,[3 1 2]);
  end
  
  saccErrData = [];
  for t=1:numel(Trials)
    if (Trials(t).TaskCode==11 &  Trials(t).RewardTask==1) | ...
       (Trials(t).TaskCode==16 &  Trials(t).RewardTask==1)
      % Visual ODR or Memory ODR
      E_true = targetLocation([Trials(t).Target],:);
    else
      E_true = Trials(t).SaccadeChoiceContinuousLocation;
    end
    
    if ~isnan(E_true)
        
    % Identify post-saccadic eye position that is furthest from the target.
    E_obs_t = sq(E_obs_trial(t,:,:))'; 
    Edev_t = sqrt(sum((repmat(E_true,size(E_obs_t,1),1)-E_obs_t).^2,2));
    [maxDev,maxInd]=max(Edev_t);
    E_obs = E_obs_t(maxInd,:);
    
    % Estimate the median post-saccadic eye position. Note that this can
    % result in a position estimate that doesn't appear in recorded data.
    % Also, on trials where the animal saccades to the correct location but
    % breaks fixation early, this code will erroneously report his eye
    % position to be at the correct target. We should really be focusing
    % on the eye position that is furthest from the target immediately
    % after SaccStop, as this will correctly reveal errors.
%     E_obs = sq(median(sq(E_obs_trial(t,:,:)),2))';

    Edev = sqrt(sum((E_true-E_obs).^2,2));
    
    Ang_true = atan(E_true(:,2)./E_true(:,1));
      negInd = find(Ang_true<0);
      Ang_true(negInd) = 2*pi + Ang_true(negInd);
      Ang_true = 360*Ang_true/(2*pi);
    
    Ang_obs = atan(E_obs(:,2)./E_obs(:,1));
      negInd = find(Ang_obs<0);
      Ang_obs(negInd) = 2*pi + Ang_obs(negInd);
      Ang_obs = 360*Ang_obs/(2*pi);
      
    Ecc_true = sqrt(sum((E_true).^2,2));
    Ecc_obs = sqrt(sum((E_obs).^2,2));
    
    angDiff = abs(Ang_obs-Ang_true);
    angDiff = min(angDiff,360-angDiff);
    
    eccDiff = Ecc_obs - Ecc_true;
    
    saccErrData = [ saccErrData; E_true E_obs Ang_true Ang_obs Ecc_true Ecc_obs angDiff eccDiff Edev ];
    
    else
      saccErrData = [ saccErrData; NaN*zeros(1,11) ];
    end
    
      end % for t=1:numel(Trials)
  
      Task(k,j).EyeTargetLocation = saccErrData(:,1:2);
      Task(k,j).SaccEndpoint = saccErrData(:,3:4);
      Task(k,j).TargetAngle_TrueObs = saccErrData(:,5:6);
      Task(k,j).TargetEccentricity_TrueObs = saccErrData(:,7:8);
      Task(k,j).AbsAngleDiff = saccErrData(:,9);
      Task(k,j).EccDiff = saccErrData(:,10);
      Task(k,j).AbsSaccTargetDev = saccErrData(:,11);
      
          Fields = AnalParams(k,j).Fields;
          for fid = 1:length(Fields)
            Field = Fields{fid};
            bn = AnalParams(k,j).bn;
            
            Lfp = single(trialLfp(Trials,Sys,Ch,Contact,Field,bn));
            
            Task(k,j).Field(fid).Field = Field;
            Task(k,j).Field(fid).Lfp = Lfp;
            Task(k,j).Field(fid).bn = bn;
          end
        else
          Task(k,j).Field = [];
        end
      end
     end

  Session{1} = Day;
  Series.Session = Session;
  Series.Task = Task;
  