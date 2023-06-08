function ph_trig = phasetrigextract(data, ph, pref_ph, dt)
%
% ph_trig = phasetrigextract(data, ph, pref_ph, dt)
%

ph_trig = [];
for iTr = 1:size(ph,1)
  ts = data(iTr,:)';
  ph_tr = ph(iTr,:);
  binph = zeros(1,length(ph_tr));
  binph(ph_tr > pref_ph)=1;
  ind = find(binph(1:end-1)==1 & binph(2:end)==0);
  ind = ind';
  n = find(ind>-dt(1)+1 & ind<length(data)-dt(2));
  if ~isempty(n)
    base = ones(length(n),1)*[dt(1):dt(2)];
    align = ind(n,ones(1,size(base,2)));
    index = base+align;
    ph_trig = [ph_trig;ts(index)];
  end
end


