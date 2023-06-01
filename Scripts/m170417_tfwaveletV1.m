clear LSTrials;
counter=0;
for A=1:length(Trials)
    if Trials(A).StartCode>=5 && Trials(A).StartCode<=7
        LSTrials(counter+1)=A;
        counter=counter+1;
    end;
end;
CondParams.bn=[-2000 3000];
CondParams.Field='Auditory';
srate=2000;
ieeg=trialIEEG(Trials,AnalParams.Channel,CondParams.Field,CondParams.bn);
ieegN=ieeg./repmat(mean(ieeg,2),1,64,1);

chan=4;

FREQPAR.foi=2.^[1:1/4:8];
%FREQPAR.foi=2.^[1:1/8:5];
FREQPAR.bw = 0.5;
FREQPAR.stepsize=0.025;
%FREQPAR.win_centers=500:25:9500;
waveflag=0;
[WAVEPAR, spec] = tfwavelet(sq(ieegN(LSTrials,chan,:)), srate, FREQPAR, waveflag);

specM=sq(mean(abs(spec)));
specMN=specM./repmat(mean(specM(1:5,:),1),size(specM,1),1);
tscale=WAVEPAR.win_centers+CondParams.bn(1)./1e3*srate;


tscale=linspace(CondParams.bn(1),CondParams.bn(2),size(specMN,1));
%tscale=1:202;
figure;uimagesc(tscale,WAVEPAR.foi,(specMN'));
set(gca,'YDir','normal');
caxis([0.7 1.5])