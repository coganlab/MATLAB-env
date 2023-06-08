function [EX,EY,eidx,esub,spacing]=SC32_channelmap
% [EX,EY,spacing,eidx,esub]=SC32_channelmap
%
% Coordinates of electrodes in chamber space and channel mapping according
% to PCB of the SC32. This depends oninformation provided by Gray Matter
% Research.
% 
% EX/EY: coordinates of the SC96 grid (padded by 1 position in all
%        directions) 
% eidx:  linear index of channels 1-96 in a 13x13 matrix 
% esub:  column and row subscripts of channels 1-96 in a 13x13 matrix
% spacing: electrode spacing

% basic electrode array
nx = 8; % 11 electrodes + 1 on each side
ny = 8; % 11 electrodes + 1 on each side
spacing = 1.524; % mm, 0.060"
D = nan(nx,ny);

% coordinate of electrode 1, measured by Baldwin
e1 = [3.8862 -3.81]; % mm
% create the rest of the coordinate system based on the regular spacing
EX = [e1(1)-5.*spacing : spacing : e1(1)+2.*spacing];
EY = [e1(2)-1.*spacing : spacing : e1(2)+6.*spacing];

% numerically ascending (1-32) electrode subscripts such that an ndgrid of
% EX and EY can be referenced for each electrode.
esub = [
    % Connector 1
    6 2 % 1
    5 2 % 2
    4 2 % 3
    3 2 % 4
    2 2 % 5
    6 3 % 6
    5 3 % 7
    4 3 % 8
    3 3 % 9
    2 3 % 10
    7 4 % 11
    6 4 % 12
    5 4 % 13
    4 4 % 14
    3 4 % 15
    2 4 % 16
    7 5 % 17
    6 5 % 18 
    5 5 % 19
    4 5 % 20 
    3 5 % 21
    2 5 % 22
    6 6 % 23
    5 6 % 24
    4 6 % 25
    3 6 % 26
    2 6 % 27
    6 7 % 28
    5 7 % 29
    4 7 % 30
    3 7 % 31
    2 7 % 32
    ];

eidx = sub2ind([nx ny],esub(:,1),esub(:,2));
