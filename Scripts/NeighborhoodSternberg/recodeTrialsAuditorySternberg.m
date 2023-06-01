function Trials2 = recodeTrialsAuditorySternberg(Trials);
% Recodes Trials sructure to make all the FirstStimAuditory each separate
% auditory stim

counter1=0;
counter2=0;
Trials2=Trials;
for iTrials1=1:length(Trials);
%Trials2(counter2+1)=Trials(counter1+1);
for iS=1:length(Trials(counter1+1).StimAuditory)
Trials2(counter2+1)=Trials(counter1+1);
Trials2(counter2+1).FirstStimAuditory=Trials(counter1+1).StimAuditory(iS);
%Trials2(counter2+1).Item=iS;
%Trials2(counter2+1).ListLength=length(Trials(counter1+1).StimAuditory);
counter2=counter2+1;
end
counter1=counter1+1;
end