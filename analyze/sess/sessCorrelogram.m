function [XCorrData] = sessCorrelogram(Sess, CondParams, AnalParams)
%
%   [TaskXCorr] = sessCorrelogram(Sess, CondParams, AnalParams)
%
%   Generate auto- and cross-correlograms for a spike-spike session
%   under the task conditions specified by CondParams and AnalParams.
% 
%   SESS        =  Cell array.  Session information
%   CONDPARAMS  =  Data structure.  Parameter information for
%                  condition information
%   ANALPARAMS  =  Data structure.  Analysis parameter information.

global MONKEYDIR

XCorrData = [];

Day = sessDay(Sess);
Sys = sessTower(Sess);
Ch = sessElectrode(Sess);
Contact = sessContact(Sess);
Cl = sessCell(Sess);

% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    All_Trials = sessTrials(Sess);
end

TaskXCorr = [];

for iCond = 1:length(CondParams)

  if(isfield(AnalParams(iCond),'Fields'))
    Fields = AnalParams(iCond).Fields;
  else
    Fields = 'TargsOn';
  end

  if(isfield(AnalParams(iCond),'bn'))
      bn = AnalParams(iCond).bn;
  else
    bn = [-2e3,2e3];
  end

  if(isfield(AnalParams(iCond),'cwlen'))
      N = AnalParams(iCond).cwlen;
  else
    N = 100;
  end

  if(isfield(AnalParams(iCond),'Intervals'))
      Intervals = AnalParams(iCond).Intervals;
  else
    Intervals = {};
    Intervals{1} = bn;
  end

  if(~isfield(CondParams,'Task'))
      CondParams(iCond).Task = 'DelSaccade';
  end
  
  Task = CondParams(iCond).Task;
  
  TaskXCorr(iCond).Task = Task;
  if(~isfield(CondParams,'sort'))
    TaskXCorr(iCond).sort = []; 
  else
    TaskXCorr(iCond).sort = CondParams(iCond).sort;
  end
      
  
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
  
% if(~isfield(CondParams,'conds'))
%     CondParams.conds = {[]};
% end

  disp('Running Params2Trials');
  All_Trials_filt = Params2Trials(All_Trials,CondParams(iCond));

  if(~iscell(All_Trials_filt))
    Trials{1} = All_Trials_filt;
  else
    Trials = All_Trials_filt;
  end

  disp([num2str(length(Trials{1})) ' Trials'])

  TaskXCorr(iCond).Ntrials = length(Trials{1});
  
  for fid=1:length(Fields)
    Field = Fields{fid};

    TaskXCorr(iCond).Field(fid).FieldName = Field;

    % AnalParams.Intervals allows the user to generate separate
    % correlograms for specific intervals in the bn time domain.
    % e.g. if bn = [-1e3,2e3], and intervals = [ -300 0; 0 300 ],
    % correlograms will be generated for Baseline and Cue intervals.
    
    aInt = Intervals{fid};
    intTotal = size(aInt,1);

ref1SampleTotal = zeros(intTotal,1);
ref2SampleTotal = zeros(intTotal,1);
xc11 = zeros(intTotal,N+1); 
xc12 = zeros(intTotal,N+1); 
xc22 = zeros(intTotal,N+1);
xc21 = zeros(intTotal,N+1); 
xc11_shuf = zeros(intTotal,N+1);
xc12_shuf = zeros(intTotal,N+1); 
xc22_shuf = zeros(intTotal,N+1);
xc21_shuf = zeros(intTotal,N+1); 

if length(Trials{1}) > 0
    for iTaskComp = 1:length(Trials)
        TaskString = [];
        for iTaskPool = 1:length(Task{iTaskComp})
            TaskString = [TaskString Task{iTaskComp}{iTaskPool} ' '];
        end
        disp(['Calculating Spik-Spike XCorr with N = ' ...
            num2str(N) ' for ' ...
            TaskString ' using  ' num2str(length(Trials{iTaskComp})) ' Trials']);

                tic
                Spike1 = trialSpike(Trials{iTaskComp}, Sys{1}, Ch(1), Contact{1}, Cl(1), Field, ...
                    [bn(1)-N/2,bn(2)+N/2]);
                Spike2 = trialSpike(Trials{iTaskComp}, Sys{2}, Ch(2), Contact{2}, Cl(2), Field, ...
                    [bn(1)-N/2,bn(2)+N/2]);
                
                for tid=1:length(Spike1) % for each trial
                  sp1 = Spike1{tid};
                  sp2 = Spike2{tid};
                  if length(sp1)>0 & length(sp2)>0

                  % Shuffled spike trains are shifted 100 ms into the
                  % future, as described in (Csicsvari et al, Neuron 1998).
                  % This allows us to discriminate between true causal
                  % synaptic interactions and population synchrony events.
                  sp1_shuf1 = sp1+100;
                  sp2_shuf1 = sp2+100;

                  sp1bn = sp2ts(sp1,[0,diff(bn)+N,1])>0; % binarize
                  sp2bn = sp2ts(sp2,[0,diff(bn)+N,1])>0; % binarize
                  
                  sp1bn_shuf1 = sp2ts(sp1_shuf1,[0,diff(bn)+N,1])>0; % binarize
                  sp2bn_shuf1 = sp2ts(sp2_shuf1,[0,diff(bn)+N,1])>0; % binarize
                  
                  for intID=1:intTotal
                  
                      intRange = aInt(intID,:);
                      startBin = intRange(1)-(bn(1)-N/2)-N/2+1;
                      endBin = intRange(2)-(bn(1)-N/2)+N/2+1;
                      
                      sp1bn_int = sp1bn(startBin:endBin);
                      sp2bn_int = sp2bn(startBin:endBin);
                      sp1bn_shuf1_int = sp1bn_shuf1(startBin:endBin);
                      sp2bn_shuf1_int = sp2bn_shuf1(startBin:endBin);
                      
                  xc11_temp = zeros(1,N+1);
                  xc12_temp = zeros(1,N+1);
                  xc22_temp = zeros(1,N+1);
                  xc21_temp = zeros(1,N+1);

                  xc11_shuf_temp = zeros(1,N+1);
                  xc12_shuf_temp = zeros(1,N+1);
                  xc22_shuf_temp = zeros(1,N+1);
                  xc21_shuf_temp = zeros(1,N+1);

                  sp1locs = find(sp1bn_int); sp2locs = find(sp2bn_int);
                  sp1locs(find(sp1locs<=N/2|sp1locs>=(diff(intRange)+N/2))) = [];
                  sp2locs(find(sp2locs<=N/2|sp2locs>=(diff(intRange)+N/2))) = [];

                  sp1locs_shuf1 = find(sp1bn_shuf1_int); sp2locs_shuf1 = find(sp2bn_shuf1_int);
                  sp1locs_shuf1(find(sp1locs_shuf1<=N/2|sp1locs_shuf1>=(diff(intRange)+N/2))) = [];
                  sp2locs_shuf1(find(sp2locs_shuf1<=N/2|sp2locs_shuf1>=(diff(intRange)+N/2))) = [];

                  for ref1=sp1locs
                    xc11_temp = xc11_temp + sp1bn_int(ref1-N/2:ref1+N/2);
                    xc12_temp = xc12_temp + sp2bn_int(ref1-N/2:ref1+N/2);
                  end
                  for ref2=sp2locs
                    xc22_temp = xc22_temp + sp2bn_int(ref2-N/2:ref2+N/2);
                    xc21_temp = xc21_temp + sp1bn_int(ref2-N/2:ref2+N/2);
                  end

                  for ref1=sp1locs
                    xc11_shuf_temp = xc11_shuf_temp + sp1bn_shuf1_int(ref1-N/2:ref1+N/2);
                    xc12_shuf_temp = xc12_shuf_temp + sp2bn_shuf1_int(ref1-N/2:ref1+N/2);
                  end
                  for ref2=sp2locs
                    xc22_shuf_temp = xc22_shuf_temp + sp2bn_shuf1_int(ref2-N/2:ref2+N/2);
                    xc21_shuf_temp = xc21_shuf_temp + sp1bn_shuf1_int(ref2-N/2:ref2+N/2);
                  end
                 
                  xc11_shuf(intID,:) = xc11_shuf(intID,:) + xc11_shuf_temp;
                  xc12_shuf(intID,:) = xc12_shuf(intID,:) + xc12_shuf_temp;
                  xc22_shuf(intID,:) = xc22_shuf(intID,:) + xc22_shuf_temp;
                  xc21_shuf(intID,:) = xc21_shuf(intID,:) + xc21_shuf_temp;
                  xc11(intID,:) = xc11(intID,:) + xc11_temp;
                  xc12(intID,:) = xc12(intID,:) + xc12_temp;
                  xc22(intID,:) = xc22(intID,:) + xc22_temp;
                  xc21(intID,:) = xc21(intID,:) + xc21_temp;
                  ref1SampleTotal(intID) = ref1SampleTotal(intID) + length(sp1locs);
                  ref2SampleTotal(intID) = ref2SampleTotal(intID) + length(sp2locs);

                  end % for intID=1:intTotal
                  
                  end % if length(sp1)>0 & length(sp2)>0
                end
                
  


    end
  else
    % do nothing - not enough trials
  end
  
TaskXCorr(iCond).Field(fid).xc11 = uint32(xc11);
TaskXCorr(iCond).Field(fid).xc12 = uint32(xc12);
TaskXCorr(iCond).Field(fid).xc22 = uint32(xc22);
TaskXCorr(iCond).Field(fid).xc21 = uint32(xc21);
TaskXCorr(iCond).Field(fid).xc11_shuf = uint32(xc11_shuf);
TaskXCorr(iCond).Field(fid).xc12_shuf = uint32(xc12_shuf);
TaskXCorr(iCond).Field(fid).xc22_shuf = uint32(xc22_shuf);
TaskXCorr(iCond).Field(fid).xc21_shuf = uint32(xc21_shuf);
TaskXCorr(iCond).Field(fid).ref1SampleTotal = uint32(ref1SampleTotal);
TaskXCorr(iCond).Field(fid).ref2SampleTotal = uint32(ref2SampleTotal);

  end % for fid=1:length(Fields)
end

XCorrData.Task = TaskXCorr;
XCorrData.Session = Sess;
XCorrData.CondParams = CondParams;
XCorrData.AnalParams = AnalParams;
