function procField_Database(day)
%
%  procField_Database(day)
%
%  Appends Field Sessions to existing Field_Database.mat
%	based on Trials.mat and Movement_Database.mat
%
%  Works as part of procDay stream.

global MONKEYDIR

%fid = fopen([MONKEYDIR '/m/Field_Database.m'],'a');
%ind = length(loadField_Database)+1;

Session = loadField_Database;
ind = length(Session)+1;

TrialsFile = [MONKEYDIR '/' day '/mat/Trials.mat'];
MocapTrialsFile = [MONKEYDIR '/' day '/mat/MocapTrials.mat'];
if exist(TrialsFile,'file')
    load(TrialsFile)
elseif exist(MocapTrialsFile,'file')
    load(MocapTrialsFile)
    Trials = MocapTrials;
else
    disp('No Trials information')
    return
end
if(length(Trials) > 0)
    % recs = unique(getRec(Trials));
    recs =dayrecs(day);
else
    recs = {'001'};
end
load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
nTower = length(experiment.hardware.microdrive);
% For each system
for iTower = 1:nTower
    if isfield(experiment.hardware.microdrive(iTower),'nofield')
        fieldflag = 1 - experiment.hardware.microdrive(iTower).nofield;
    else
        fieldflag= 1;
    end
    if fieldflag
        sysString = ['''' experiment.hardware.microdrive(iTower).name ''''];
        nCh = length(experiment.hardware.microdrive(iTower).electrodes);
        
        recString = [];
        for r=1:length(recs)
            if r>1
                recString= [ recString ',' ];
            end
            recString = [ recString '''' recs{r} '''' ];
        end
        
        Depth = getDepth(Trials);
        for iCh = 1:nCh
            % I changed getDepth so that it always returns a numeric array--Ryan
            if iscell(Depth) %Ryans data gets cell from getDepth. If other people do as well this may not be backward comp.
                DepthMat = cell2mat(Depth(:,iTower));
                ChannelDepth = DepthMat(:,iCh);
                ChannelDepth = unique(ChannelDepth, 'rows');
            else
                ChannelDepth = mean(unique(Depth(:,iCh,iTower)));
            end
            tmp = experiment.hardware.microdrive(iTower).electrodes(iCh);
            try
                nContact = experiment.hardware.microdrive(iTower).electrodes(iCh).numContacts;
            catch
                %If nContact doesn't exist
                nContact = 1;
            end
            if length(ChannelDepth) == 1
                for iContact = 1:nContact
                    Session{ind} = {day,recs,{experiment.hardware.microdrive(iTower).name},{iCh,iContact},{[ChannelDepth,20]},ind};
                    Session{ind}{7} = MONKEYDIR;
                    Session{ind}{8} = {'Field'};
                    ind = ind+1;
                end
            else
                trialDepth = [Trials(1).Depth];
                trialDepth = cell2mat(trialDepth);
                trialDepths = [Trials.Depth];
                depthMat = cell2mat(trialDepths);
                depthMat = reshape(depthMat, length(trialDepth), length(depthMat)/length(trialDepth));
                chTotal = 0;
                for iTow = 1:iTower-1
                    prevCh = length(Trials(1).Depth{iTow});
                    chTotal = chTotal + prevCh;
                end
                chDepths = depthMat(iCh + chTotal,:);
                for iDepth = 1:length(ChannelDepth)
                    depth = ChannelDepth(iDepth);
                    depthIdx = find(chDepths == depth);
                    recList = unique({Trials(depthIdx).Rec});
                    for iContact = 1:nContact
                        Session{ind} = {day,recList,{experiment.hardware.microdrive(iTower).name},{iCh,iContact},{[depth,20]},ind};
                        Session{ind}{7} = MONKEYDIR;
                        Session{ind}{8} = {'Field'};
                        ind = ind+1;
                    end
                end
                    
            end
        end
    end
end

save([MONKEYDIR '/mat/Field_Session.mat'],'Session');
