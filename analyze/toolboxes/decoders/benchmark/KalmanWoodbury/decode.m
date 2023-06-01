function [state prediction] = decode( state, params, neural_data )
% state:
%   z - mean
%   V - covariance
% params:
%   A - transition matrix
%   C - output matrix
%   Q - transition noise
%   R - output noise
%   Rinv - inverse output noise (precomputed for speed)
%   mz - mean of the latent state (added back to the prediction)
%   my - mean of the observed state(subtracted for prediction)

% predict
zt = params.A*state.z;
Pt = params.A*state.V*params.A' + params.Q;

% Same as (C*Pt*C' + R)^-1 by Woodbury lemma.  Should be faster for larger
% number of neurons.
T = params.Rinv*params.C;
Sinv = params.Rinv - T*(Pt^-1 + params.C'*T)^-1*T';
xt = (neural_data - params.my) - params.C*zt; % residual

% update
Kt = Pt*params.C'*Sinv; % Kalman gain
zt = zt + Kt*xt;
Vt = Pt - Kt*params.C*Pt;

state.z = zt;
state.V = Vt;

prediction = zt + params.mz;