function PanelCoords = calcSubPanelCoords(AnalParams, PlotParams, PanelCoords);
%
%  PanelCoords = calcSubPanelCoords(AnalParams, PlotParams, PanelCoords);
%
%  Calculates the lower-left edge, width and height of each subpanel within each panel
%
%  AnalParams is in row-major format.
%  AnalParams(i,:).bn should be the same
%
%  SubPanelCoords = calcSubPanelCoords(AnalParams, PlotParams, PanelCoords);
%
%  PanelCoords(M,N).SubPanelCoords(SubM,SubN).LowerLeft
%  PanelCoords(M,N).SubPanelCoords(SubM,SubN).Width
%  PanelCoords(M,N).SubPanelCoords(SubM,SubN).Height
%
%       Note:  All variables in normalized units
%

SubM = size(AnalParams,1); % Number of rows = Number of plot-types
SubN = size(AnalParams,2); % Number of columns = Number of alignment times

M = size(PanelCoords,1);
N = size(PanelCoords,2);

H = PanelCoords.Height;
W = PanelCoords.Width;

TotalTime = 0;
for iSubN = 1:SubN
  TotalTime = TotalTime + diff(AnalParams(1,iSubN).bn);
end
PropTime = zeros(1,SubN);
for iSubN = 1:SubN
  PropTime(iSubN) = diff(AnalParams(1,iSubN).bn)./TotalTime;
end

for iM = 1:M
  for iN = 1:N
    for iSubM = 1:SubM
      for iSubN = 1:SubN
	Height = (PanelCoords(iM,iN).Height - PlotParams.SubTextBar.TopMargin ...
        - (SubM-1)*PlotParams.Margins.SubInner)./SubM;
	Width = PropTime(iSubN).*(PanelCoords(iM,iN).Width ...
		- PlotParams.SubTextBar.SideMargin ...
		- (SubN-1)*PlotParams.Margins.SubInner);
	PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Height = Height;
	PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Width = Width;
      end
    end
  end
end

for iM = 1:M
  for iN = 1:N
    VerticalOffset = 0;
    for iSubM = 1:SubM
      HorizontalOffset = 0;
      for iSubN = 1:SubN
	SubPanelWidth = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Width;
        SubPanelHeight = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Height;

        LowerLeft(1) = PanelCoords(iM,iN).LowerLeft(1) + HorizontalOffset;
        LowerLeft(2) = PanelCoords(iM,iN).LowerLeft(2) + VerticalOffset;
        PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).LowerLeft = LowerLeft;

	if iSubN == SubN 
          VerticalOffset = VerticalOffset + PlotParams.Margins.SubInner ...
              + SubPanelHeight;
	end
	HorizontalOffset = HorizontalOffset + PlotParams.Margins.SubInner ...
				+ SubPanelWidth;
      end
    end
  end
end

