function [Sp,Spktimes] = spikeextract(Mu,thresh,SAMPLING)
%  SPIKEEXTRACT 
%  
%   [Sp,Spktimes] = spikeextract(Mu,thresh)
%
%  Inputs:      MU  =   Array.  Multiunit activity
%                 THRESH  =   Scalar.  Threshold for extraction.
%                               If two elements - extract positive and
%                               negative spikes
%               SAMPLING in Hz
%
%  Outputs:     SP                =  Array.  Spike waveforms.
%                                               1ms upsampled 4x.
%                   SPKTIMES    =  Vector.  Spike times at 1ms.
%   

if(nargin < 3)
    SAMPLING = 20;
else
    SAMPLING=SAMPLING/1e3;
end
DT = SAMPLING*1.6;

flag = 0;
if thresh > 0
    flag = 1;
end
if length(thresh)==2
    thresh = sort(thresh,'ascend');
    flag = 2; 
end

% % extract waveforms            
tmu = zeros(1,size(Mu,2));
switch flag
    case 1
        %disp('Positive threshold')
        tmu(Mu > thresh)=1;   %  Positive threshold
    case 0
        %disp('Negative threshold')
        tmu(Mu < thresh)=1;   %  Negative threshold
    case 2
        %disp('Positive and negative threshold')
        tmu(find(Mu < thresh(1) | Mu > thresh(2)))=1;
end

Spktimes = find(diff(tmu)>0)';
Sp = [];

n = find(Spktimes > DT & Spktimes < size(Mu,2)-DT);
nsp = length(n);
%disp([num2str(nsp) ' spikes']);
if nsp>0
    base = ones(nsp,1)*[-DT:DT];
    align = Spktimes(n,ones(1,size(base,2)));
    intspike = resample(reshape(Mu(base+align),size(align))',4,1);  % Upsampling
    switch flag
        case 1
        [a,ind] = max(intspike(3*DT:5*DT,:));    %  Positive threshold
        ind = ind + 3*DT-1;
        case 0
        [a,ind] = min(intspike(3*DT:5*DT,:));    %  Negative threshold
        ind = ind+3*DT-1;
        case 2
            neg = find(intspike(4*DT,:)<0);
            [a,negind] = min(intspike(3*DT:5*DT,neg));    %  Negative threshold
            pos = find(intspike(4*DT,:)>0);
            [a,posind] = max(intspike(3*DT:5*DT,pos));    %  Positive threshold
            [dum,interleaveind]=sort([neg pos],'ascend');
            negposind = [negind posind];
            negposind = negposind(interleaveind);
            ind = negposind + 3*DT-1;
    end
    ind = ind';
    % Sp = intspike;
    %  The following is to avoid indexing spikes at edge of spike extraction
    %  window
    n = find(ind > DT+1 & ind < size(intspike,1)-3*DT);  %  What are the right numbers here for 8x oversampling?
    %disp(['  ' num2str(length(n)) ' spikes']);
    if n > 0
        base = ones(length(n),1)*[-DT:3*DT];
        x = 1:length(n);
        xx = x(ones(1,size(base,2)),:)*size(intspike,1);
        xx = xx'-size(intspike,1);
        align = ind(n,ones(1,size(base,2)));
        index = base+align+xx;
        index = index';
        intspike = intspike(:,n);
        Sp = intspike(index(1:4:end,:));            %  Downsampling
        Spktimes = Spktimes(n')./SAMPLING;
    else
        Sp = zeros(1,DT+1);
        Spktimes = zeros(1,1);
    end
else
    %Sp = zeros(1,DT+1);
    Sp = [];
    Spktimes = zeros(1,1);
end

Sp =Sp';
