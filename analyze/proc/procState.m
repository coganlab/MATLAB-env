function procState(day,rec);
%
%   procState(day,rec);
%

global MONKEYDIR

recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end

%  For Chase task v4.

MoveCode = 1;
RestCode = 2;
InvisibleCode = 3;
VisibleCode = 4;
NearCode = 5;
FarCode = 6;
RewardCode = 7;
StopCode = 8;
StartCode = 9;
GoalXCode = 10;
GoalYCode = 11;
TargetXCode = 12;
TargetYCode = 13;

YMAX = 20;
YMIN = -20;
XMAX = 21;
XMIN = -21;
%
%
% mysetparallel(1,TargetXCode);
% mysetparallel(0,floor(128.*(TARGET_POS(1) - XMIN)./(XMAX - XMIN)));
% mysetparallel(1,TargetYCode);
% mysetparallel(0,floor(128.*(TARGET_POS(2) - YMIN)./(YMAX - YMIN)));
% mysetparallel(1,GoalXCode);
% mysetparallel(0,floor(128.*(GOAL_POS(1)-XMIN)./(XMAX - XMIN)));
% mysetparallel(1,GoalYCode);
% mysetparallel(0,floor(128.*(GOAL_POS(2)-YMIN)./(YMAX-YMIN)));
%     mysetparallel(1,StartCode)
%       MoveCodes:
%                             mysetparallel(1,NearCode);
%                             mysetparallel(1,FarCode);
%                             mysetparallel(1,RewardCode);
%      GoalCodes:
%                         mysetparallel(1,TargetXCode);
%                         mysetparallel(0,floor(128.*(TARGET_POS(1)-XMIN)./(XMAX - XMIN)));
%                         mysetparallel(1,TargetYCode);
%                         mysetparallel(0,floor(128.*(TARGET_POS(2)-YMIN)./(YMAX-YMIN)));
%                             mysetparallel(1,RestCode);
%                             mysetparallel(1,MoveCode);
%                             mysetparallel(1,GoalXCode);
%                             mysetparallel(0,floor(128.*(GOAL_POS(1) - XMIN)./(XMAX - XMIN)));
%                             mysetparallel(1,GoalYCode);
%                             mysetparallel(0,floor(128.*(GOAL_POS(2) - YMIN)./(YMAX - YMIN)));
%                                     mysetparallel(1,VisibleCode)
%                                     mysetparallel(1,InvisibleCode)


for iNum = num(1):num(2)
    rec = recs{iNum};
    dio = load([MONKEYDIR '/' day '/' rec '/rec' rec '.dio.txt']);
    disp(['Processing state for ' day ':' rec]);
    if(length(dio) == 0)
        disp('  DIO file empty: Exiting procState this loop');
    else

        Codes = [dio(:,1)./30 base2todec(dio(:,end-15:end-8)) base2todec(dio(:,end-7:end))];
        ind = find(Codes(:,2)>127); Codes(ind,2)=Codes(ind,2)-128;
        ind = find(Codes(:,3)>127); Codes(ind,3)=Codes(ind,3)-128;

        clear Move;
        MoveInds = find(Codes(:,2)==MoveCode); Move = Codes(MoveInds,1);

        clear Rest;
        RestInds = find(Codes(:,2)==RestCode); Rest = Codes(RestInds,1);

        clear Target;
        TargetXCodeInds = find(Codes(:,2)==TargetXCode);
        TargetXCodeInds = TargetXCodeInds(find(diff(TargetXCodeInds)==1)+1);
        TargetXCodeInds = TargetXCodeInds(find(TargetXCodeInds<size(Codes,1)));
        dum = Codes(TargetXCodeInds,3)*(XMAX-XMIN)+XMIN;
        Target(1:length(dum),2) = dum;
        TargetYCodeInds = find(Codes(:,2)==TargetYCode);
        TargetYCodeInds = TargetYCodeInds(find(diff(TargetYCodeInds)==1)+1);
        TargetYCodeInds = TargetYCodeInds(find(TargetYCodeInds<size(Codes,1)));
        dum = Codes(TargetYCodeInds,3)*(YMAX-YMIN)+YMIN;
        Target(1:length(dum),3) = dum;
        Target(:,1) = Codes(TargetYCodeInds,1);

        clear Goal;
        GoalXCodeInds = find(Codes(:,2)==GoalXCode);
        GoalXCodeInds = GoalXCodeInds(find(diff(GoalXCodeInds)==1)+1);
        GoalXCodeInds = GoalXCodeInds(find(GoalXCodeInds<size(Codes,1)));
        dum = Codes(GoalXCodeInds,3)*(XMAX-XMIN)+XMIN;
        Goal(1:length(dum),2) = dum;
        GoalYCodeInds = find(Codes(:,2)==GoalYCode);
        GoalYCodeInds = GoalYCodeInds(find(diff(GoalYCodeInds)==1)+1);
        GoalYCodeInds = GoalYCodeInds(find(GoalYCodeInds<size(Codes,1)));
        dum = Codes(GoalYCodeInds,3)*(YMAX-YMIN)+YMIN;
        Goal(1:length(dum),3) = dum;
        Goal(:,1) = Codes(GoalYCodeInds,1);

        clear GoalCode;
        GoalCode = Codes(GoalYCodeInds+1,2);

        clear Near;
        NearInds = find(Codes(:,2)==NearCode);
        Near = Codes(NearInds,1:2);

        clear Far;
        FarInds = find(Codes(:,2)==FarCode);
        Far = Codes(FarInds,1:2);

        clear Reward;
        RewardInds = find(Codes(:,2)==RewardCode);
        Reward = Codes(RewardInds,1:2);

        clear Reward;
        RewardInds = find(Codes(:,2)==RewardCode);
        Reward = Codes(RewardInds,1:2);

        clear State
        State.Target = Target;
        State.Near = Near;
        State.Far = Far;
        State.Goal = Goal;
        State.GoalCode = GoalCode;
        State.Move = Move;
        State.Rest = Rest;
        State.Reward = Reward;
        
        save([MONKEYDIR '/' day '/' rec '/rec' rec '.State.mat'],'State');
        end
        
    end
end
