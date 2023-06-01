function skf = rm_model(xdims,ydims)
%% Load rest/move model


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVEMENT MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model{1}.A = eye(xdims);
model{1}.Q = eye(xdims);
model{1}.H = ones(ydims,xdims);
model{1}.R = eye(ydims);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STATIONARY MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model{2}.A = eye(xdims);
model{2}.Q = eye(xdims);
model{2}.H = ones(ydims,xdims);
model{2}.R = eye(ydims);

skf.Z = eye(2);

skf.X_0 = [0 0 0.1 0.1 0 0 ]';
skf.P_0 = 1e-3*eye(6);
skf.model = model;

em_flags = em_flags_init();
em_flags.Q = 0;
em_flags.A = 0;

skf.em_flags = em_flags;
