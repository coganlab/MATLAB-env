function [rho, Xspace, Yspace] = pfcca_tr(X, Y, tapers, sampling, dn, fk);
%PFCCA_TR  Parallel version of FCCA_TR for multivariate time series
%
% [RHO, XSPACE, YSPACE] = PFCCA_TR(X, Y, TAPERS, SAMPLING, DN, FK) 
%
%  Inputs:  X		=  Time series array in [Trials,Space,Time] form.
%       Y		=  Time series array in [Trials,Space,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N,W] form.
%			   	Defaults to [N,3,5] where N is NT/10
%				and NT is duration of X. 
%	    SAMPLING 	=  Sampling rate of time series X in Hz. 
%				Defaults to 1.
%	    DN		=  Overlap in time between neighbouring windows.
%			       	Defaults to N./10;
%	    FK 	 	=  Frequency range to return in Hz in
%
%  Outputs: RHO	=  Canonical correlation in [Time, Freq, Mode] form. 
%       XSPACE   =   X Space modes in [Time,Frequency,Space,Mode] form.
%       YSPACE   =   Y Space modes in [Time,Frequency,Space,Mode] form.
%
%   See also DPSS, PSD, SPECGRAM.

%   Author: Bijan Pesaran, version date 01/09/03.

szX=size(X);
nTr = szX(1);               % ntr is the number of trials
nChX = szX(2);
nt = szX(3);                % nt is the number of time points.

szY=size(Y);
nTr = szY(1);               % ntr is the number of trials
nChY = szY(2);
nt = szY(3);                % nt is the number of time points.

nCh = nChX;

if nargin < 4 sampling = 1.; end
n = floor(nt./10)./sampling;
if nargin < 3 tapers = [n,3,5]; end
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling;  
   tapers = dpsschk(tapers);
end
if nargin < 5 dn = n./10; end
if nargin < 6 fk = [0,sampling./20.,sampling./2.]; end

K = length(tapers(1,:)); 
N = length(tapers(:,1));
if N > nt error('Error: Tapers are longer than time series'); end

% Determine outputs
errorchk = 0;
if nargout > 2 errorchk = 1; end

dn = dn.*sampling;
f_axis = [fk(1):fk(2):fk(3)];

nf = length(f_axis); 
nwin = floor((nt-N)./dn);           % calculate the number of windows
neid = PMI_Size;
eid = [1:neid];

%  Need to determine the parcellation for trials,freq,time over cluster
nspecs = nwin*nf;  
% blksize = 20; % Define load per node = number of tfspectra to calculate
niter = nwin;

for id = 1:neid
    status = PMI_Send2(eid(id),tapers);
end

it = 0;
rit = 0;
rho = zeros(nwin,nf,min(K*nTr,nCh));
while (it < nwin)
    for id = 1:neid
        if it < nwin
            it = it+1;
            disp(['Iteration ' num2str(it) ' of ' num2str(nwin)]); 
            tmp1 = X(:,:,(it-1)*dn+1:(it-1)*dn+N);
            tmp2 = Y(:,:,(it-1)*dn+1:(it-1)*dn+N);
            status = PMI_Send2(eid(id),tmp1);
            status = PMI_Send2(eid(id),tmp2);

            cmd = ['rhotmp = fcca_tr(tmp1, tmp2, tapers, ' num2str(sampling) ...
                    ',' num2str(dn./sampling) ',[' num2str(fk(1)) ...
                    ',' num2str(fk(2)) ',' num2str(fk(3)) ']);'];    
            PMI_IEval(eid(id),cmd);
            disp([' ... Computing on engine ' num2str(eid(id))]);
        end
    end
    for id = 1:neid
        if rit < nwin
            rit = rit+1;
            rhotmp = PMI_Recv(eid(id),'rhotmp');
            rho(rit,:,:) = rhotmp;
        end
    end
end

% it = niter;
% rit = niter;
% tmp1 = X(:,:,it*blksize+1:end);
% tmp2 = Y(:,:,it*blksize+1:end);
% 
% if size(tmp1,1)
%   rhotmp = fcca_tr(tmp1, tmp2, tapers,sampling,dn./sampling,fk);
%   rho(rit*blksize+1:end,:,:) = rhotmp;
% end
