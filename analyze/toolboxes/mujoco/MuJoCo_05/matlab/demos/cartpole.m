%--------------------------------------%
%  cart-pole trajectory optimization   %
%--------------------------------------%

% -- prepare 

% convert if necessary
%xml2mjb('cartpole.xml')

% load model
mj('load',which('cartpole.mjb'))
model = mj('getmodel');

% plot
mjplot

%% -- optimize

% problem parameters
N        = 60;				% number of time steps
x0       = [0 3 1 0.1]';	% initial state
u0       = zeros(1,N);		% initial control sequence

% select between iLQG and full DDP
order    = 2;

h     = 2^-18;  % finite-differencing epsilon

% set up dynamics
F     = @(x,u) mj('step',x,u);
DYN   = @(x,u,t) diff_xu(F, x, u, h, order);

% set up cost
C     = @(x,u) cartpole_cost(x,u);
CST   = @(x,u,t) diff_xu(C, x, u, h, 2);

% combine into DYNCST, add some discounting
gamma = 0.99;
DYNCST   = @(x,u,t) combine(DYN,CST,x,u,t,gamma);


% solve 
Op			= struct('lims',0.99*model.actuator_range,'print',3); 
[x, u, L]   = iLQG(DYNCST, x0, u0, Op);

%% -- animate

% bring the figure into focus
if ~isempty(findobj(0,'Tag','mjplot'))
	figure(findobj(0,'Tag','mjplot'));
end

% prepare the DATA structure
DATA = getData;
for i = 1:N
	mj('set','qpos',x(1:2,i));
	mj('set','time',i*mj('get','dt'));
	mj kinematics;
	DATA(i) = getData;
end

% animate
animate(DATA)

%% -- plot multiple states

mjplot(DATA)