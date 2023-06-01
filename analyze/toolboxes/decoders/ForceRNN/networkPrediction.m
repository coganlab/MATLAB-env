function zpt = networkPrediction(IN, J, wf, wi, wo, M, N)

% based on FORCE_INTERNAL_ALL2ALL.m code by David Sussillo
% made available with supplement to paper "Generating Coherent Patterns of Activity
% from Chaotic Neural Networks"
%
% This code implements a simple RNN for decoding using the FORCE training
% procedure
%
% JM 2-28-12

%% Now test. 
u = IN;

dt = 0.1;
nsecs = length(u)/10;
simtimeb = 0:dt:nsecs-dt;
simtime_lenb = length(simtimeb);
zpt = zeros(M,simtime_lenb);

x0 = 0.5*randn(N,1);
z0 = 0.5*randn(M,1);

x = x0;
z = z0; 
r = tanh(x);

ti = 0;
for t = simtimeb				% don't want to subtract time in indices 
    ti = ti+1;    
    
    % sim, so x(t) and r(t) are created.
    x = (1.0-dt)*x + J*(r*dt) + wf*(z*dt) + wi*(u(:,ti)*dt);
    r = tanh(x);
    z = wo'*r;

    zpt(:,ti) = z;
end