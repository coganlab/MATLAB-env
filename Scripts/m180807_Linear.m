chanList=1:244;
tRange=[];
fRange=[70:150];

c_exp= 6:1:13;
g_exp = -10:-3:-25;
c_s=2.^c_exp;
g_s=2.^g_exp;
[c,g] = meshgrid(c_s,g_s);
params=[c(:) g(:)];

clear AuditoryAll
clear AuditoryF
for iChan=1:length(chanList);
    tmp=[];
    trialIdx=[];
    for iCond=1:4;
        tmp=cat(1,tmp,Auditory_Spec{iCond}{chanList(iChan)}(:,:,:));
        trialIdx=cat(1,trialIdx,iCond*ones(size(Auditory_Spec{iCond}{chanList(iChan)},1),1));
    end
    [M S]=normfit(sq(mean(tmp(:,1:10,:),2)));
    AuditoryAll=(tmp-repmat(reshape(M,1,1,size(M,2)),size(tmp,1),size(tmp,2),1))./repmat(reshape(S,1,1,size(S,2)),size(tmp,1),size(tmp,2),1);
    
    for iCond=1:2;
        ii1=find(trialIdx==1);
        ii2=find(trialIdx==2);
        ii3=find(trialIdx==3);
        ii4=find(trialIdx==4);
        iiA=find(trialIdx==iCond);
                 AuditoryF{1}{iChan}=cat(1,AuditoryAll(ii1,:,:),AuditoryAll(ii3,:,:));
                 AuditoryF{2}{iChan}=cat(1,AuditoryAll(ii2,:,:),AuditoryAll(ii4,:,:));
        
     %   AuditoryF{iCond}{iChan}=AuditoryAll(iiA,:,:);
    end
       
    %    AuditoryF{1}{iChan}=cat(1,(sq(Auditory_Spec{1}{iChan}(:,tRange,fRange))-M)./S,(sq(Auditory_Spec{2}{iChan}(:,tRange,fRange))-M)./S);
    %    AuditoryF{2}{iChan}=cat(1,(sq(Auditory_Spec{3}{iChan}(:,tRange,fRange))-M)./S,(sq(Auditory_Spec{4}{iChan}(:,tRange,fRange))-M)./S);
   
end
tic
%chanorder=Subject(SN).SM;

% tic
clear trialn
counter=length(chanList);
for iCond=1:2
        for iElec=1:counter
            trialn(iCond,iElec)=size(AuditoryF{iCond}{iElec},1);
        end
 end
    maxtrial=min(min(trialn));
    
    for iTime=1:40;
        AUDCAT=[];
        for iChan=1:length(chanList)
            
            tic
            
            %  AUDCAT2=[];
            
            tRange=iTime;
            %chanorder=shuffle(1:iChanCUM); % for curve
            %   chanorder=shuffle(1:counter);
            %    chanorder=chanorder(1:iChanCUM);
            % chanorder(iChan)=iChan; %=iChanCUM; %iChan;
            % iChan=iChanCUM;
            %  chanorder=1:36;
            
            
            Aud1B=[];
            Aud2B=[];
            for iCond=1:2
                trialorder1=trialn(iCond,iChan);
                trialorder1=shuffle(1:trialorder1);
                trialorder1=trialorder1(1:maxtrial);
                %   Aud1A=log(DataMat.Data{iCond}{chanorder(iChan)}(trialorder1,:));
                %    Aud1A=reshape(Auditory_SpecNW{iCond}{chanorder(iChan)}(trialorder1,tRange,fRange),length(trialorder1),length(tRange)*length(fRange));
                Aud1A=reshape(AuditoryF{iCond}{iChan}(trialorder1,tRange,fRange),length(trialorder1),length(tRange)*length(fRange));
                %    Aud2A=reshape(mean(AuditoryF{iCond}{iChan}(trialorder1,1:10,fRange),2),length(trialorder1),length(tRange)*length(fRange));
                
                %Aud1A=AuditoryF{iCond}{chanorder(iChan)};
                Aud1B=cat(1,Aud1B,Aud1A);
                %    Aud2B=cat(1,Aud2B,Aud2A);
            end
            %   Aud3B=cat(1,Aud1B,Aud2B);
            %  AUDCAT=cat(2,AUDCAT,Aud1B);
            AUDCAT=cat(2,AUDCAT,Aud1B);
            
            
        end
        FullCodeList = 1:2;
        nFullCode = length(FullCodeList);
        
        %     groups=cat(1,1*ones(maxtrial,1),2*ones(maxtrial,1),3*ones(maxtrial,1),4*ones(maxtrial,1),5*ones(maxtrial,1),6*ones(maxtrial,1),7*ones(maxtrial,1));
        %    groups=cat(1,1*ones(maxtrial,1),2*ones(maxtrial,1),3*ones(maxtrial,1),4*ones(maxtrial,1));
        groups=cat(1,1*ones(maxtrial,1),2*ones(maxtrial,1),3*ones(maxtrial,1),4*ones(maxtrial,1));
        groups=cat(1,1*ones(maxtrial,1),2*ones(maxtrial,1)); %,3*ones(maxtrial,1),4*ones(maxtrial,1));

        
        nTrial = length(groups);
        
        comps=2; %iChanCUM;  % NUMBER OF COMPONENTS - = iChanCUM for most stuff (ie 1 comp/elec), 5 for PROD elecs
        % this is where we pick our features...time? freq?
        class = zeros(nTrial,1);
        for iTrial = 1:nTrial
            xLooTrial = AUDCAT(setdiff(1:nTrial,iTrial),:);
            xLooTrial2 = xLooTrial*xLooTrial'; % called?
            [u,s,v] = svd(xLooTrial2);
            vTrial = xLooTrial'*v(:,1:comps);
            xTrial = sq(AUDCAT(iTrial,:));
            %uTrial(iTrial,:) = xTrial(:)'*vTrial;
            TestTrial = xTrial(:)'*vTrial;
            TrainTrial = xLooTrial*vTrial;
            train = setdiff(1:nTrial,iTrial);
            cutoff=3;
            for iC=1:comps;
                [m s]=normfit(abs(TrainTrial(:,iC)));
                iiX=find(abs(TrainTrial(:,iC))>(m+cutoff*s));
                if length(iiX)>0
                    TrainTrial=TrainTrial(setdiff(1:size(TrainTrial,1),iiX),:);
                    train=train(setdiff(1:size(train,2),iiX));
                end
            end
            
            
             class(iTrial) = classify(TestTrial(1,1:comps),TrainTrial(:,1:comps),groups(train));
%             
%              svmstruct = svmtrain(double(groups(train)),double(TrainTrial(:,1:comps)),['-g ' num2str(params(1,2)) ' -c ' num2str(params(1,1))]);
%              svmstruct = fitcsvm(double(groups(train)),double(TrainTrial(:,1:comps)),['-g ' num2str(params(1,2)) ' -c ' num2str(params(1,1))]);
              svmstruct = fitcsvm(TrainTrial(:,1:comps),groups(train));
% 
              [predicted_label accuracy dvals]=svmpredict(0,double(TestTrial(1,1:comps)),svmstruct);
%               class(iTrial)=predicted_label;
            
        end
        
        
        %                 splitIdx=repmat(1:4,1,48);
        %                %    class = zeros(nTrial,1);
        %                 for iTrial = 1:4
        %                     iiS=find(splitIdx==iTrial);
        %                     xLooTrial = AUDCAT(setdiff(1:size(AUDCAT,1),iiS),:);
        %                     xLooTrial2 = xLooTrial*xLooTrial'; % called?
        %                     [u,s,v] = svd(xLooTrial2);
        %                     vTrial = xLooTrial'*v(:,1:comps);
        %
        %                     for iTrial2=1:length(iiS)
        %                     xTrial = sq(AUDCAT(iiS(iTrial2),:));
        %                     %uTrial(iTrial,:) = xTrial(:)'*vTrial;
        %                     TestTrial = xTrial(:)'*vTrial;
        %                     TrainTrial = xLooTrial*vTrial;
        %                     train = setdiff(1:size(AUDCAT,1),iiS);
        %
        %                         class(iTrial,iTrial2) = classify(TestTrial(1,1:comps),TrainTrial(:,1:comps),groups(train));
        %                     end
        %                 end
        
        
        Pmatrix=zeros(2,2);
        counter2=0;
        for ii=1:2
            val1=class(counter2+1:counter2+maxtrial);
            for ii2=1:2
                val2=find(val1==ii2);
                Pmatrix(ii,ii2)=length(val2)./(maxtrial);
            end
            counter2=counter2+maxtrial;
        end
        PmatrixFULL(:,:,iTime)=Pmatrix;
        display(iTime)
        %  toc
        
        toc
        %     display(['iTime = ' num2str(iTime)]);
        %save([NYUMCDIR '/classifier/Data/Allway_ClassPROD_PROD_5COMP_1500ms_5080_OUT12_130627.mat'],'PmatrixFULL');
        % filename is usually
        % Allway_Class<ELECCAT>_<EPOCH>_<NUMBERofCOMPS>COMP_<TIMEDURATION>_<EPOCHWINDOW>_<OUTLIERTHRESH>_DATE.mat
        % eg 'Allway_ClassPROD_PROD_5COMP_1500ms_5080_OUT12_130627.mat' is for
        % PROD elecs during the prod epoch, using 5 SVD comps, for 1500 ms, from 5080 time
        % points, with an outliner thresh of 12 on June 27/13
    end
    %       display(['Chan = ' num2str(iChan)])
    %     end
    
    for iTime=1:40;avgC(iTime)=mean(diag(sq(PmatrixFULL(:,:,iTime))));end;

