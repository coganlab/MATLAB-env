function responses = responseextract(delta, data, Nsnip)
%
% responses = responseextract(delta, data, Nsnip)  
%
%  Inputs:      DELTA  =    Array.  delta functions at pulses activity
%		DATA   =    Array.  data array.
%		NSNIP  =    Scalar. Number of points to extract for each response.
%
%  Outputs:     RESPONSES         =  Array.  Response waveforms.            
%   


% % extract waveforms            

if length(Nsnip) == 1
    Nsnip = Nsnip./2*[-1,1];
end

tot = 0;
for iBurst = 1:size(delta,1)
  tot = tot+length(find(delta(iBurst,-Nsnip(1)+1:end-Nsnip(2))>0.5));
end

responses = zeros(tot,diff(Nsnip)+1);
Nresponses = 0;
for iBurst = 1:size(delta,1);
    Pulsetimes = find(delta(iBurst,-Nsnip(1)+1:end-Nsnip(2)-1)>0.5)' - Nsnip(1);
    num_delta = length(Pulsetimes);
    %  disp([num2str(num_delta) ' pulses']);
    base = ones(num_delta,1)*[Nsnip(1):Nsnip(2)];
    align = Pulsetimes(:,ones(1,size(base,2)));
    index = base+align;
    tmp = data(iBurst,:);
    responses(Nresponses+1:Nresponses+num_delta, :) = tmp(index);
    Nresponses = Nresponses + num_delta;
end

responses = responses - repmat(mean(responses(:,:),2),1,diff(Nsnip)+1);
