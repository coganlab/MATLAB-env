function Data = procLaserAwakeEvents(day, rec)
%
%  Data = procLaserEvents(day, rec)
%

global MONKEYDIR 

olddir = pwd;
cd([MONKEYDIR '/' day])
Dir1 = dir([MONKEYDIR '/' day '/0*']);
Dir2 = dir([MONKEYDIR '/' day '/1*']);
Dir3 = dir([MONKEYDIR '/' day '/2*']);
tmp = [Dir1;Dir2;Dir3];
[recs{1:length(tmp)}] = deal(tmp.name);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
else
    num = rec;
end


for iRec = num(1):num(2)
    prenum = recs{iRec};
    disp(['Processing ' day ':' prenum]);
    cd([MONKEYDIR '/' day '/' prenum]);
    load([MONKEYDIR '/' day '/' prenum '/rec' prenum '.experiment.mat']);

    sample_rate = experiment.hardware.acquisition.samplingrate;

    % Figure out how to figure out events and how many
    fid = fopen(['rec' prenum '.display.dat']);
    laserData = fread(fid, 1.2e7, 'short'); %assumes no more than 10min recordings
    fclose(fid);
    
    pulseTimes = find(laserData(1:end-1) <= 2500 & laserData(2:end) > 2500);
    pulseTimes = pulseTimes + 1;
    
    burstTimes = find(pulseTimes(2:end) - pulseTimes(1:end-1) >= sample_rate);
    burstTimes = pulseTimes(burstTimes+1);
    burstTimes = [pulseTimes(1); burstTimes];
    
    pulseEnds = find(laserData(1:end-1) > 2500 & laserData(2:end) <=2500);
    pulseDur = (pulseEnds(1)-pulseTimes(1) + 1)/sample_rate;
    NumBursts = length(burstTimes);

    PulseDur = pulseDur*sample_rate;
    PulseFreq = round(length(pulseTimes)/NumBursts);
    
    tr = 0;
    Events.StartOn = zeros(NumBursts,1);      %  Time start on
    Events.End = zeros(NumBursts,1);      %  Time end
    Events.TargsOn = zeros(NumBursts,1);
    Events.Burst = zeros(NumBursts,1);
    Events.PulseDur = zeros(NumBursts,1);
    Events.PulseAmp = zeros(NumBursts,1);
    Events.PulseFreq = zeros(NumBursts,1);
    for iBurst = 1:NumBursts
        burstTime = burstTimes(iBurst);
        indPulseTimes = find(pulseTimes < burstTime + sample_rate & pulseTimes >= burstTime);
        pulseStarts = pulseTimes(indPulseTimes);
        %         for iPulse = 1:length(pulseStarts)
        %             tr = tr + 1;
        %             Events.StartOn(tr) = burstTime/sample_rate; %samples to s
        %             Events.End(tr) = (burstTime + sample_rate)/sample_rate; %samples to s
        %             Events.Burst(tr) = iBurst;
        %             Events.PulseStarts(tr) = pulseStarts(iPulse)/sample_rate;
        %             Events.PulseDur(tr) = PulseDur/sample_rate;
        %             Events.PulseAmp(tr) = 5; %careful--this is hardcoded.
        %             Events.PulseFreq(tr) = PulseFreq;
        %         end
        tr = tr + 1;
        Events.StartOn(tr) = round(burstTime/sample_rate*1e3); %samples to ms
        Events.TargsOn(tr) = round(burstTime/sample_rate*1e3); %samples to ms, same as StartOn
        Events.End(tr) = (burstTime + sample_rate)/sample_rate*1e3; %samples to ms
        Events.Burst(tr) = iBurst;
        Events.PulseStarts{tr} = pulseStarts/sample_rate*1e3; %samples to ms
        Events.PulseDur(tr) = PulseDur/sample_rate*1/3; %samples to ms
        Events.PulseAmp(tr) = 5; %careful--this is hardcoded.
        Events.PulseFreq(tr) = PulseFreq;
        
    end
    disp('Done loading data');
    
    %save this data
    disp('Saving Events file');
    save(['rec' recs{iRec} '.Events.mat'],'Events');

end


cd(olddir);
