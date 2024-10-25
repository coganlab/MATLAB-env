function [sv,space,f_axis] = fsvd_tr(X, tapers, sampling, dn, fk)
%FSVD_TR  Space-frequency calculation using multitaper methods with
%      trial averaging over the first index.
%
% [SV, SPACE, F] = FSVD_TR(X, TAPERS, SAMPLING, DN, FK) 
%
%  Inputs:  X		=  Time series array in [Trials,Space,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N,W] form.
%			   	Defaults to [N,3,5] where N is NT/10
%				and NT is duration of X. 
%	    SAMPLING 	=  Sampling rate of time series X in Hz. 
%				Defaults to 1.
%	    DN		=  Overlap in time between neighbouring windows.
%			       	Defaults to N./10;
%	    FK 	 	=  Frequency range in Hz in FK(1):FK(2):FK(3) form.        
%			   	Defaults to [0,SAMPLING/20,SAMPLING/2]
%
%   Outputs:  SV  =   Singular value spectrum in [Time,Frequency,Mode] form.
%       SPACE   =   Space modes in [Time,Frequency,Space,Mode] form.
%
%   Author: Bijan Pesaran, version date 12/12/2002.

% parameters/defaults:


szX=size(X);  
nTr = szX(1);               % ntr is the number of trials
nCh = szX(2);
nt = szX(3);                % nt is the number of time points.

if nargin < 3 sampling = 1.; end
N = floor(nt./10)./sampling;
if nargin < 2 tapers = [N,3,5]; end
if length(tapers) == 2
   N = tapers(1);
   w = tapers(2);
   p = N*w;
   K = floor(2*p-1);
   tapers = [N,p,K];
   disp(['Using ' num2str(K) ' tapers.']);
end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling;  
   tapers = dpsschk(tapers);
end
K = length(tapers(1,:)); 
N = length(tapers(:,1));
if nargin < 4 dn = N./10; end
if nargin < 5 fk = [0,sampling./20.,sampling./2.]; end
dn = dn.*sampling;

t = 0;
if nt > N t = 1; end         % set time processing flag

if t nwin = floor((nt-N)./dn); end   % nwin is the number of time windows
f_axis = [fk(1):fk(2):fk(3)];
nf = length(f_axis);

if ~t                       % process the single window case
	disp('Processing the single window case'); 
    % Allocate the various matrices
    sv = zeros(nf,min(K*nTr,nCh));
    space = zeros(nf,nCh,min(K*nTr,nCh));
%     freq = zeros(nf,num,K);
    time = zeros(nf,N);
    ftapers = zeros(K,N); 
    
    for ii = 1:nf
        tt = exp(j.*2.*pi.*f_axis(ii).*[1:N]./sampling);
        pr_op = dp_proj(tapers,sampling,f_axis(ii));
        PROJ = zeros(nCh, nTr*K);
        for iTr = 1:nTr
            X_proc_tr = sq(X(iTr,:,:));
            PROJ(:,(iTr-1)*K+1:iTr*K) = X_proc_tr*pr_op;
        end    
        [u,s,v] = svd(PROJ);
        sv(ii,:) = diag(s);
        space(ii,:,:) = u;
        %    freq(ii,:,:)=v(1:num,:);
        %for jj=1:K ftapers(jj,:)=tapers(:,jj)'.*tt; end
        %    time(ii,:)=(ftapers'*squeeze(freq(ii,1,:)))';
    end
else        % process the moving-window case
disp('Processing the moving-window case');
    sv = zeros(nwin,nf,min(K*nTr,nCh));
    space = zeros(nwin,nf,nCh,min(K*nTr,nCh));    
    for win = 1:nwin
tic
        disp(['Window ' num2str(win) ' of ' num2str(nwin)]);
        for ii = 1:nf
            PROJ = zeros(nCh,nTr*K);
            pr_op = dp_proj(tapers,sampling,f_axis(ii));
            for iTr = 1:nTr
                X_proc_tr = sq(X(iTr,:,:));
                PROJ(:,(iTr-1)*K+1:iTr*K) = X_proc_tr(:,floor(win*dn)+1:floor(win*dn)+N)*pr_op;
            end
            [u,s,v] = svd(PROJ);
            sv(win,ii,:) = diag(s);
            space(win,ii,:,:) = u;
        end
toc
    end
end
