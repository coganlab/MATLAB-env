function Spectrum = saveSessSpec(Sess,CondParams,AnalParams,forceSave)
%
%
%   saveSessSpec(Sess,CondParams,AnalParams,forceSave)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information 
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.condstype = 'Choice'  - looks at eye/hand movement
%   not Target
%   CondParams.Delay   =  Vector. Select trials according to delay interval (s).
%                    Delay = [DelayStart,DelayStop].
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%
%

global MONKEYDIR

if nargin<4
  forceSave = 0; 
end

Spectrum.Session = Sess;

sessType = 'Field';
dirPath = [ MONKEYDIR '/mat/' sessType '/Spec' ];

if ~exist([dirPath],'dir');
    eval(['mkdir ' dirPath ]);
end

Params = [];
Params.CondParams = CondParams;
Params.AnalParams = AnalParams;

fNameRoot = ['Spec.Sess' num2str(Sess{6}(1))];

[p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams,AnalParams);
if p==0 || forceSave
    if p>0
        pMax = p-1;
        disp('--> ForceSave: Overwriting previous data file.');
    end
    % Now compute and save data
    
    All_Trials = sessTrials(Sess);
    Trials = Params2Trials(All_Trials,CondParams);
    if iscell(Trials); Trials = Trials{1}; end
    
    Spectrum.Spec = trialSpectrum(Sess,Trials,CondParams,AnalParams);
 
    eval(['save ' dirPath '/' fNameRoot '.d' num2str(pMax+1) '.mat Spectrum']);
    eval(['save ' dirPath '/' fNameRoot '.p' num2str(pMax+1) '.mat Params']);
    disp(['saved ' fNameRoot ]);
else
    disp('--> Data file already saved.');
end


