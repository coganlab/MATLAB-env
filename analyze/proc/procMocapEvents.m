function procMocapEvents(day, recs)
%
%  procMocapEvents(day, recs)
%
%  Processes task events for nascent Mocap data acquisition 12/2011
%
%  Based on touching the touchscreen to denote reach time.

global MONKEYDIR

%day = '111205'; rec = '006';

if nargin < 2 recs = dayrecs(day); end
if ischar(recs) recs = {recs}; end

TOUCHDURATION = 300;
TRIALDURATION = 2e3;

for iRec = 1:length(recs)
    clear MocapEvents
    MocapEvents.Success = [];
    MocapEvents.StartOn = [];
    MocapEvents.End = [];
    cd(MONKEYDIR)
    rec = recs{iRec};
    cd(day); cd(rec);
    disp(['Recording ' rec '. ' num2str(iRec) ' of ' num2str(length(recs))]);
    
    % Calculating touch by handler
    fid = fopen(['rec' rec '.hnd.dat']);
    data = fread(fid,[2,inf],'ushort');
    
    th = zeros(1,size(data,2));
    th(data(2,:)>3e3) = 1;
    dth = diff(medfilt1(th,100));
    trialind = find(dth>0);
    
    dur = diff(trialind);
    nTrial = length(trialind);
    for iTrial = 1:nTrial-1
        if dur(iTrial) <TOUCHDURATION trialind(iTrial+1) = 0; end
    end
    trialind = trialind(trialind>0);
    dur = diff(trialind);
    
    StartOn = trialind' - TRIALDURATION;
    StartOn(StartOn<0)=1;
    MocapEvents.StartOn = StartOn;
    MocapEvents.End = trialind';
    MocapEvents.Success = ones(1,length(trialind))';
    MocapEvents.Trial = [1:length(trialind)];
    
    save([MONKEYDIR '/' day '/' rec '/rec' rec '.MocapEvents.mat'],'MocapEvents');
end

