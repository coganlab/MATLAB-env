function Value = calcAllFiringRatesS2(Session,CondParams,AnalParams)
%
%  Value = calcAllFiringRates(Session,CondParams,AnalParams)


global MONKEYDIR

SSess = splitSession(Session);
Sess = SSess{2};

Type = getSessionType(Sess);


dirPath = [MONKEYDIR '/mat/' Type '/FiringRate'];
fNameRoot = ['FiringRate.Sess' num2str(Sess{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,[]);

if p > 0 
    FiringRate = loadSessFiringRate(Sess,CondParams);
    if ~isfield(FiringRate,'AllRates')
        FiringRate = saveSessFiringRate(Sess,CondParams,1);
    end
else
    FiringRate = saveSessFiringRate(Sess,CondParams);
end

%load up saved tuning information
Value = FiringRate.AllRates;


