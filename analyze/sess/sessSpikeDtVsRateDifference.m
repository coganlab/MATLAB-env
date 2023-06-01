function [ DtVsRateDiff ] = sessSpikeDtVsRateDifference(Session1,Session2,CondParams,AnalParams);

%  sessSpikeDtVsRateDifference(SESSION1,SESSION2,CONDPARAMS,ANALPARAMS);
%  
%  Calculates the relative spike timing for the units specified by
%  Session1 and Session 2 as a function of their firing rate difference.
%  
%  SESSION1 = Metadata for unit 1.
%  SESSION2 = Metadata for unit 2.
%  CONDPARAMS = Task and Field conditions to analyze.
%  ANALPARAMS = Analysis parameters.

DtVsRateDiff = [];

Day1 = Session1{1};
Sys1 = Session1{3}{1};
Ch1 = Session1{4};
Cl1 = Session1{5};
Day2 = Session2{1};  
Sys2 = Session2{3}{1};
Ch2 = Session2{4};
Cl2 = Session2{5};

% bnBuffer = 1000; % Allows us to estimate rate of first spike in a window

if ~isequal(Day1,Day2)
  error('sessSpikeDtVsRateDifference: Unable to compare units from different days.');
  return;
end

[ Raster1, Params ] = loadSessRaster(Session1,CondParams,AnalParams);
[ Raster2, Params ] = loadSessRaster(Session2,CondParams,AnalParams);
if isempty(Raster1) | isempty(Raster2)
  error('sessSpikeDtVsRateDifference: Raster data not found.');
  return;
end

TuningTask1 = Raster1.TuningTask;
TuningTask2 = Raster2.TuningTask;

TuningTask = [];
for m=1:size(TuningTask1,1)
  for n=1:size(TuningTask1,2)
    TuningTask(m,n).Task = TuningTask1(m,n).Task;
    TuningField1 = TuningTask1(m,n).TuningField;
    TuningField2 = TuningTask2(m,n).TuningField;
    for tfid=1:length(TuningField1)
      TuningTask(m,n).TuningField(tfid).Field =  TuningField1(tfid).Field;
      Task1 = [];
      Task2 = [];
      try
        Task1 = TuningField1(tfid).Task;
        Task2 = TuningField2(tfid).Task;
      catch end
      if ~isempty(Task1) & ~isempty(Task2)

Task = [];
for k=1:size(CondParams,1)
  for j=1:size(CondParams,2)
    Field = [];
    TaskName = CondParams(k,j).Name;
    TaskString = CondParams(k,j).Task;
    
    isCenterOut = 0;
    trialIndex = [];
    inEitherRFlocs = [];
    inBothRFlocs = [];
    inNeitherRFlocs = [];
    
    % During which trials do both units qualify for this analysis?
    trialIndex1 = Task1(k,j).trialIndex;
    trialIndex2 = Task2(k,j).trialIndex;

    if length(trialIndex1)>0 | length(trialIndex2)>0
      
    if ismember(Task1(k,j).Task,{'DelSaccade','MemorySaccade'}) & length(Task1(k,j).sort)==0
      % CenterOut task - target must be in RF of at least one unit
      isCenterOut = 1;
      tlocs1 = find(ismember(trialIndex1,trialIndex2));
      tlocs2 = find(ismember(trialIndex2,trialIndex1));
      trialIndex = trialIndex1(tlocs1); % should be same length as trialIndex1, trialIndex2
      rfChoiceCode1 = Task1(k,j).ChosenTargetInRFCode(tlocs1);
      rfChoiceCode2 = Task2(k,j).ChosenTargetInRFCode(tlocs2);
      inEitherRFlocs = find(rfChoiceCode1==1|rfChoiceCode2==1);
      inBothRFlocs = find(rfChoiceCode1==1&rfChoiceCode2==1);
      inNeitherRFlocs = find(rfChoiceCode1~=1&rfChoiceCode2~=1);
    else
      % LRS task - both units must have targets in their respective RFs

k1 = k; j1 = j;
        k2 = k; j2 = j;
        if k1==1 k2 = 3; elseif k1==3 k2 = 1; end;
        if j1==1 j2 = 3; elseif j1==3 j2 = 1; end;
        
        % Sort by target properties in unit1 RF, then unit2 RF
        totalAdded = 0;
        for refUnitIter=1:2
          if refUnitIter==2
            ktemp = [ k1 k2 ];
            jtemp = [ j1 j2 ];
            k1 = ktemp(2); k2 = ktemp(1); j1 = jtemp(2); j2 = jtemp(1);
          end
          
          % Find trials when target in reference unit RF satisfies sort condition
          trialIndex1 = Task1(k1,j1).trialIndex;
          trialIndex2 = Task2(k2,j2).trialIndex;
          tlocs1 = find(ismember(trialIndex1,trialIndex2));
          tlocs2 = find(ismember(trialIndex2,trialIndex1));
          if length(tlocs1)==0 & length(tlocs2)==0
            % it's possible units have same RF...
            trialIndex1_temp = Task1(k,j).trialIndex;
            trialIndex2_temp = Task2(k,j).trialIndex;
            tlocs1_temp = find(ismember(trialIndex1_temp,trialIndex2_temp));
            tlocs2_temp = find(ismember(trialIndex2_temp,trialIndex1_temp));
            if length(tlocs1_temp)>0 & length(tlocs2_temp)>0 & length(trialIndex)==0
              % yup, same RF
              k1 = k; k2 = k1; 
              j1 = j; j2 = j1;
              trialIndex1 = trialIndex1_temp;
              trialIndex2 = trialIndex2_temp;
              tlocs1 = tlocs1_temp;
              tlocs2 = tlocs2_temp;
            end
          end
          if refUnitIter==1
            tlocs1_c1 = tlocs1;
            tlocs2_c1 = tlocs2;
          else
            tlocs1_c2 = tlocs1;
            tlocs2_c2 = tlocs2;
          end
          trialIndex_12 = trialIndex1(tlocs1); % should be same length as trialIndex1, trialIndex2
          if length(trialIndex_12)>0
            rfChoiceCode1 = Task1(k1,j1).ChosenTargetInRFCode(tlocs1);
            rfChoiceCode2 = Task2(k2,j2).ChosenTargetInRFCode(tlocs2);
            if refUnitIter==1
              inEitherRFlocs_12 = find((rfChoiceCode1==1&rfChoiceCode2==0));
            elseif refUnitIter==2
              inEitherRFlocs_12 = find((rfChoiceCode2==1&rfChoiceCode1==0));
            end
            inBothRFlocs_12 = find(rfChoiceCode1==1&rfChoiceCode2==1);
            inNeitherRFlocs_12 = find(rfChoiceCode1==0&rfChoiceCode2==0);

            trialIndex = [ trialIndex trialIndex_12 ];
            inEitherRFlocs = [ inEitherRFlocs totalAdded+inEitherRFlocs_12 ];
            inBothRFlocs = [ inBothRFlocs totalAdded+inBothRFlocs_12 ];
            inNeitherRFlocs = [ inNeitherRFlocs totalAdded+inNeitherRFlocs_12 ];
        
            totalAdded  = totalAdded + length(tlocs1);
          end
        end
        
        if ~(k1==k2 & j1==j2) % if units don't have same RF, reset these indexes
          k1 = k; j1 = j;
          k2 = k; j2 = j;
          if k1==1 k2 = 3; elseif k1==3 k2 = 1; end;
          if j1==1 j2 = 3; elseif j1==3 j2 = 1; end;
        end
        
    end
    
    if length(trialIndex)>0 & (isCenterOut | ...
                               (size(Task1,1)>=max(k1,k2) & size(Task1,2)>=max(j1,j2) & ...
                                size(Task2,1)>=max(k1,k2) & size(Task2,2)>=max(j1,j2)))

      Fields = AnalParams(k,j).Fields;
      for fid=1:length(Fields)
        FieldString = Fields{fid};
        slidingWindowLengths = AnalParams(k,j).slidingWindowLengths;
        slideInc = AnalParams(k,j).slidingWindowIncrement;
        bn = AnalParams(k,j).bn;
        centerVals = single([bn(1):slideInc:bn(2)]);
        
        
        Spike1 = [];
        Spike2 = [];
        if isCenterOut
          Spike1 = Task1(k,j).Field(fid).Spike(tlocs1);
          Spike2 = Task2(k,j).Field(fid).Spike(tlocs2);
        else % LRStask
          if length(tlocs1_c1)>0 & length(Task1(k1,j1).Field)>=fid & length(Task2(k2,j2).Field)>=fid
            Spike1 = [ Spike1 Task1(k1,j1).Field(fid).Spike(tlocs1_c1) ];
            Spike2 = [ Spike2 Task2(k2,j2).Field(fid).Spike(tlocs2_c1) ];
          end
          if length(tlocs1_c2)>0 & length(Task1(k2,j2).Field)>=fid & length(Task2(k1,j1).Field)>=fid
            Spike1 = [ Spike1 Task1(k2,j2).Field(fid).Spike(tlocs1_c2) ];
            Spike2 = [ Spike2 Task2(k1,j1).Field(fid).Spike(tlocs2_c2) ];
          end
        end        
      
        % Shuffle trials
        shufTrial1 = {Spike1{randperm(length(Spike1))}};
        shufTrial2 = {Spike2{randperm(length(Spike2))}};
      
        testData = calcSpikeDtVsRateDifference(Spike1,Spike2);
        trialShufData = calcSpikeDtVsRateDifference(shufTrial1,shufTrial2);
        
        Field(fid).Field = FieldString;
        Field(fid).bn = bn;
        
        for w=1:length(slidingWindowLengths)
          windowLen = slidingWindowLengths(w);          
          for b=1:length(centerVals)            
            for shufIter=1:2
              for filtIter=1:4
                tLocs = [1:length(Spike1)];
                if shufIter==1
                  data = testData;
                else
                  data = trialShufData;
                end
                switch filtIter
                    case 1
                    case 2
                      tLocs = tLocs(inEitherRFlocs);
                    case 3
                      tLocs = tLocs(inBothRFlocs);
                    case 4
                      tLocs = tLocs(inNeitherRFlocs);
                end
                data = data(find(ismember(data(:,1),tLocs)),:);
                ref1locs = find(data(:,2)==1);
                ref2locs = find(data(:,2)==2);            
                b1locs = find(data(ref1locs,3)>(centerVals(b)-windowLen/2)&...
                              data(ref1locs,3)<=(centerVals(b)+windowLen/2));
                b2locs = find(data(ref2locs,4)>(centerVals(b)-windowLen/2)&...
                              data(ref2locs,4)<=(centerVals(b)+windowLen/2));                      
                dt = [ abs(diff(data(ref1locs(b1locs),3:4),1,2)); ...
                       abs(diff(data(ref2locs(b2locs),3:4),1,2)) ];
                rateDiff = [ abs(diff(data(ref1locs(b1locs),5:6),1,2)); ...
                             abs(diff(data(ref2locs(b2locs),5:6),1,2)) ];
                dtVsRateDiff = int16(round([ rateDiff dt ]));
                if shufIter==1
                  switch filtIter
                    case 1
                      Field(fid).windowLength(w).bin(b).dtVsRateDiff_all = dtVsRateDiff;
                    case 2
                      Field(fid).windowLength(w).bin(b).dtVsRateDiff_inEitherRF = dtVsRateDiff;
                    case 3
                      Field(fid).windowLength(w).bin(b).dtVsRateDiff_inBothRF = dtVsRateDiff;
                    case 4
                      Field(fid).windowLength(w).bin(b).dtVsRateDiff_inNeitherRF = dtVsRateDiff;
                  end
                else
                  switch filtIter
                      case 1
                        Field(fid).windowLength(w).bin(b).dtVsRateDiff_all_shuf = dtVsRateDiff;
                      case 2
                        Field(fid).windowLength(w).bin(b).dtVsRateDiff_inEitherRF_shuf = dtVsRateDiff;
                      case 3
                        Field(fid).windowLength(w).bin(b).dtVsRateDiff_inBothRF_shuf = dtVsRateDiff;
                      case 4
                        Field(fid).windowLength(w).bin(b).dtVsRateDiff_inNeitherRF_shuf = dtVsRateDiff;
                  end
                end
              end
            end
          end          
        end
      end
      end % if length(trialIndex)>0
    end
    Task(k,j).Name = TaskName;
    Task(k,j).Task = TaskString;
    Task(k,j).Field = Field;
    Task(k,j).trialIndex = trialIndex;
  end
end

         TuningTask(m,n).TuningField(tfid).Task = Task;   
       end
    end
  end
end

DtVsRateDiff.Session1 = Session1;
DtVsRateDiff.Session2 = Session2;
DtVsRateDiff.TuningTask = TuningTask;
