function MPC_controller(model)

persistent policy lambda dlambda

% problem parameters
N       = 20;		% number of time steps
x0      = [mj('get','qpos'); mj('get','qvel')];% initial state

% warm-start controls
if isempty(policy) || any(size(policy) ~= [1 N])
	policy  = zeros(1,N);
	lambda	= 1;
	dlambda	= 1;
end

% select between iLQG and full DDP
order    = 0;

h     = 2^-18;  % finite-differencing epsilon

% set up dynamics
F     = @(x,u) mj('step',x,u);
DYN   = @(x,u,t) diff_xu(F, x, u, h, order);

% set up cost
C     = @(x,u) cartpole_cost(x,u);
CST   = @(x,u,t) diff_xu(C, x, u, h, 2);

% combine into DYNCST
DYNCST   = @(x,u,t) combine(DYN,CST,x,u,t);

% solve 
Op			= struct('lims',0.99*model.actuator_range,...
					 'print',0,'plot',0,'maxIter',1,...
					 'lambdaInit', lambda,... 
					 'dlambdaInit', dlambda); 
[~, policy, ~, ~, ~, ~, trace]   = iLQG(DYNCST, x0, policy, Op);
lambda	= trace(end,2);
dlambda = trace(end,8);

% apply control
mj('set','ctrl', policy(1));

