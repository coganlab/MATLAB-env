function [EX,EY,eidx,esub,spacIng]=vSUBNETS220_channelmap
% [EX,EY,spacing,eidx,esub]=vSUBNETS_channelmap
%
% coordinates of electrodes in chamber space and channel mapping according
% to PCB of the vSUBNETS. This depends on STL files provided by Gray Matter
% Research.
%
% EX/EY: coordinates of the vSUBNETS grid (padded by 1 position in all
%        directions)
% eidx:  linear index of channels 1-96 in a 12x28 matrix
% esub:  column and row subscripts of channels 1-96 in a 12x28 matrix
% spacing: electrode spacing

% basic electrode array
nx = 12; % 11 electrodes + 1 on each side
ny = 28; % 11 electrodes + 1 on each side
spacing = 1.524; % mm, 0.060"
D = nan(nx,ny);

% coordinate of electrode 1
e1 = [5.98 20.36]; % mm
EX = [e1(1)-10.*spacing : spacing : e1(1)+1.*spacing];
EY = [e1(2)-26.*spacing : spacing : e1(2)+1.*spacing];

% numerically ascending electrode subscripts such that an ndgrid of
% EX and EY can be referenced for each electrode.
esub = [
    % Connector (BANK) 1
    11 27   % 1
    10 27   % 2
    9  27   % 3
    8 27    % 4
    11 26   % 5
    10 26   % 6
    9 26    % 7
    8 26    % 8
    8 25    % 9
    8 24    % 10
    8 23    % 11
    7 24    % 12
    7 23    % 13
    6 23    % 14
    11 22   % 15
    10 22   % 16
    9 22    % 17
    8 22    % 18
    7 22    % 19
    6 22    % 20
    5 23    % 21
    5 22    % 22
    11 21   % 23
    10 21   % 24
    11 20   % 25
    10 20   % 26
    11 19   % 27
    9 21    % 28
    7 21    % 29
    6 21    % 30
    7 20    % 31
    6 20    % 32
    % Connector (BANK) 2
    10 19   % 33
    9 19    % 34
    10 18   % 35
    9 18    % 36
    8 18    % 37
    7 17    % 38
    5 18    % 39
    4 18    % 40
    8 17    % 41
    8 16    % 42
    5 17    % 43
    4 17    % 44
    3 17    % 45
    2 17    % 46
    11 15   % 47
    10 15   % 48
    11 14   % 49
    10 14   % 50
    11 13   % 51
    10 13   % 52
    9 15    % 53
    8 15    % 54
    7 16    % 55
    6 16    % 56
    7 15    % 57
    6 15    % 58
    6 14    % 59
    3 16    % 60
    2 16    % 61
    2 15    % 62
    2 14    % 63
    2 13    % 64
    % Connector (BANK) 3
    10 12   % 65
    9 12    % 66
    10 11   % 67
    9 11    % 68
    3 10    % 69
    2 9     % 70
    7 9     % 71
    7 8     % 72
    6 9     % 73
    6 8     % 74
    5 8     % 75
    4 9     % 76
    4 8     % 77
    3 9     % 78
    3 8     % 79
    10 6    % 80
    10 5    % 81
    9 5     % 82
    7 7     % 83
    6 7     % 84
    5 7     % 85
    4 7     % 86
    3 7     % 87
    2 6     % 88
    6 5     % 89
    5 6     % 90
    5 5     % 91
    5 4     % 92
    4 6     % 93
    4 5     % 94
    3 6     % 95
    3 5     % 96
    % Connector (BANK) 4
    7 27    % 97
    7 26    % 98
    7 25    % 99
    6 25    % 100
    11 25   % 101
    10 25   % 102
    11 24   % 103
    10 24   % 104
    11 23   % 105
    10 23   % 106
    9 25    % 107
    9 23    % 108
    9 24    % 109
    6 24    % 110
    11 18   % 111
    9 20    % 112
    8 21    % 113
    8 20    % 114
    5 21    % 115
    4 21    % 116
    5 20    % 117
    4 20    % 118
    8 19    % 119
    7 19    % 120
    7 18    % 121
    6 17    % 122
    6 19    % 123
    6 18    % 124
    5 19    % 125
    4 19    % 126
    3 19    % 127
    3 18    % 128
    % Connector (BANK) 5
    11 17   % 129
    10 17   % 130
    11 16   % 131
    10 16   % 132
    9 17    % 133
    9 16    % 134
    5 16    % 135
    4 16    % 136
    5 15    % 137
    4 15    % 138
    9 14    % 139
    9 13    % 140
    8 14    % 141
    8 13    % 142
    7 14    % 143
    7 13    % 144
    6 13    % 145
    5 13    % 146
    5 14    % 147
    4 13    % 148
    4 14    % 149
    3 15    % 150
    3 14    % 151
    3 13    % 152
    5 12    % 153
    5 11    % 154
    4 12    % 155
    4 11    % 156
    3 12    % 157
    3 11    % 158
    2 12    % 159
    2 11    % 160
    % Connector (BANK) 6
    11 12   % 161
    8 12    % 162
    7 12    % 163
    6 12    % 164
    11 11   % 165
    8 11    % 166
    7 11    % 167
    6 11    % 168
    11 10   % 169
    10 10   % 170
    9 10    % 171
    8 10    % 172
    7 10    % 173
    6 10    % 174
    5 9     % 175
    5 10    % 176
    4 10    % 177
    2 10    % 178
    11 9    % 179
    10 9    % 180
    9 9     % 181
    8 9     % 182
    11 8    % 183
    10 8    % 184
    9 8     % 185
    8 8     % 186
    11 7    % 187
    10 7    % 188
    9 7     % 189
    8 7     % 190
    2 7     % 191
    2 8     % 192
    % Connector (BANK) 7
    11 6    % 193
    9 6     % 194
    8 6     % 195
    7 6     % 196
    11 5    % 197
    8 5     % 198
    7 5     % 199
    6 6     % 200
    11 4    % 201
    10 4    % 202
    9 4     % 203
    8 4     % 204
    7 4     % 205
    6 4     % 206
    4 4     % 207
    11 3    % 208
    10 3    % 209
    9 3     % 210
    8 3     % 211
    7 3     % 212
    6 3     % 213
    5 3     % 214
    11 2    % 215
    10 2    % 216
    9 2     % 217
    8 2     % 218
    7 2     % 219
    6 2     % 220
    ];

eidx = sub2ind([nx ny],esub(:,1),esub(:,2));
