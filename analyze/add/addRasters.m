function addRasters(ax, Spikes1, Spikes2, XRange, YRange, colors)
%
%  addRasters(ax, Spikes1, Spikes2, XRange, YRange, colors)
%

if nargin < 6; colors = [0,.5]; end

% nTr1 = min([20,length(Spikes1)]);
% nTr2 = min([20,length(Spikes2)]);

nTr1 = length(Spikes1);
nTr2 = length(Spikes2);
dT = (YRange(2)-YRange(1))./(nTr1 + nTr2);

if nTr2
  for iTr2 = 1:nTr2
    ind = find(Spikes2{iTr2} > XRange(1) & Spikes2{iTr2} < XRange(2));
    for iSpike = 1:length(ind)
      h=line([Spikes2{iTr2}(ind(iSpike)),Spikes2{iTr2}(ind(iSpike))]-XRange(1), YRange(1) + [(iTr2-1)*dT iTr2*dT]);
      set(h,'Color',colors(2).*[1,1,1])
    end
  end
end

if nTr1
  for iTr1 = 1:nTr1
    ind = find(Spikes1{iTr1} > XRange(1) & Spikes1{iTr1} < XRange(2));
    for iSpike = 1:length(ind)
      h=line([Spikes1{iTr1}(ind(iSpike)),Spikes1{iTr1}(ind(iSpike))]-XRange(1), YRange(1) + nTr2*dT + [(iTr1-1)*dT iTr1*dT]);
      set(h,'Color',colors(1).*[1,1,1]);
    end
  end
end
set(gca,'YLim',[0,YRange(2)]);