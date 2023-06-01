%--------------------------------------%
%  getting-up trajectory optimization  %
%--------------------------------------%

% -- prepare 

% convert if necessary
% xml2mjb('humanoid.xml')

% load model
mj('load',which('humanoid.mjb'))
model = mj('getmodel');

% rotate a little to break symmetries
mj reset
qpos = mj('get','qpos');
qpos(5:7) = 0.1*randn(3,1); % perturb the quat
mj('set','qpos',qpos)

falling_data = mjsim([],.6);

% plot 7 frames of the falling sequence
mjplot(falling_data(round(linspace(1,end,7))));

%% -- optimize
% reset initial state
mj('set','qpos',falling_data(end).qpos);
mj('set','qvel',falling_data(end).qvel);

% problem parameters
N        = 50;						% number of time steps
x0       = [mj('get','qpos'); mj('get','qvel')];	% initial state
u0       = zeros(model.nu2,N);		% initial control sequence

% select between iLQG and full DDP
order    = 0;

h     = 2^-18;  % finite-differencing epsilon

% set up dynamics
F     = @(x,u) mj('step',x,u);
DYN   = @(x,u,t) diff_xu(F, x, u, h, order);

% set up cost
C     = @(x,u) getup_cost(x,u);
CST   = @(x,u,t) diff_xu(C, x, u, h, 2);

% combine into DYNCST
DYNCST   = @(x,u,t) combine(DYN,CST,x,u,t);


% solve 
Op			= struct('lims',0.99*model.actuator_range,'print',3); 
[x, u, L]   = iLQG(DYNCST, x0, u0, Op);

%% -- animate
figure(findobj(0,'Tag','mjplot'))

DATA = struct;
for i = 1:N
    DATA(i).qpos = x(1:model.nq,i);
    DATA(i).time = i*mj('get','dt');
end
animate(DATA)