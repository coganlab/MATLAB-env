function [rate, nTr] = psth(spikecell, bn, smoothing, maxrate, marks, flag)
%
%  psth(spike, bn, smoothing, maxrate, marks, flag)
%
%	Spike is a cell array of spike times in ms.  This is assumed to start from 0ms.
%	bn is [start,stop] to give the start and stop times 
%		of the spike times in Spike.  This realigns the spike times
%	smoothing is the degree of smoothing in the psth in ms.
%	maxrate is used for display - it specifies the maximum firing rate
%		on the y-axis
%

if nargin < 3 || isempty(smoothing); smoothing = 50; end
if nargin < 4; maxrate = 50; end
if nargin < 5; marks = []; end
if nargin < 6; flag = 0; end

%spikecell = cell2mat(spikecell);
nTr = length(spikecell);
dT = maxrate./nTr;

Start = bn(1); Stop = bn(2);

X = [];
Y = [];
for iTr = 1:nTr;
    x = spikecell{iTr};
    x = (x + Start)';
    y = ones(1,length(x))*(iTr*dT);
    
    X = [X x];
    Y = [Y y];
end
%whos X Y
if nargout == 0 || flag == 1
    if nTr > 5
        plot(X,Y,'r.','MarkerSize',4);
    else
        plot(X,Y,'r.','MarkerSize',10);
    end
end

if ~isempty(marks)
    hold on;
    plot(marks,[1:nTr].*dT,'k.','Markersize',10)
end

% disp('Here1');
% disp(X);
% disp('Here2');

Z = hist(X,Start:Stop);
window = normpdf([-3*smoothing:3*smoothing],0,smoothing);

rate = (1000/nTr)*conv(Z,window);
rate = rate(3*smoothing+1:end-3*smoothing);

% 
if nargout==0 || flag == 1
    hold on;
    plot(Start:Stop,rate,'k');
    plot([0 0],[0 maxrate],'b')
    axis([Start Stop 0 maxrate])
end
