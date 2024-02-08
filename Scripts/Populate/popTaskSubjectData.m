function Subject = popTaskSubjectData(Task, options)
% Populates subject data for a given task, including channel and ROI information.
%
% Args:
%   Task (struct): Task information.
%   options (struct, optional): Options for the data population process.
%       - gmThresh (double): Grey matter threshold for assigning channels (default: 0.05).
%       - voxRadius (double): Voxel radius for ROI analysis (default: 10).
%
% Returns:
%   Subject (struct array): Populated subject data.
arguments
    Task
    options.gmThresh = 0.05;
    options.voxRadius = 10;
end

% make the box path global and make sure its set
global BOX_DIR
global RECONDIR


if ~isfield(Task,'Directory')
    Task.('Directory')=fullfile(BOX_DIR, 'CoganLab', 'D_Data', Task.Name);
end


TASK_DIR=Task.Directory;

%TASK_DIR=[BOX_DIR '/CoganLab/D_Data/' Task];
display(['Task = ' Task.Name]);
display(['Task Directory = ' TASK_DIR]);
if ~exist(TASK_DIR)
    display('Task Directory does not exist!')
end

% get directory/subject info from task_dir
fileDir=dir(TASK_DIR);
fileDir=fileDir(3:end);
counter=0;
fIdx=[];
for iF=1:length(fileDir);
    if fileDir(iF).isdir==1 && startsWith(fileDir(iF).name,'D')
        if ~isfolder([RECONDIR '/' fileDir(iF).name '/elec_recon/'])
            warning(['Skipping ' fileDir(iF).name ' due to nonexisten' ...
                't recon directory at ' RECONDIR])
            continue
        end
        fIdx(counter+1)=iF;
        counter=counter+1;
    end
end
fileDir=fileDir(fIdx);

% fill date and channel info from task dir
% Note: you should have a file in the subject directory called
% badChannels.mat which had your badchannel numbers listed
% for iF=1:length(fileDir)
%     if strcmp(lastSubjName,fileDir(iF).name)
%         lastSubj=iF;
%     end
% end
%fileDir=fileDir(1:lastSubj);

Subject=[];
for iF=1:length(fileDir)
    Subject(iF).Name=fileDir(iF).name;
    fileDir2=dir([TASK_DIR filesep fileDir(iF).name filesep]);
    fileDir2=fileDir2(3:end);
    
    counter=0;
    fIdx=[];
    for iF2=1:length(fileDir2);
        if fileDir2(iF2).isdir==1
            fIdx(counter+1)=iF2;
            counter=counter+1;
        end
    end
    fileDir2=fileDir2(fIdx);
    
    Subject(iF).Date=fileDir2(1).name;
    % get rec info
    fileDir3=dir([TASK_DIR filesep fileDir(iF).name filesep Subject(iF).Date]);
    fileDir3=fileDir3(3:end);
    counter=0;
    for iR=1:length(fileDir3)
        if strcmp(fileDir3(iR).name,['00' num2str(iR)])
            counter=counter+1;
        end
    end
    Subject(iF).NumofRecs=counter;
    
    % check to see if linefiltered
    load(fullfile(TASK_DIR, Subject(iF).Name, 'mat','experiment.mat'))
    Subject(iF).Experiment=experiment;
    for iR=1:Subject(iF).NumofRecs
        fileName=dir(fullfile(TASK_DIR, fileDir(iF).name, Subject(iF).Date, ['00' num2str(iR)], '*.dat'));
        for iR2=1:length(fileName)
            if contains(fileName(iR2).name,'clean')
                Subject(iF).Rec(iR).lineNoiseFiltered=1;
                Subject(iF).Rec(iR).fileNamePrefix=erase(fileName(iR2).name,'.cleanieeg.dat');
                break
            else
                Subject(iF).Rec(iR).lineNoiseFiltered=0;
                Subject(iF).Rec(iR).fileNamePrefix=erase(fileName(iR2).name,'.ieeg.dat');
            end
        end
    end
    
    for SN=1:length(Subject);
        % load trials file
        load(fullfile(TASK_DIR, Subject(SN).Name, Subject(SN).Date, 'mat','Trials.mat'))
        % save([TASK_DIR '/' Subject(SN).Name '/' Subject(SN).Date '/mat/Trials.mat'],'Trials')
        
        Subject(SN).Trials=Trials;
        load(fullfile(TASK_DIR, Subject(SN).Name, Subject(SN).Date, 'mat','trialInfo.mat'))
        Subject(SN).trialInfo=trialInfo;
    end
    
    Subject(iF).ChannelNums=1:length(experiment.channels);
    badChannelsPath = fullfile(TASK_DIR, Subject(iF).Name, 'badChannels.mat');
    muscleChannelsPath = fullfile(TASK_DIR, Subject(iF).Name, 'muscleChannelWavelet.mat');
    
    if exist(badChannelsPath, 'file')
        badChannels = load(badChannelsPath);
        Subject(iF).badChannels = badChannels.badChannels;
    else
        Subject(iF).badChannels = [];
    end
    
    if exist(muscleChannelsPath, 'file')
        
        muscleChannels = load(muscleChannelsPath);
        muscleChannels.muscleChannel;
        Subject(iF).badChannels = unique([Subject(iF).badChannels find(muscleChannels.muscleIds)']);
    end
    
    Subject(iF).goodChannels=setdiff(Subject(iF).ChannelNums,Subject(iF).badChannels);
end
% load the list of grid subjects
load(fullfile(BOX_DIR, 'CoganLab','D_Data','gList.mat'))

% populate type of electrode info
for iF=1:length(Subject);
    Subject(iF).Type='SEEG';
    for iG=1:length(gList);
        if strcmp(Subject(iF).Name,strcat('D',num2str(gList(iG))))
            Subject(iF).Type='ECoG';
        end
    end
end


% this will populate the channel information (name, location)
load([RECONDIR filesep 'missingRecons.mat']);
missRecIdx=ones(length(Subject),1);

for iSN=1:length(Subject)
    for iM=1:length(missingRecons)
        if strcmp(Subject(iSN).Name,['D' num2str(missingRecons(iM))]);
            missRecIdx(iSN)=0;
        end
    end
end

SNList=find(missRecIdx==1);

subjRoiInfo = extractRoiInformation(Subject(SNList),voxRad=options.voxRadius);

chanInfo = assignRoiInformation(subjRoiInfo, gmThresh=options.gmThresh);

for iSN = 1:length(SNList)
    
    SN=SNList(iSN);
    Subject(SN).Name
    chanInfoSubj = chanInfo(iSN).ChannelInfo;
    chanNameRoi = {chanInfoSubj.Name};
   % load(fullfile(TASK_DIR, Subject(SN).Name, 'mat','experiment.mat'))
    chanNameActual = strcat(Subject(SN).Name, '-', {Subject(SN).Experiment.channels.name});
    length(chanNameRoi)
    length(chanNameActual)
    chanInfoSubjAligned = [];
    wmId = [];
    for iChan = 1:length(chanNameActual)
        
        idTrue = ismember(chanNameRoi,chanNameActual(iChan));
        sum(idTrue)
        if(sum(idTrue))
            chanInfoSubjChan = chanInfoSubj(idTrue);
            chanInfoSubjAligned(iChan).Name=chanInfoSubjChan.Name;
            chanInfoSubjAligned(iChan).xyz=chanInfoSubjChan.xyz;
            chanInfoSubjAligned(iChan).Location=chanInfoSubjChan.Location;
            if(contains(chanInfoSubjAligned(iChan).Location,["White","hypointensities","known"]))
                wmId = [wmId iChan];
            end
        else
            continue
        end
    end
    
    Subject(SN).ChannelInfo = chanInfoSubjAligned;
    %wmIds = contains({chanInfoSubjAligned.Location},["White","hypointensities"]);
    Subject(SN).WM = wmId;
    Subject(SN).Task=Task.Name;    
end


   
end



