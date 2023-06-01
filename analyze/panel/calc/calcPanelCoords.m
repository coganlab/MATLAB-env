function PanelCoords = calcPanelCoords(CondParams, PlotParams)
%
%  Calculates the lower-left edge, width and height of each panel
%
%  CondParams is in row-major format.
%
%  PanelCoords = calcPanelCoords(CondParams, PlotParams)
%
%	PanelCoords(M,N).LowerLeft = x,y coordinates
%	PanelCoords(M,N).Height = Height of panels
%	PanelCoords(M,N).Width = Width of panels
%
%	Note:  All variables in normalized units

M = size(CondParams,1);
N = size(CondParams,2);

for iM = 1:M
  for iN = 1:N
    PanelCoords(iM,iN).Height = (1 - PlotParams.TitleBar.Height - ...
			2*PlotParams.Margins.Outer - (M-1)*PlotParams.Margins.Inner)./M;
    PanelCoords(iM,iN).Width = (1 - 2*PlotParams.Margins.Outer - ...
				(N-1)*PlotParams.Margins.Inner)./N;
  end
end

for iM = 1:M
  for iN = 1:N
    PanelCoords(iM,iN).LowerLeft(1) = PlotParams.Margins.Outer + ...
        (iN-1)*(PanelCoords(iM,iN).Width + PlotParams.Margins.Inner);
    PanelCoords(iM,iN).LowerLeft(2) = PlotParams.Margins.Outer + ...
	(iM-1)*(PanelCoords(iM,iN).Height + PlotParams.Margins.Inner);
  end
end


