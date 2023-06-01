for iG=1:2
    if iG==1
        chanOff=0;
    elseif iG==2
        chanOff=60;
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
        for iCond=1:2
            iCond2=iCond;
            hold on;
            tmp=sq(mean(Auditory_Spec{iCond2}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{iCond2},1,size(Auditory_Spec{iCond2}{iChan2},2),1),3));
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
    end
    legend('Decision Words','Decision nonwords');
        
     figure;
    for iChan=1:60
        iChan2=iChan+chanOff;
        subplot(6,10,iChan);
        cvals=cat(1,[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560]);
        
        for iCond=1:2
            iCond2=iCond+2;
            hold on;
            tmp=sq(mean(Auditory_Spec{iCond2}{iChan2}(:,:,freqRange)./repmat(baseline_chans{iChan}{iCond2},1,size(Auditory_Spec{iCond2}{iChan2},2),1),3));
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
    end
        legend('Repetition Words','Repetition nonwords');

end
    

    
    
