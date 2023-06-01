function isi = calcIsi(Spike)
%
%  isi = calcIsi(Spike)
%

isi = [];

if iscell(Spike)
  nTr = length(Spike);
  for iTr = 1:nTr
    isi = [isi diff(Spike{iTr})'];
  end
else
  nTr = size(Spike,1);
  for iTr = 1:nTr
    sptimes = find(Spike(iTr,:));
    isi = [isi diff(sptimes)];
  end
end
