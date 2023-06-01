


for iG=1:2
    if iG==1
        chanOff=0;
    elseif iG==2
        chanOff=50;
    end
    freqRange=70:120;
    
    for iChan=1:60
        iChan2=iChan+chanOff;
        for iCond=1:4
            %baseline_chans{iChan}{iCond}=sq(mean(mean(mean(Auditory_Spec{iCond}{iChan2}(:,1:10,freqRange),2),3),1));
            baseline_chans{iChan}{iCond}=mean(Auditory_Spec{iCond}{iChan2}(:,1:10,freqRange),2);
            
        end
    end
    
    
    
    figure;
    for iChan=1:60
        iChan2=iChan+chanOff;
        subplot(6,10,iChan);
        cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560]);
        for iCond=1:4
            iCond2=iCond;
            hold on;
           % tmp=sq(mean(Auditory_Spec{iCond2}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{iCond2},1,size(Auditory_Spec{iCond2}{iChan2},2),1),3));
            tmp=sq(mean(Auditory_Spec{iCond2}{iChan2}(:,:,freqRange)./repmat(mean(baseline_chans{iChan}{iCond2},1),size(Auditory_Spec{iCond2}{iChan2},1),size(Auditory_Spec{iCond2}{iChan2},2),1),3));

            errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond2,:));
            %     hold on;
            %     tmp=sq(mean(Auditory_Spec{2}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{2};
            %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.8500 0.3250 0.0980]);
            %     hold on;
            %     tmp=sq(mean(Auditory_Spec{3}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{3};
            %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.9290 0.6940 0.1250]);
            %     hold on;
            %     tmp=sq(mean(Auditory_Spec{4}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{4};
            %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.4940 0.1840 0.5560]);
        end
        axis('tight')
        title([experiment.channels(iChan2).name])
        
    end
    
    legend('Decision Words','Decision NonWords','Repeat Words','Repeat Nonwords');
    
    
    
    figure;
    for iChan=1:60
        iChan2=iChan+chanOff;
        subplot(6,10,iChan);
        
        cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560]);
        for iCond=1:2
            hold on;
            tmp1=sq(mean(Auditory_Spec{iCond}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{iCond},1,size(Auditory_Spec{iCond}{iChan2},2),1),3));
            tmp2=sq(mean(Auditory_Spec{iCond+2}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{iCond+2},1,size(Auditory_Spec{iCond+2}{iChan2},2),1),3));
            tmp=cat(1,tmp1,tmp2);
            errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond,:));
        end
        %     tmp1=sq(mean(Auditory_Spec{1}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{1};
        %     tmp2=sq(mean(Auditory_Spec{3}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{3};
        %     tmp=cat(1,tmp1,tmp2);
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0 0.4470 0.7410]);
        %     hold on;
        %     tmp3=sq(mean(Auditory_Spec{2}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{2};
        %     tmp4=sq(mean(Auditory_Spec{4}{iChan2}(:,:,freqRange),3))./baseline_chans{iChan}{4};
        %     tmp=cat(1,tmp3,tmp4);
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.8500 0.3250 0.0980]);
        %     hold on;
        %
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.9290 0.6940 0.1250]);
        %     hold on;
        %
        %     errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',[0.4940 0.1840 0.5560]);
        axis('tight')
        title([experiment.channels(iChan2).name])
        
    end
    
    legend('Words','Nonwords');
    
    
    figure;
    for iChan=1:60
        iChan2=iChan+chanOff;
        subplot(6,10,iChan);
        cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560]);
        for iCond=1:2
            hold on;
            tmp1=sq(mean(Auditory_Spec{2*iCond-1}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{2*iCond-1},1,size(Auditory_Spec{2*iCond-1}{iChan2},2),1),3));
         %   tmp2=sq(mean(Auditory_Spec{2*iCond}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{2*iCond},1,size(Auditory_Spec{2*iCond}{iChan2},2),1),3));
            tmp=cat(1,tmp1,tmp2);
            errorbar(mean(tmp),std(tmp,[],1)./sqrt(size(tmp,1)),'color',cvals(iCond+2,:));
        end
        axis('tight')
        title([experiment.channels(iChan2).name])
        
    end
    
    legend('Decision','Repeat');
end
