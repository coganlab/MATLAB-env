function Value = calcSpectrumS1(Session,CondParams,AnalParams)
%
%  Value = calcSpectrum(Session,CondParams,AnalParams)
% 


global MONKEYDIR

SSess = splitSession(Session);
Sess = SSess{1};

Type = getSessionType(Sess);

dirPath = [MONKEYDIR '/mat/' Type '/Spec'];
fNameRoot = ['Spec.Sess' num2str(Sess{6}) ];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);

if p > 0 
    Spectrum = loadSessSpec(Sess,CondParams,AnalParams); 
    if isempty(Spectrum)
        Spectrum = saveSessSpec(Sess,CondParams,AnalParams,1); %like saveSessPSTH
    end
else
    Spectrum = saveSessSpec(Sess,CondParams,AnalParams); %like saveSessPSTH
    close all
end

%load up saved tuning information
Value = Spectrum.Spec;



