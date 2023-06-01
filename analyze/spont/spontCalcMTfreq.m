function f = spontCalcMTfreq(nt, sampling, tapers, dn, fk, pad)

%f = spontCalcMTfreq(nt, sampling, tapers, dn, fk)
%function quickly runs calculations done at the beginning of tfcoh/tfspec
%to compute the frequency bins for spectral calculations. 
%useful to pre-allocate memory/space 
%
%input: nt - number of time-points
%       sampling - sampling rate (Hz)
%       tapers   - tapers to use. Format as outlined in tfcoh, tfspec
%       dn       - time-window for spectral estimates
%       fk       - cut-off frequency
%       pad      - padding
%
%output: f - frequencies 

if length(tapers) == 2
    n = tapers(1);
    w = tapers(2);
    p = n*w;
    k = floor(2*p-1);
    tapers = [n,p,k];
    %disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3
    tapers(1) = floor(tapers(1).*sampling);
    tapers = single(dpsschk(tapers));
end

if length(fk) == 1
    fk = [0,fk];
end

if  isempty(pad); pad = 2; end

K = length(tapers(1,:));
N = length(tapers(:,1));
if N > nt error('Error: Tapers are longer than time series'); end


dn = floor(dn.*sampling);
nf = max(256, pad*2^nextpow2(N+1));
nfk = floor(fk./sampling.*nf);
f = linspace(fk(1),fk(2),diff(nfk));