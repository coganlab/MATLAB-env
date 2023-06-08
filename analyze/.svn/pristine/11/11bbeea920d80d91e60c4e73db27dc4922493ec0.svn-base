function XTickLabel = setPanelXTickLabel(Type, Data, XTick)
%
%  XTickLabel = setPanelXTickLabel(Type, Data, XTick)
%

nTick = length(XTick);
XTickLabel = cell(1, nTick);
switch Type
    case {'image'}
        for iT = 1:nTick
            XTickLabel{iT} = num2str(Data.xax(XTick(iT)+1));
        end
    case {'line'}
        nT = length(Data.xax);
        TickInd = round(linspace(1,nT,nTick));
        for iT = 1:nTick
            XTickLabel{iT} = num2str(Data.xax(TickInd(iT)));
        end
end

