function skf = sri_model()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOVEMENT MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model{1}.A = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];
model{1}.Q = diag([1e-15 1e-15 1 1]);
model{1}.H = [0 0 1 0; 0 0 0 1];
model{1}.R = diag([1e-3 1e-3]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STATIONARY MODEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
model{2}.A = diag([1 1 0 0]);
model{2}.Q = 1e-11*eye(4);
model{2}.H = [0 0 1 0; 0 0 0 1];
model{2}.R = diag([1e-3 1e-3 ]);

skf.Z = [0.99 0.01
	 0.01 0.99];
skf.X_0 = [0 0 0.1 0.1]';
skf.P_0 = 1e-3*eye(4);
skf.model = model;
