Subject=[];
Subject(1).Name='R0021';
Subject(2).Name='R0026';
Subject(3).Name='R0053';
Subject(4).Name='R0088';
Subject(5).Name='R0182';
Subject(6).Name='R0183';
Subject(7).Name='R0244';
Subject(8).Name='R0370';
Subject(9).Name='R0632';
Subject(10).Name='R0888';
Subject(11).Name='R0960';
Subject(12).Name='R0995';
Subject(13).Name='R0997';

Sent=[];
Sent(1).Name='S1R';
Sent(2).Name='S2R';
Sent(3).Name='S3R';
Sent(4).Name='S1C';
Sent(5).Name='S2C';
Sent(6).Name='S3C';

%addpath(genpath('/vol/sas2b/nim1/MI'));
%addpath(genpath('/vol/sas2b/nim1/AVScripts/'));
addpath(genpath('/vol/sas4a/Greg/MI'));

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

Hemi=[];
Hemi(1).Name='lh';
Hemi(2).Name='rh';
for SN=11:13
    for iHemi=1:2
        for iSent=1:6;
          %  for iP=1:4;
                %load(['/vol/sas2b/nim1/MI/' Subject(SN).Name '/Uber/NEW/' Subject(SN).Name '_' Hemi(iHemi).Name '_' Sent(iSent).Name '_' num2str(iP) '_desc.mat']);
                load(['/vol/sas4a/Greg/MI/' Subject(SN).Name '/Uber/NEW/' Subject(SN).Name '_' Hemi(iHemi).Name '_' Sent(iSent).Name '_RAW.mat']);

               % data1=make_label_datastack(MNE_epoch_info);
               % data2=zeros(size(data1,1),size(data1,2)/4,size(data1,3));
               data1=data(:,501:6500,1:32);
               data2=zeros(size(data1,1),size(data1,2)./4,size(data1,3)); 
              % tic
                for iCh=1:size(data1,1);
                    for iTrial=1:size(data1,3);
                        data2(iCh,:,iTrial)=decimate((sq(data1(iCh,:,iTrial)))',4);
                    end
                end
              %  toc
                
               % data_spec=zeros(size(data2,1),size(data2,3),33,size(data2,2));
              
                
                for iC=1:size(data2,1);
                   % tic
%                     for iTrial=1:size(data2,3);
%                         tmp=sq(data2(iC,:,iTrial));
%                         [wave,period,scale,coi]=basewave4(tmp,250,1,90,5,0);
%                         % [wavepar tmp_spec]=tfwavelet2(tmp,FREQPAR2,250,0);
%                         tmp2(iTrial,:,:)=wave;
%                     end
                         [wave,period,scale,coi]=basewave5(sq(data2(iC,:,:))',250,1,90,5,0);   
                   
                        for iF=1:size(wave,2)
                        tmp3=angle(sq(wave(:,iF,:)));
                      
                        tmp4=reshape(tmp3,1,size(tmp3,1),size(tmp3,2));
                       R1=binr(tmp4,nt,bins,'eqspace');
                        
%                        R1=sq(R1);
%                        for iB=1:bins;
%                            PR(iB)=length(find(R1==(iB-1)));
%                        end
%                        PR=PR./sum(PR);
%                        
%                        for iT=1:length(R1)
%                            for iB=1:bins;
%                            PRS(iB,iT)=length(find(R1(:,iT)==(iB-1)));
%                            end
%                        end
%                       
%                        
%                        PRS=PRS./repmat(sum(PRS,1),4,1);
%                        ii=find(PRS==0);
%                        PRS(ii)=0.000000001;
%                        I1=sum(sum(1/length(PRS).*PRS.*log2(PRS./repmat(PR',1,length(PRS)))));
                      % tic
                        [I1] = information(R1, opts, 'Ish');
                      %  toc
                        I4(iC,iF,:)=I1;
                         end
                    %    toc
               end
                   
                
                
               % save(['/mnt/raid/MI/' Subject(SN).Name '/Uber/NEW/' Subject(SN).Name '_' Hemi(iHemi).Name '_' Sent(iSent).Name '_' num2str(iP) '_WAVELET_I_1.mat'],'scale','period','I4');
                save(['/vol/sas4a/Greg/MI/' Subject(SN).Name '/Uber/NEW/' Subject(SN).Name '_' Hemi(iHemi).Name '_' Sent(iSent).Name '_WAVELET_I_1.mat'],'scale','period','I4');

                clear tmp*
                clear I4
               % clear wavepar
         %   end
        end
    end
end
                
                