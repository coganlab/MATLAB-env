duke;
global experiment
Subject = struct([]);

Subject(1).Name = 'D1'; Subject(1).Day = '260216'; % 160216 is clin 1, 160217 is clin 2
Subject(3).Name = 'D3'; Subject(3).Day = '100916';
Subject(7).Name = 'D7'; Subject(7).Day = '030117';
Subject(8).Name = 'D8'; Subject(8).Day = '030317';
Subject(9).Name = 'D12'; Subject(9).Day = '090917';
Subject(10).Name = 'D13'; Subject(10).Day = '071017';
Subject(11).Name = 'D14'; Subject(11).Day = '101117';
Subject(12).Name= 'D15'; Subject(12).Day = '171217';
Subject(13).Name = 'D16'; Subject(13).Day ='200118';
Subject(14).Name = 'D17'; Subject(14).Day = '180309';
Subject(2).Name = 'S1'; Subject(2).Day = '080318';
Subject(15).Name = 'D20'; Subject(15).Day = '180518';


subj_locations={};
counter=0;
for SN = [9:12,14,15];
   [NUM,TXT,RAW]=xlsread([RECONDIR '/' Subject(SN).Name '/elec_recon/' Subject(SN).Name '_elec_location_radius_3mm.csv']);
   TXT=TXT(2:end,:);
   chanNames=TXT(:,2);
   for iChan=1:length(chanNames)
       for iChan2=1:length(chanNames);
           if strcmp(chanNames{iChan},erase(subj_labels{iChan2+counter},strcat(Subject(SN).Name,'-')))
               subj_locations(counter+iChan2)=TXT(iChan,1);
           end
       end
   end
   counter=counter+length(chanNames);
end
       
   