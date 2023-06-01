function L = GMM_HMM_lhood(alpha,a,state_seq)
%GMM_HMM_LHOOD L(GMM|N,S)/L(HMM|N,S)
% 
% ...converges to 0 => L(HMM|N,S) >> L(GMM|N,S)

p_gmm = [alpha 1-alpha];
ps = state_seq(1)+1;
L = 1;
for t=2:length(state_seq)
    cs = state_seq(t)+1;
    L = L * (p_gmm(cs) / a(ps,cs))
    ps = cs;
end

