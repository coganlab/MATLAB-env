tvals=linspace(-.5,2,length(3751:10000));
for iG=0:1;
    figure;
    for iChan=1:60;
        iChan2=iChan+iG*60;
        subplot(6,10,iChan);
        hold on
        plot(tvals,sq(mean(eegD(iChan2,3751:10000,stimLength==3).^2,3)));
        hold on
        plot(tvals,sq(mean(eegD(iChan2,3751:10000,stimLength==5).^2,3)));
        hold on
        plot(tvals,sq(mean(eegD(iChan2,3751:10000,stimLength==7).^2,3)));
        hold on
        plot(tvals,sq(mean(eegD(iChan2,3751:10000,stimLength==9).^2,3)));
        axis('tight')
    end
end


TAPERS=[2 2];
SAMPLING=fs;
DN=0.05;
FK1=[0 1200];
FK2=[0 200];
PAD=0.5;
cutoff=3;
FREQPAR=[];
FREQPAR.foi=2.^[1:1/8:10];
%FREQPAR.stepsize=.01;
FREQPAR.win_centers=[3750:125:(size(eegD,2)-3750)];
%eegSpec=zeros(124,34,3750);
%eegSpec=zeros(124,40,163);
eegSpecD={}; %zeros(124,224,71,49);
for iChan=1:124;
    eegTmp=sq(eegD(iChan,:,:));
  %  eegTmp=sq(eeg(iChan,:,:)-mean(eegD(iChan,:,:),3));

    [m s]=normfit(log(eegTmp(:).^2));
    [ii1 jj1]=find(log(eegTmp.^2)>cutoff*s+m);
%[SPEC, F] = tfspec(eegTmp(:,:)', TAPERS, SAMPLING, DN, FK1, PAD, [], 0, [], []);
%tmpSpec=reshape(sq(mean(SPEC(:,:,165:end),3)),size(SPEC,1)*size(SPEC,2),1);
%

   % trialBad{iChan}=unique(cat(1,jj1,jj2));
    trialBad{iChan}=unique(jj1);

    goodTrialsD{iChan}=setdiff(1:size(eegTmp,2),trialBad{iChan});
%[SPEC, F] = tfspec(eegTmp(:,goodTrials{iChan})', TAPERS, SAMPLING, DN, FK2, PAD, [], 0, [], []);

%[wave,period,scale,coi]=basewave5(eegTmp(:,goodTrials{iChan})',SAMPLING,1,200,5,0);
[WAVEPAR, spec] = tfwavelet(eegTmp(:,goodTrials{iChan})',2500,FREQPAR, []);
%wave2=wave(:,:,626:5000-625);
%eegSpec(iChan,:,:)=sq(mean(abs(wave2)));
eegSpecD{iChan}=spec;
%eegSpec(iChan,:,:)=SPEC;
display(iChan)
end


TAPERS=[2 2];
SAMPLING=fs;
DN=0.05;
FK1=[0 1200];
FK2=[0 200];
PAD=0.5;
cutoff=3;
FREQPAR=[];
FREQPAR.foi=2.^[1:1/8:10];
%FREQPAR.stepsize=.01;
FREQPAR.win_centers=[3750:125:(size(eegALL,2)-3750)];
%eegSpec=zeros(124,34,3750);
%eegSpec=zeros(124,40,163);
eegSpec={}; %zeros(124,224,71,49);
for iChan=1:124;
    eegTmp=sq(eegALL(iChan,:,:));
  %  eegTmp=sq(eeg(iChan,:,:)-mean(eegD(iChan,:,:),3));

    [m s]=normfit(log(eegTmp(:).^2));
    [ii1 jj1]=find(log(eegTmp.^2)>cutoff*s+m);
%[SPEC, F] = tfspec(eegTmp(:,:)', TAPERS, SAMPLING, DN, FK1, PAD, [], 0, [], []);
%tmpSpec=reshape(sq(mean(SPEC(:,:,165:end),3)),size(SPEC,1)*size(SPEC,2),1);
%

   % trialBad{iChan}=unique(cat(1,jj1,jj2));
    trialBad{iChan}=unique(jj1);

    goodTrialsA{iChan}=setdiff(1:size(eegTmp,2),trialBad{iChan});
%[SPEC, F] = tfspec(eegTmp(:,goodTrials{iChan})', TAPERS, SAMPLING, DN, FK2, PAD, [], 0, [], []);

%[wave,period,scale,coi]=basewave5(eegTmp(:,goodTrials{iChan})',SAMPLING,1,200,5,0);
[WAVEPAR, spec] = tfwavelet(eegTmp(:,goodTrials{iChan})',2500,FREQPAR, []);
%wave2=wave(:,:,626:5000-625);
%eegSpec(iChan,:,:)=sq(mean(abs(wave2)));
eegSpecA{iChan}=spec;
%eegSpec(iChan,:,:)=SPEC;
display(iChan)
end



for iG=0:1
    
    figure;
    for iChan=1:62;
        iChan2=iChan+iG*62;
        subplot(8,8,iChan);
       %iChan2=iChan+chanOff;
        idx=1:length(trialInfo);%find(stimLength==3);
        %    idxW=find(condVals<=2);
        %    idxWL{iCond}=intersect(idx,idxW);
      [c trialIdxD]=intersect(goodTrialsD{iChan2},idx);
      [c trialIdxA]=intersect(goodTrialsA{iChan2},idx);
      sig1=sq(abs(eegSpecD{iChan2}(trialIdxD,:,:)));
      sig1A=sq(abs(eegSpecA{iChan2}(trialIdxA,:,:)));

     % sig1B=sq(abs(eegSpec{iChan2}(trialIdx,:,:)));
          sig2=log(sq(mean(sig1(:,:,51:end),3)));
          [m s]=normfit(sig2(:));
          [iiOutI iiOutJ]=find(sig2>3*s+m);
           sig2A=log(sq(mean(sig1A(:,:,51:end),3)));
          [m s]=normfit(sig2A(:));
          [iiOutIA iiOutJA]=find(sig2A>3*s+m);
          
          trialInD=setdiff(1:length(trialIdxD),unique(iiOutI));
          trialInA=setdiff(1:length(trialIdxA),unique(iiOutIA));
%           trialIn2=intersect(find(condVals>=3),trialIn);
%           trialIn2B=intersect(find(condVals<=2),trialIn);

        %  trialIn2=intersect(find(condVals>=3),trialIn);
      %   tvimage(sq(mean(sig1(trialIn2,:,1:54)./mean(mean(sig1(trialIn,:,1:54)))))-sq(mean(sig1(trialIn2B,:,1:54)./mean(mean(sig1(trialIn,:,1:54))))),'XRange',[-.5 2]); 
         tvimage(sq(mean(sig1(trialInD,:,1:46))./mean(mean(sig1A(trialInA,1:10,1:46)))),'XRange',[-.5 2]);
       %tvimage(sq(mean(abs(eegSpec{iChan2}(trialIdx,:,:))./mean(mean(abs(eegSpec{iChan2}(trialIdx,1:10,:)))))));
    %  tvimage(sq(eegSpec(iChan2,:,:)./mean(eegSpec(iChan2,:,501:1250),3))');
     %  tvimage(sq(eegSpec(iChan2,:,1:83)./mean(eegSpec(iChan2,1:10,1:83),2)));
    %   tvimage(sq(eegSpec(iChan2,:,1:165)./mean(eegSpec(iChan2,1:10,1:165),2)));
  %     tvimage(sq(eegSpec(iChan2,:,1:82)./mean(eegSpec(iChan2,1:10,1:82),2)),'YRange',[0 100]);
% sigDALL=cat(1,sigDALL,mean(sig1(trialInD,:,1:46)));
% sigAALL=cat(1,sigAALL,mean(sig1A(trialInA,:,1:46)));
     caxis([0.9 1.1]);
    %  caxis([-0.2 .2]);
      
     %   axis('tight');
    end
end



for iG=0:1
    
    figure;
    for iChan=1:62;
        iChan2=iChan+iG*62;
        subplot(8,8,iChan);
       %iChan2=iChan+chanOff;
        idx=1:length(trialInfo); %find(stimLength==9);
        %    idxW=find(condVals<=2);
        %    idxWL{iCond}=intersect(idx,idxW);
      [c trialIdx]=intersect(goodTrials{iChan2},idx);
      sig1=sq(abs(eegSpecD{iChan2}(trialIdx,:,:)));
      sig1B=sq(abs(eegSpec{iChan2}(trialIdx,:,:)));
          sig2=log(sq(mean(sig1(:,:,51:end),3)));
          [m s]=normfit(sig2(:));
          [iiOutI iiOutJ]=find(sig2>3*s+m);
          trialIn=setdiff(1:length(trialIdx),unique(iiOutI));
          tvimage(sq(mean(sig1(trialIn,:,1:end)./mean(mean(sig1(trialIn,:,1:end))))));
         axis('tight')
       %tvimage(sq(mean(abs(eegSpec{iChan2}(trialIdx,:,:))./mean(mean(abs(eegSpec{iChan2}(trialIdx,1:10,:)))))));
    %  tvimage(sq(eegSpec(iChan2,:,:)./mean(eegSpec(iChan2,:,501:1250),3))');
     %  tvimage(sq(eegSpec(iChan2,:,1:83)./mean(eegSpec(iChan2,1:10,1:83),2)));
    %   tvimage(sq(eegSpec(iChan2,:,1:165)./mean(eegSpec(iChan2,1:10,1:165),2)));
  %     tvimage(sq(eegSpec(iChan2,:,1:82)./mean(eegSpec(iChan2,1:10,1:82),2)),'YRange',[0 100]);

      caxis([0.9 1.1]);
     %   axis('tight');
    end
end



for iG=0:1
    figure;
    for iChan=1:62;
        iChan2=iChan+iG*62;
        subplot(8,8,iChan);
      %  sig1=abs(eegSpec{iChan2})./mean(mean(abs(eegSpec{iChan2}(:,1:40,:))));
        sig1=abs(eegSpecD{iChan2});
        for iCond=[3,5,7,9];
%             idx=find(stimLength==iCond);
%             [c trialIdx]=intersect(goodTrials{iChan2},idx);
%             cCount(iCond)=length(trialIdx);

            idx=find(stimLength==iCond);
        %    idxW=find(condVals<=2);
        %    idxWL{iCond}=intersect(idx,idxW);
      [c trialIdx]=intersect(goodTrials{iChan2},idx);
      sig1=sq(abs(eegSpec{iChan2}(trialIdx,:,:)));
    %  sig1B=sq(abs(eegSpec{iChan2}(trialIdx,:,:)));
          sig2=log(sq(mean(sig1(:,:,51:end),3)));
          [m s]=normfit(sig2(:));
          [iiOutI iiOutJ]=find(sig2>3*s+m);
          trialIn=setdiff(1:length(trialIdx),unique(iiOutI));

            hold on;
    %        plot(WAVEPAR.foi(1:54),sq(mean(mean(sig1(trialIn,1:40,1:54)))));
           semilogy(sq(mean(mean(sig1(trialIn,11:end,1:54)./mean(sig1(trialIn,:,1:54),2)))))
        %   plot(sq(mean(mean(sig1(trialIn,:,20:25),1),3)./mean(mean(mean(sig1B(trialIn,:,20:25))))));
            
     %      errorbar(WAVEPAR.foi,sq(mean(mean(sig1(trialIdx,11:50,:)))),std(sq(mean(sig1(trialIdx,11:50,:),2)),[],1)./sqrt(length(trialIdx)));
            
            axis('tight')
        end
        
    end
end


for iG=0:1
    figure;
    for iChan=1:62;
        iChan2=iChan+iG*62;
        subplot(8,8,iChan);
      %  sig1=abs(eegSpec{iChan2})./mean(mean(abs(eegSpec{iChan2}(:,1:40,:))));
        sig1=abs(eegSpecD{iChan2});
        for iCond=[3,5,7,9];
        %for iCond=[1,2,3,4];
%             idx=find(stimLength==iCond);
%             [c trialIdx]=intersect(goodTrials{iChan2},idx);
%             cCount(iCond)=length(trialIdx);

            idx=find(stimLength==iCond);
        %    idx=find(condVals==iCond);
        %    idxW=find(condVals<=2);
        %    idxWL{iCond}=intersect(idx,idxW);
      [c trialIdx]=intersect(goodTrials{iChan2},idx);
      sig1=sq(abs(eegSpecD{iChan2}(trialIdx,:,:)));
   %   sig1B=sq(abs(eegSpec{iChan2}(trialIdx,:,:)));
          sig2=log(sq(mean(sig1(:,:,51:end),3)));
          [m s]=normfit(sig2(:));
          [iiOutI iiOutJ]=find(sig2>3*s+m);
          trialIn=setdiff(1:length(trialIdx),unique(iiOutI));
            hold on;
    %        plot(WAVEPAR.foi(1:54),sq(mean(mean(sig1(trialIn,1:40,1:54)))));
        %   semilogy(sq(mean(mean(sig1(trialIn,21:end,1:54)))./mean(mean(sig1(trialIn,:,1:54)))));
         %  plot(sq(mean(mean(sig1(trialIn,:,20:25),1),3)./mean(mean(mean(sig1B(trialIn,:,20:25))))));
            plot(sq(mean(mean(sig1(trialIn,11:end,18:24),1),3)));
     %      errorbar(WAVEPAR.foi,sq(mean(mean(sig1(trialIdx,11:50,:)))),std(sq(mean(sig1(trialIdx,11:50,:),2)),[],1)./sqrt(length(trialIdx)));
            
            axis('tight')
        end
        
    end
end

eegSpecDStim=zeros(124,4,51,73);
stimIdx=[3,5,7,9];
for iChan=1:124;
    for iStim=1:length(stimIdx);
        idx=find(stimLength==stimIdx(iStim));
        %    idx=find(condVals==iCond);
        %    idxW=find(condVals<=2);
        %    idxWL{iCond}=intersect(idx,idxW);
        [c trialIdx]=intersect(goodTrials{iChan2},idx);
        sig1=sq(abs(eegSpecD{iChan2}(trialIdx,:,:)));
        %   sig1B=sq(abs(eegSpec{iChan2}(trialIdx,:,:)));
        sig2=log(sq(mean(sig1(:,:,51:end),3)));
        [m s]=normfit(sig2(:));
        [iiOutI iiOutJ]=find(sig2>3*s+m);
        trialIn=setdiff(1:length(trialIdx),unique(iiOutI));
        eegSpecDStim(iChan,iStim,:,:)=mean(sig1(trialIn,:,:));
    end
end
    

eegSpecDCond=zeros(124,4,51,73);
condIdx=1:4;
for iChan=1:124;
    for iCond=1:length(condIdx);
        idx=find(condVals==condIdx(iCond));
        %    idx=find(condVals==iCond);
        %    idxW=find(condVals<=2);
        %    idxWL{iCond}=intersect(idx,idxW);
        [c trialIdx]=intersect(goodTrials{iChan2},idx);
        sig1=sq(abs(eegSpecD{iChan2}(trialIdx,:,:)));
        %   sig1B=sq(abs(eegSpec{iChan2}(trialIdx,:,:)));
        sig2=log(sq(mean(sig1(:,:,51:end),3)));
        [m s]=normfit(sig2(:));
        [iiOutI iiOutJ]=find(sig2>3*s+m);
        trialIn=setdiff(1:length(trialIdx),unique(iiOutI));
        eegSpecDCond(iChan,iCond,:,:)=mean(sig1(trialIn,:,:));
    end
end
