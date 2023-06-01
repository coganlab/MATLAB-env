for iPerm=1:1000;
    designMat=[1 1 0 0 1 1 0 0;1 1 1 1 0 0 0 0;1 0 1 0 1 0 1 0];
    idx=1:704; %iiABCD;
    for iChan=1:length(idx); %704 %length(ii);
        F1=[];
        F2=[];
        F3=[];
        % ii=find(NewAreaLoc==iChan);
        AreaTrials=[];
        %   SubjectTrials=[];
        baseD=[];
        baseR=[];
        for iCond=1:4;
            baseD=cat(1,baseD,Spec_Chan_All_Aud{idx(iChan)}{iCond});
            baseR=cat(1,baseR,Spec_Chan_All_Aud{idx(iChan)}{iCond+4});
        end
        
        
        for iCond=1:8
            AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:10))));
            %     AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(Spec_Chan_All_Aud{idx(iChan)}{iCond}(:,1:40),2));
            %AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond});
            
            %             if iCond<=4
            %             AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(baseD(:,1:10))));
            %             elseif iCond>=5
            %             AreaTrials=cat(1,AreaTrials,Spec_Chan_All_Aud{idx(iChan)}{iCond}./mean(mean(baseR(:,1:10))));
            %             end
            
            % SubjectTrials=cat(1,SubjectTrials,Spec_Subject(ii(iChan))*ones(size(Spec_Chan_All_Aud{ii(iChan)}{iCond},1),1));
            F1=cat(1,F1,designMat(1,iCond)*ones(size(Spec_Chan_All_Aud{idx(iChan)}{iCond},1),1));
            F2=cat(1,F2,designMat(2,iCond)*ones(size(Spec_Chan_All_Aud{idx(iChan)}{iCond},1),1));
            F3=cat(1,F3,designMat(3,iCond)*ones(size(Spec_Chan_All_Aud{idx(iChan)}{iCond},1),1));
        end
        
        
        
        
        % FS=cat(2,F1,F2,F3,F1.*F2,F1.*F3,F2.*F3); % mains and inter
        FS1=cat(2,F1,F2,F3); % just mains
        %  FS=cat(2,FS1,SubjectTrials); % subject random effects
        FS=cat(2,FS1,ones(size(FS1,1),1)); % add constant
        for iTime=1:40
            dataT=AreaTrials(:,iTime);
            dataT=shuffle(dataT);
            % [b,bint,r,rint,stats] = regress(dataT,FS);
            %mdl=fitlm(FS,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
            %   mdl=fitlm(FS1,dataT,'interactions','PredictorVars',{'Lex','Task','Phono'},'CategoricalVar',{'Lex','Task','Phono'});
            [P T stats terms]=anovan(dataT,FS1,'model','linear','display','off');
            TvalsS(iPerm,iChan,iTime,:)=stats.coeffs;
            %      Tvals(iChan,iTime,:)=b; %Tvals1;
            %     Pvals(iChan,iTime,:)=stats(3);
            %   Pvals(iChan,iTime,:)=P; %stats(3);
            FvalsS(iPerm,iChan,iTime,1)=T{2,6};
            FvalsS(iPerm,iChan,iTime,2)=T{3,6};
            FvalsS(iPerm,iChan,iTime,3)=T{4,6};
            %          Fvals(iChan,iTime,4)=T{5,6};
            %          Fvals(iChan,iTime,5)=T{6,6};
            %          Fvals(iChan,iTime,6)=T{7,6};
            % Fvals(iChan,iTime,7)=T{8,6};
            
            %     Rvals(iChan,iTime,:)=stats(1);
            %     TvalsM{iChan}{iTime}=mdl;
        end
        %   display(iChan)
        
    end
    display(iPerm)
end
