function TD = getStateCodes(evs,TD,Ind_StartOn,Task,CurrentTask);
%
%  TD = getStateCodes(evs,TD,Ind_StartOn,Task);
%

disp('Inside getStateCodes')

Task;

switch Task

    case 'Task Control v2.8'
        CODE.StartOn = 1;
        CODE.StartAq = 2;
        CODE.TargetOn = 3;
        CODE.Go = 4;
        CODE.TargetAq =5;
        CODE.Success = 7;
        CODE.Abort = 8;

        disp('Finding StartAq')
        StartAq = evs(3,Ind_StartOn+1) - StartOn;
        TD.StartAq(TD.currentTrial) = StartAq;
        disp('Finding TargetOn')
        TargetOn = evs(3,find(evs(2,:)==CODE.TargetOn)) - StartOn;
        TD.TargetOn(TD.currentTrial) = TargetOn;
        if ~strcmp(CurrentTask,'Microstim')
            disp('Finding Go')
            Go = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            TD.Go(TD.currentTrial) = Go;
            disp('Finding TargetAq')
            TargetAq = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            TD.TargetAq(TD.currentTrial) = TargetAq;
        end
        %  Trial End with respect to circular buffer time
        Ind_Success = find(evs(2,:)==CODE.Success);
        End = evs(3,Ind_Success);

    case 'Task Control v2.10'
        disp('Task Control v2.10')
        CODE.StartOn = 1;
        CODE.StartAq = 2;
        CODE.TargetOn = 3;
        CODE.Go = 4;
        CODE.TargetAq =5;
        CODE.Success = 7;
        CODE.Abort = 8;
        CODE.InstOn = 6;
        CODE.TargetOff = 9;
        CODE.TargetRet = 10;
        StartOn = evs(3,Ind_StartOn);
        evs = evs(:,Ind_StartOn+1:end)
        disp('Finding StartAq')
        StartAq = evs(3,1) - StartOn;
        TD.StartAq(TD.currentTrial) = StartAq;
        disp('Finding TargetOn')
        TargetOn = evs(3,find(evs(2,:)==CODE.TargetOn)) - StartOn;
        TD.TargetOn(TD.currentTrial) = TargetOn;
        if strfind(CurrentTask,'Memory');
            disp('Finding TargetOff')
            TargetOff = evs(3,find(evs(2,:)==CODE.TargetOff)) - StartOn;
            TD.TargetOff(TD.currentTrial) = TargetOff;
            disp('Finding TargetRet')
            TargetRet = evs(3,find(evs(2,:)==CODE.TargetRet)) - StartOn;
            TD.TargetRet(TD.currentTrial) = TargetRet;
        end
        if find(evs(2,:)==CODE.InstOn)
            TD.InstOn = evs(3,find(evs(2,:)==CODE.InstOn)) - StartOn;
        end
        if ~strcmp(CurrentTask,'Microstim')
            disp('Finding Go')
            Go = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            TD.Go(TD.currentTrial) = Go;
            disp('Finding TargetAq')
            TargetAq = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            TD.TargetAq(TD.currentTrial) = TargetAq;
        end
        %  Trial End with respect to circular buffer time
        Ind_Success = find(evs(2,:)==CODE.Success);
        End = evs(3,Ind_Success);

    case {'Task Control v3.00','Task Control v3.01','Task Control v3.03','Task Control v3.04','Task Control v3.05','Task Control v3.06'}
        disp('Task Control v3.00-v3.06')
        CODE.StartOn = 1;
        CODE.StartAq = 2;
        CODE.TargetOn = 3;
        CODE.Go = 4;
        CODE.TargetAq =5;
        CODE.Success = 7;
        CODE.Abort = 8;
        CODE.InstOn = 6;
        CODE.TargetOff = 9;
        CODE.TargetRet = 10;
        CODE.ReachGo = 11;
        CODE.SaccadeGo = 12;
        CODE.ReachAq = 13;
        CODE.SaccadeAq = 14;
        StartOn = evs(3,Ind_StartOn);                 
        evs = evs(:,Ind_StartOn+1:end)
        disp('Finding StartAq')
        StartAq = evs(3,1) - StartOn;
        TD.StartAq(TD.currentTrial) = StartAq;
        disp('Finding TargetOn')
        TargetOn = evs(3,find(evs(2,:)==CODE.TargetOn)) - StartOn;
        TD.TargetOn(TD.currentTrial) = TargetOn;
        if strfind(CurrentTask,'Memory');
            disp('Finding TargetOff')
            TargetOff = evs(3,find(evs(2,:)==CODE.TargetOff)) - StartOn;
            TD.TargetOff(TD.currentTrial) = TargetOff;
            disp('Finding TargetRet')
            TargetRet = evs(3,find(evs(2,:)==CODE.TargetRet)) - StartOn;
            TD.TargetRet(TD.currentTrial) = TargetRet;
        end
        if find(evs(2,:)==CODE.InstOn)
            disp('Assigning InstOn')
            TD.InstOn = evs(3,find(evs(2,:)==CODE.InstOn)) - StartOn;
        end
        if find(evs(2,:)==CODE.SaccadeGo)
            TD.SaccadeGo = evs(3,find(evs(2,:)==CODE.SaccadeGo)) - StartOn;
        end
        if find(evs(2,:)==CODE.SaccadeAq)
            TD.SaccadeAq = evs(3,find(evs(2,:)==CODE.SaccadeAq)) - StartOn;
        end
        if find(evs(2,:)==CODE.ReachGo)
            TD.ReachGo = evs(3,find(evs(2,:)==CODE.ReachGo)) - StartOn;
        end
        if find(evs(2,:)==CODE.ReachAq)
            TD.ReachAq = evs(3,find(evs(2,:)==CODE.ReachAq)) - StartOn;
        end
        strfind(CurrentTask,'then')
        if ~strcmp(CurrentTask,'Microstim') && length(strfind(CurrentTask,'then'))==0
            disp('Finding Go')
            Go = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            TD.Go(TD.currentTrial) = Go;
            disp('Finding TargetAq')
            TargetAq = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            TD.TargetAq(TD.currentTrial) = TargetAq;
        end
        %  Trial End with respect to circular buffer time
        Ind_Success = find(evs(2,:)==CODE.Success);
        TD.End(TD.currentTrial) = evs(3,Ind_Success);

    
    case {'Task Control v3.07','Task Control v3.08','Task Control v3.09','Task Control v3.10','Task Control v3.11','Task Control v3.12','Task Control v3.13','Task Control v3.14','Task Control v3.15','Task Control v3.16'}
        disp('Task Control v3.07-v3.16')
        CODE.StartOn = 1;
        CODE.StartAq = 2;
        CODE.TargetOn = 3;
        CODE.Go = 4;
        CODE.TargetAq =5;
        CODE.Success = 7;
        CODE.Abort = 8;
        CODE.InstOn = 6;
        CODE.TargetOff = 9;
        CODE.TargetRet = 10;
        CODE.ReachGo = 11;
        CODE.SaccadeGo = 12;
        CODE.ReachAq = 13;
        CODE.SaccadeAq = 14;
        StartOn = evs(3,Ind_StartOn);                 
        evs = evs(:,Ind_StartOn+1:end)
        disp('Finding StartAq')
        StartAq = evs(3,1) - StartOn;
        TD.StartAq(TD.currentTrial) = StartAq;
        disp('Finding TargetOn')
        if strfind(CurrentTask,'Target Onset Asynchrony');
            TargetOn = evs(3,find(evs(2,:)==CODE.SaccadeGo)) - StartOn;
        else
            TargetOn = evs(3,find(evs(2,:)==CODE.TargetOn)) - StartOn;
        end
        TD.TargetOn(TD.currentTrial) = TargetOn;
        if strfind(CurrentTask,'Memory');
            disp('Finding TargetOff')
            TargetOff = evs(3,find(evs(2,:)==CODE.TargetOff)) - StartOn;
            TD.TargetOff(TD.currentTrial) = TargetOff;
            disp('Finding TargetRet')
            TargetRet = evs(3,find(evs(2,:)==CODE.TargetRet)) - StartOn;
            TD.TargetRet(TD.currentTrial) = TargetRet;
        end
        if find(evs(2,:)==CODE.InstOn)
            disp('Assigning InstOn')
            TD.InstOn = evs(3,find(evs(2,:)==CODE.InstOn)) - StartOn;
        end
        if find(evs(2,:)==CODE.SaccadeGo)
            TD.SaccadeGo = evs(3,find(evs(2,:)==CODE.SaccadeGo)) - StartOn;
        end
        if find(evs(2,:)==CODE.SaccadeAq)
            TD.SaccadeAq = evs(3,find(evs(2,:)==CODE.SaccadeAq)) - StartOn;
        end
        if find(evs(2,:)==CODE.ReachGo)
            TD.ReachGo = evs(3,find(evs(2,:)==CODE.ReachGo)) - StartOn;
        end
        if find(evs(2,:)==CODE.ReachAq)
            TD.ReachAq = evs(3,find(evs(2,:)==CODE.ReachAq)) - StartOn;
        end
        strfind(CurrentTask,'then')
        if ~strcmp(CurrentTask,'Microstim') && length(strfind(CurrentTask,'then'))==0 && length(strfind(CurrentTask,'Asynchrony'))==0
            disp('Finding Go')
            Go = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            TD.Go(TD.currentTrial) = Go;
            disp('Finding TargetAq')
            TargetAq = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            TD.TargetAq(TD.currentTrial) = TargetAq;
        end
        %  Trial End with respect to circular buffer time
        Ind_Success = find(evs(2,:)==CODE.Success);
        TD.End(TD.currentTrial) = evs(3,Ind_Success);

    case {'Task Control v3.17','Task Control v3.18','Task Control v3.19'}
        disp('Task Control v3.17-19')
        CODE.StartOn = 1;
        CODE.StartAq = 2;
        CODE.TargetOn = 3;
        CODE.Go = 4;
        CODE.TargetAq =5;
        CODE.Success = 7;
        CODE.Abort = 8;
        CODE.InstOn = 6;
        CODE.TargetOff = 9;
        CODE.TargetRet = 10;
        CODE.ReachGo = 11;
        CODE.SaccadeGo = 12;
        CODE.ReachAq = 13;
        CODE.SaccadeAq = 14;
        StartOn = evs(3,Ind_StartOn);                 
        evs = evs(:,Ind_StartOn+1:end)
        disp('Finding StartAq')
        StartAq = evs(3,1) - StartOn;
        TD.StartAq(TD.currentTrial) = StartAq;
        disp('Finding TargetOn')
        if strfind(CurrentTask,'Target Onset Asynchrony');
            TargetOn = evs(3,find(evs(2,:)==CODE.SaccadeGo)) - StartOn;
        else
            TargetOn = evs(3,find(evs(2,:)==CODE.TargetOn)) - StartOn;
        end
        TD.TargetOn(TD.currentTrial) = TargetOn;
        if strfind(CurrentTask,'Memory');
            disp('Finding TargetOff')
            TargetOff = evs(3,find(evs(2,:)==CODE.TargetOff)) - StartOn;
            TD.TargetOff(TD.currentTrial) = TargetOff;
            disp('Finding TargetRet')
%             TargetRet = evs(3,find(evs(2,:)==CODE.TargetRet)) - StartOn;
%             TD.TargetRet(TD.currentTrial) = TargetRet;
        end
        if find(evs(2,:)==CODE.InstOn)
            disp('Assigning InstOn')
            TD.InstOn = evs(3,find(evs(2,:)==CODE.InstOn)) - StartOn;
        end
        if find(evs(2,:)==CODE.SaccadeGo)
            TD.SaccadeGo = evs(3,find(evs(2,:)==CODE.SaccadeGo)) - StartOn;
        end
        if find(evs(2,:)==CODE.SaccadeAq)
            TD.SaccadeAq = evs(3,find(evs(2,:)==CODE.SaccadeAq)) - StartOn;
        end
        if find(evs(2,:)==CODE.ReachGo)
            TD.ReachGo = evs(3,find(evs(2,:)==CODE.ReachGo)) - StartOn;
        end
        if find(evs(2,:)==CODE.ReachAq)
            TD.ReachAq = evs(3,find(evs(2,:)==CODE.ReachAq)) - StartOn;
        end
        strfind(CurrentTask,'then')
        if ~strcmp(CurrentTask,'Microstim') && length(strfind(CurrentTask,'then'))==0 && length(strfind(CurrentTask,'Asynchrony'))==0
            disp('Finding Go')
            Go = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            TD.Go(TD.currentTrial) = Go;
            disp('Finding TargetAq')
            TargetAq = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            TD.TargetAq(TD.currentTrial) = TargetAq;
        end
        %  Trial End with respect to circular buffer time
        Ind_Success = find(evs(2,:)==CODE.Success);
        TD.End(TD.currentTrial) = evs(3,Ind_Success);

    case {'Task Control v4.00','Task Control v4.01','Task Control v4.02','Task Control v4.03','Task Control v4.04','Task Control v4.05','Task Control v4.06','Task Control v4.07'}
        disp('Task Control v4.00-4.07')
        CODE.StartOn = 1;
        CODE.StartAq = 2;
        CODE.TargetOn = 3;
        CODE.Go = 4;
        CODE.TargetAq =5;
        CODE.Success = 7;
        CODE.Abort = 8;
        CODE.InstOn = 6;
        CODE.TargetOff = 9;
        CODE.TargetRet = 10;
        CODE.ReachGo = 11;
        CODE.SaccadeGo = 12;
        CODE.ReachAq = 13;
        CODE.SaccadeAq = 14;
        StartOn = evs(3,Ind_StartOn);                 
        evs = evs(:,Ind_StartOn+1:end)
        disp('Finding StartAq')
        StartAq = evs(3,1) - StartOn;
        TD.StartAq(TD.currentTrial) = StartAq;
        disp('Finding TargetOn')
        CurrentTask
        if strfind(CurrentTask,'SOA');
            TargetOn = evs(3,find(evs(2,:)==CODE.SaccadeGo)) - StartOn;
        elseif strfind(CurrentTask,'Race')
            TargetOn = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
        elseif strfind(CurrentTask,'Eye Calibration');
            TargetOn = StartAq;
        else
            
            disp('here')
            TargetOn = evs(3,find(evs(2,:)==CODE.TargetOn)) - StartOn;
            
            disp('out')
        end
        TD.TargetOn(TD.currentTrial) = TargetOn;
        if strfind(CurrentTask,'Memory');
            disp('Finding TargetOff')
            TargetOff = evs(3,find(evs(2,:)==CODE.TargetOff)) - StartOn;
            TD.TargetOff(TD.currentTrial) = TargetOff;
            disp('Finding TargetRet')
%             TargetRet = evs(3,find(evs(2,:)==CODE.TargetRet)) - StartOn;
%             TD.TargetRet(TD.currentTrial) = TargetRet;
        end
        if find(evs(2,:)==CODE.InstOn)
            disp('Assigning InstOn')
            TD.InstOn = evs(3,find(evs(2,:)==CODE.InstOn)) - StartOn;
        end
        if find(evs(2,:)==CODE.SaccadeGo)
            TD.SaccadeGo = evs(3,find(evs(2,:)==CODE.SaccadeGo)) - StartOn;
        end
        if find(evs(2,:)==CODE.SaccadeAq)
            TD.SaccadeAq = evs(3,find(evs(2,:)==CODE.SaccadeAq)) - StartOn;
        end
        if find(evs(2,:)==CODE.ReachGo)
            TD.ReachGo = evs(3,find(evs(2,:)==CODE.ReachGo)) - StartOn;
        end
        if find(evs(2,:)==CODE.ReachAq)
            TD.ReachAq = evs(3,find(evs(2,:)==CODE.ReachAq)) - StartOn;
        end
        %strfind(CurrentTask,'then')
        if ~strcmp(CurrentTask,'Microstim') && ~strcmp(CurrentTask,'Eye Calibration') && length(strfind(CurrentTask,'then'))==0 && length(strfind(CurrentTask,'SOA'))==0
            disp('Finding Go')
            Go = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            TD.Go(TD.currentTrial) = Go;

            disp('Finding TargetAq')
            if strfind(CurrentTask,'Eye Calibration');
                TD.SaccadeAq = evs(3,find(evs(2,:)==CODE.StartAq)) - StartOn;
                TargetAq = TD.SaccadeAq;
            else
                TargetAq = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            end
            TD.TargetAq(TD.currentTrial) = TargetAq;
        end
        %  Trial End with respect to circular buffer time
        Ind_Success = find(evs(2,:)==CODE.Success);
        TD.End(TD.currentTrial) = evs(3,Ind_Success);

    case {'Task Control v4.08','Task Control v4.09','Task Control v4.10','Task Control v4.11','Task Control v5.00','Task Control v5.01'}
        disp('Task Control v4.08-4.11 and 5.00-5.01')
        CODE.StartOn = 1;
        CODE.StartAq = 2;
        CODE.TargetOn = 3;
        CODE.Go = 4;
        CODE.TargetAq = 5;
        CODE.Success = 7;
        CODE.Abort = 8;
        CODE.InstOn = 6;
        CODE.TargetOff = 9;
        CODE.TargetRet = 10;
        CODE.ReachGo = 11;
        CODE.SaccadeGo = 12;
        CODE.ReachAq = 13;
        CODE.SaccadeAq = 14;
        CODE.Inst2On = 15;
        CODE.Cue2On = 16;
        StartOn = evs(3,Ind_StartOn); 
        evs = evs(:,Ind_StartOn+1:end)
        disp('Finding StartAq')
        StartAq = evs(3,1) - StartOn;
        TD.StartAq(TD.currentTrial) = StartAq;
        disp('Finding TargetOn')
        CurrentTask
        if strfind(CurrentTask,'SOA');
            TargetOn = evs(3,find(evs(2,:)==CODE.TargetOn)) - StartOn;
        elseif strfind(CurrentTask,'Race')
            TargetOn = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
        elseif strfind(CurrentTask,'Eye Calibration');
            TargetOn = StartAq;
        else
            TargetOn = evs(3,find(evs(2,:)==CODE.TargetOn)) - StartOn;
        end
        TD.TargetOn(TD.currentTrial) = TargetOn;
        if strfind(CurrentTask,'Memory');
            disp('Finding TargetOff')
            TargetOff = evs(3,find(evs(2,:)==CODE.TargetOff)) - StartOn;
            TD.TargetOff(TD.currentTrial) = TargetOff;
            disp('Finding TargetRet')
%             TargetRet = evs(3,find(evs(2,:)==CODE.TargetRet)) - StartOn;
%             TD.TargetRet(TD.currentTrial) = TargetRet;
        end
        if find(evs(2,:)==CODE.InstOn)
            disp('Assigning InstOn')
            TD.InstOn(TD.currentTrial) = evs(3,find(evs(2,:)==CODE.InstOn)) - StartOn;
        else
            TD.InstOn(TD.currentTrial) = 0;
        end
        if find(evs(2,:)==CODE.SaccadeGo)
            TD.SaccadeGo(TD.currentTrial) = evs(3,find(evs(2,:)==CODE.SaccadeGo)) - StartOn;
        else
            TD.SaccadeGo(TD.currentTrial) = 0;
        end
        if find(evs(2,:)==CODE.SaccadeAq)
            TD.SaccadeAq(TD.currentTrial) = evs(3,find(evs(2,:)==CODE.SaccadeAq)) - StartOn;
        else
            TD.SaccadeAq(TD.currentTrial) = 0;
        end
        if find(evs(2,:)==CODE.ReachGo)
            TD.ReachGo(TD.currentTrial) = evs(3,find(evs(2,:)==CODE.ReachGo)) - StartOn;
        else
            TD.ReachGo(TD.currentTrial) = 0;
        end
        if find(evs(2,:)==CODE.ReachAq)
            TD.ReachAq(TD.currentTrial) = evs(3,find(evs(2,:)==CODE.ReachAq)) - StartOn;
        else
            TD.ReachAq(TD.currentTrial) = 0;
        end
        if find(evs(2,:)==CODE.Cue2On)
            TD.Cue2On(TD.currentTrial) = evs(3,find(evs(2,:)==CODE.Cue2On)) - StartOn;
        else
            TD.Cue2On(TD.currentTrial) = 0;
        end
        %strfind(CurrentTask,'then')
        if ~strcmp(CurrentTask,'Microstim') && ~strcmp(CurrentTask,'Eye Calibration') && length(strfind(CurrentTask,'then'))==0 && length(strfind(CurrentTask,'SOA'))==0
            disp('Finding Go')
            if find(evs(2,:)==CODE.Go)
            Go = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
            else
              Go = evs(3,find(evs(2,:)==CODE.TargetOn)) - StartOn;
            end
            TD.Go(TD.currentTrial) = Go;
            
            disp('Finding TargetAq')
            if strfind(CurrentTask,'Eye Calibration');
                TD.SaccadeAq(TD.currentTrial) = evs(3,find(evs(2,:)==CODE.StartAq)) - StartOn;
                TargetAq = TD.SaccadeAq;
            else
                if find(evs(2,:)==CODE.Go)
                    TargetAq = evs(3,find(evs(2,:)==CODE.Go)) - StartOn;
                else
                    TargetAq = evs(3,find(evs(2,:)==CODE.TargetOn)) - StartOn;
                end

            end
            TD.TargetAq(TD.currentTrial) = TargetAq;
        end
        %  Trial End with respect to circular buffer time
        Ind_Success = find(evs(2,:)==CODE.Success);
        TD.End(TD.currentTrial) = evs(3,Ind_Success);

end

disp('Leaving getStateCodes')
