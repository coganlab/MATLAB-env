function [r,phi,sel,F] = calcTuning(Data,Group,GroupIDs)
%
%  [r,phi,sel,F] = calcTuning(Data,Group,GroupIDs)
%
%   Inputs: Data  =  Array, trial vs time
%
if nargin < 3
    sGroup = sort(Group(:),'ascend');
    dsGroup = diff(sGroup);
    Tind = [sGroup(dsGroup>0),max(Group)];
else
    Tind = GroupIDs;
end
NG = length(Tind);
Theta = [0:pi./4:7.*pi./4];

if size(Data,1)==1 Data = Data'; end;
if size(Group,1)~=size(Data,1) Group = Group'; end;

if size(Data,2) > 1
    % Several time points
    F = zeros(size(Data,2),NG);
    for i = 1:NG
      F(:,Tind(i)) = sum(Data.*(Group==Tind(i)),1)./sum(Group==Tind(i),1);
    end
    
    C = sum(F(:,Tind).*repmat(cos(Theta(Tind)),size(Data,2),1),2);
    S = sum(F(:,Tind).*repmat(sin(Theta(Tind)),size(Data,2),1),2);
    sel = sqrt((C./(sum(F,2)./NG)).^2+(S./(sum(F,2)./NG)).^2);
    r = sqrt(C.^2+S.^2);
    phi = atan2(S,C);
    
else
    %  One time point
    F = zeros(1,NG);
    for i = 1:NG
        F(Tind(i)) = sum(Data(Group==Tind(i)))/sum(Group==Tind(i));
        
    end
    
    C = sum(F(Tind).*cos(Theta(Tind)));
    S = sum(F(Tind).*sin(Theta(Tind)));
    
    
    r = sqrt(C.^2+S.^2);
    sel = sqrt((C/(sum(F)./NG)).^2+(S/(sum(F)./NG)).^2);
    
    
    phi = atan2(S,C);
end

