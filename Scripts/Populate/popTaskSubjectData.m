function Subject = popTaskSubjectData(Task)

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
    muscleChannelsPath = fullfile(TASK_DIR, Subject(iF).Name, 'muscleChannelsWavelet.mat');
    
    if exist(badChannelsPath, 'file')
        Subject(iF).badChannels = load(badChannelsPath);
    else
        Subject(iF).badChannels = [];
    end
    
    if exist(muscleChannelsPath, 'file')
        muscleChannels = load(muscleChannelsPath);
        Subject(iF).badChannels = [Subject(iF).badChannels muscleChannels.muscleChannel];
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

counterChan=0;
iElecS=0;
%SNList=1:length(Subject);
load([RECONDIR filesep 'missingRecons.mat']);
missRecIdx=ones(length(Subject),1);
counter=0;
for iSN=1:length(Subject)
    for iM=1:length(missingRecons)
        if strcmp(Subject(iSN).Name,['D' num2str(missingRecons(iM))]);
            missRecIdx(iSN)=0;
        end
    end
end

SNList=find(missRecIdx==1);

for iSN=1:length(SNList)
    clear elecIdx
    SN=SNList(iSN);
    load(fullfile(TASK_DIR, Subject(SN).Name, 'mat','experiment.mat'))
    rfiledir=[RECONDIR filesep Subject(SN).Name filesep 'elec_recon' filesep];
    if ~isfile([ rfiledir filesep Subject(SN).Name '_elec_locations_RAS.txt' ])
        warning(['Skipping subject ' Subject(SN).Name '\n%s Reason: ' ...
            'missing required files in ' rfiledir ])
        continue
    end
    elecs=list_electrodes(Subject(SN).Name);
    
    % load regular locations if seeg, brain shifted if grid
    if strcmp(Subject(SN).Type,'SEEG')  %|| strcmp(Subject(SN).Name,'D16')
        filename=[rfiledir Subject(SN).Name '_elec_location_radius_3mm_aparc+aseg.mgz.csv'];
        % filename=[rfiledir Subject(SN).Name '_elec_location_radius_3mm_aparc.a2009s+aseg.mgz.csv'];
        elecInfo = parse_RAS_file([rfiledir Subject(SN).Name '_elec_locations_RAS.txt']);
    elseif strcmp(Subject(SN).Type,'ECoG')
        filename=[rfiledir Subject(SN).Name '_elec_location_radius_3mm_aparc+aseg.mgz_brainshifted.csv'];
        %   filename=[rfiledir Subject(SN).Name '_elec_location_radius_3mm_aparc.a2009s+aseg.mgz_brainshifted.csv'];
        elecInfo = parse_RAS_file([rfiledir Subject(SN).Name '_elec_locations_RAS_brainshifted.txt']);
        
    end
    
    % read through the xls file
    %[NUM,TXT,RAW]=xlsread(filename);
    T=readtable(filename);
    TXT=T;
    NUM=table2array(T(:,[4,6,8,10]));
%     NUM=zeros(size(T,1),4);
%     iN_List=[4,6,8,10];
%     for iN=1:5
%         NUM(:,iN)=table2array(T(:,iN_List(iN)));
%     end
%     NUM=table2cell(T(:,[4,6,8,10]));

    %TXT=TXT(2:end,:);
    Tname=table2array(TXT(:,2));
    Trest=table2cell(TXT(:,1:2:size(TXT,2)));
    
    for iElec=1:length(elecs);
        for iElec2=1:size(TXT,1)
            if strcmp(elecs{iElec},(strcat(Subject(SN).Name,'-',Tname(iElec2,:))))
                elecIdx(iElec)=iElec2;
            end
        end
    end
    ii=find(elecIdx==0);
    elecIdx(ii)=[];
    TXT=TXT(elecIdx,:);
    NUM=NUM(elecIdx,:);
    Tname=Tname(elecIdx,:);
    Trest=Trest(elecIdx,:);
    % this can be adjusted! Looks for proportion that is white matter (less
    % than 0.67) and keeps it. Could be higher or lower
    for iElec=1:size(TXT,1)
        elec_nameT=strcat(Subject(SN).Name, '-',Tname(iElec,:));
        iN=1;
        
        while (contains(Trest(iElec,iN),'White-Matter'))  && iN<=7 && NUM(iElec,iN)<0.8
            %|| NUM(iElec,iN-2)<0.5
            iN=iN+1;
        end
        
%         while (contains(Trest(iElec,iN),'Unknown') || contains(Trest(iElec,iN),'unknown') || contains(Trest(iElec,iN),'hypointensities')   ) && NUM(iElec,iN)==1
%         subj_labels_loc(iElecS+iElec)='Unknown';
%         end
        
        while (contains(Trest(iElec,iN),'Unknown') || contains(Trest(iElec,iN),'unknown') || contains(Trest(iElec,iN),'hypointensities')   ) && NUM(iElec,iN)<1 && iN<=7
            %|| NUM(iElec,iN-2)<0.5
            iN=iN+1;
        end

        subj_labels2(iElecS+iElec)=elec_nameT;
        %
        subj_labels_loc(iElecS+iElec)=Trest(iElec,iN); % percentages
        %    subj_labels_loc{iElecS+iElec}=TXT(iElec+1,1); % first column
    end
    
    % writes labels and names to Subject file
    for iElec=1:length(experiment.channels)
        for iElec2=1:length(subj_labels2)
            if strcmp(subj_labels2{iElec2},[Subject(SN).Name '-' experiment.channels(iElec).name])
                Subject(SN).ChannelInfo(iElec).Name=subj_labels2{iElec2};
                Subject(SN).ChannelInfo(iElec).Location=subj_labels_loc{iElec2};
            end
        end
    end
    
    % locate white matter + no label electrodes?
    
    counter=0;
    for iChan=1:length(Subject(SN).ChannelInfo);
        if isempty(Subject(SN).ChannelInfo(iChan).Location) || contains(Subject(SN).ChannelInfo(iChan).Location, 'White-Matter') || contains(Subject(SN).ChannelInfo(iChan).Location, ' ')
            Subject(SN).WM(counter+1)=iChan;
            counter=counter+1;
        end
    end
    
    for iElec1=1:length(Subject(iSN).ChannelInfo)
        for iElec2=1:length(elecInfo.labels)
            if strcmp(Subject(iSN).ChannelInfo(iElec1).Name,[Subject(iSN).Name '-' elecInfo.labels{iElec2}])
                Subject(iSN).ChannelInfo(iElec1).xyz=elecInfo.xyz(iElec2,:);
            end
        end
    end
    
    Subject(iSN).Task=Task.Name;
end



