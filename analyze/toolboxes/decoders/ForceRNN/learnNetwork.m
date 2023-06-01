function [zt, J, wf, wi, wo, M, N] = learnNetwork(IN, OUT)

% based on FORCE_INTERNAL_ALL2ALL.m code by David Sussillo
% made available with supplement to paper "Generating Coherent Patterns of Activity
% from Chaotic Neural Networks"
%
% This code implements a simple RNN for decoding using the FORCE training
% procedure
%
% JM 2-28-12
%
% IN = dimxtime, OUT = dimxtime
% IN is the input to the network
% OUT is the desired output of the network

%%
u = IN;

N = 1000;
p = .1; %default .1
g = 1;	%defualt 1.5			% g greater than 1 leads to chaotic networks.
alpha = 1.0;
nsecs = length(IN)/10;
dt = 0.1;
learn_every = 2;

scale = 1.0/sqrt(p*N);
J = sprandn(N,N,p)*g*scale;
J = full(J);

%inputs
I = size(IN,1);
h = .5;
scale2 = 1.0/sqrt(p*I);
wi = sprandn(N,I,p)*h*scale2;
wi = full(wi);

%feedback
p2 = .01; %default .1
M = size(OUT,1);
scale3 = 1.0/sqrt(p2*M);
wf = sprandn(N,M,p2)*scale3;
wf = full(wf);

wo = zeros(N,M);
dw = zeros(N,M);

disp(['   N: ', num2str(N)]);
disp(['   g: ', num2str(g)]);
disp(['   p: ', num2str(p)]);
disp(['   alpha: ', num2str(alpha,3)]);
disp(['   nsecs: ', num2str(nsecs)]);
disp(['   learn_every: ', num2str(learn_every)]);

simtime = 0:dt:nsecs-dt;
simtime_len = length(simtime);

wo_len = zeros(M,simtime_len);    
zt = zeros(M,simtime_len);

x0 = 0.5*randn(N,1);
z0 = 0.5*randn(M,1);

x = x0; 
r = tanh(x);
z = z0; 

% figure;
ti = 0;
P = (1.0/alpha)*eye(N);
for t = simtime
    ti = ti+1;	
    
    % sim, so x(t) and r(t) are created.
    x = (1.0-dt)*x + J*(r*dt) + wf*(z*dt) + wi*(u(:,ti)*dt);
    r = tanh(x);
    r(1) = 1; %allows for constant bias
    z = wo'*r;
    
    if mod(ti, learn_every) == 0
	% update inverse correlation matrix
	k = P*r;
	rPr = r'*k;
	c = 1.0/(1.0 + rPr);
	P = P - k*(k'*c);
	
	% update the error for the linear readout
	e = z-OUT(:,ti);
	
	% update the output weights
    for ic = 1:size(dw,2)
        dw(:,ic) = -e(ic)*k*c;
    end
	wo = wo + dw;
	
    end

    % Store the output of the system.
    zt(:,ti) = z;
    wo_len(:,ti) = sum(sum(sqrt(wo'*wo))); %?
end


