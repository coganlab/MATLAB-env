function PanelAxes = setPanelAxesLimits(PanelAxes, PanelData, AnalParams)
%
%  PanelAxes = setPanelAxesLimits(PanelAxes, PanelData, AnalParams)
%

M = size(PanelAxes,1);
N = size(PanelAxes,2);
SubM = size(PanelAxes(1,1).SubPanel,1);

AxisMax = cell(1,SubM);
AxisMin = cell(1,SubM);

% Calculate the axes limits
for iSubM = 1:SubM
    for iM = 1:M
        for iN = 1:N
            SubN = size(PanelAxes(iM,iN).SubPanel,2);
            for iSubN = 1:SubN
                Data = PanelData(iM,iN).SubPanel(iSubM,iSubN).Data.Data;
                if ~isreal(Data); Data = abs(Data); end %To deal with coherence
                AxisMax{iSubM} = max([AxisMax{iSubM}, max(max(Data))]);
                AxisMin{iSubM} = min([AxisMin{iSubM}, min(min(Data))]);
            end
        end
    end
end

for iM = 1:M
    for iN = 1:N
        for iSubM = 1:SubM
            for iSubN = 1:SubN
                DataHandle = PanelAxes(iM,iN).SubPanel(iSubM,iSubN).DataHandle;
                DataHandleType = get(DataHandle,'Type');
                Axes = PanelAxes(iM,iN).SubPanel(iSubM,iSubN).Axes;
                switch DataHandleType
                    case 'image'
                        if isfield(AnalParams(iSubM,iSubN),'CLim') && ~isempty(AnalParams(iSubM,iSubN).CLim)
                            CLim = AnalParams(iSubM,iSubN).CLim;
                        else
                            CLim = [AxisMin{iSubM},AxisMax{iSubM}];
                        end
                        if diff(CLim); set(Axes,'CLim',CLim); end
                    case 'line'
                        if isfield(AnalParams(iSubM,iSubN),'YLim') && ~isempty(AnalParams(iSubM,iSubN).YLim)
                            YLim = AnalParams(iSubM,iSubN).YLim;
                        else
                            YLim = [AxisMin{iSubM},AxisMax{iSubM}];
                        end
                        if diff(YLim); set(Axes,'YLim',YLim); end
                end
                PanelAxes(iM,iN).SubPanel(iSubM,iSubN).Axes = Axes;
            end
        end
    end
end
