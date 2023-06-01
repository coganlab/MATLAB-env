function PanelAxes = setPanelLabels(PanelCoords, PanelAxes, PanelData, CondParams, AnalParams)
%
%  PanelAxes = setPanelLabels(PanelCoords, PanelAxes, PanelData, CondParams, AnalParams)
%

M = size(PanelAxes,1);
N = size(PanelAxes,2);
SubM = size(PanelAxes(1,1).SubPanel,1);
SubN = size(PanelAxes(1,1).SubPanel,2);

%  Type labels on right side
for iM = 1:M
    for iN = N
        for iSubM = 1:SubM
            for iSubN = SubN
                Type = AnalParams(iSubM,iSubN).Type;
                LowerLeft = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).LowerLeft;
                Height = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Height;
                Width = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Width;
                Location = [LowerLeft(1)+Width+0.015,LowerLeft(2)];
                axes('position',[Location,0.05,Height]);
                axis off;
                text(0,1, Type,'Rotation',-90,'VerticalAlignment','bottom');
            end
        end
    end
end

%  Colorbars on right side
for iM = 1:M
    for iN = N
        for iSubM = 1:SubM
            for iSubN = SubN
                Type = get(PanelAxes(iM,iN).SubPanel(iSubM,iSubN).DataHandle,'Type');
                if strcmp(Type,'image')
                    LowerLeft = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).LowerLeft;
                    Height = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Height;
                    Width = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Width;
                    Location = [LowerLeft(1)+Width+0.01,LowerLeft(2)];
                    ax=axes('position',[Location,0.05,Height]);
                    axis off;                cax = colorbar('peer',ax);
                    set(cax, 'Fontsize', 8);
                    CLim = get(PanelAxes(iM,iN).SubPanel(iSubM,iSubN).Axes,'CLim');
                    vals = linspace(CLim(1),CLim(2),5);
                    for iTick = 1:5; YTickLabel{iTick} = num2str(vals(iTick)); end
                    set(cax,'TickDir','out','YTick',[1,16,32,48,64],'YTickLabel',YTickLabel);
                end
            end
        end
    end
end

%  Type labels on top
for iM = 1:M
    for iN = 1:N
        for iSubM = SubM
            for iSubN = 1
                Data = PanelData(iM,iN).SubPanel(iSubM,iSubN).Data;
                TaskString = [];
                if iscell(CondParams(iM,iN).Task)
                    for iTask = 1:length(CondParams(iM,iN).Task{1});
                        CurrentTaskString = CondParams(iM,iN).Task{1}{iTask};
                        TaskString = [TaskString ' ' CurrentTaskString];
                    end
                else
                    TaskString = CondParams(iM,iN).Task;
                end
                DirString = ['Direction ' num2str(CondParams(iM,iN).conds{1})];
                if isfield(CondParams(iM,iN),'Norm')
                    DirString = [DirString ' vs ' num2str(CondParams(iM,iN).Norm.Cond{1})];
                end
                TrialsString = [num2str(Data.NumTrials) ' Trials'];
                LowerLeft = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).LowerLeft;
                Height = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Height;
                Width = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Width;
                Location = [LowerLeft(1),LowerLeft(2)+Height];

                axes('position',[Location,Width,0.05]);
                axis off;
                text(0,0.25,[TaskString ' ' DirString],'VerticalAlignment','bottom');
                text(0,0,TrialsString,'VerticalAlignment','bottom');
            end
        end
    end
end

%  Field labels on bottom
for iM = 1
    for iN = 1:N
        for iSubM = 1
            for iSubN = 1:SubN
                axes(PanelAxes(iM,iN).SubPanel(iSubM,iSubN).Axes);
                xlabel(AnalParams(iSubM,iSubN).Field);
            end
        end
    end
end
