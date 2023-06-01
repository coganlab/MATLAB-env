
    

for iG=1:2
    if iG==1
        chanOff=0;
    elseif iG==2
        chanOff=60;
    end
    freqRange=70:120;
    
    for iChan=1:60
        iChan2=iChan+chanOff;
        for iCond=1:8
            %baseline_chans{iChan}{iCond}=sq(mean(mean(mean(Auditory_Spec{iCond}{iChan2}(:,1:10,freqRange),2),3),1));
            baseline_chans{iChan}{iCond}=mean(Auditory_Spec{iCond}{iChan2}(:,1:10,freqRange),2);
            
        end
    end
    
    figure;
    for iChan=1:60
        iChan2=iChan+chanOff;
        subplot(6,10,iChan);
        cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[34/255 139/255 34/255],[1 0 1],[1 192/255 203/255],[119/255 136/255 153/255]);
        %cvals=cat(1,[0 0 1],[1 0 0],[1 0 0],[1 0 0],[0 0 1],[1 0 0],[1 0 0],[1 0 0]);
        for iCond=1:8
            iCond2=iCond;
            hold on;
            tmp=sq(mean(Auditory_Spec{iCond2}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{iCond2},1,size(Auditory_Spec{iCond2}{iChan2},2),1),3));
            tmp2(iCond,:)=mean(tmp);
            hold on;
            plot(tmp2(iCond,:),'Color',cvals(iCond,:));
        end
        %  errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond2,:));
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{2}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{2};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.8500 0.3250 0.0980]);
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{3}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{3};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.9290 0.6940 0.1250]);
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{4}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{4};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.4940 0.1840 0.5560]);
        axis('tight')
        title([experiment.channels(iChan2).name])
    end
    legend('HW D','LW D','HNW D','LNW D','HW R','LW R','HNW R','LNW R');
    clear tmp*
end

for iG=1:2
    if iG==1
        chanOff=0;
    elseif iG==2
        chanOff=60;
    end
    freqRange=70:120;
    
    for iChan=1:60
        iChan2=iChan+chanOff;
        for iCond=1:8
            %baseline_chans{iChan}{iCond}=sq(mean(mean(mean(Auditory_Spec{iCond}{iChan2}(:,1:10,freqRange),2),3),1));
            baseline_chans{iChan}{iCond}=mean(Auditory_Spec{iCond}{iChan2}(:,1:10,freqRange),2);
            
        end
    end
    
    figure;
    for iChan=1:60
        iChan2=iChan+chanOff;
        subplot(6,10,iChan);
        cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[34/255 139/255 34/255],[1 0 1],[1 192/255 203/255],[119/255 136/255 153/255]);
        %cvals=cat(1,[0 0 1],[1 0 0],[1 0 0],[1 0 0],[0 0 1],[1 0 0],[1 0 0],[1 0 0]);
        for iCond=1:8
            iCond2=iCond;
            hold on;
            tmp=sq(mean(Motor_Spec{iCond2}{iChan2}(:,:,freqRange)))./repmat(sq(mean(baseline_chans{iChan}{iCond2}))',size(Motor_Spec{iCond2}{iChan2},2),1);
            tmp2(iCond,:)=mean(tmp,2);
            hold on;
            plot(tmp2(iCond,:),'Color',cvals(iCond,:));
        end
        %  errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond2,:));
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{2}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{2};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.8500 0.3250 0.0980]);
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{3}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{3};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.9290 0.6940 0.1250]);
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{4}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{4};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.4940 0.1840 0.5560]);
        axis('tight')
    end
    legend('HW D','LW D','HNW D','LNW D','HW R','LW R','HNW R','LNW R');
end



clear tmp*


for iG=1:2
    if iG==1
        chanOff=0;
    elseif iG==2
        chanOff=60;
    end
    freqRange=70:120;
    
    for iChan=1:60
        iChan2=iChan+chanOff;
        for iCond=1:8
            %baseline_chans{iChan}{iCond}=sq(mean(mean(mean(Auditory_Spec{iCond}{iChan2}(:,1:10,freqRange),2),3),1));
            baseline_chans{iChan}{iCond}=mean(Auditory_Spec{iCond}{iChan2}(:,1:10,freqRange),2);
            
        end
    end
    
    figure;
    for iChan=1:60
        iChan2=iChan+chanOff;
        subplot(6,10,iChan);
        cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[34/255 139/255 34/255],[1 0 1],[1 192/255 203/255],[119/255 136/255 153/255]);
        %cvals=cat(1,[0 0 1],[1 0 0],[1 0 0],[1 0 0],[0 0 1],[1 0 0],[1 0 0],[1 0 0]);
        for iCond=1:2
            iCond2=iCond;
            hold on;
            tmp=sq(mean(Auditory_Spec{iCond2}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{iCond2},1,size(Auditory_Spec{iCond2}{iChan2},2),1),3));
            tmpB=sq(mean(Auditory_Spec{iCond2+4}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{iCond2+4},1,size(Auditory_Spec{iCond2+4}{iChan2},2),1),3));
            tmpC=sq(mean(Auditory_Spec{iCond2+2}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{iCond2+2},1,size(Auditory_Spec{iCond2+2}{iChan2},2),1),3));
            tmpD=sq(mean(Auditory_Spec{iCond2+6}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{iCond2+6},1,size(Auditory_Spec{iCond2+6}{iChan2},2),1),3));

            
            tmp2(iCond,:)=mean(cat(1,tmp,tmpB,tmpC,tmpD));
            hold on;
            plot(tmp2(iCond,:),'Color',cvals(iCond,:));
        end
        %  errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond2,:));
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{2}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{2};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.8500 0.3250 0.0980]);
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{3}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{3};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.9290 0.6940 0.1250]);
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{4}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{4};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.4940 0.1840 0.5560]);
        axis('tight')
        title([experiment.channels(iChan2).name])

    end
    legend('H','L');
    clear tmp*
end

for iG=1:2
    if iG==1
        chanOff=0;
    elseif iG==2
        chanOff=60;
    end
    freqRange=70:120;
    
    for iChan=1:60
        iChan2=iChan+chanOff;
        for iCond=1:8
            %baseline_chans{iChan}{iCond}=sq(mean(mean(mean(Auditory_Spec{iCond}{iChan2}(:,1:10,freqRange),2),3),1));
            baseline_chans{iChan}{iCond}=mean(Auditory_Spec{iCond}{iChan2}(:,1:10,freqRange),2);
            
        end
    end
    
    figure;
    for iChan=1:60
        iChan2=iChan+chanOff;
        subplot(6,10,iChan);
        cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[34/255 139/255 34/255],[1 0 1],[1 192/255 203/255],[119/255 136/255 153/255]);
        %cvals=cat(1,[0 0 1],[1 0 0],[1 0 0],[1 0 0],[0 0 1],[1 0 0],[1 0 0],[1 0 0]);
        for iCond=1:2
            iCond2=iCond;
            hold on;
            tmp=sq(mean(Motor_Spec{iCond2}{iChan2}(:,:,freqRange)))./repmat(sq(mean(baseline_chans{iChan}{iCond2}))',size(Motor_Spec{iCond2}{iChan2},2),1);
            tmp=reshape(tmp,1,size(tmp,1),size(tmp,2));
            
            tmpB=sq(mean(Motor_Spec{iCond2+2}{iChan2}(:,:,freqRange)))./repmat(sq(mean(baseline_chans{iChan}{iCond2+2}))',size(Motor_Spec{iCond2+2}{iChan2},2),1);
            tmpB=reshape(tmpB,1,size(tmpB,1),size(tmpB,2));
            
            tmpC=sq(mean(Motor_Spec{iCond2+4}{iChan2}(:,:,freqRange)))./repmat(sq(mean(baseline_chans{iChan}{iCond2+4}))',size(Motor_Spec{iCond2+4}{iChan2},2),1);
            tmpC=reshape(tmpC,1,size(tmpC,1),size(tmpC,2));
            
            tmpD=sq(mean(Motor_Spec{iCond2+6}{iChan2}(:,:,freqRange)))./repmat(sq(mean(baseline_chans{iChan}{iCond2+6}))',size(Motor_Spec{iCond2+6}{iChan2},2),1);
            tmpD=reshape(tmpD,1,size(tmpD,1),size(tmpD,2));
            
            tmp2(iCond,:)=sq(mean(mean(cat(1,tmp,tmpB,tmpC,tmpD),1),3));
            hold on;
            plot(tmp2(iCond,:),'Color',cvals(iCond,:));
        end
        %  errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond2,:));
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{2}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{2};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.8500 0.3250 0.0980]);
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{3}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{3};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.9290 0.6940 0.1250]);
        %     hold on;
        %     tmp=sq(mean(Auditory_Spec{4}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{4};
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.4940 0.1840 0.5560]);
        axis('tight')
    end
    legend('H','L');
end










