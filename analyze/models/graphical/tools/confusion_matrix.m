function [STATE, ACU] = confusion_matrix(P_rest, state_truth)
%CONFUSION_MATRIX Compute confusion matrix
%
% [CONF_MATRIX, ACCURACY] = confusion_matrix(P_rest, state_truth)
% 
% Inputs:
%   P_rest(t) = Probability of being in the rest state at time t
%   state_truth(t) = True state sequence
% Outputs:
%   CONF_MATRIX = confusion matrix
%   ACCURACY = percent correct

P_move = 1 - P_rest;

idx = 1;
for P_CHOICE=0:0.005:1
predicted_state = zeros(size(P_move));
predicted_state(P_move > P_CHOICE) = 1;
predicted_state = predicted_state(1:length(P_move));

d = sum(state_truth.*predicted_state);	    % # True Positives
a = sum((~state_truth).*(~predicted_state)); % # True Negatives
b = sum((~state_truth).*(predicted_state));  % # False Positives
c = sum((state_truth).*~predicted_state);    % # False negatives

TP = d/(c+d);
FN = c/(c+d);
FP = b/(a+b);
TN = a/(a+b);
AC = (a+d)/(a+b+c+d);
%P = d/(b+d);

STATE{idx} = [TP FP; FN TN];
ACU(idx) = AC;
idx = idx + 1;
end
