function [Trials,ind] = getDepthTrials(Trials,sys,ch,depth)
%   Returns trials that have ch and depth within +-delta
%
%   [Trials,ind] = getDepthTrials(Trials,sys,ch,depth,delta)
%
%   SYS     =   String.  Chamber to select.  'PRR' or 'LIP'
%   DELTA = Scalar.  Range around depth to accept trials
%               Defaults to +/-100um.
%
%   Note:  Assumes all trials have same chamber assignment
%

global MONKEYDIR
%disp('Inside getDepthTrials')

if length(sys)~=2
    SysNum = findSys(Trials,sys);
    mtch = ch;
    
%     load([MONKEYDIR '/' Trials(1).Day '/' Trials(1).Rec '/rec' Trials(1).Rec '.experiment.mat'])
%     for i = 1:length(experiment.hardware.microdrive)
%       if strcmp(experiment.hardware.microdrive(i).name(1),sys)
%           SysNum = i;
%       end
%     end

elseif length(sys)==2
    switch sys
    case 'PL'
        Sys1 = SysPRR(Trials);  Sys2 = SysLIP(Trials);
    case 'LL'
        Sys1 = SysLIP(Trials); Sys2 = Sys1;
    case 'LP'
        Sys1 = SysLIP(Trials);  Sys2 = SysPRR(Trials); 
    case 'PP'
        Sys1 = SysPRR(Trials);  Sys2 = Sys1;
    end 
    mtch = 2*([Sys1(1),Sys2(1)]-1) + ch;
end
if length(depth)==1 
    delta = 100; 
else delta = depth(2);
    depth = depth(1);
end
Depth = getDepth(Trials);
if length(ch)==1
    SysNum(1);
    if Trials(1).Ch(SysNum(1)) == 24
        ch = 1;
    end
    Depth = Depth(:,ch,SysNum(1));
    ind = find(Depth > depth-delta & Depth < depth+delta);
    Trials = Trials(ind);
elseif length(ch)==2
    Depth1 = Depth1(:,SysNum1(1),mtch(1));
    Depth2 = Depth2(:,mtch(2));
    ind1 = find(Depth1 > depth(1)-delta & Depth1 < depth(1)+delta);
    ind2 = find(Depth2 > depth(2)-delta & Depth2 < depth(2)+delta);
    ind = intersect(ind1,ind2);
    if ~isempty(ind)
        Trials = Trials(ind);
    end
else
    Depth1 = Depth1(:,mtch(1));
    Depth2 = Depth2(:,mtch(2));
    Depth3 = Depth3(:,mtch(3));
    ind1 = find(Depth1 > depth(1)-delta & Depth1 < depth(1)+delta);
    ind2 = find(Depth2 > depth(2)-delta & Depth2 < depth(2)+delta);
    ind3 = find(Depth3 > depth(3)-delta & Depth3 < depth(3)+delta);
    ind = intersect(ind1,ind2);
    ind = intersect(ind,ind3);
    if ~isempty(ind)
        Trials = Trials(ind);
    end
end
