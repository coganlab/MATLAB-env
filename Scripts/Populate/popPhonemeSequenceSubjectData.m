function Subject = popPhonemeSequenceSubjectData
% this will populate info about the phoneme sequencing task.  Might make it
% global later....

% make the box path global and make sure its set
global BOX_DIR
global RECONDIR
TASK_DIR=[BOX_DIR '/CoganLab/D_Data/Phoneme_Sequencing']

% get directory/subject info from task_dir
fileDir=dir(TASK_DIR);
fileDir=fileDir(3:end);
counter=0;
fIdx=[];
for iF=1:length(fileDir);
    if fileDir(iF).isdir==1 && startsWith(fileDir(iF).name,'D')
        fIdx(counter+1)=iF;
        counter=counter+1;
    end
end
fileDir=fileDir(fIdx);

% fill date and channel info from task dir
% Note: you should have a file in the subject directory called
% BadChannels.mat which had your badchannel numbers listed
Subject=[];
for iF=1:length(fileDir)
    Subject(iF).Name=fileDir(iF).name;
    fileDir2=dir([TASK_DIR '\' fileDir(iF).name '\']);
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
   
    load([TASK_DIR '/' Subject(iF).Name '/mat/experiment.mat'])

    Subject(iF).ChannelNums=1:length(experiment.channels);
    if exist([TASK_DIR '/' Subject(iF).Name '/BadChannels.mat'])
        load([TASK_DIR '/' Subject(iF).Name '/BadChannels.mat']);
        Subject(iF).BadChannels=BadChannels;
    else
        Subject(iF).BadChannels=[];
    end
    
end
% load the list of grid subjects
load([BOX_DIR '/CoganLab/D_Data/gList.mat'])

% populate type of electrode info
for iF=1:length(Subject);
    for iG=1:length(gList);
    if strcmp(Subject(iF).Name,strcat('D',num2str(gList(iG))))
        Subject(iF).Type='ECoG';
    else
        Subject(iF).Type='SEEG';
    end
    end
end


% this will populate the channel information (name, location)

counterChan=0;
iElecS=0;
%SNList=1:length(Subject);
load([RECONDIR '/missingRecons.mat']);
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

for iSN=1:length(SNList);
    SN=SNList(iSN);
   load([TASK_DIR '/' Subject(SN).Name '/mat/experiment.mat'])
   elecs=list_electrodes(Subject(SN).Name);
    
   % load regular locations if seeg, brain shifted if grid
    filedir=[RECONDIR '/' Subject(SN).Name '/elec_recon/'];
    if strcmp(Subject(SN).Type,'SEEG')  %|| strcmp(Subject(SN).Name,'D16')
        filename=[filedir Subject(SN).Name '_elec_location_radius_3mm_aparc+aseg.mgz.csv'];
        filename=[filedir Subject(SN).Name '_elec_location_radius_3mm_aparc.a2009s+aseg.mgz.csv'];
    elseif strcmp(Subject(SN).Type,'ECoG')
        filename=[filedir Subject(SN).Name '_elec_location_radius_3mm_aparc+aseg.mgz_brainshifted.csv'];
        filename=[filedir Subject(SN).Name '_elec_location_radius_3mm_aparc.a2009s+aseg.mgz_brainshifted.csv'];   
    end
    
    % read through the xls file
    [NUM,TXT,RAW]=xlsread(filename);
    TXT=TXT(2:end,:);
    for iElec=1:length(elecs);
        for iElec2=1:length(TXT)
            if strcmp(elecs{iElec},(strcat(Subject(SN).Name,'-',TXT(iElec2,2))))
                elecIdx(iElec)=iElec2;
            end
        end
    end
    ii=find(elecIdx==0);
    elecIdx(ii)=[];
    TXT=TXT(elecIdx,:);
    NUM=NUM(elecIdx,:);
    
    % this can be adjusted! Looks for proportion that is white matter (less
    % than 0.67) and keeps it. Could be higher or lower
    for iElec=1:length(TXT)
        elec_nameT=strcat(Subject(SN).Name, '-',TXT(iElec,2));
        iN=3;
       
        while (contains(TXT(iElec,iN),'White-Matter'))  && iN<=7 && NUM(iElec,iN-2)<0.67
            %|| NUM(iElec,iN-2)<0.5
            iN=iN+2;
        end
        
        
        while (contains(TXT(iElec,iN),'Unknown') || contains(TXT(iElec,iN),'unknown') || contains(TXT(iElec,iN),'hypointensities')   ) && iN<=7
            %|| NUM(iElec,iN-2)<0.5
            iN=iN+2;
        end
        subj_labels2(iElecS+iElec)=elec_nameT;
  %
        subj_labels_loc(iElecS+iElec)=TXT(iElec,iN); % percentages
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
end
         

