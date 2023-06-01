sig=d1(:,t2range);
totTime=floor(size(sig,2)./2048);
totWin=(totTime-1)*2+1;
%winVal(1)=1:2048;
winVal=zeros(totWin,2048);
counter=0;
for iW=1:totWin
    winVal(iW,:)=counter+1:counter+2048;
    counter=counter+1024;
end
hannWin=hann(2048);

d1chanFFT=zeros(size(sig,1),2048);
for iChan=1:size(sig,1)
    d1chan=sig(iChan,:);
    d1chanWin=d1chan(winVal);
    d1chanWinHann=hannWin'.*d1chanWin;
    d1chanWinHannFFT=abs(fft(d1chanWinHann'));
    d1chanFFT(iChan,:)=mean(d1chanWinHannFFT,2);
end
  