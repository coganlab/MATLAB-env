clear all
% ROI
% Subjects
Subject=[];
Subject(1).Name='R0021';
Subject(2).Name='R0026';
Subject(3).Name='R0053';
Subject(4).Name='R0088';
Subject(5).Name='R0182';
Subject(6).Name='R0183';
Subject(7).Name='R0244';
Hemi{1}='LH';
Hemi{2}='RH';

Sent=[];
Sent(1).Name='S1R';
Sent(2).Name='S2R';
Sent(3).Name='S3R';
Sent(4).Name='S1C';
Sent(5).Name='S2C';
Sent(6).Name='S3C';

addpath(genpath('/mnt/raid/MI'));
make_ibtb;
lsec=6;
ntrials=32;
nt=ntrials*(ones(1500,1));
%nt=ones(lsec*srate/decifactor,1);
%I=find(nt==1);
%nt(I)=ntrials;
%S=[1:lsec*srate/decifactor];
opts.method='dr'
opts.bias='qe'
opts.nt=nt;
bins=4;
opts.btsp=20;

% WITHIN!
for SN=5:7
    for iHemi=1:1
        load(['/mnt/raid/MI/' Subject(SN).Name '/coordfiles' Hemi{iHemi} 'ICO3.mat'])
        load(['/mnt/raid/MI/' Subject(SN).Name '/coordfiles' Hemi{iHemi+1} 'ICO3.mat'])
        
        [verticesL, labelL, colortableL]=read_annotation(['/mnt/raid/MI/' Subject(SN).Name '/label/lh.aparc.annot']);
        
        [verticesR, labelR, colortableR]=read_annotation(['/mnt/raid/MI/' Subject(SN).Name '/label/rh.aparc.annot']);
        
        idx_STGL=find(labelL==colortableL.table(31,5));
        idx_STGR=find(labelR==colortableR.table(31,5));
        
        counter=0;
        for iS=1:length(idx_STGL)
            clear tmp
            tmp=find(CHANNAMESLH==idx_STGL(iS));
            if length(tmp)>0% && length(tmp)<2
                STGchans_LH(counter+1)=tmp;
                counter=counter+1;
            end
        end
        
        counter=0;
        for iS=1:length(idx_STGR)
            clear tmp
            tmp=find(CHANNAMESRH==idx_STGR(iS));
            if length(tmp)>0% && length(tmp)<2
                STGchans_RH(counter+1)=tmp;
                counter=counter+1;
            end
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        for iSent=1:3;
            dataallRL=[];
            dataallCL=[];
            dataallRR=[];
            dataallCR=[];
            % LH R
            for iP=1:4;
                
                load(['/mnt/raid/MI/' Subject(SN).Name '/Uber/NEW/' Subject(SN).Name '_' Hemi{iHemi} '_' Sent(iSent).Name '_' num2str(iP) '_desc.mat']);
                data1=make_label_datastack(MNE_epoch_info);
                % data2=zeros(size(data1,1),size(data1,2)/4,size(data1,3));
                data1=data1(:,501:6500,:);
                data2=zeros(size(data1,1),size(data1,2)./4,size(data1,3));
                % tic
                for iCh=1:size(data1,1);
                    for iTrial=1:size(data1,3);
                        data2(iCh,:,iTrial)=decimate((sq(data1(iCh,:,iTrial)))',4);
                    end
                end
                dataallRL=cat(1,dataallRL,data2);
            end
            
            dataallRLSTG=dataallRL(STGchans_LH,:,:);
            clear dataallRL
            % LH C
            for iP=1:4;
                
                load(['/mnt/raid/MI/' Subject(SN).Name '/Uber/NEW/' Subject(SN).Name '_' Hemi{iHemi} '_' Sent(iSent+3).Name '_' num2str(iP) '_desc.mat']);
                data1=make_label_datastack(MNE_epoch_info);
                % data2=zeros(size(data1,1),size(data1,2)/4,size(data1,3));
                data1=data1(:,501:6500,:);
                data2=zeros(size(data1,1),size(data1,2)./4,size(data1,3));
                % tic
                for iCh=1:size(data1,1);
                    for iTrial=1:size(data1,3);
                        data2(iCh,:,iTrial)=decimate((sq(data1(iCh,:,iTrial)))',4);
                    end
                end
                dataallCL=cat(1,dataallCL,data2);
            end
            
            dataallCLSTG=dataallCL(STGchans_LH,:,:);
            clear dataallCL
            %   RH R
            for iP=1:4;
                
                load(['/mnt/raid/MI/' Subject(SN).Name '/Uber/NEW/' Subject(SN).Name '_' Hemi{iHemi+1} '_' Sent(iSent).Name '_' num2str(iP) '_desc.mat']);
                data1=make_label_datastack(MNE_epoch_info);
                % data2=zeros(size(data1,1),size(data1,2)/4,size(data1,3));
                data1=data1(:,501:6500,:);
                data2=zeros(size(data1,1),size(data1,2)./4,size(data1,3));
                % tic
                for iCh=1:size(data1,1);
                    for iTrial=1:size(data1,3);
                        data2(iCh,:,iTrial)=decimate((sq(data1(iCh,:,iTrial)))',4);
                    end
                end
                dataallRR=cat(1,dataallRR,data2);
            end
            
            dataallRRSTG=dataallRR(STGchans_RH,:,:);
            clear dataallRR
            % RH C
            for iP=1:4;
                
                load(['/mnt/raid/MI/' Subject(SN).Name '/Uber/NEW/' Subject(SN).Name '_' Hemi{iHemi+1} '_' Sent(iSent+3).Name '_' num2str(iP) '_desc.mat']);
                data1=make_label_datastack(MNE_epoch_info);
                % data2=zeros(size(data1,1),size(data1,2)/4,size(data1,3));
                data1=data1(:,501:6500,:);
                data2=zeros(size(data1,1),size(data1,2)./4,size(data1,3));
                % tic
                for iCh=1:size(data1,1);
                    for iTrial=1:size(data1,3);
                        data2(iCh,:,iTrial)=decimate((sq(data1(iCh,:,iTrial)))',4);
                    end
                end
                dataallCR=cat(1,dataallCR,data2);
            end
            
            dataallCRSTG=dataallCR(STGchans_RH,:,:);
            clear dataallCR
            
            
            dataallRLSTG_Spec=zeros(size(dataallRLSTG,1),size(dataallRLSTG,3),33,size(dataallRLSTG,2));
            dataallCLSTG_Spec=zeros(size(dataallCLSTG,1),size(dataallCLSTG,3),33,size(dataallCLSTG,2));
            for iC=1:size(dataallRLSTG,1);
                
                for iTrial=1:size(dataallRLSTG,3);
                    tmp=sq(dataallRLSTG(iC,:,iTrial));
                    [wave,period,scale,coi]=basewave4(tmp,250,1,90,5,0);
                    dataallRLSTG_Spec(iC,iTrial,:,:)=wave;
                    
                    tmp=sq(dataallCLSTG(iC,:,iTrial));
                    [wave,period,scale,coi]=basewave4(tmp,250,1,90,5,0);
                    dataallCLSTG_Spec(iC,iTrial,:,:)=wave;
                end
                display(iC)
            end
            dataallRRSTG_Spec=zeros(size(dataallRRSTG,1),size(dataallRRSTG,3),33,size(dataallRRSTG,2));
            dataallCRSTG_Spec=zeros(size(dataallCRSTG,1),size(dataallCRSTG,3),33,size(dataallCRSTG,2));
            
            for iC=1:size(dataallRRSTG,1)
                for iTrial=1:size(dataallRRSTG,3);
                    tmp=sq(dataallRRSTG(iC,:,iTrial));
                    [wave,period,scale,coi]=basewave4(tmp,250,1,90,5,0);
                    dataallRRSTG_Spec(iC,iTrial,:,:)=wave;
                    
                    tmp=sq(dataallCRSTG(iC,:,iTrial));
                    [wave,period,scale,coi]=basewave4(tmp,250,1,90,5,0);
                    dataallCRSTG_Spec(iC,iTrial,:,:)=wave;
                end
                display(iC)
            end
            
            % within L loop
            for iC=1:size(dataallRLSTG_Spec,1)
                for iC2=iC+1:size(dataallRLSTG_Spec,1)
                    for iF=1:18
                        tic
                        tmpR1=angle(sq(dataallRLSTG_Spec(iC,:,iF,:)));
                        tmpR2=angle(sq(dataallRLSTG_Spec(iC2,:,iF,:)));
                        tmpC1=angle(sq(dataallCLSTG_Spec(iC,:,iF,:)));
                        tmpC2=angle(sq(dataallCLSTG_Spec(iC2,:,iF,:)));
                        
                        tmpR1B=reshape(tmpR1,1,size(tmpR1,1),size(tmpR1,2));
                        tmpR2B=reshape(tmpR2,1,size(tmpR2,1),size(tmpR2,2));
                        tmpC1B=reshape(tmpC1,1,size(tmpC1,1),size(tmpC1,2));
                        tmpC2B=reshape(tmpC2,1,size(tmpC2,1),size(tmpC2,2));
                        
                        tmpRR=cat(1,tmpR1B,tmpR2B);
                        tmpCC=cat(1,tmpC1B,tmpC2B);
                        tmpRC=cat(1,tmpR1B,tmpC2B);
                        tmpCR=cat(1,tmpC1B,tmpR2B);
                        
                        
                     %   R_RR=binr(tmpRR,nt,bins,'eqspace');
                     %   R_CC=binr(tmpCC,nt,bins,'eqspace');
                        R_RC=binr(tmpRC,nt,bins,'eqspace');
                        R_CR=binr(tmpCR,nt,bins,'eqspace');
                        
                        
%                         [ISH ILIN ICI ICDSH] = information(R_RR, opts, 'Ish','ILIN','ICI','ICDsh');
%                         ISH_RR_LH(iC,iC2,iF,:)=ISH;
%                         ILIN_RR_LH(iC,iC2,iF,:)=ILIN;
%                         ICI_RR_LH(iC,iC2,iF,:)=ICI;
%                         ICDsh_RR_LH(iC,iC2,iF,:)=ICDSH;
%                         clear ISH ILIN ICI ICDSH
                        
%                         [ISH ILIN ICI ICDSH] = information(R_CC, opts, 'Ish','ILIN','ICI','ICDsh');
%                         ISH_CC_LH(iC,iC2,iF,:)=ISH;
%                         ILIN_CC_LH(iC,iC2,iF,:)=ILIN;
%                         ICI_CC_LH(iC,iC2,iF,:)=ICI;
%                         ICDsh_CC_LH(iC,iC2,iF,:)=ICDSH;
%                         clear ISH ILIN ICI ICDSH
                        
                        [ISH ILIN ICI ICDSH] = information(R_RC, opts, 'Ish','ILIN','ICI','ICDsh');
                        ISH_RC_LH(iC,iC2,iF,:)=ISH;
                        ILIN_RC_LH(iC,iC2,iF,:)=ILIN;
                        ICI_RC_LH(iC,iC2,iF,:)=ICI;
                        ICDsh_RC_LH(iC,iC2,iF,:)=ICDSH;
                        clear ISH ILIN ICI ICDSH
                        
                        [ISH ILIN ICI ICDSH] = information(R_CR, opts, 'Ish','ILIN','ICI','ICDsh');
                        ISH_CR_LH(iC,iC2,iF,:)=ISH;
                        ILIN_CR_LH(iC,iC2,iF,:)=ILIN;
                        ICI_CR_LH(iC,iC2,iF,:)=ICI;
                        ICDsh_CR_LH(iC,iC2,iF,:)=ICDSH;
                        clear ISH ILIN ICI ICDSH
                        toc
                    end
                end
            end
            
            % within R loop
            for iC=1:size(dataallRRSTG_Spec,1)
                for iC2=iC+1:size(dataallRRSTG_Spec,1)
                    for iF=1:18
                        
                        tmpR1=angle(sq(dataallRRSTG_Spec(iC,:,iF,:)));
                        tmpR2=angle(sq(dataallRRSTG_Spec(iC2,:,iF,:)));
                        tmpC1=angle(sq(dataallCRSTG_Spec(iC,:,iF,:)));
                        tmpC2=angle(sq(dataallCRSTG_Spec(iC2,:,iF,:)));
                        
                        tmpR1B=reshape(tmpR1,1,size(tmpR1,1),size(tmpR1,2));
                        tmpR2B=reshape(tmpR2,1,size(tmpR2,1),size(tmpR2,2));
                        tmpC1B=reshape(tmpC1,1,size(tmpC1,1),size(tmpC1,2));
                        tmpC2B=reshape(tmpC2,1,size(tmpC2,1),size(tmpC2,2));
                        
                        tmpRR=cat(1,tmpR1B,tmpR2B);
                        tmpCC=cat(1,tmpC1B,tmpC2B);
                        tmpRC=cat(1,tmpR1B,tmpC2B);
                        tmpCR=cat(1,tmpC1B,tmpR2B);
                        
                        
                      %  R_RR=binr(tmpRR,nt,bins,'eqspace');
                      %  R_CC=binr(tmpCC,nt,bins,'eqspace');
                        R_RC=binr(tmpRC,nt,bins,'eqspace');
                        R_CR=binr(tmpCR,nt,bins,'eqspace');
                        
                        
%                         [ISH ILIN ICI ICDSH] = information(R_RR, opts, 'Ish','ILIN','ICI','ICDsh');
%                         ISH_RR_RH(iC,iC2,iF,:)=ISH;
%                         ILIN_RR_RH(iC,iC2,iF,:)=ILIN;
%                         ICI_RR_RH(iC,iC2,iF,:)=ICI;
%                         ICDsh_RR_RH(iC,iC2,iF,:)=ICDSH;
%                         clear ISH ILIN ICI ICDSH
%                         
%                         [ISH ILIN ICI ICDSH] = information(R_CC, opts, 'Ish','ILIN','ICI','ICDsh');
%                         ISH_CC_RH(iC,iC2,iF,:)=ISH;
%                         ILIN_CC_RH(iC,iC2,iF,:)=ILIN;
%                         ICI_CC_RH(iC,iC2,iF,:)=ICI;
%                         ICDsh_CC_RH(iC,iC2,iF,:)=ICDSH;
%                         clear ISH ILIN ICI ICDSH
                        
                        [ISH ILIN ICI ICDSH] = information(R_RC, opts, 'Ish','ILIN','ICI','ICDsh');
                        ISH_RC_RH(iC,iC2,iF,:)=ISH;
                        ILIN_RC_RH(iC,iC2,iF,:)=ILIN;
                        ICI_RC_RH(iC,iC2,iF,:)=ICI;
                        ICDsh_RC_RH(iC,iC2,iF,:)=ICDSH;
                        clear ISH ILIN ICI ICDSH
                        
                        [ISH ILIN ICI ICDSH] = information(R_CR, opts, 'Ish','ILIN','ICI','ICDsh');
                        ISH_CR_RH(iC,iC2,iF,:)=ISH;
                        ILIN_CR_RH(iC,iC2,iF,:)=ILIN;
                        ICI_CR_RH(iC,iC2,iF,:)=ICI;
                        ICDsh_CR_RH(iC,iC2,iF,:)=ICDSH;
                        clear ISH ILIN ICI ICDSH
                    end
                end
            end
            
            
            % Across loop
            for iC=1:size(dataallRLSTG_Spec,1)
                for iC2=iC+1:size(dataallRRSTG_Spec,1)
                    for iF=1:18
                        
                        tmpR1=angle(sq(dataallRLSTG_Spec(iC,:,iF,:)));
                        tmpR2=angle(sq(dataallRRSTG_Spec(iC2,:,iF,:)));
                        tmpC1=angle(sq(dataallCLSTG_Spec(iC,:,iF,:)));
                        tmpC2=angle(sq(dataallCRSTG_Spec(iC2,:,iF,:)));
                        
                        tmpR1B=reshape(tmpR1,1,size(tmpR1,1),size(tmpR1,2));
                        tmpR2B=reshape(tmpR2,1,size(tmpR2,1),size(tmpR2,2));
                        tmpC1B=reshape(tmpC1,1,size(tmpC1,1),size(tmpC1,2));
                        tmpC2B=reshape(tmpC2,1,size(tmpC2,1),size(tmpC2,2));
                        
                        tmpRR=cat(1,tmpR1B,tmpR2B);
                        tmpCC=cat(1,tmpC1B,tmpC2B);
                        tmpRC=cat(1,tmpR1B,tmpC2B);
                        tmpCR=cat(1,tmpC1B,tmpR2B);
                        
                        
                     %   R_RR=binr(tmpRR,nt,bins,'eqspace');
                     %   R_CC=binr(tmpCC,nt,bins,'eqspace');
                        R_RC=binr(tmpRC,nt,bins,'eqspace');
                        R_CR=binr(tmpCR,nt,bins,'eqspace');
                        
                        
%                         [ISH ILIN ICI ICDSH] = information(R_RR, opts, 'Ish','ILIN','ICI','ICDsh');
%                         ISH_RR_Across(iC,iC2,iF,:)=ISH;
%                         ILIN_RR_Across(iC,iC2,iF,:)=ILIN;
%                         ICI_RR_Across(iC,iC2,iF,:)=ICI;
%                         ICDsh_RR_Across(iC,iC2,iF,:)=ICDSH;
%                         clear ISH ILIN ICI ICDSH
%                         
%                         [ISH ILIN ICI ICDSH] = information(R_CC, opts, 'Ish','ILIN','ICI','ICDsh');
%                         ISH_CC_Across(iC,iC2,iF,:)=ISH;
%                         ILIN_CC_Across(iC,iC2,iF,:)=ILIN;
%                         ICI_CC_Across(iC,iC2,iF,:)=ICI;
%                         ICDsh_CC_Across(iC,iC2,iF,:)=ICDSH;
%                         clear ISH ILIN ICI ICDSH
                        
                        [ISH ILIN ICI ICDSH] = information(R_RC, opts, 'Ish','ILIN','ICI','ICDsh');
                        ISH_RC_Across(iC,iC2,iF,:)=ISH;
                        ILIN_RC_Across(iC,iC2,iF,:)=ILIN;
                        ICI_RC_Across(iC,iC2,iF,:)=ICI;
                        ICDsh_RC_Across(iC,iC2,iF,:)=ICDSH;
                        clear ISH ILIN ICI ICDSH
                        
                        [ISH ILIN ICI ICDSH] = information(R_CR, opts, 'Ish','ILIN','ICI','ICDsh');
                        ISH_CR_Across(iC,iC2,iF,:)=ISH;
                        ILIN_CR_Across(iC,iC2,iF,:)=ILIN;
                        ICI_CR_Across(iC,iC2,iF,:)=ICI;
                        ICDsh_CR_Across(iC,iC2,iF,:)=ICDSH;
                        clear ISH ILIN ICI ICDSH
                    end
                end
            end
            
            
            save(['/mnt/raid/MI/' Subject(SN).Name '/Uber/NEW/' Subject(SN).Name '_' Sent(iSent).Name '_WAVELET_I_1_COMBO_STG_HEMI_F.mat'],'scale','period','ISH_*','ILIN_*','ICI_*','ICDsh_*');
            clear tmp*
            clear I4
        end
    end
end
