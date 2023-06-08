function procCluWaveClus(day,rec,microdrive)
% procCluWaveClus(day,rec,microdrive)
%
% Unsupervised Spike Sorting with wave_clus (Quiroga 2004). Creates clu.mat files
%
% Requires procSpMuLfp and procPk to be run in advance.
% 'rec' can be cell array of strings specifying multiple recordings to use for
% spike sorting.
%
% microdrive, string specifying the microdrive to spike sort, defaults to 'all'
%
% parameters for sorting are set in procCluWaveClus_params.m, or
% procCluWaveClus_MONKEY.m if it exists
%
% Based on the Do_clustering.m, run_cluster.m and find_temp.m code distributed with wave_clus
%
% cluster_linux.exe (and 32-bit exe compatibility) has to be installed under ubuntu

global MONKEYDIR MONKEYNAME

% Parameters
try
    eval(sprintf('handles = procCluWaveClus_%s;',day));
    fprintf('Using specific parameters for %s\n',day);
catch
    handles = procCluWaveClus_params;
    fprintf('Using default parameters in procCluWaveClus_params.m\n');
end

% recordings to spike sort over
olddir = pwd;
recs= dayrecs(day);
nRecs = length(recs);
if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif iscell(rec)
    num = [find(strcmp(recs,rec{1})),find(strcmp(recs,rec{end}))];
elseif length(rec)==1
    num = [rec,rec];
else
    num = rec;
end

% microdrives to spike sort for
if nargin<3
    microdrive = 'all';
end
load([MONKEYDIR '/mat/prototype.experiment.mat']);
nMicrodrives = numel(experiment.hardware.microdrive);
MicrodriveNames = {experiment.hardware.microdrive(:).name};
if strcmp(microdrive,'all')
    iMicrodrive = 1:nMicrodrives;
else
    iMicrodrive = strmatch(microdrive,MicrodriveNames);
end

% check whether clu files exist already, create empty clu files for recs over which to sort, cluster 1 clu files for unsorted recs
recsort = dayrecs(num(1):num(2));
for iM = iMicrodrive
    for iRec = 1:numel(recs)
        prenum = recs{iRec};
        if exist(sprintf('%s/%s/%s/rec%s.%s.clu.mat',MONKEYDIR,day,prenum,prenum,experiment.hardware.microdrive(iMicrodrive(iM)).name),'file')
            error('clu.mat files exist already')
        else
            isrecsort = strmatch(prenum,recsort);
            if ~isempty(isrecsort) % does rec belong to sort?
                % yes, create empty clu file
                clu = cell{numel(experiment.hardware.microdrive(iM).electrodes),1};
                save(sprintf('%s/%s/%s/rec%s.%s.clu.mat',MONKEYDIR,day,prenum,prenum,experiment.hardware.microdrive(iMicrodrive(iM)).name),'clu')
                clear clu
            else
                % no, asign all spikes cluster id 1
                load(sprintf('%s/%s/%s/rec%s.%s.pk.mat',MONKEYDIR,day,prenum,prenum,experiment.hardware.microdrive(iM).name),'pk')
                clu = pk;
                for iElec = 1:numel(clu)
                   clu{iElec}(:,2)=1; 
                end
                save(sprintf('%s/%s/%s/rec%s.%s.clu.mat',MONKEYDIR,day,prenum,prenum,experiment.hardware.microdrive(iM).name),'clu')
                clear pk clu
            end
        end
    end
end

for iM = iMicrodrive
    nElectrodes = numel(experiment.hardware.microdrive(iM).electrodes);
    for iElec = 1:nElectrodes
        tic,fprintf('%s, Electrode %d/%d\n',experiment.hardware.microdrive(iM).name,iElec,nElectrodes)
        %% load spikes across recordings
        allSpikes = []; % spike waveforms
        allIndex = []; % time stamps
        spikeInfo = []; % [rec time stamps | used for sort based on peak? | recording number]
        index_offset = 0;
        for iRec = num(1):num(2)
            prenum = recs{iRec};
            % sp and pk
            load(sprintf('%s/%s/%s/rec%s.%s.sp.mat',MONKEYDIR,day,prenum,prenum,experiment.hardware.microdrive(iM).name),'thresh','threshfactor','sp')
            load(sprintf('%s/%s/%s/rec%s.%s.pk.mat',MONKEYDIR,day,prenum,prenum,experiment.hardware.microdrive(iM).name),'pk')
            % minimum peak for sorting and maximum peak for rejection
            threshmin = abs((handles.par.stdmin./threshfactor)).* thresh{iM}(iElec); % minimum spike peak
            threshmax = abs((handles.par.stdmax./threshfactor)).* thresh{iM}(iElec); % noise rejection
            % spike wave forms, time stamps and info
            allSpikes = [allSpikes;sp{iElec}(:,2:end)];
            allIndex = [allIndex;sp{iElec}(:,1)+index_offset];
            index_offset = index_offset+max(sp{iElec}(:,1));
            spikeInfo = [spikeInfo;sp{iElec}(:,1) (pk{iElec}(:,2)>threshmax & pk{iElec}(:,2)<threshmin) ones(size(sp{iElec},1),1).*str2num(prenum)];
        end
        
        %% spike clustering
        iSpikes = find(spikeInfo(:,2));
        nSpikes = numel(iSpikes);
        nallSpikes = size(allSpikes,1);
        if nSpikes > handles.par.min_spikes
            spikes = allSpikes(iSpikes,:);
            index = allIndex(iSpikes);
            
            nspk = size(spikes,1);
            naux = min(handles.par.max_spk,size(spikes,1));
            handles.par.min_clus = max(handles.par.min_clus_abs,handles.par.min_clus_rel*naux);
            
            % wavelet features for clustering algorithm
            inspk_aux = wave_features(spikes,handles); %takes wavelet coefficients.
            
            % RUN_CLUSTER.M
            save(handles.par.fname_in,'inspk_aux','-ascii');
            dim=handles.par.inputs;
            fname=handles.par.fname;
            fname_in=handles.par.fname_in;
            
            % delete previous files
            if exist([fname '.dg_01.lab'],'file');
                delete([fname '.dg_01.lab']);
                delete([fname '.dg_01']);
            end
            
            % write out auxiliary data file
            dat=load(fname_in);
            n=length(dat);
            fid=fopen(sprintf('%s.run',fname),'wt');
            fprintf(fid,'NumberOfPoints: %s\n',num2str(n));
            fprintf(fid,'DataFile: %s\n',fname_in);
            fprintf(fid,'OutFile: %s\n',fname);
            fprintf(fid,'Dimensions: %s\n',num2str(dim));
            fprintf(fid,'MinTemp: %s\n',num2str(handles.par.mintemp));
            fprintf(fid,'MaxTemp: %s\n',num2str(handles.par.maxtemp));
            fprintf(fid,'TempStep: %s\n',num2str(handles.par.tempstep));
            fprintf(fid,'SWCycles: %s\n',num2str(handles.par.SWCycles));
            fprintf(fid,'KNearestNeighbours: %s\n',num2str(handles.par.KNearNeighb));
            fprintf(fid,'MSTree|\n');
            fprintf(fid,'DirectedGrowth|\n');
            fprintf(fid,'SaveSuscept|\n');
            fprintf(fid,'WriteLables|\n');
            fprintf(fid,'WriteCorFile~\n');
            if handles.par.randomseed ~= 0
                fprintf(fid,'ForceRandomSeed: %s\n',num2str(handles.par.randomseed));
            end
            fclose(fid);
            
            % call of clustering function
            run_linux = sprintf('cluster_linux.exe %s.run',fname);
            unix(run_linux);
            
            clu=load([fname '.dg_01.lab']);
            tree=load([fname '.dg_01']);
            delete(sprintf('%s.run',fname));
            delete *.mag
            delete *.edges
            delete *.param
            delete(fname_in);
            
            %S FIND_TEMP.m
            % Selects the temperature.
            num_temp=handles.par.num_temp;
            min_clus=handles.par.min_clus;
            aux =diff(tree(:,5));   % Changes in the first cluster size
            aux1=diff(tree(:,6));   % Changes in the second cluster size
            aux2=diff(tree(:,7));   % Changes in the third cluster size
            aux3=diff(tree(:,8));   % Changes in the third cluster size
            temp = 1;         % Initial value
            for t=1:num_temp-1;
                % Looks for changes in the cluster size of any cluster larger than min_clus.
                if ( aux(t) > min_clus | aux1(t) > min_clus | aux2(t) > min_clus | aux3(t) >min_clus )
                    temp=t+1;
                end
            end
            %In case the second cluster is too small, then raise the temperature a little bit
            if (temp == 1 & tree(temp,6) < min_clus)
                temp = 2;
            end
            
            % define clusters
            class1=find(clu(temp,3:end)==0);
            class2=find(clu(temp,3:end)==1);
            class3=find(clu(temp,3:end)==2);
            class4=find(clu(temp,3:end)==3);
            class5=find(clu(temp,3:end)==4);
            class0=setdiff(1:size(spikes,1), sort([class1 class2 class3 class4 class5]));
            whos class*
            
            %% write out clu file to recording directories
            % Clusters of spikes that have been sorted
            clusters = ones(nSpikes,1);
            clusters(class1)=2;
            clusters(class2)=3;
            clusters(class3)=4;
            clusters(class4)=5;
            clusters(class5)=6;
            clusters(class0)=14;
            
            % Reconstitute all spikes
            allclusters = ones(nallSpikes,1); % unsorted spikes are assigned to cluster id 1
            allclusters(iSpikes)=clusters;
            
            for iRec = num(1):num(2)
                prenum = recs{iRec};

                % load clu file
                load(sprintf('%s/%s/%s/rec%s.%s.clu.mat',MONKEYDIR,day,prenum,prenum,experiment.hardware.microdrive(iMicrodrive(iM)).name),'clu')
                
                % modify
                jRec = find(spikeInfo(:,3)==str2num(prenum)); % which spikes belong to this recording?
                clu{iElec} = [spikeInfo(jRec,1) allclusters(jRec)];
                
                % save clu file
                save(sprintf('%s/%s/%s/rec%s.%s.clu.mat',MONKEYDIR,day,prenum,prenum,experiment.hardware.microdrive(iMicrodrive(iM)).name),'clu')
            end
    
            %% print figures with information about the sort
            if handles.par.print_figures
                DIRFIG = sprintf('%s/%s/WaveClusFigures/',MONKEYDIR,day);
                if ~exist(DIRFIG); mkdir(DIRFIG); end
                hFig=figure('PaperOrientation','Portrait','PaperPosition',[0.25 0.25 10.5 8],'Visible','off'); 
                clf
                clus_pop = [];
                ylimit = [];
                subplot(3,5,11)
                temperature=handles.par.mintemp+temp*handles.par.tempstep;
                switch handles.par.temp_plot
                    case 'lin'
                        plot([handles.par.mintemp handles.par.maxtemp-handles.par.tempstep], ...
                            [handles.par.min_clus handles.par.min_clus],'k:',...
                            handles.par.mintemp+(1:handles.par.num_temp)*handles.par.tempstep, ...
                            tree(1:handles.par.num_temp,5:size(tree,2)),[temperature temperature],[1 tree(1,5)],'k:')
                    case 'log'
                        semilogy([handles.par.mintemp handles.par.maxtemp-handles.par.tempstep], ...
                            [handles.par.min_clus handles.par.min_clus],'k:',...
                            handles.par.mintemp+(1:handles.par.num_temp)*handles.par.tempstep, ...
                            tree(1:handles.par.num_temp,5:size(tree,2)),[temperature temperature],[1 tree(1,5)],'k:')
                end
                subplot(3,5,6)
                hold on
                cluster=zeros(nspk,2);
                cluster(:,2)= index';
                num_clusters = length(find([length(class1) length(class2) length(class3)...
                    length(class4) length(class5) length(class0)] >= handles.par.min_clus));
                clus_pop = [clus_pop length(class0)];
                if length(class0) > handles.par.min_clus;
                    subplot(3,5,6);
                    max_spikes=min(length(class0),handles.par.max_spikes);
                    plot(spikes(class0(1:max_spikes),:)','k');
                    xlim([1 size(spikes,2)]);
                    subplot(3,5,10);
                    hold on
                    plot(spikes(class0(1:max_spikes),:)','k');
                    plot(mean(spikes(class0,:),1),'c','linewidth',2)
                    xlim([1 size(spikes,2)]);
                    title('Cluster 0','Fontweight','bold')
                    subplot(3,5,15)
                    xa=diff(index(class0));
                    [n,c]=hist(xa,0:1:100);
                    bar(c(1:end-1),n(1:end-1))
                    xlim([0 100])
                    xlabel([num2str(sum(n(1:3))) ' in < 3ms'])
                    title([num2str(length(class0)) ' spikes']);
                end
                if length(class1) > handles.par.min_clus;
                    clus_pop = [clus_pop length(class1)];
                    subplot(3,5,6);
                    max_spikes=min(length(class1),handles.par.max_spikes);
                    plot(spikes(class1(1:max_spikes),:)','b');
                    xlim([1 size(spikes,2)]);
                    subplot(3,5,7);
                    hold
                    plot(spikes(class1(1:max_spikes),:)','b');
                    plot(mean(spikes(class1,:),1),'k','linewidth',2)
                    xlim([1 size(spikes,2)]);
                    title('Cluster 1','Fontweight','bold')
                    ylimit = [ylimit;ylim];
                    subplot(3,5,12)
                    xa=diff(index(class1));
                    [n,c]=hist(xa,0:1:100);
                    bar(c(1:end-1),n(1:end-1))
                    xlim([0 100])
                    % set(get(gca,'children'),'facecolor','b','linewidth',0.01)
                    xlabel([num2str(sum(n(1:3))) ' in < 3ms'])
                    title([num2str(length(class1)) ' spikes']);
                    cluster(class1(:),1)=1;
                end
                if length(class2) > handles.par.min_clus;
                    clus_pop = [clus_pop length(class2)];
                    subplot(3,5,6);
                    max_spikes=min(length(class2),handles.par.max_spikes);
                    plot(spikes(class2(1:max_spikes),:)','r');
                    xlim([1 size(spikes,2)]);
                    subplot(3,5,8);
                    hold
                    plot(spikes(class2(1:max_spikes),:)','r');
                    plot(mean(spikes(class2,:),1),'k','linewidth',2)
                    xlim([1 size(spikes,2)]);
                    title('Cluster 2','Fontweight','bold')
                    ylimit = [ylimit;ylim];
                    subplot(3,5,13)
                    xa=diff(index(class2));
                    [n,c]=hist(xa,0:1:100);
                    bar(c(1:end-1),n(1:end-1))
                    xlim([0 100])
                    % set(get(gca,'children'),'facecolor','r','linewidth',0.01)
                    xlabel([num2str(sum(n(1:3))) ' in < 3ms'])
                    cluster(class2(:),1)=2;
                    title([num2str(length(class2)) ' spikes']);
                end
                if length(class3) > handles.par.min_clus;
                    clus_pop = [clus_pop length(class3)];
                    subplot(3,5,6);
                    max_spikes=min(length(class3),handles.par.max_spikes);
                    plot(spikes(class3(1:max_spikes),:)','g');
                    xlim([1 size(spikes,2)]);
                    subplot(3,5,9);
                    hold
                    plot(spikes(class3(1:max_spikes),:)','g');
                    plot(mean(spikes(class3,:),1),'k','linewidth',2)
                    xlim([1 size(spikes,2)]);
                    title('Cluster 3','Fontweight','bold')
                    ylimit = [ylimit;ylim];
                    subplot(3,5,14)
                    xa=diff(index(class3));
                    [n,c]=hist(xa,0:1:100);
                    bar(c(1:end-1),n(1:end-1))
                    xlim([0 100])
                    % set(get(gca,'children'),'facecolor','g','linewidth',0.01)
                    xlabel([num2str(sum(n(1:3))) ' in < 3ms'])
                    cluster(class3(:),1)=3;
                    title([num2str(length(class3)) ' spikes']);
                end
                if length(class4) > handles.par.min_clus;
                    clus_pop = [clus_pop length(class4)];
                    subplot(3,5,6);
                    max_spikes=min(length(class4),handles.par.max_spikes);
                    plot(spikes(class4(1:max_spikes),:)','c');
                    xlim([1 size(spikes,2)]);
                    cluster(class4(:),1)=4;
                end
                if length(class5) > handles.par.min_clus;
                    clus_pop = [clus_pop length(class5)];
                    subplot(3,5,6);
                    max_spikes=min(length(class5),handles.par.max_spikes);
                    plot(spikes(class5(1:max_spikes),:)','m');
                    xlim([1 size(spikes,2)]);
                    cluster(class5(:),1)=5;
                end
                
                % Rescale spike's axis
                if ~isempty(ylimit)
                    ymin = min(ylimit(:,1));
                    ymax = max(ylimit(:,2));
                else
                    ymin = -200;
                    ymax = 200;
                end
                if length(class1) > handles.par.min_clus; subplot(3,5,7); ylim([ymin ymax]); end
                if length(class2) > handles.par.min_clus; subplot(3,5,8); ylim([ymin ymax]); end
                if length(class3) > handles.par.min_clus; subplot(3,5,9); ylim([ymin ymax]); end
                if length(class0) > handles.par.min_clus; subplot(3,5,10); ylim([ymin ymax]); end
                
                % add infostrings
                ax=subplot(3,5,1);
                axis off
                info1 = sprintf('Subject: %s, Day: %s, Microdrive: %s, Electrode: %d',MONKEYNAME, day, experiment.hardware.microdrive(iM).name, iElec);
                info2 = sprintf('Seed: %d, MinClus: %.1f, StdMin: %.1f, Temperature: %.1f-%.1f xe-3',handles.par.randomseed,handles.par.min_clus,handles.par.stdmin,handles.par.mintemp*1e3,handles.par.maxtemp*1e3);
                info3 = sprintf('Sorted over Recs: %s-%s',recs{num(1)},recs{num(2)});
                text(0,1,info1)
                text(0,0.5, info2)
                text(0,0,info3)
                
                % print figure
                FIGSTRING = sprintf('%s%s_%04d.png',DIRFIG,MicrodriveNames{iM},iElec);
                print(FIGSTRING,'-dpng')
                close(hFig)
                
            end
        end
        fprintf('done (%.2fs)\n',toc)
    end
end




