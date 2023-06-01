function Range = sessRange(Sess)
%
%   Range = sessRange(Sess)
%



if ~iscell(Sess{1})
    Sess = {Sess};
end
nSess = length(Sess);
nComponent = length(Sess{1}{8});
Range = zeros(nSess, nComponent);
for iSess = 1:nSess
    Type = sessTypeCell(Sess{iSess});
    for iComponent = 1:length(Type)
        ComponentType = Type{iComponent};
        switch ComponentType
            case {'Field','Multiunit','Laminar'}
                if ~iscell(Sess{iSess}{5})
                    Sess{iSess}{5} = {Sess{iSess}{5}};
                end
                Range(iSess,iComponent) = Sess{iSess}{5}{iComponent}(1);
            case 'Spike'
                Range(iSess,iComponent) = NaN;
        end
    end
end