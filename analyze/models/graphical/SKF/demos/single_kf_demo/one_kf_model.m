function skf = one_kf_model()

model = {};
model{1}.A = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];
model{1}.Q = 0.1*eye(4);
model{1}.H = [1 0 0 0; 0 1 0 0];
model{1}.R = 1*eye(2);

skf.Z = 1;
skf.X_0 = [10 10 1 0]';
skf.P_0 = 10*eye(4);
skf.model = model;
