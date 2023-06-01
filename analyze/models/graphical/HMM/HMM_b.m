function b = HMM_b(HMM, observ_matrix)
%HMM_B Compute observation probablities 
%
% b = HMM_b(HMM,observ_matrix)
%
% Inputs:
%   HMM = HMM being trained
%   observ_matrix = observations (O)
% Output:
%   b(j,t) = P(O_t|q_t=j)


length_seq = size(observ_matrix,1);
b = zeros(HMM.states, length_seq);
tic
for t = 1:length_seq
    data = observ_matrix(t,:);
    for j = 1:HMM.states
	mu = squeeze(HMM.mu_bar(j,:,:));
	U = squeeze(HMM.U_bar(j,:,:,:));
	U = permute(U,[2 3 1]);
	b(j,t) = prob_mixmodel(data,mu,U,HMM.c_bar(j,:));
    end
end
