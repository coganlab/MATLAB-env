function C = spontTScorr(dat)

%C = spontTScorr(dat)
%computes pair-wise time-series correlation of each electrode pair. 
%INPUT: dat - (channels x time) matrix of time-series data
%
%OUTPUT: C - (channels x channels) correlation matrix with pairwise
%correlations. Note, only calculates C(i,j) for j>i. All other entries are NaN;


nE = size(dat,1);

C = nan(nE, nE);

%start cluster if not already open
hPool = gcp('nocreate');
if isempty(hPool)
    hPool = parpool('local');
end

parfor iE1 = 1:nE
    if mod(iE1,5)==1
        fprintf('     electrode %d...\n', iE1)
    end
    
    C_tmp = nan(1,nE);
    for iE2 = iE1+1:nE
        
        dum = corrcoef(dat(iE1,:)', dat(iE2,:), 'rows', 'pairwise');
        C_tmp(iE2) = dum(1,2);
    end
    
    C(iE1,:) = C_tmp;
end