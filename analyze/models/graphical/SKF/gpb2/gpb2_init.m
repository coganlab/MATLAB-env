function skf = skf_init(skf,T)

skf.nmodels = length(skf.model);
for i=1:skf.nmodels
    skf.model{i}.xdims = size(skf.model{i}.A,1);
    skf.model{i}.ydims = size(skf.model{i}.H,1);
    skf.model{i}.ind = [1:skf.model{1}.xdims]';
end

skf.xdims = skf.model{1}.xdims;
skf.ydims = skf.model{1}.ydims;
skf.mu_0 = [1:skf.nmodels]'/skf.nmodels;

for i=1:skf.nmodels
    skf.model{i}.X = zeros(skf.xdims,T);
    skf.model{i}.X(:,1) = skf.X_0;
    skf.model{i}.P = zeros(skf.xdims,skf.xdims,T);
    skf.model{i}.P(:,:,1) = skf.P_0;

    skf.model{i}.smooth = {};
    skf.model{i}.smooth.X = skf.model{i}.X;
    skf.model{i}.smooth.P = skf.model{i}.P;
  %  skf.model{i}.Pf = skf.model{i}.P;
  %  skf.model{i}.Pc = skf.model{i}.P;
  %  skf.model{i}.Xf = skf.model{i}.X;
  %  skf.model{i}.e = zeros(skf.ydims,T);
  %  skf.model{i}.S = zeros(skf.ydims,skf.ydims,T);
  %  skf.model{i}.K = zeros(skf.xdims,skf.ydims,T);
  %  skf.model{i}.L = zeros(1,T);
end
skf.X = zeros(skf.xdims,T);
skf.X(:,1) = skf.X_0;
skf.P = zeros(skf.xdims,skf.xdims,T);
skf.P(:,:,1) = skf.P_0;
skf.mu = zeros(skf.nmodels,T);
skf.mu(:,1) = skf.mu_0;

% kf_filter results
skf.Xij = zeros(skf.xdims,skf.nmodels,skf.nmodels,T);
skf.Pij = zeros(skf.xdims,skf.xdims,skf.nmodels,skf.nmodels,T);
skf.Pcij = zeros(skf.xdims,skf.xdims,skf.nmodels,skf.nmodels,T);
skf.L = zeros(skf.nmodels,skf.nmodels,T);

skf.Mt = zeros(skf.nmodels,skf.nmodels,T);
skf.M = zeros(skf.nmodels,T);
skf.Wij = zeros(skf.nmodels,skf.nmodels,T);
skf.M(:,1) = skf.mu_0;

% kf_smooth results
skf.smooth = {};
skf.smooth.Xjk = zeros(skf.xdims,skf.nmodels,skf.nmodels,T);
skf.smooth.Pjk = zeros(skf.xdims,skf.xdims,skf.nmodels,skf.nmodels,T);
skf.smooth.Pcjk = skf.smooth.Pjk;

skf.smooth.U = zeros(skf.nmodels,skf.nmodels,T);
skf.smooth.Mt = zeros(skf.nmodels,skf.nmodels,T);
skf.smooth.M = zeros(skf.nmodels,T);
skf.smooth.Wkj = zeros(skf.nmodels,skf.nmodels,T);
skf.smooth.X = zeros(skf.xdims,T);
skf.smooth.P = zeros(skf.xdims,skf.xdims,T);
skf.smooth.XuT = zeros(skf.xdims, skf.nmodels, skf.nmodels, T);
skf.smooth.PutTk = zeros(skf.xdims, skf.xdims, skf.nmodels, T);
skf.smooth.Xb = zeros(skf.xdims, skf.nmodels, T);
skf.smooth.VutT = zeros(skf.xdims,skf.xdims,T);


self.smooth.XtTj = zeros(skf.xdims,skf.nmodels,T);
self.smooth.PtTj = zeros(skf.xdims,skf.xdims,skf.nmodels,T);





skf.flags = {};
skf.flags.eval_traj = 1;
skf.flags.eval_lhood = 1;
skf.flags.eval_state = 1;

