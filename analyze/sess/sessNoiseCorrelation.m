function [ NoiseCorr ] = sessNoiseCorrelation(Session1,Session2,CondParams,AnalParams);

%  sessNoiseCorrelation(SESSION1,SESSION2,CONDPARAMS,ANALPARAMS);
%  
%  Calculate pairwise noise correlation for units specified
%  by Session1 and Session2. 
%  
%  SESSION1 = Metadata for unit 1.
%  SESSION2 = Metadata for unit 2.
%  CONDPARAMS = Task/Field conditions to analyze.
%  ANALPARAMS = Analysis parameters.

NoiseCorr = [];

Day1 = sessDay(Session1);
Sys1 = sessTower(Session1);
Ch1 = sessElectrode(Session1);
Contact1 = sessContact(Session1);
Cl1 = sessCell(Session1);

Day2 = sessDay(Session2);  
Sys2 = sessTower(Session2);
Ch2 = sessElectrode(Session2);
Contact2 = sessContact(Session2);
Cl2 = sessCell(Session2);

if ~isequal(Day1,Day2)
  error('sessNoiseCorrelation: Unable to compare units from different days.');
  return;
end

AllTrials = dbdatabase(Day1);
Sess1 = Session1;
Sess2 = Session2;
Sess1{1} = AllTrials
Sess2{1} = AllTrials;

Task = [];
for m=1:size(CondParams,1)
  for n=1:size(CondParams,2)
    Fields = AnalParams(m,n).Fields;
    bn = AnalParams(m,n).bn;
    wlen = 1e3*AnalParams(m,n).wlen;
    dn = 1e3*AnalParams(m,n).dn;
    nPerm = AnalParams(m,n).nPerm;
    scaleFactor = AnalParams(m,n).scaleFactor;

    Trials1 = Params2Trials(Sess1,CondParams(m,n));
    Trials2 = Params2Trials(Sess2,CondParams(m,n));
    Target1 = [ Trials1.Target ];
    Target2 = [ Trials2.Target ];
    Trial1 = [ Trials1.Trial ];
    Trial2 = [ Trials2.Trial ];
    StartOn1 = [ Trials1.StartOn ];
    StartOn2 = [ Trials2.StartOn ];
    
    ind1 = find(ismember([Trial1' Target1' StartOn1'],[Trial2' Target2' StartOn2'],'rows'));
    ind2 = find(ismember([Trial2' Target2' StartOn2'],[Trial1' Target1' StartOn1'],'rows'));

    sampleTotal = zeros(8,1);
    
    for fid=1:numel(Fields)
      Field = Fields{fid};
      
      noiseCorr = zeros(numel(wlen),8,ceil(diff(bn)/dn)+1);
      noiseCorr_shuf = noiseCorr;
      p = noiseCorr;

      % 121102
      noiseCorrAll = zeros(numel(wlen),ceil(diff(bn)/dn)+1);
      noiseCorrAll_shuf = noiseCorrAll;
      pAll = noiseCorrAll;
      
      for w=1:numel(wlen)
        sp1 = trialSpike(Trials1(ind1), Sys1, Ch1, Contact1, Cl1, Field,[bn(1)-wlen(w)/2,bn(2)+wlen(w)/2]);
        sp2 = trialSpike(Trials2(ind2), Sys2, Ch2, Contact2, Cl2, Field,[bn(1)-wlen(w)/2,bn(2)+wlen(w)/2]);
        
        % 121102
        sp1TotalAll = [];
        sp2TotalAll = [];
        
        
        for targetID=1:8
          tInd1 = find(Target1(ind1)==targetID);
          tInd2 = find(Target2(ind2)==targetID);          
          
          sampleTotal(targetID) = numel(tInd1);
          
          sp1Total = zeros(numel(tInd1),size(noiseCorr,3));
          sp2Total = sp1Total;
          for k=1:numel(tInd1)
            spEvents1 = sp1{tInd1(k)}+(bn(1)-wlen(w)/2);
            for e=1:numel(spEvents1)
              sp1TrialBn = find(spEvents1(e)>=[(bn(1)-wlen(w)/2):dn:(bn(2)-wlen(w)/2)]&...
                                spEvents1(e)< [(bn(1)+wlen(w)/2):dn:(bn(2)+wlen(w)/2)]);
              sp1Total(k,sp1TrialBn) = sp1Total(k,sp1TrialBn) + 1;
            end
            spEvents2 = sp2{tInd2(k)}+(bn(1)-wlen(w)/2);
            for e=1:numel(spEvents2)
              sp2TrialBn = find(spEvents2(e)>=[(bn(1)-wlen(w)/2):dn:(bn(2)-wlen(w)/2)]&...
                                spEvents2(e)< [(bn(1)+wlen(w)/2):dn:(bn(2)+wlen(w)/2)]);
              sp2Total(k,sp2TrialBn) = sp2Total(k,sp2TrialBn) + 1;
            end
          end % for k=1:numel(ind1)
         
          % 121102
          sp1TotalAll = [ sp1TotalAll; (sp1Total-repmat(mean(sp1Total,1),size(sp1Total,1),1))./(repmat(std(sp1Total,0,1),size(sp1Total,1),1)+eps) ];
          sp2TotalAll = [ sp2TotalAll; (sp2Total-repmat(mean(sp2Total,1),size(sp2Total,1),1))./(repmat(std(sp2Total,0,1),size(sp2Total,1),1)+eps) ];
          
          trueCorr = zeros(1,size(sp1Total,2));
          shufCorr = trueCorr;
          p_shuf = trueCorr;
          
          permInd1 = ceil(numel(tInd1)*rand(numel(tInd1),nPerm));
          permInd2 = ceil(numel(tInd2)*rand(numel(tInd2),nPerm));
                    
          parfor t=1:size(sp1Total,2)
            c = corrcoef(sp1Total(:,t),sp2Total(:,t));
            if ~isnan(c(1,2))
              trueCorr(t) = c(1,2);
            end
            shufCorrT = zeros(nPerm,1);
            p_temp = zeros(nPerm,1);
            for r=1:nPerm
              c = corrcoef(sp1Total(permInd1(:,r),t),sp2Total(permInd2(:,r),t));
              if ~isnan(c(1,2))
                shufCorrT(r) = c(1,2);
              end
              p_temp(r) = single(shufCorrT(r)>trueCorr(t));
            end
            p_shuf(t) = sum(p_temp)/nPerm;
            shufCorr(t) = mean(shufCorrT);
          end
          
          noiseCorr(w,targetID,:) = trueCorr;
          noiseCorr_shuf(w,targetID,:) = shufCorr;
          p(w,targetID,:) = p_shuf;
          
        end % for targetID=1:8
        
        % 121102
        trueCorr = zeros(1,size(sp1TotalAll,2));
        shufCorr = trueCorr;
        p_shuf = trueCorr;
        permInd1 = ceil(size(sp1TotalAll,1)*rand(size(sp1TotalAll,1),nPerm));
        permInd2 = ceil(size(sp2TotalAll,1)*rand(size(sp2TotalAll,1),nPerm));
        parfor t=1:size(sp1TotalAll,2)
          c = corrcoef(sp1TotalAll(:,t),sp2TotalAll(:,t));
          if ~isnan(c(1,2))
            trueCorr(t) = c(1,2);
          end
          shufCorrT = zeros(nPerm,1);
          p_temp = zeros(nPerm,1);
          for r=1:nPerm
            c = corrcoef(sp1TotalAll(permInd1(:,r),t),sp2TotalAll(permInd2(:,r),t));
            if ~isnan(c(1,2))
              shufCorrT(r) = c(1,2);
             end
            p_temp(r) = single(shufCorrT(r)>trueCorr(t));
          end
          p_shuf(t) = sum(p_temp)/nPerm;
          shufCorr(t) = mean(shufCorrT);
        end
        noiseCorrAll(w,:) = trueCorr;
        noiseCorrAll_shuf(w,:) = shufCorr;
        pAll(w,:) = p_shuf;
        
      end %  for w=1:numel(wlen)
        
      Task(m,n).sampleTotal = uint16(sampleTotal);
      Task(m,n).Field(fid).noiseCorr = int16(noiseCorr*scaleFactor);
      Task(m,n).Field(fid).noiseCorr_shuf = int16(noiseCorr_shuf*scaleFactor);
      Task(m,n).Field(fid).p = int16(p*scaleFactor);

      Task(m,n).Field(fid).noiseCorr_all = int16(noiseCorrAll*scaleFactor);
      Task(m,n).Field(fid).noiseCorr_all_shuf = int16(noiseCorrAll_shuf*scaleFactor);
      Task(m,n).Field(fid).p_all = int16(pAll*scaleFactor);
      
    end % for fid=1:numel(Fields)
  end % for n=1:size(CondParams,2)
end % for m=1:size(CondParams,1)


NoiseCorr.Session1 = Session1;
NoiseCorr.Session2 = Session2;
NoiseCorr.Task = Task;
NoiseCorr.scaleFactor = scaleFactor;

