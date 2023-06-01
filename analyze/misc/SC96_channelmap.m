function [EX,EY,eidx,esub,spacing]=SC96_channelmap
% [EX,EY,spacing,eidx,esub]=SC96_channelmap
%
% coordinates of electrodes in chamber space and channel mapping according
% to PCB of the SC96. This depends on STL files provided by Gray Matter
% Research.
% 
% EX/EY: coordinates of the SC96 grid (padded by 1 position in all
%        directions) 
% eidx:  linear index of channels 1-96 in a 13x13 matrix 
% esub:  column and row subscripts of channels 1-96 in a 13x13 matrix
% spacing: electrode spacing

% basic electrode array
nx = 13; % 11 electrodes + 1 on each side
ny = 13; % 11 electrodes + 1 on each side
spacing = 1.524; % mm, 0.060"
D = nan(nx,ny);

% coordinate of electrode 1, measured by Baldwin
e1 = [-5.7658 -4.572 ]; % mm
EX = [e1(1)-2.*spacing : spacing : e1(1)+10.*spacing];
EY = [e1(2)-3.*spacing : spacing : e1(2)+9.*spacing];

% numerically ascending (1-96) electrode subscripts such that an ndgrid of
% EX and EY can be referenced for each electrode.
esub = [
    % Connector 1
    3 4 % 1
    2 5 % 2
    4 4 % 3
    3 5 % 4
    2 6 % 5
    4 5 % 6
    3 6 % 7
    2 7 % 8
    4 6 % 9
    3 7 % 10
    2 8 % 11
    5 6 % 12
    4 7 % 13
    3 8 % 14
    2 9 % 15
    5 7 % 16
    4 8 % 17
    3 9 % 18 
    6 7 % 19
    5 8 % 20 
    4 9 % 21
    3 10 % 22
    6 8 % 23
    5 9 % 24
    4 10 % 25
    6 9 % 26
    5 10 % 27
    4 11 % 28
    6 10 % 29
    5 11 % 30
    6 11 % 31
    5 12 % 32
    % Connector 2
    6 12 % 33
    7 12 % 34
    7 11 % 35
    8 12 % 36
    7 10 % 37
    8 11 % 38
    9 12 % 39
    7 9 % 40
    8 10 % 41
    9 11 % 42
    7 8 % 43
    8 9 % 44
    9 10 % 45
    10 11 % 46
    7 7 % 47
    8 8 % 48 
    9 9 % 49
    10 10 % 50
    8 7 % 51
    9 8 % 52
    10 9 % 53
    11 10 % 54
    9 7 % 55
    10 8 % 56
    11 9 % 57
    10 7 % 58
    11 8 % 59
    12 9 % 60
    11 7 % 61
    12 8 % 62
    12 7 % 63
    12 6 % 64
    % Connector 3
    11 6 % 65
    12 5 % 66
    10 6 % 67
    11 5 % 68
    9 6 % 69
    10 5 % 70
    11 4 % 71
    8 6 % 72
    9 5 % 73
    10 4 % 74
    7 6 % 75
    8 5 % 76
    9 4 % 77
    10 3 % 78
    6 6 % 79
    7 5 % 80
    8 4 % 81
    9 3 % 82
    6 5 % 83
    7 4 % 84
    8 3 % 85
    9 2 % 86
    5 5 % 87
    6 4 % 88
    7 3 % 89
    8 2 % 90
    5 4 % 91
    6 3 % 92
    7 2 % 93
    5 3 % 94
    6 2 % 95
    4 3 % 96
    ];

eidx = sub2ind([nx ny],esub(:,1),esub(:,2));
