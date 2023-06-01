file_dir='C:\Users\gbc8\Google Drive\Data\Micro\S1\2018-03-08_15-04-36_003';

load(['C:\Users\gbc8\Google Drive\Data\Micro\ChanMap.mat'])
load(['C:\Users\gbc8\Google Drive\Data\Micro\ChanMapQ.mat'])

fftMat=zeros(16,16,5120);
fscale=[0:5120/20000:19999.99999];
for iChan1=1:16
    for iChan2=1:16
        if chanMap(iChan1,iChan2)>0
            tmp=load_open_ephys_data([file_dir '/100_CH' num2str(chanMap(iChan1,iChan2)) '.continuous']);
            fftMat(iChan1,iChan2,:)=abs(fft(tmp,5120));
        end
    end
end


counter=zeros(4,1);
fftHeadStage=zeros(4,61,5120);
for iChan1=1:16
    for iChan2=1:16
        if chanMapQ(iChan1,iChan2)>0
            idx=chanMapQ(iChan1,iChan2);
            fftHeadStage(idx,counter(idx)+1,:)=fftMat(iChan1,iChan2,:);
            counter(idx)=counter(idx)+1;
        end
    end
end


figure;
errorbar(fscale(1:800),sq(mean(log(fftHeadStage(1,:,1:800)),2)),std(sq(log(fftHeadStage(1,:,1:800))),[],1)./sqrt(61),'b');
hold on;
errorbar(fscale(1:800),sq(mean(log(fftHeadStage(2,:,1:800)),2)),std(sq(log(fftHeadStage(2,:,1:800))),[],1)./sqrt(61),'r');
hold on;
errorbar(fscale(1:800),sq(mean(log(fftHeadStage(3,:,1:800)),2)),std(sq(log(fftHeadStage(3,:,1:800))),[],1)./sqrt(61),'g');
hold on;
errorbar(fscale(1:800),sq(mean(log(fftHeadStage(4,:,1:800)),2)),std(sq(log(fftHeadStage(4,:,1:800))),[],1)./sqrt(61),'m');
title('Old 5120 Way')
  

% moving average


nFFT=5120;
fftMat=zeros(16,16,5120);
fscale=[0:nFFT/20000:19999.99999];
for iChan1=1:16
    for iChan2=1:16
        if chanMap(iChan1,iChan2)>0
            tmp=load_open_ephys_data([file_dir '/100_CH' num2str(chanMap(iChan1,iChan2)) '.continuous']);
            winLength=floor(length(tmp)./(nFFT/2));
            counter=0;
            fftTmp=zeros(winLength-1,nFFT);
            for iW=1:winLength-1
                fftTmp(iW,:)=abs(fft(tmp(counter*0.5*nFFT+1:counter*0.5*nFFT+nFFT),nFFT));
                counter=counter+1;
            end
            fftMat(iChan1,iChan2,:)=mean(fftTmp);
            clear fftTmp
        end
    end
end

counter=zeros(4,1);
fftHeadStage=zeros(4,61,nFFT);
for iChan1=1:16
    for iChan2=1:16
        if chanMapQ(iChan1,iChan2)>0
            idx=chanMapQ(iChan1,iChan2);
            fftHeadStage(idx,counter(idx)+1,:)=fftMat(iChan1,iChan2,:);
            counter(idx)=counter(idx)+1;
        end
    end
end


figure;
errorbar(fscale(1:800),sq(mean(log(fftHeadStage(1,:,1:800)),2)),std(sq(log(fftHeadStage(1,:,1:800))),[],1)./sqrt(61),'b');
hold on;
errorbar(fscale(1:800),sq(mean(log(fftHeadStage(2,:,1:800)),2)),std(sq(log(fftHeadStage(2,:,1:800))),[],1)./sqrt(61),'r');
hold on;
errorbar(fscale(1:800),sq(mean(log(fftHeadStage(3,:,1:800)),2)),std(sq(log(fftHeadStage(3,:,1:800))),[],1)./sqrt(61),'g');
hold on;
errorbar(fscale(1:800),sq(mean(log(fftHeadStage(4,:,1:800)),2)),std(sq(log(fftHeadStage(4,:,1:800))),[],1)./sqrt(61),'m');
title('New Moving Average Way')




% bandpass?
srate=20000;
nyq = srate/2;
filtorder=500;
m=[0 0 1 1 0 0];
f=[70 150];
f2=[0 (f(1)-2)/nyq f(1)/nyq f(2)/nyq (f(2)+2)/nyq 1] ;
filtery=firls(filtorder,f2,m);
fftMat=zeros(16,16);
for iChan1=1:16
    for iChan2=1:16
        if chanMap(iChan1,iChan2)>0
            tmp=load_open_ephys_data([file_dir '/100_CH' num2str(chanMap(iChan1,iChan2)) '.continuous']);
            tmp2=filtfilt(filtery,1,tmp);
            fftMat(iChan1,iChan2)=mean(sqrt(tmp2.^2));
        end
    end
end


