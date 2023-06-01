function skf = move_model(xdims,ydims)
%% Load move model

xdims = 6;
ydims = 9;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVEMENT MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model{1}.A = eye(xdims);
model{1}.Q = eye(xdims);
model{1}.H = ones(ydims,xdims);
model{1}.R = eye(ydims);

skf.Z = 1;

skf.X_0 = [0 0 0.1 0.1 0 0 ]';
skf.P_0 = 1e-3*eye(6);
skf.model = model;

em_flags = em_flags_init();
em_flags.Q = 0;
em_flags.A = 0;

skf.em_flags = em_flags;
