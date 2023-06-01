function state_seq = HMM_state_seq (HMM, length_seq)
%HMM_SEQ Compute a sequence of length n from the transition probability matrix a, and initial probabilities pi
%
% state_seq = HMM_state_seq (HMM, length_seq)
% 
% Inputs:
%   HMM = HMM structure containing states, a, and pi
%   length_seq = length of sequence to be generated 

state_list = 1:HMM.states;
state_seq = zeros(1, HMM.states);
state_seq(1) = randsample(state_list,1,true,HMM.pi);
for t=2:length_seq
    state_seq(t) = randsample(state_list,1,true,HMM.a(state_seq(t-1),:));
end
