duke;

Subject=[];


%filedir=['H:\Box Sync\CoganLab\ECoG_Task_Data\Cogan_Task_Data'];
Subject(23).Name='D23';  Subject(23).Day = '180718';
Subject(24).Name='D24';  Subject(24).Day = '181028';
Subject(26).Name='D26';  Subject(26).Day = '190128';
Subject(27).Name='D27';  Subject(27).Day = '190304';
Subject(28).Name='D28';  Subject(28).Day = '190302';
Subject(29).Name='D29';  Subject(29).Day = '190315'; Subject(29).File = 'D29 190315 Cogan_SternbergNeighborhood.edf'; Subject(29).Chans=[2:121 130:149];
Subject(30).Name='D30';  Subject(30).Day = '190413'; Subject(30).File = 'D30 Cogan_SternbergNeighborhood_Part1  190413.edf'; Subject(30).Chans=[2:63,66:107];
Subject(31).Name='D31';  Subject(31).Day = '190423'; Subject(31).File = 'D31 Cogan_SternbergNeighborhood 190423.edf'; Subject(31).Chans=[2:61,66:125,130:169];
Subject(33).Name='D33';  Subject(33).Day = '190603'; Subject(33).File = 'D33 Cogan_NeighborhoodSternberg_Part1 190603.edf'; Subject(33).Chans=[2:121 130:123 130:249];
Subject(34).Name='D34';  Subject(34).Day = '190730'; Subject(34).File = 'D34 Cogan_SternbergNeighborhood 193007.edf'; Subject(34).Chans=[2:63 66:185]; 
Subject(35).Name='D35';  Subject(35).Day = '190801'; Subject(35).File = 'D35 Cogan_SternbergNeighborhood 190801 .edf'; Subject(35).Chans=[2:55 66:123 130:191];
Subject(36).Name='D36';  Subject(36).Day = '190808'; Subject(36).File = 'D36 Cogan_SternbergNeighborhood.edf'; Subject(36).Chans=[2:63 66:111 130:237];
Subject(37).Name='D37';  Subject(37).Day = '190913'; Subject(37).File = 'D37 Cogan_SternbergNeighborhood  190913.edf'; Subject(37).Chans=[2:61,66:115,130:187,194:205];  
Subject(38).Name='D38';  Subject(38).Day = '190921'; Subject(38).File = 'D38 Cogan_SternbergNeighborhood 190921.edf'; Subject(38).Chans=[2:57,66:119,130:183,194:237]; 
Subject(39).Name='D39';  Subject(39).Day = '191011'; Subject(39).File = 'D39_Noise.edf'; Subject(39).Chans = [2:57,66:127,130:249];
SNList=[29,30,31,33,34,35,36,37,38,39];
%SNList=[35];

DUKEDIR = ['H:\Box Sync\CoganLab\D_Data\Neighborhood_Sternberg'];
for iSN=1:length(SNList);
    SN=SNList(iSN);
    [h d]=edfread([DUKEDIR '\' Subject(SN).Name '\' Subject(SN).File]);

    
    

%Subject(SN).Trials = dbTrials(Subject(SN).Name,Subject(SN).Day,'Speech_OvertMimeMove');


    Subject(29).Channel=[1:140];
    Subject(29).badChannels=[8,56,133,136,137,140];
    Subject(29).Channel=setdiff(Subject(29).Channel,Subject(29).badChannels);

    Subject(30).Channel=[1:104];
    Subject(30).badChannels=[12,13,19,36,37,80,82]; 
    Subject(30).Channel=setdiff(Subject(30).Channel,Subject(30).badChannels);    

    Subject(31).Channel=[1:160];
    Subject(31).badChannels=[9,17,67,68,40,117,148,149]; 
    Subject(31).Channel=setdiff(Subject(31).Channel,Subject(31).badChannels);       
    
    Subject(33).Channel=[1:240];
  %  AnalParams.badChannels=[39,100,101,102,104,175,184,188];
    Subject(33).badChannels=[37,38,39,40,100,101,102,104,105,175,183,184,185,188,222];
    Subject(33).Channel=setdiff(Subject(33).Channel,Subject(33).badChannels);       
    
    Subject(34).Channel=[1:182];
    Subject(34).badChannels=[40,41,45,100,174];
    Subject(34).Channel=setdiff(Subject(34).Channel,Subject(34).badChannels);       

    Subject(35).Channel=[1:174];
    Subject(35).badChannels= [2,8,10,26,37,38,39,40,54,79,80,81,82,142,143,155];
    Subject(35).Channel=setdiff(Subject(35).Channel,Subject(35).badChannels);   
%     Subject(35).Channel=[1:112]; % second box appears to be noisy
%     Subject(35).badChannels= [12,26,39,82];
%     Subject(35).Channel=setdiff(Subject(35).Channel,Subject(35).badChannels); 

    Subject(36).Channel=[1:216];
    Subject(36).badChannels=[8,30,62,101,104,151,152,153,173,187];
    Subject(36).Channel=setdiff(Subject(36).Channel,Subject(36).badChannels);        

    Subject(37).Channel=[1:180];
   % AnalParams.badChannels=[89,92,157,158];
    Subject(37).badChannels=[61,62,76,87,88,89,90,92,93,126,157,158,179,180];
    Subject(37).Channel=setdiff(Subject(37).Channel,Subject(37).badChannels);  

    Subject(38).Channel=[1:208];
    Subject(38).badChannels=[5,8,48,61,158,179,197];
    Subject(38).Channel=setdiff(Subject(38).Channel,Subject(38).badChannels); 

    Subject(39).Channel=[1:238];
    Subject(39).badChannels=[47,103,123:126,140:143];
    Subject(39).Channel=setdiff(Subject(39).Channel,Subject(39).badChannels); 
    


%d=d(Subject(SN).Chans(AnalParams.Channel),:);
d=d(Subject(SN).Chans,:);

dLength=floor(size(d,2)./3072);

dStep=1:3072:dLength*3072;

Subject(SN).ieeg=zeros(size(d,1),dLength-1,3072);
for iStep=1:dLength-1
    Subject(SN).ieeg(:,iStep,:)=d(:,dStep(iStep):dStep(iStep+1)-1);
end




fscale=[0:2048/3072:2047.99999];

    tmpFFT=zeros(size(d,1),dLength-1,3072);
    for iChan=1:size(d,1)
        tmpFFT(iChan,:,:)=(abs(fft(sq(Subject(SN).ieeg(iChan,:,:)),[],2))).^2;
    end
    Subject(SN).ieegFFT=sq(mean(tmpFFT,2));
    clear h d;
    Subject(SN).ieeg=[];
    display(['Subject D' num2str(SN)])
end

fTop=find(fscale<=200);
fTop=fTop(end);
figure;
for iSN=1:length(SNList);
    SN=SNList(iSN);
    subplot(1,10,iSN)
    %semilogy(fscale(1:fTop),Subject(SN).ieegFFT(:,1:fTop))
    semilogy(fscale(1:fTop),Subject(SN).ieegFFT(Subject(SN).Channel,1:fTop))
    title(Subject(SN).Name);
    ylim([10e2 10e10])
    xlim([0 fTop])
    ylabel('Power')
    xlabel('Frequency (Hz)')
end

ii60=find(fscale==60);

for iSN=1:length(SNList);
    SN=SNList(iSN);
   % power60(iSN)=mean(Subject(SN).ieegFFT(:,ii60));
    power60(iSN)=mean(Subject(SN).ieegFFT(Subject(SN).Channel,ii60));    
end
figure;plot(power60);

ii50=find(fscale==50);

for iSN=1:length(SNList);
    SN=SNList(iSN);
 %   power50(iSN)=mean(Subject(SN).ieegFFT(:,ii50));
    power50(iSN)=mean(Subject(SN).ieegFFT(Subject(SN).Channel,ii50));    
end
figure;
plot(power50);
    
