function [coh_pt, tfsp_dN, tfsp_dM, rate_dN, rate_dM, f, ...
		coh_err, tfsp_dN_err, tfsp_dM_err] = ...
   tfcoh_pt(dN, dM, tapers, sampling, dn, fk, pad, pval, flag);
%TFCOH_PT  Moving window time-frequency point process coherency.
%
%  [COH_PT, TFSP_DN, TFSP_DM, RATE_dN, RATE_dM, F, ...
%		COH_ERR, TFSP_DN_ERR, TFSP_DM_ERR] = ...
%		TFCOH_PT(dN, dM, TAPERS, DN, SAMPLING, FK, PAD, PVAL, FLAG) 
%
%  Inputs:  dN		=  Point process array in [Space/Trials,Time] form.
%	    dM		=  Point process array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME] form or [N,P,K] form.
%			   	Defaults to [N, 3, 5] where N is NT/10
%	    SAMPLING 	=  Sampling rate of point process, dN, in Hz. 
%				Defaults to 1.
%	    DN		=  Overlap in time of neighbouring windows.
%			       	Defaults to N./10;
%	    FK 	 	=  Frequency range to return in Hz in
%                               either [F1,F2] or [F2] form.  
%                               In [F2] form, F1 is set to 0.
%			   	Defaults to [0,SAMPLING/2]
%	    PAD		=  Padding factor for the FFT.  
%			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
%			      	to 1024 points; if PAD = 4, we pad the FFT
%			      	to 2048 points.
%				Defaults to 2.
%	   PVAL		=  P-value to calculate error bars for.
%				Defaults to 0.05 i.e. 95% confidence.
%
%	   FLAG = 0:	calculate COH_PT seperately for each channel/trial.
%	   FLAG = 1:	calculate COH_PT by pooling across channels/trials. 
%	   FLAG = 11 	calcuation is done as for FLAG = 1 
%		but the error bars cannot be calculated to save memory.
%	   	Defaults to FLAG = 11.
%
%  Outputs: COH_PT	=  TF Coh between dN and dM in [Space,Time,Freq] form. 
%	    TFSP_dN	=  TF Spec of dN in [Space,Time,Freq] form.  
%	    TFSP_dM	=  TF Spec of dM in [Space,Time,Freq] form.    
%	    RATE_dN	=  Rate of point process dN.  
%	    RATE_dM	=  Rate of point process dM.  
%	    F		=  Units of Frequency axis for COH_PT. 
%	    COH_ERR 	=  Error bars for COH_PT in [Hi/Lo,Space,Time,Freq]
%			   form given by the Jacknife-t interval for PVAL. 
% 	    TFSP_dN_ERR =  Error bars for TFSP_dN.
% 	    TFSP_dM_ERR =  Error bars for TFSP_dM.
%
%
%   Author: Bijan Pesaran, Bell Labs, July 2000.

sdN = size(dN);
nt1  = sdN(2);              % calculate the number of points
nch1 = sdN(1);              % calculate the number of channels/trials

sdM  = size(dM);
nt2  = sdM(2);              % calculate the number of points
nch2 = sdM(1);              % calculate the number of channels/trials

if nt1 ~= nt2 error('Both processes must have the same length'); end
nt = nt1;

if nch1 ~= nch2 
   error('Both processes must have the same number of channels/trials'); 
end
nch = nch1;

if nargin < 4 sampling = 1.; end
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3
   tapers(1) = floor(tapers(1).*sampling);  
   tapers = dpsschk(tapers);
end
n = length(tapers(:,1));
if nargin < 5 dn = n./10; end
if nargin < 6 fk = [0,sampling./2.]; end
if length(fk) == 1  fk = [0,fk]; end
if nargin < 7 pad = 2; end
if nargin < 8 pval = 0.05; end
if nargin < 9 flag = 11; end

errorchk = 0;
if nargout > 6 errorchk = 1; end

dn = floor(dn.*sampling);
nf = max(256, pad*2^nextpow2(n+1)); 
nfk = floor(fk./sampling.*nf);
nwin = floor((nt-n)./dn);          % calculate the number of windows
f = linspace(fk(1),fk(2),diff(nfk));

if flag	== 0			% No pooling across trials
    disp('No pooling across trials')
    
    coh_pt = zeros(nch,nwin,diff(nfk));
    tfsp_dN = zeros(nch,nwin,diff(nfk));
    tfsp_dM = zeros(nch,nwin,diff(nfk));
    rate_dN = zeros(nch,nwin);
    rate_dM = zeros(nch,nwin);
    
    if errorchk
        coh_err =zeros(2, nch, nwin, diff(nfk));
        tfsp_dN_err =zeros(2, nch, nwin, diff(nfk));
        tfsp_dM_err =zeros(2, nch, nwin, diff(nfk));
    end
    for ch = 1:nch
        for win = 1:nwin
            tmp1 = dN(ch,win*dn+1:win*dn+n);
            tmp2 = dM(ch,win*dn+1:win*dn+n);
            if ~errorchk				%  Don't estimate error bars
                disp('Don''t estimate error bars')
                [coh_tmp, sdn_tmp, sdm_tmp, rate_dn, rate_dm] = ...
                    coherency_pt(tmp1, tmp2, tapers, sampling, fk, pad);
                coh_pt(ch,win,:) = coh_tmp;
                tfsp_dN(ch,win,:) = sdn_tmp;
                tfsp_dM(ch,win,:) = sdm_tmp;
                rate_dN(ch,win) = rate_dn;
                rate_dM(ch,win) = rate_dm;
            else 					%  Estimate error bars
                disp('Estimate error bars');
                [coh_tmp, sdn_tmp, sdm_tmp, rate_dn, rate_dm, dum, ...
                        cerr_tmp, dnerr_tmp, dmerr_tmp] = ... 	
                    coherency_pt(tmp1,tmp2,tapers,sampling,fk,pad,pval);
                coh_pt(ch,win,:) = coh_tmp; 	
                tfsp_dN(ch,win,:) = sdn_tmp;
                tfsp_dM(ch,win,:) = sdm_tmp;
                rate_dN(ch,win) = rate_dn;
                rate_dM(ch,win) = rate_dm;
                coh_err(1,ch,win,:) = cerr_tmp(1,:);
                coh_err(2,ch,win,:) = cerr_tmp(2,:);
                tfsp_dN_err(1,ch,win,:) = dnerr_tmp(1,:);
                tfsp_dN_err(2,ch,win,:) = dnerr_tmp(2,:);
                tfsp_dM_err(1,ch,win,:) = dmerr_tmp(1,:);
                tfsp_dM_err(2,ch,win,:) = dmerr_tmp(2,:);
            end
        end
    end
end

if flag	> 0				% Pooling across trials
%     disp('Pooling across trials')
    coh_pt = zeros(nwin,diff(nfk));
    tfsp_dN = zeros(nwin,diff(nfk));
    tfsp_dM = zeros(nwin,diff(nfk));
    rate_dN = zeros(1,nwin);
    rate_dM = zeros(1,nwin);
    
    if errorchk
        coh_err =zeros(2, nwin, diff(nfk));
        tfsp_dN_err =zeros(2, nwin, diff(nfk));
        tfsp_dM_err =zeros(2, nwin, diff(nfk));
    end
    for win = 1:nwin
        tmp1 = dN(:,win*dn+1:win*dn+n);
        tmp2 = dM(:,win*dn+1:win*dn+n);
        if ~errorchk				%  Don't estimate error bars
%             disp('Don''t estimate error bars')
            [coh_tmp, sdn_tmp, sdm_tmp, rate_dn, rate_dm] = ...
                coherency_pt(tmp1, tmp2, tapers,sampling,fk,pad,pval,flag); 
            coh_pt(win,:) = coh_tmp;
            tfsp_dN(win,:) = sdn_tmp;
            tfsp_dM(win,:) = sdm_tmp;
            rate_dN(win) = rate_dn;
            rate_dM(win) = rate_dm;
        else					%  Estimate error bars
%             disp('Estimate error bars');
            [coh_tmp, sdn_tmp, sdm_tmp, rate_dn, rate_dm, dum, ...
                    cerr_tmp, dnerr_tmp, dmerr_tmp] = ... 
                coherency_pt(tmp1, tmp2, tapers, sampling, fk, pad,pval,flag);
            coh_pt(win,:) = coh_tmp; 	
            tfsp_dN(win,:) = sdn_tmp;
            tfsp_dM(win,:) = sdm_tmp;
            rate_dN(win) = rate_dn;
            rate_dM(win) = rate_dm;
            coh_err(1,win,:) = cerr_tmp(1,:);
            coh_err(2,win,:) = cerr_tmp(2,:);
            tfsp_dN_err(1,win,:) = dnerr_tmp(1,:);
            tfsp_dN_err(2,win,:) = dnerr_tmp(2,:);
            tfsp_dM_err(1,win,:) = dmerr_tmp(1,:);
            tfsp_dM_err(2,win,:) = dmerr_tmp(2,:);
        end
    end
end
