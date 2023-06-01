function YTickLabel = setPanelYTickLabel(Type, Data, YTick, Axes)
%
%  YTickLabel = setPanelXTickLabel(Type, Data, YTick, Axes)
%

nTick = length(YTick);
YTickLabel = cell(1,nTick);

switch Type
    case {'image'}
        yax = round(Data.yax(end:-1:1)); 
         for iT = 1:nTick
             ind = find(yax>YTick(iT),1,'last');
             if isempty(ind); ind=0; end
             NewYTicks(iT) = size(Data.Data,2)-ind;
         end
         set(Axes,'YTick',NewYTicks)
        for iT = 1:nTick
            YTickLabel{iT} = num2str(round(yax(NewYTicks(iT))));
        end
    case {'line'}
        YLim = get(Axes,'YLim');
        YTickValues = round(linspace(YLim(1),YLim(2),nTick));
        for iT = 1:nTick
            YTickLabel{iT} = num2str(YTickValues(iT));
        end
end
