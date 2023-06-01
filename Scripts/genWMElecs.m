function [iiWM, iiNWM, subj_labels_loc] = genWMElecs(Subject,subj_labels)  
global RECONDIR
%subj_labels={};
counterChan=0;
subj_labels_loc={};
%subj_labels_loc2={};
    filedir=[RECONDIR '/' Subject '/elec_recon/'];
    filename=[filedir Subject '_elec_location_radius_3mm_aparc+aseg.mgz.csv'];
    %  filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm_aparc.a2009s+aseg.mgz.csv'];
    %filename=[filedir Subject(SNList(iSN)).Name '_elec_location_radius_3mm.csv'];
    
    [NUM,TXT,RAW]=xlsread(filename);
    for iElec=1:length(TXT)-1
        elec_nameT=strcat(Subject, '-',TXT(iElec+1,2));
        for iElecS=1:length(subj_labels);
            if strcmp(elec_nameT,subj_labels{iElecS});
                
                %                 TXTidx=[1,3,5,7,9];
                %                 for iTXT=1:length(TXTidx)
                iN=3;
                while (contains(TXT(iElec+1,iN),'White-Matter')...
                        || contains(TXT(iElec+1,iN),'Unknown')...
                        || contains(TXT(iElec+1,iN),'unknown')...
                        || contains(TXT(iElec+1,iN),'hypointensities')...
                        || contains(TXT(iElec+1,iN),'Ventricle')...
                        || contains(TXT(iElec+1,iN),'Vent')...
                        || contains(TXT(iElec+1,iN),'[]')  ) ...
                        && iN<=7 && NUM(iElec,iN-2)>0.5
                    %|| NUM(iElec,iN-2)<0.5
                    iN=iN+2;

                end
                if strlength(TXT(iElec+1,5))<=1
                    subj_labels_loc{iElecS}='Unknown';
                else
                subj_labels_loc{iElecS}=TXT(iElec+1,iN); % label output
                end
            end
        end
    end


%                 
%               
% 
% for iElec=1:length(subj_labels_loc);
%     subj_labels_loc2(iElec)=subj_labels_loc{iElec};
% end
% subj_labels_loc3=unique(subj_labels_loc2);

counterNWM=0;
subj_labels_WM=[];
subj_labels_NWM=[];
counterWM=0;
for iChan=1:length(subj_labels_loc)
    %   if contains(subj_labels_loc{iChan},'White-Matter') || strcmp(subj_labels_loc{iChan},' ')
    if  contains(char(subj_labels_loc{iChan}),' ') ...
            || contains(char(subj_labels_loc{iChan}),'White-Matter')...
            || contains(char(subj_labels_loc{iChan}),'white-matter') ...
            || contains(char(subj_labels_loc{iChan}),'Unknown') ...
            || contains(char(subj_labels_loc{iChan}),'unknown') ...
            || contains(char(subj_labels_loc{iChan}),'hypointensities') ...
            || contains(char(subj_labels_loc{iChan}),'Vent') ...
            || contains(char(subj_labels_loc{iChan}),'[]') ...
            || isempty(subj_labels_loc{iChan})
        subj_labels_WM(iChan)=1;
        counterWM=counterWM+1;
        %  subj_labels_NWM(iChan)=0;
    else
        subj_labels_WM(iChan)=0;
        %   subj_labels_NWM(counterNWM+1)=iChan;
        counterNWM=counterNWM+1;
    end
end

iiWM=find(subj_labels_WM==1);

iiNWM=setdiff(1:length(subj_labels_loc),iiWM);

            

        