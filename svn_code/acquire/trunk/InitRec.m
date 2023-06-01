function Rec = InitRec
%  Initialize Rec data structure

global Rec

Rec.Z = [0,0,0];
Rec.X1 = 0; Rec.Y1 = 0; Rec.Pitch1 = 0; Rec.Yaw1 = 0;
Rec.X2 = 0; Rec.Y2 = 0; Rec.Pitch2 = 0; Rec.Yaw2 = 0;
Rec.StartTime = 0;
Rec.Duration = 0;
Rec.Filename = '';
Rec.LogName = '';
Rec.Paramsname = '';
Rec.Num = 1;
Rec.prenum = '';
Rec.fid = 0;
Rec.Fs = 0;
Rec.Monkey = 'Reggie';
Rec.MT1 = '';  Rec.MT2 = '';
Rec.Gain = zeros(1,4);
Rec.Channels = zeros(1,4);
Rec.NumTrials = zeros(1,9);
Rec.TaskController = '';
Rec.Ch = '';
Rec.IsoWin = '';
Rec.BinaryDataFormat = 'ushort';

