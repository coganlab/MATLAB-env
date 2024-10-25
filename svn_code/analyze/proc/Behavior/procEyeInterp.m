function procEyeInterp(day)
%  procEyeInterp determines the calibration data to interpolate eye position
%
%	procEyeInterp(day)
%
%	Inputs:	DAY = String.  Recording day to analyse
%
%
% EyeInterp.TrueX           Grid of sampled true x - locations
% EyeInterp.TrueY           Grid of sampled true y - locations
% EyeInterp.MeasX           Grid of measured x - locations
% EyeInterp.MeasY           Grid of measured y - locations
% EyeInterp.GridX           Grid of true x locations for interpolation
% EyeInterp.GridY           Grid of true y locations for interpolation
% EyeInterp.ScaleX          Grid of interpolated measured x - locations
% EyeInterp.ScaleY          Grid of interpolated measured y - locations
%

global MONKEYDIR

Trials = dbSelectTrials(day);

Trials = Trials(find([Trials.TaskCode]==26));
Target = getTarget(Trials);
at = 'StartAq'; bn = [40,70];
[E,H] = EyeHandTrial(Trials,at,bn,1);
e = [sq(mean(E,3))];
Pos = [[10,0];[10,10];[0,10];[-10,10];[-10,0];...
    [-10,-10];[0,-10];[10,-10];[20,0];[-20,0];...
    [0,0];[0,0];[24,0];[16,0];[25,15];...
    [25,5];[25,0];[25,-5];[25,-15];[20,-10];...
    [20,-5];[20,5];[20,10];[15,15];[15,5];...
    [15,0];[15,-5];[15,-15];[10,-5];[10,5];...
    [5,15];[5,5];[5,0];[5,-5];[5,-15];...
    [0,-5];[-5,-15];[-10,-15];[-10,-5];[-10,5];...
    [-15,15];[-15,5];[-15,0];[-15,-5];[-15,-10];...
    [-15,-15];[-20,-15];[-20,-10];[-20,-5];[-20,5];...
    [-20,10];[-25,15];[-25,5];[-25,0];[-25,-5];...
    [-25,-10];[-25,-15];[0,0];[-24,0];[-16,0];...
    [-5,15];[0,5];[-5,5];[-5,0];[-5,-5];...
    [-5,-10]];

ii = 0; clear X T; 
for iPos = 1:size(Pos,1)
    ind = find(Target==iPos);
    if length(ind)
        ii = ii+1;
        X(ii,:) = Pos(iPos,:);
        T(ii,:) = mean(e(ind,:));
    end
end

xx = [-25:5:25];
yy = [-15:5:15];
[XX,YY] = meshgrid(xx,yy);
for iX = 1:size(XX,1)
    for iY = 1:size(XX,2);
        i = find(X(:,1)==XX(iX,iY) & X(:,2)==YY(iX,iY));
        if length(i)
            ZZx(iX,iY) = T(i,1);
            ZZy(iX,iY) = T(i,2);
        end
    end
end
%ZZx(1,1) = ZZx(3,1);
%ZZy(1,1) = ZZy(1,3);

missing = find(ZZx==0);
[i,j] = ind2sub(size(ZZx),missing);
if length(find(i==1 & j==1)) & length(find(i==1 & j==2))
    ZZy(1,1) = ZZy(1,3);
end
if length(find(i==1 & j==1)) & length(find(i==2 & j==1))
    ZZx(1,1) = ZZx(3,1);
end

if length(find(i~=size(ZZx,1) & j~=size(ZZx,2) & i~=1 & j~=1))  %  The body
    a = find(i~=size(ZZx,1) & j~=size(ZZx,2) & i~=1 & j~=1);
    for ia = 1:length(a)
        ai = i(a(ia)); aj = j(a(ia));
        ZZx(ai,aj) = (ZZx(ai,aj-1) + ZZx(ai,aj+1) + ZZx(ai-1,aj) + ZZx(ai+1,aj))./4;
        ZZy(ai,aj) = (ZZy(ai,aj-1) + ZZy(ai,aj+1) + ZZy(ai-1,aj) + ZZy(ai+1,aj))./4;
    end
end
if  length(find(j~=size(ZZx,2) & i==1 & j~=1))  %  Top side
    a = find(j~=size(ZZx,2) & i==1 & j~=1);
    for ia = 1:length(a)
        aj = j(a(ia));
        ZZx(1,aj) = (ZZx(1,aj-1)+ZZx(1,aj+1))./4 + ZZx(2,aj)./2;
        ZZy(1,aj) = (ZZy(1,aj-1)+ZZy(1,aj+1))./2;
    end
end
if  length(find(i~=size(ZZx,1) & i~=1 & j==1))  %  Left side
    a = find(i~=size(ZZx,1) & i~=1 & j==1);
    for ia = 1:length(a)
        ai = i(a(ia));
        ZZx(ai,1) = (ZZx(ai+1,1) + ZZx(ai-1,1))./2;
        ZZy(ai,1) = (ZZy(ai+1,1) + ZZy(ai-1,1))./4 + ZZy(ai,2)./2;
    end
end
if length(find(i==size(ZZx,1) & j~=size(ZZx,2) & j~=1)) %  Bottom side
    a = find(j~=size(ZZx,2) & i==size(ZZx,1) & j~=1);
    for ia = 1:length(a)
        aj = j(a(ia));
        ZZx(end,aj) = (ZZx(end,aj-1) + ZZx(end,aj+1))./4 + ZZx(end-1,aj)./2;
        ZZy(end,aj) = (ZZy(end,aj-1) + ZZy(end,aj+1))./2;
    end
end
if length(find(j==size(ZZx,2) & i~=size(ZZx,1) & i~=1))  %  Right side
    a = find(i~=size(ZZx,1) & i~=1 & j==size(ZZx,2));
    for ia = 1:length(a)
        ai = i(a(ia));
        ZZx(ai,end) = (ZZx(ai+1,end) + ZZx(ai-1,end))./2;
        ZZy(ai,end) = (ZZy(ai+1,end) + ZZy(ai-1,end))./4 + ZZy(ai,end-1)./2;
    end
end
if length(find( (i==1 & j==1) & ~(i==1 & j==2) & ~(i==2 & j==1)))
    ZZx(1,1) = ZZx(2,1); ZZy(1,1) = ZZy(1,2);
end
if length(find(i==1 & j==size(ZZx,2)))
    ZZx(1,end) = ZZx(2,end); ZZy(1,end) = ZZy(1,end-1);
end
if length(find(i==size(ZZx,1) & j==1))
    ZZx(end,1) = ZZx(end-1,1); ZZy(end,1) = ZZy(end,2);
end
if length(find(i==size(ZZx,1) & j==size(ZZx,2)))
    ZZx(end,end) = ZZx(end-1,end); ZZy(end,end) = ZZy(end,end-1);
end

NewX = linspace(-25,25,50*10);
NewY = linspace(-15,15,20*10);
for iNewX = 1:length(NewX)
    for iNewY = 1:length(NewY)
        ScaleX(iNewX,iNewY) = interp2(XX,YY,ZZx,NewX(iNewX),NewY(iNewY),'cubic');
        ScaleY(iNewX,iNewY) = interp2(XX,YY,ZZy,NewX(iNewX),NewY(iNewY),'cubic');
    end
end


EyeInterp.TrueX = XX;  
EyeInterp.TrueY = YY;
EyeInterp.MeasX = ZZx;
EyeInterp.MeasY = ZZy;
EyeInterp.GridX = NewX;
EyeInterp.GridY = NewY;
EyeInterp.ScaleX = ScaleX;
EyeInterp.ScaleY = ScaleY;

% EyeInterp.TrueX           Grid of sampled true x - locations
% EyeInterp.TrueY           Grid of sampled true y - locations
% EyeInterp.MeasX           Grid of measured x - locations
% EyeInterp.MeasY           Grid of measured y - locations
% EyeInterp.GridX           Grid of true x locations for interpolation
% EyeInterp.GridY           Grid of true y locations for interpolation
% EyeInterp.ScaleX          Grid of interpolated measured x - locations
% EyeInterp.ScaleY          Grid of interpolated measured y - locations

subplot(2,2,1)
imagesc(EyeInterp.MeasX)
subplot(2,2,2)
imagesc(EyeInterp.MeasY)
subplot(2,2,3)
imagesc(EyeInterp.ScaleX')
subplot(2,2,4)
imagesc(EyeInterp.ScaleY')
supertitle([MONKEYDIR '/' day]);

if ~isdir([MONKEYDIR '/' day '/fig'])
    mkdir([MONKEYDIR '/' day '/fig'])
end
saveas(gcf,[MONKEYDIR '/' day '/fig/EyeInterp.fig'],'fig');

save([MONKEYDIR '/' day '/mat/EyeInterp.mat'],'EyeInterp');

