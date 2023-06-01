function Value = calcTunedUnitS1(Session,CondParams,AnalParams)
%
%  Value = calcTunedUnit(Session,CondParams,AnalParams)
%  Should be sent a spike or multiunit session

%I have to make this specific for UFF right now
%(or first session in a multipart session)

% [RateDiff.p,~,~,~,~] = sessTestRateDiff(Sess{1}, CondParams{1}, CondParams{2});

global MONKEYDIR

Sess = splitSession(Session);

Type = getSessionType(Sess{1});
dirPath = [MONKEYDIR '/mat/' Type '/RateDiff'];
fNameRoot = ['RateDiff.Sess' num2str(Sess{1}{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,[]);

if p > 0 
    RateDiff = loadSessTestRateDiff(Sess{1},CondParams{1},CondParams{2});
else
    RateDiff = saveSessTestRateDiff(Sess{1},CondParams{1},CondParams{2});
end

%load up saved tuning information
if RateDiff.p < 0.05
    Value = 1;
else
    Value = 0;
end



