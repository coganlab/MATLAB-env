function [skf,SKFs] = gpb2_em(skf, iters,Y,X,S,flags)
%_GPB2_EM    Expectation maximization for GPB2
% SKF = GPB2_EM(SKF,Y,T) returns a GPB2 model with updated parameters
%
%

T = size(Y,2); %% Timesteps

if nargin < 6
    flags = em_flags_init();
end

if nargin < 5
    S = ones(1,T);
    flags.use_state = 0;
end

if nargin < 4
    flags.eval_traj =0;
end


skf.flags = flags;

SKFs = cell(1,iters);
SKFs{1} = skf;


for it=2:iters
    tic
    disp(['<<<< Iteration ' num2str(it) ' >>>>']);
    skf = gpb2_init(skf,T);
    skf = gpb2_filter(skf,Y);
    skf = gpb2_smooth(skf,Y);

    % Some evaluation.....
    skf.train = skf_eval(skf, flags, Y, S, X);
    
    SKFs{it-1} = skf;
    W_t_j = skf.smooth.M;
    
    % Use true states, not GPB2 state probabilities
    if flags.use_state
	W_t_j(2,:) = S-1;
	W_t_j(1,:) = 1 - W_t_j(2,:);
    end

    % Deterministic annealling of state probabilities
    if flags.da
	BETA = 1-exp(-(it-2)/(iters/6));
	W_t_j = W_t_j.^BETA;
	for t=1:T
	    W_t_j(:,t) = W_t_j(:,t)/sum(W_t_j(:,t));
	end
    end


    x_t = skf.smooth.X;
    P_t(:,:,1) = skf.smooth.P(:,:,1)+x_t(:,1)*x_t(:,1)';
    for t=2:T
	P_t(:,:,t) = skf.smooth.P(:,:,t)+x_t(:,t)*x_t(:,t)';
	P_ts(:,:,t) = skf.smooth.VutT(:,:,t) + x_t(:,t)*x_t(:,t-1)';

	P_ts2(:,:,t) =  x_t(:,t)*x_t(:,t-1)';
	P_t2(:,:,t) = x_t(:,t)*x_t(:,t)';
    end
    P_t2 = P_t;
    P_ts2 = P_ts;


    dims = skf.xdims;

for i=1:skf.nmodels


    new_A1 = zeros(skf.xdims,skf.xdims);
    new_A2 = zeros(skf.xdims,skf.xdims);
    nA1 = new_A1;
    nA2 = new_A2;
    for t=2:T
	new_A1 = new_A1 + W_t_j(i,t)*P_ts2(:,:,t);
	new_A2 = new_A2 + W_t_j(i,t)*P_t2(:,:,t-1);
    end
    new_A = new_A1*pinv(new_A2);

    new_Q1 = zeros(dims,dims);
    new_Q2 = zeros(dims,dims);
    for t=2:T
	new_Q1 = new_Q1 + W_t_j(i,t)*(P_t(:,:,t));
	new_Q2 = new_Q2 + W_t_j(i,t)*(P_ts(:,:,t)');

    end
    
    %Wishart prior
    if flags.wishart
	alpha = .01*T;
	l = eye(skf.xdims)*alpha;
    else
	alpha = 0;
	l = zeros(skf.xdims);
    end


    new_Q = (l+new_Q1 - new_A*(new_Q2))/(alpha+sum(W_t_j(i,2:end)));



    new_H1 = zeros(skf.ydims,skf.xdims);
    new_H2 = zeros(skf.xdims,skf.xdims);
    for t=1:T
	new_H1 = new_H1 + W_t_j(i,t)*Y(:,t)*x_t(:,t)';
	new_H2 = new_H2 + W_t_j(i,t)*P_t2(:,:,t);
    end
    new_H = new_H1*pinv(new_H2);


    new_R = zeros(skf.ydims,skf.ydims);
    for t=1:T
	new_R = new_R + W_t_j(i,t)*(Y(:,t)*Y(:,t)'-new_H*x_t(:,t)*Y(:,t)');
    end
    l = eye(skf.ydims,skf.ydims)*alpha;
    new_R = (l+new_R) / (sum(W_t_j(i,:))+alpha);
    
    new_Z(i,:) = sum(shiftdim(skf.smooth.Mt(i,:,1:end-1),1),2)/sum(skf.smooth.M(i,1:end-1));

   % Floating point inaccuracies accumulate in
   % covariance matrices and cause loss of symmetry
   new_Q = (new_Q + new_Q')/2;
   new_R = (new_R + new_R')/2;


    skf.model{i}.Q = new_Q;
    skf.model{i}.H = new_H;
    skf.model{i}.A = new_A;
    skf.model{i}.R = new_R; 
end
skf.Z = new_Z;

skf.X_0 = skf.smooth.X(:,1);
skf.P_0 = skf.smooth.P(:,:,1);

    

new_lhood = gpb2_lhood(skf,Y);
disp(sprintf('\tnew_l = %g',new_lhood));
disp(sprintf('\tCompleted in %.2f seconds.\n',toc));
SKFs{it} = skf;


end
