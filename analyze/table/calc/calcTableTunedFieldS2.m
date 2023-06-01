function Value = calcTableTunedFieldS2(Session,CondParams,AnalParams)
%
%  Value = calcTableTunedFieldS2(Session,CondParams,AnalParams)
%  Should be sent a field session

%I have to make this specific for UFF right now
%(or second session in a multipart session)

% [p,~,~,~,~] = sessTestSpecDiff(Sess{2}, CondParams{1}, CondParams{2}, AnalParams);

global MONKEYDIR

Sess = splitSession(Session);

Type = getSessionType(Sess{2});
dirPath = [MONKEYDIR '/mat/' Type '/SpecDiff'];
fNameRoot = ['SpecDiff.Sess' num2str(Sess{2}{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);

if p > 0
    SpecDiff = loadSessTestSpecDiff(Sess{2},CondParams{1},CondParams{2},AnalParams);
else
    SpecDiff = saveSessTestSpecDiff(Sess{2},CondParams{1},CondParams{2},AnalParams);
end

%load up saved tuning information
if SpecDiff.p < 0.05
    Value = 1;
else
    Value = 0;
end

