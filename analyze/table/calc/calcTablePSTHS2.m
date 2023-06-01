function Value = calcPSTHS2(Session,CondParams,AnalParams)
%
%  Value = calcPSTH(Session,CondParams,AnalParams)


global MONKEYDIR

SSess = splitSession(Session);
Sess = SSess{2};

Type = getSessionType(Sess);

dirPath = [MONKEYDIR '/mat/' Type '/PSTH'];
fNameRoot = ['PSTH.Sess' num2str(Sess{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,[]);

if p > 0 
    PSTH = loadSessPSTH(Sess,CondParams);
else
    PSTH = saveSessPSTH(Sess,CondParams);
end

%load up saved tuning information
Value = PSTH.PSTH;


