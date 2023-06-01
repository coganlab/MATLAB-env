function Trials = procCodes(Task,Codes)
%
%   Trials = procCodes(Task,Codes)
%
%  Task = 'Speech_CovertOvert'
%


Trials = struct([]);
switch Task
  case 'Speech_CovertOvert'
    GoInd = 3:3:size(Codes,1);
    for iTrial = 1:length(GoInd)
      Trials(iTrial).Start = Codes(GoInd(iTrial)-2,1);
      Trials(iTrial).Auditory = Codes(GoInd(iTrial)-1,1);
      Trials(iTrial).Go = Codes(GoInd(iTrial),1);
      Trials(iTrial).StartCode = Codes(GoInd(iTrial)-2,2);
      Trials(iTrial).AuditoryCode = Codes(GoInd(iTrial)-1,2);
      Trials(iTrial).GoCode = Codes(GoInd(iTrial),2);
    end

%  case 'Speech_OvertMime'
%     GoInd = 3:3:size(Codes,1);
%     for iTrial = 1:length(GoInd)
%       Trials(iTrial).Start = Codes(GoInd(iTrial)-2,1);
%       Trials(iTrial).Auditory = Codes(GoInd(iTrial)-1,1);
%       Trials(iTrial).Go = Codes(GoInd(iTrial),1);
%       Trials(iTrial).StartCode = Codes(GoInd(iTrial)-2,2);
%       Trials(iTrial).AuditoryCode = Codes(GoInd(iTrial)-1,2);
%       Trials(iTrial).GoCode = Codes(GoInd(iTrial),2);
%     end
case 'Speech_OvertMime'
  indexSTART=find(Codes(:,2) > 0 & Codes(:,2) <= 21); % was 29, my guess is for added conditions? GBC
   %indexAUDITORY=find(Codes(:,2) >= 26 & Codes(:,2) <= 46);
   %indexGO=find(Codes(:,2) >= 51 & Codes(:,2) <= 71);
   
   INDiTrial=1;
   for iTrial=1:length(indexSTART)
       if indexSTART(iTrial)>(length(Codes)-2)
           catchy=1;
           
           
           
       elseif    Codes((indexSTART(iTrial)+1),2) == (Codes(indexSTART(iTrial),2)+25) && Codes((indexSTART(iTrial)+2),2) == (Codes(indexSTART(iTrial),2)+50);
           
           Trials(INDiTrial).Start = Codes(indexSTART(iTrial),1);
           Trials(INDiTrial).StartCode = Codes(indexSTART(iTrial),2);
           Trials(INDiTrial).Auditory = Codes((indexSTART(iTrial)+1),1);
           Trials(INDiTrial).AuditoryCode = Codes((indexSTART(iTrial)+1),2);
           Trials(INDiTrial).Go = Codes((indexSTART(iTrial)+2),1);
           Trials(INDiTrial).GoCode = Codes((indexSTART(iTrial)+2),2);
           INDiTrial=INDiTrial+1;
       end
   end

   case 'Speech_OvertMimeMove'
  indexSTART=find(Codes(:,2) > 0 & Codes(:,2) <= 24); % was 29, my guess is for added conditions? GBC
   %indexAUDITORY=find(Codes(:,2) >= 26 & Codes(:,2) <= 46);
   %indexGO=find(Codes(:,2) >= 51 & Codes(:,2) <= 71);
   
   INDiTrial=1;
   for iTrial=1:length(indexSTART)
       if indexSTART(iTrial)>(length(Codes)-2)
           catchy=1;
           
           
           
       elseif    Codes((indexSTART(iTrial)+1),2) == (Codes(indexSTART(iTrial),2)+25) && Codes((indexSTART(iTrial)+2),2) == (Codes(indexSTART(iTrial),2)+50);
           
           Trials(INDiTrial).Start = Codes(indexSTART(iTrial),1);
           Trials(INDiTrial).StartCode = Codes(indexSTART(iTrial),2);
           Trials(INDiTrial).Auditory = Codes((indexSTART(iTrial)+1),1);
           Trials(INDiTrial).AuditoryCode = Codes((indexSTART(iTrial)+1),2);
           Trials(INDiTrial).Go = Codes((indexSTART(iTrial)+2),1);
           Trials(INDiTrial).GoCode = Codes((indexSTART(iTrial)+2),2);
           INDiTrial=INDiTrial+1;
       end
   end
   
   
case 'Speech_OvertMime30'
  indexSTART=find(Codes(:,2) > 0 & Codes(:,2) <= 29);
   %indexAUDITORY=find(Codes(:,2) >= 26 & Codes(:,2) <= 46);
   %indexGO=find(Codes(:,2) >= 51 & Codes(:,2) <= 71);
   
   INDiTrial=1;
   for iTrial=1:length(indexSTART)
       if indexSTART(iTrial)>=(length(Codes)-2)
           catchy=1;
           
           
           
       elseif    Codes((indexSTART(iTrial)+1),2) == (Codes(indexSTART(iTrial),2)+30) && Codes((indexSTART(iTrial)+2),2) == (Codes(indexSTART(iTrial),2)+60);
           
           Trials(INDiTrial).Start = Codes(indexSTART(iTrial),1);
           Trials(INDiTrial).StartCode = Codes(indexSTART(iTrial),2);
           Trials(INDiTrial).Auditory = Codes((indexSTART(iTrial)+1),1);
           Trials(INDiTrial).AuditoryCode = Codes((indexSTART(iTrial)+1),2);
           Trials(INDiTrial).Go = Codes((indexSTART(iTrial)+2),1);
           Trials(INDiTrial).GoCode = Codes((indexSTART(iTrial)+2),2);
           INDiTrial=INDiTrial+1;
       end
   end

   case 'Speech_OvertMime20'
  indexSTART=find(Codes(:,2) > 0 & Codes(:,2) <= 29);
   %indexAUDITORY=find(Codes(:,2) >= 26 & Codes(:,2) <= 46);
   %indexGO=find(Codes(:,2) >= 51 & Codes(:,2) <= 71);
   
   INDiTrial=1;
   for iTrial=1:length(indexSTART)
       if indexSTART(iTrial)>=(length(Codes)-2)
           catchy=1;
           
           
           
       elseif    Codes((indexSTART(iTrial)+1),2) == (Codes(indexSTART(iTrial),2)+20) && Codes((indexSTART(iTrial)+2),2) == (Codes(indexSTART(iTrial),2)+20);
           
           Trials(INDiTrial).Start = Codes(indexSTART(iTrial),1);
           Trials(INDiTrial).StartCode = Codes(indexSTART(iTrial),2);
           Trials(INDiTrial).Auditory = Codes((indexSTART(iTrial)+1),1);
           Trials(INDiTrial).AuditoryCode = Codes((indexSTART(iTrial)+1),2);
           Trials(INDiTrial).Go = Codes((indexSTART(iTrial)+2),1);
           Trials(INDiTrial).GoCode = Codes((indexSTART(iTrial)+2),2);
           INDiTrial=INDiTrial+1;
       end
   end
end