function [PCALfp, PCAParams] = processPCALFP(LfpIn, PCAParams)
%
%
%   PCAParams.U
%   PCAParams.s 
%   PCAParams.MedParam
%   PCAParams.nDim
%   
%   PCAParams.Mean
%   PCAParams.Base;

if length(size(LfpIn))==3
    Lfp = shiftdim(LfpIn,1);
    Lfp = reshape(Lfp,size(Lfp,1),size(Lfp,2).*size(Lfp,3));
else
    Lfp = LfpIn;
end

Lfp = log(abs(Lfp));
% 
% if nargin < 2 || isempty(PCAParams)
%     PCAParams.MedParam = 10;
% end

if isfield(PCAParams,'nDim');
    nDim = PCAParams.nDim;
else
    nDim = size(Lfp,1);
end
% if isfield(PCAParams,'MedParam')
%     MedParam = PCAParams.MedParam;
% else
%     MedParam = 10;
% end

    meanLfp = mean(Lfp);
    meanCenteredLfp = Lfp - repmat(meanLfp, size(Lfp,1), 1);
    meanCenteredLfp = meanCenteredLfp';

    if isfield(PCAParams,'U')
        u = PCAParams.U;
    else
       [u,s,v] = svd(meanCenteredLfp,0);
%        [u,s,v] = tqlisvd(meanCenteredLfp);
        PCAParams.U = u;
        PCAParams.s = s;
    end
    if isfield(PCAParams,'nDim')        
%nDim
%whos u
        u = u(:,1:nDim);
    end
    PCAParams.U = u;

    PCALfp = u'*meanCenteredLfp;
    
    
    PCAParams.Mean = meanLfp;
    PCAParams.nDim = size(PCALfp,1);
