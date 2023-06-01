%filedir=['Z:\EEG_TestFiles\SBF\'];
filedir=['G:\Box\Box Sync\CoganLab\EEG\Data'];


SN=5;
filename{1}.subjdir=['\SBF_Test\BrainVisionRecorder\'];
filename{1}.captrackdir=['\SBF_Test\CapTrak\'];
% filename{1}.data=[filedir filename{1}.subjdir 'SBF_TwoBeeps_092018.eeg'];
% filename{1}.header=[filedir filename{1}.subjdir 'SBF_TwoBeeps_092018.vhdr'];
% filename{1}.marker=[filedir filename{1}.subjdir 'SBF_TwoBeeps_092018.vmrk'];
% filename{1}.data=[filedir filename{1}.subjdir 'SBF_CheckerboardContrastCombo_092018.eeg'];
% filename{1}.header=[filedir filename{1}.subjdir 'SBF_CheckerboardContrastCombo_092018.vhdr'];
% filename{1}.marker=[filedir filename{1}.subjdir 'SBF_CheckerboardContrastCombo_092018.vmrk'];
 filename{1}.data=[filedir filename{1}.subjdir 'SBF_Sternberg_Audio_Blocks_200918.eeg'];
 filename{1}.header=[filedir filename{1}.subjdir 'SBF_Sternberg_Audio_Blocks_200918.vhdr'];
 filename{1}.marker=[filedir filename{1}.subjdir 'SBF_Sternberg_Audio_Blocks_200918.vmrk'];
% filename{1}.captrack=[filedir filename{1}.captrackdir 'SBF_124Ch_200918.csv'];

filename{2}.subjdir=['\E1\BrainVisionRecorder\'];
filename{2}.captrackdir=['\E1\CapTrak\'];
%filename{2}.data=[filedir filename{2}.subjdir 'E1_TwoBeeps.eeg'];
%filename{2}.header=[filedir filename{2}.subjdir 'E1_TwoBeeps.vhdr'];
%filename{2}.marker=[filedir filename{2}.subjdir 'E1_TwoBeeps.vmrk'];
% filename{2}.data=[filedir filename{2}.subjdir 'E1_Checkboard.eeg'];
% filename{2}.header=[filedir filename{2}.subjdir 'E1_Checkboard.vhdr'];
% filename{2}.marker=[filedir filename{2}.subjdir 'E1_Checkboard.vmrk'];
filename{2}.data=[filedir filename{2}.subjdir 'E1_SternbergAudio_210918.eeg'];
filename{2}.header=[filedir filename{2}.subjdir 'E1_SternbergAudio_210918.vhdr'];
filename{2}.marker=[filedir filename{2}.subjdir 'E1_SternbergAudio_210918.vmrk'];
filename{2}.captrack=[filedir filename{2}.captrackdir 'E1_124Ch_210918.csv'];

filename{3}.subjdir=['\CPD_Test\BrainVision_Recorder\'];
filename{3}.captrackdir=['\CPD_Test\CapTrak\'];
filename{3}.data=[filedir filename{3}.subjdir 'CPD_SternbergAudio_4Blocks.eeg'];
filename{3}.header=[filedir filename{3}.subjdir 'CPD_SternbergAudio_4Blocks.vhdr'];
filename{3}.marker=[filedir filename{3}.subjdir 'CPD_SternbergAudio_4Blocks.vmrk'];
filename{3}.captrack=[filedir filename{3}.captrackdir 'CPD_124Ch.csv'];
% filename_data=['SBF_TwoBeeps_T2.eeg'];
% filename_header=['SBF_TwoBeeps_T2.vhdr'];
% filename_marker=['SBF_TwoBeeps_T2.vmrk'];
% filename_captrak=['SBF_EEGTesting\124_58cm.txt'];
filename{4}.subjdir=['\E2\BrainVision_Recorder\'];
filename{4}.captrackdir=['\E2\CapTrak\'];
filename{4}.data=[filedir filename{4}.subjdir 'E2_SternbergAudio.eeg'];
filename{4}.header=[filedir filename{4}.subjdir 'E2_SternbergAudio.vhdr'];
filename{4}.marker=[filedir filename{4}.subjdir 'E2_SternbergAudio.vmrk'];
%filename{4}.captrack=[filedir filename{3}.captrackdir 'CPD_124Ch.csv'];
filename{5}.subjdir=['\E3\BrainVision_Recorder\'];
filename{5}.captrackdir=['\E3\CapTrak\'];
filename{5}.data=[filedir filename{5}.subjdir 'E3_SternbergAudio_181018.eeg'];
filename{5}.header=[filedir filename{5}.subjdir 'E3_SternbergAudio_181018.vhdr'];
filename{5}.marker=[filedir filename{5}.subjdir 'E3_SternbergAudio_181018.vmrk'];
%filename{4}.captrack=[filedir filename{3}.captrackdir 'CPD_124Ch.csv'];
[eeg]=bva_loadeeg([filename{SN}.header]);
[fs label meta]=bva_readheader([filename{SN}.header]);
triggers=bva_readmarker([filename{SN}.marker]);
%captrak =    in_channel_brainvision([filename{SN}.captrack]);
%captrak=csvread([filename{1}.captrack]);
%triggers(2,:)=triggers(2,:)+1250; % 500 ms off?
%triggers=cat(2,triggers{1},triggers{2});
 triggerIdent=triggers(1,:);
 triggerTimes=triggers(2,:);

eogChan=eeg(125:128,:);
eeg=eeg(1:124,:);
eegCA=eeg-mean(eeg);
%eegCA_Filt=eegfilt(eegCA,2500,1,40);
% 
%   [eegTone1]=bva_epoch(eegCA,triggers,[1],-2000,2000,fs);
%   [eegTone2]=bva_epoch(eegCA,triggers,[2],-2000,2000,fs);
%   eegALL=cat(3,eegTone1,eegTone2);
 
[eeg101]=bva_epoch(eegCA,triggers,[101],-2000,2000,fs);
[eeg102]=bva_epoch(eegCA,triggers,[102],-2000,2000,fs);
[eeg103]=bva_epoch(eegCA,triggers,[103],-2000,2000,fs);
[eeg104]=bva_epoch(eegCA,triggers,[104],-2000,2000,fs);
%  [eegD]=bva_epoch(eegCA,delay,[1],-2000,3500,fs);
[eegP]=bva_epoch(eegCA,triggers,[152],-3500,3500,fs);
[eegD]=bva_epoch(eegCA,triggers,[151],-2000,3500,fs);
eegALL=cat(3,eeg101,eeg102,eeg103,eeg104);
%
%   [eeg101]=bva_epoch(eeg,triggers,[101],-750,1750,fs);
%   [eeg102]=bva_epoch(eeg,triggers,[102],-750,1750,fs);
%   [eeg103]=bva_epoch(eeg,triggers,[103],-750,1750,fs);
%   [eeg104]=bva_epoch(eeg,triggers,[104],-750,1750,fs);
% eegALL2=cat(3,eeg101,eeg102,eeg103,eeg104);
% [eeg1]=bva_epoch(eegCA,triggers,[1],-750,1250,fs);
% [eeg2]=bva_epoch(eegCA,triggers,[2],-750,1250,fs);
% [eeg3]=bva_epoch(eegCA,triggers,[3],-750,1250,fs);
% [eeg4]=bva_epoch(eegCA,triggers,[4],-750,1250,fs);
% eegALL=cat(3,eeg1,eeg2,eeg3,eeg4);

%tscale=linspace(-750,1750,size(eegALL,2));
tscale=linspace(-750,1250,size(eegALL,2));

for iG=0:1
    
    figure;
    for iChan=1:62;
        iChan2=iChan+iG*62;
        subplot(7,10,iChan);
       %iChan2=iChan+chanOff;
       sig1=sq(eegALL(iChan2,:,:));
       
        plot(tscale,mean(sig1-mean(sig1(1:1875,:)),2));
    %    plot(mean(sig1-mean(sig1(1:1875,:)),2));
        axis('tight');
    end
end

TAPERS=[0.5 10];
SAMPLING=fs;
DN=0.05;
FK1=[0 1200];
FK2=[0 200];
PAD=1;
cutoff=3;
FREQPAR=[];
FREQPAR.foi=2.^[1:1/8:7];
%FREQPAR.stepsize=.01;
FREQPAR.win_centers=[3750:125:(size(eegALL,2)-3750)];
%eegSpec=zeros(124,34,3750);
%eegSpec=zeros(124,40,163);
eegSpec=zeros(124,51,49);
for iChan=1:124;
    eegTmp=sq(eegALL(iChan,:,:));
    [m s]=normfit(log(eegTmp(:).^2));
    [ii1 jj1]=find(log(eegTmp.^2)>cutoff*s+m);
%[SPEC, F] = tfspec(eegTmp(:,:)', TAPERS, SAMPLING, DN, FK1, PAD, [], 0, [], []);
%tmpSpec=reshape(sq(mean(SPEC(:,:,165:end),3)),size(SPEC,1)*size(SPEC,2),1);
%

   % trialBad{iChan}=unique(cat(1,jj1,jj2));
    trialBad{iChan}=unique(jj1);

    goodTrials{iChan}=setdiff(1:size(eegTmp,2),trialBad{iChan});
%[SPEC, F] = tfspec(eegTmp(:,goodTrials{iChan})', TAPERS, SAMPLING, DN, FK2, PAD, [], 1, [], []);

%[wave,period,scale,coi]=basewave5(eegTmp(:,goodTrials{iChan})',SAMPLING,1,100,5,0);
[WAVEPAR, spec] = tfwavelet(eegTmp(:,goodTrials{iChan})',2500,FREQPAR, []);
%wave2=wave(:,:,626:5000-625);
%eegSpec(iChan,:,:)=sq(mean(abs(wave2)));
eegSpec(iChan,:,:)=sq(mean(abs(spec)));
%eegSpec(iChan,:,:)=SPEC;
display(iChan)
end


for iG=0:1
    
    figure;
    for iChan=1:62;
        iChan2=iChan+iG*62;
        subplot(8,8,iChan);
       %iChan2=iChan+chanOff;
       tvimage(sq(eegSpec(iChan2,:,:)./mean(eegSpec(iChan2,:,:),2)));
    %  tvimage(sq(eegSpec(iChan2,:,:)./mean(eegSpec(iChan2,:,501:1250),3))');
     %  tvimage(sq(eegSpec(iChan2,:,1:83)./mean(eegSpec(iChan2,1:10,1:83),2)));
    %   tvimage(sq(eegSpec(iChan2,:,1:165)./mean(eegSpec(iChan2,1:10,1:165),2)));
  %     tvimage(sq(eegSpec(iChan2,:,1:82)./mean(eegSpec(iChan2,1:10,1:82),2)),'YRange',[0 100]);

      caxis([0.8 1.1]);
     %   axis('tight');
    end
end


tscale=linspace(-750,1750,size(eegALL,2));
for iG=0:1
    
    figure;
    for iChan=1:60;
        iChan2=iChan+iG*60;
        subplot(6,10,iChan);
       %iChan2=iChan+chanOff;
        plot(tscale,sq(mean(eegALL(iChan2,:,goodTrials{iChan2}),3)));
        axis('tight');
    end
end

