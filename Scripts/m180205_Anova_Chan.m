% anova?



fRange=70:150;
tRange=21:30;
for iChan=1:120;
    for iCond=1:4
        tNums(iCond)=size(Auditory_Spec{iCond}{iChan},1);
    end
    tNumsMin=min(tNums);
    F1=[];
    F2=[];
    data=[];
    for iCond=1:4
        idx=shuffle(1:size(Auditory_Spec{iCond}{iChan},1));
        idx=idx(1:tNumsMin);
        tmp=sq(mean(mean(Auditory_Spec{iCond}{iChan}(idx,tRange,fRange)./repmat(mean(mean(Auditory_Spec{iCond}{iChan}(idx,1:10,fRange),2),1),length(idx),length(tRange),1),2),3));
        data=cat(1,data,tmp);
        %data=cat(1,data,sq(mean(mean(Auditory_Spec{iCond}{iChan}(idx,tRange,fRange),2),3)));
        if iCond==1 || iCond==3
        F1=cat(1,F1,zeros(length(idx),1));
        elseif iCond==2 || iCond==4
        F1=cat(1,F1,ones(length(idx),1));
        end
        if iCond<=2
        F2=cat(1,F2,zeros(length(idx),1));
        elseif iCond>=3
        F2=cat(1,F2,ones(length(idx),1));
        end
   FS=cat(2,F1,F2);
    end
    
   P=anovan(data,FS,'model','interaction','display','off');
   
   Pvals(iChan,:)=P;
end

% figure;plot(log(Pvals(:,1)));hold on;plot(log(.01*ones(1,120)),'r--');
% title('Lex');
% 
% figure;plot(log(Pvals(:,2)));hold on;plot(log(.01*ones(1,120)),'r--');
% title('Task');
% 
% figure;plot(log(Pvals(:,3)));hold on;plot(log(.01*ones(1,120)),'r--');
% title('Lex x Task');
% %[stats] = rm_anova2(data',subj,F1',F2',{'Lex','Task'});


SigLex=find(Pvals(:,1)<0.05)
SigTask=find(Pvals(:,2)<0.05)
SigInter=find(Pvals(:,3)<0.05)


        