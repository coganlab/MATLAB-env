function Depth = sessDepth(Sess)
%  SESSDepth  gets the Z Recording locations for a session
%
%   Depth = sessDepth(Sess)
%
%
% global MONKEYDIR
%


global experiment MONKEYDIR
if ~iscell(Sess{1})
    Sess = {Sess};
end
nSess = length(Sess);
nComponent = length(Sess{1}{8});
Depth = zeros(nSess, nComponent);
for iSess = 1:nSess
    Type = sessTypeCell(Sess{iSess});
    for iComponent = 1:length(Type)
        ComponentType = Type{iComponent};
        switch ComponentType
            case {'Field','Multiunit','Laminar'}
                if ~iscell(Sess{iSess}{5})
                    Sess{iSess}{5} = {Sess{iSess}{5}};
                end
                Depth(iSess,iComponent) = Sess{iSess}{5}{iComponent}(1);
            case 'Spike'
                Day = sessDay(Sess{iSess});
                Recs = sessRec(Sess{iSess});
                if(isempty(experiment))
                    if(exist([MONKEYDIR '/' Day '/' Recs{1} '/rec' Recs{1} '.experiment.mat'],'file'))
                        load([MONKEYDIR '/' Day '/' Recs{1} '/rec' Recs{1} '.experiment.mat']);
                    end
                end
                
                Tower = sessTower(Sess{iSess});
                Ch = sessElectrode(Sess{iSess});
                Trials = sessTrials(Sess{iSess});
                Dtmp = getDepth(Trials);
                towerind = findSys(Trials(1),Tower{iComponent});
                D = mean(Dtmp(:,Ch(iComponent),towerind));
                Depth(iSess,iComponent) = D;
        end
    end
end
