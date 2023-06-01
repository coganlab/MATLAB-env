
clear mdlVals
for iChan=1:124;
  
    groupsWNW=[];
    groupsHL=[];
    groupsS=[];
    sig1=[];
    sig1A=[];
    groups=[];
    iiALL=[];
    for iCond=1:4;
        ii=find(condVals==iCond);
        [ii iiIdx]=intersect(ii,goodTrials{iChan});
        for iS=1:length(ii)
            groupsS=cat(1,groupsS,stimLength(ii(iS)));
        end
        
        iiALL=cat(2,iiALL,ii);
 
        sig1=cat(1,sig1,eegSpecD{iChan}(iiIdx,:,:));
        sig1A=cat(1,sig1A,eegSpecA{iChan}(iiIdx,:,:));

        if iCond<=2
            groupsWNW=cat(1,groupsWNW,ones(length(ii),1));
        else
            groupsWNW=cat(1,groupsWNW,zeros(length(ii),1));
        end
        
        if iCond==1 || iCond==3
            groupsHL=cat(1,groupsHL,ones(length(ii),1));
        else
            groupsHL=cat(1,groupsHL,zeros(length(ii),1));
        end
    end

    
    groups=cat(2,groupsWNW,groupsHL,groupsS);
    groups(:,4)=groups(:,1).*groups(:,2);
    groups(:,5)=groups(:,1).*groups(:,3);
    groups(:,6)=groups(:,2).*groups(:,3);
    groups(:,7)=groups(:,1).*groups(:,2).*groups(:,3);
        
      for iF=1:46;
%     sig1t=sq(mean(mean(log(abs(sig1(:,11:end,35:45))),2),3));
%     sig1At=sq(mean(mean(log(abs(sig1A(:,1:10,35:45))),2),3));
   sig1t=sq(mean(log(abs(sig1(:,11:end,iF))),2));
    sig1At=sq(mean(log(abs(sig1A(:,1:10,iF))),2));
    [m s]=normfit(sig1At);
    sig1z=(sig1t-m)./s;
    mdl=fitlm(groups,sig1z,'linear','PredictorVars',{'Lex','Phono','Length','Lex x Phono','Lex x Length','Phono x Length','Lex x Phono x Length'},'CategoricalVar',{'Lex','Phono','Lex x Phono'});
    mdlVals{iChan}{iF}=mdl;
      end
    display(iChan);
end




mdlPvals=zeros(124,46,8);
mdlTvals=zeros(124,46,8);
mdlRvals=zeros(124,46);
mdlBvals=zeros(124,46,8);
mdlMSEvals=zeros(124,46);
for iChan=1:124;
    for iF=1:46
        mdlPvals(iChan,iF,:)=mdlVals{iChan}{iF}.Coefficients.pValue;
        mdlTvals(iChan,iF,:)=mdlVals{iChan}{iF}.Coefficients.tStat;
        mdlBvals(iChan,iF,:)=mdlVals{iChan}{iF}.Coefficients.Estimate;
        mdlRvals(iChan,iF)=mdlVals{iChan}{iF}.Rsquared.Adjusted;
        mdlMSEvals(iChan,iF)=mdlVals{iChan}{iF}.MSE;
    end
    display(iChan)
end