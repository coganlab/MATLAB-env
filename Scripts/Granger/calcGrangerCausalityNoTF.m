function G = calcGrangerCausalityNoTF(Lfp1ktmp, Lfp2ktmp, tapers, sampling_rate, dn, fk, pad, nIter,nPerm)
%  G = calcGrangerCausality(Lfp1, Lfp2, tapers, sampling_rate, dn, fk, pad, nIter,nPerm)
%  
%  Calculates 2-channel non-parametric granger causality in the frequency domain
%  via wilson-burg decomposition of spectral matrix
%
%  Lfp1  =  Signal1 in trials x time format
%  Lfp2  =  Signal2 in trials x time format
%  tapers  =  [N,W] Spectral analysis parameters
%  sampling_rate  =  Digitization rate in Hz
%  dn  =  Stepsize in ms
%  fk  =  [f1 f2] Frequency bands to keep
%  pad  =  Frequency padding
%  nIter  =  Number of iterations to select for wilson-burg decomposition
%  nPerm  =  Number of permutations for statistics

% GBC 7-31-2014 Added Permutations

numtrials = size(Lfp1ktmp,1);
nchan = 2;
nTapers = tapers(1);

if nargin<9
    nPerm=0;
end




for iPerm=1:nPerm+1

    if iPerm>1
        shuffM=floor(size(Lfp2ktmp,1)./2);
        shuffV=floor(rand(1,1)*12-6);
        Lfp2k=Lfp2ktmp(shuffle(1:size(Lfp2ktmp,1)),:,:,:);
           
    else
           Lfp2k=Lfp2ktmp;
    end
       
Lfp1k=Lfp1ktmp;
       
nwin = size(Lfp1k,2);  nfk = size(Lfp1k,4);  K = size(Lfp1k,3);
Lfp1k = permute(Lfp1k, [1,3,2,4]);
Lfp1k = reshape(Lfp1k, [numtrials*K, nwin, nfk]);
Lfp2k = permute(Lfp2k, [1,3,2,4]);
Lfp2k = reshape(Lfp2k, [numtrials*K, nwin, nfk]);

SLfp1 = squeeze(sum(Lfp1k.*conj(Lfp1k)));
SLfp2 = squeeze(sum(Lfp2k.*conj(Lfp2k)));
CrossSpec{1} = squeeze(sum(Lfp1k.*conj(Lfp1k)))/size(Lfp1k,1);
CrossSpec{2} = squeeze(sum(Lfp1k.*conj(Lfp2k)))/size(Lfp1k,1);
CrossSpec{3} = squeeze(sum(Lfp2k.*conj(Lfp1k)))/size(Lfp1k,1);
CrossSpec{4} = squeeze(sum(Lfp2k.*conj(Lfp2k)))/size(Lfp2k,1);
if nwin == 1
    SLfp1 = SLfp1.'; SLfp2 = SLfp2.'; CrossSpec = CrossSpec.';
end
S = zeros(size(CrossSpec{1},2), size(CrossSpec{1},1), nchan, nchan); %(f, t, S(f))
for iFreq = 1:size(CrossSpec{1},2)
    for iPair = 1:nchan^2
        CS = CrossSpec{iPair};
        S(iFreq, :, iPair) = CS(:, iFreq);
    end
end
%tic
So = S;
Sest = zeros(size(S,2),size(S,3),size(S,4),size(S,1));
Hest = zeros(size(S,2),size(S,3),size(S,4),size(S,1));
Zest = zeros(size(S,2), size(S,3), size(S,4));
%Psiest = zeros(size(S,2),size(S,3),size(S,4),size(S,1));
parfor it = 1:size(S,2) % change back to parfor!
    S = squeeze(So(:,it,:,:));
    S = permute(S, [2 3 1]);
     nf = max(256, pad*2^nextpow2(nTapers*sampling_rate+1));
     nfk = floor(fk./sampling_rate.*nf);
    freq = linspace(fk(1),fk(2),diff(nfk));
   % freq=1:1:size(So,1);
  %  tic
  tmp=S;
  % SO SVD
%   
%    dat     = sum(tmp,3); % sum over freq?
%       [u,s,v] = svd(real(dat));
%       for k = 1:size(S,3)
%         tmp(:,:,k) = u'*tmp(:,:,k)*u;
%       end
  
  
  
%  tic
   % [Htmp, Ztmp, Stmp, psi] = sfactorization_wilsonWavelet(tmp,freq, nIter);
      [Htmp, Ztmp, Stmp, psi] = sfactorization_wilson(tmp,freq, nIter);
 %   toc
     
    % Undo SVD
%      for k = 1:size(tmp,3)
%         Htmp(:,:,k) = u*Htmp(:,:,k)*u';
%         Stmp(:,:,k) = u*Stmp(:,:,k)*u';
%       end
%       Ztmp = u*Ztmp*u';
    Sest(it,:,:,:) = Stmp;
    Hest(it,:,:,:) = Htmp;
    Zest(it,:,:) = Ztmp;
  %  Psiest(it,:,:,:) = psi;
 %   toc
end
%             Sxx = permute(CrossSpec{1}, [
Sxx = CrossSpec{1};
Zyy = squeeze(Zest(:,2,2));
Zyy = repmat(Zyy, 1, size(So,1));
Zxy = squeeze(Zest(:,1,2));
Zxy = repmat(Zxy, 1, size(So,1));
Zxx = squeeze(Zest(:,1,1));
Zxx = repmat(Zxx, 1, size(So,1));
Hxy = squeeze(Hest(:,1,2,:));
SxxTilde = (Sxx - (Zyy - Zxy.^2./Zxx).*abs(Hxy).^2);
Gt = Sxx./SxxTilde;
Gt = log(Gt);
G(iPerm,:,:)=Gt;

end

G=squeeze(G);


%toc