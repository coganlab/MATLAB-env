% NOTE: repeat words = 1; repeat non words = 2; decision words = 3;
% decision non words = 4;

sampIncrease=30000/2000;
%sampIncrease=30000/1000; % second number is sampling rate

for A=1:168
    triggerI(A)=trialInfo{A}.Trigger;
    timesE(A)=floor((trialInfo{A}.cueEnd-trialInfo{A}.cueStart).*2000);
end

trigsD=triggerI;
timesD=newtrigs4%(1:2:end);
%timesE=newtrigs4(2:2:end);
timesE=timesE+timesD;
Trials=[];
%timesD=testval_times2;
%trigsD=testval_dec2;
first=1:3:168*3; % last number should be equal to total amount of triggers in both triggers6 and triggers4B
second=first+1;
third=first+2;

for A=1:168 % last number should be equal to number of trials in block
    A2=A+0; %add number of trials from previous block
    Trials(A2).Start=round(timesD(A)*sampIncrease);
    Trials(A2).StartCode=trigsD(A);
   % Trials(A2).Auditory=round(timesE(A)*sampIncrease);
    Trials(A2).Auditory=round((timesD(A)*sampIncrease)+(trialInfo{A}.cueEnd-trialInfo{A}.cueStart)*30000);
    Trials(A2).AuditoryCode=trigsD(A)+25;
    Trials(A2).Del=round((timesD(A)*sampIncrease)+(trialInfo{A}.delStart-trialInfo{A}.cueStart)*30000);
    Trials(A2).DelCode=trigsD(A)+50;
    Trials(A2).Go=round((timesD(A)*sampIncrease)+(trialInfo{A}.goStart-trialInfo{A}.cueStart)*30000);
    Trials(A2).GoCode=trigsD(A)+75;
    Trials(A2).Subject='D10'; % make sure this is right!!
    Trials(A2).Trial=A2;
    Trials(A2).Day='200617'; % make sure this is right!!
    Trials(A2).Rec='001'; % make sure this is right!!
    Trials(A2).FilenamePrefix='D10_Lexical_200616';%  make sure this is right!!
    Trials(A2).Noisy=0;
    Trials(A2).NoResponse=0;
end


% test lines: These tell you if you've done it right!!!! Plot them and make
% sure they are right
for A=1:length(Trials)
    firsttest(A)=(Trials(A).Auditory-Trials(A).Start)./30000; % should be 0.5 s for mime, 1.5 for mm
    secondtest(A)=(Trials(A).Go-Trials(A).Auditory)./30000; % should be 2 s for mime, 1.5-2 for mm
    thirdtest(A)=Trials(A).AuditoryCode-Trials(A).StartCode; % should be 25
    fourthtest(A)=Trials(A).GoCode-Trials(A).AuditoryCode; % should be 25
end

if ~exist([DUKEDIR '/' Trials(1).Subject '/' Trials(1).Day '/mat'],'dir')
    mkdir([DUKEDIR '/' Trials(1).Subject '/' Trials(1).Day '/mat']);
end
save([DUKEDIR '/' Trials(end).Subject '/' Trials(end).Day '/mat/Trials.mat'], 'Trials') % Change last number per block
