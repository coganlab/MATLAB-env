function makePk(day, rec)
%
%   makePk(day, rec)
%

global MONKEYDIR

olddir = pwd;
recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end

for iRec = num(1):num(2)
    rec = recs{iRec};
    disp(['Day ' day ' recording ' rec]);
    cd([MONKEYDIR '/' day '/' rec]);
    
    if exist([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat'],'file')
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.experiment.mat']);
        NumTowers = length(experiment.hardware.microdrive);
        TowerNames = cell(1,NumTowers);
        for iTowers = 1:NumTowers
            TowerNames{iTowers} = experiment.hardware.microdrive(iTowers).name;
        end
        SamplingRate = experiment.hardware.acquisition.samplingrate;
    else
        disp('No experiment definition file');
        load([MONKEYDIR '/' day '/' rec '/rec' rec '.Rec.mat']);
        NumTowers = 2;
        TowerNames = cell(1,NumTowers);
        TowerNames{1} = Rec.MT1;
        TowerNames{2} = Rec.MT2;
        experiment.hardware.microdrive(1).electrodes = zeros(1,Rec.Ch(1));
        experiment.hardware.microdrive(2).electrodes = zeros(1,Rec.Ch(1));
        SamplingRate = Rec.Fs;
    end
    for iTowers = 1:NumTowers
        disp(['Loading rec' rec '.' TowerNames{iTowers} '.sp.mat'])
        
         if isfile(['rec' rec '.' TowerNames{iTowers} '.sp.mat'])
             load(['rec' rec '.' TowerNames{iTowers} '.sp.mat']);
         else
		error('Missing sp file - run procSp before makePk');
         end
        nChannels = length(sp);

        if SamplingRate == 20000 %hack to deal with difference btwn DoubleMT and Yan's system
            pkbin = 10;
        else
            pkbin = 14;
        end
        
        for iCh = 1:nChannels
            if length(sp{iCh})
                pk{iCh} = sp{iCh}(:,[1,pkbin]);
            else
                pk{iCh} = [];
            end
        end
        disp(['Saving rec' rec '.' TowerNames{iTowers} '.pk.mat'])
        save(['rec' rec '.' TowerNames{iTowers} '.pk.mat'],'pk');
        clear sp
    end
end
cd(olddir);

