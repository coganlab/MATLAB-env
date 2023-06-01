SEED = 1;
rand('seed',SEED),randn('seed',SEED);

% Iterations of EM
EM_iters = 10; 

% Timesteps 
T = 5000;

% Recording Info
data_dir = '/home/poolio/';
train_rec.day = '090107';
train_rec.rec = '011';
train_rec.chs = 1:3;
train_rec.feats = 3;
test_rec = train_rec;

xdims = 6;
ydims = length(rec.chs)*rec.feats;

% Session info
[X,Y,S,T] = load_neural_data(data_dir,train_rec,'train',xdims,ydims,T);
[X2,Y2,S2,T2] = load_neural_data(data_dir,test_rec,'test',xdims,ydims);

%%% Load and initialize SKF %%%
skf = gpb2_init(rm_model(xdims,ydims), T);
% Uncomment to use move model
%skf = gpb2_init(move_model(xdims,ydims), T);

% Remove extra features of X if the model does not need them


%XXX: Sets X_0 to known initial state
skf = gpb2_set_initial(skf, X(:,1));

% Use least squares solution as initial parameters
% (Overwrites previoiusly specified model)

% Train SKF using least squares on training data 
fprintf('Finding initial least squares solution...\n');
ls_skf = gpb2_leastsquares(skf,Y,X,T,S);

% Test least squares solution on test data
fprintf('Running GPB2_filter...');
%XXX: Setting X_0 to known initial state...
test_skf = gpb2_set_initial(gpb2_init(ls_skf,T2), X2(:,1));
tic,test_skf = gpb2_filter(test_skf,Y2,T2);toc

% Evaluate performance of least squares on test data
fprintf('Evaluating performance...\n');
ls_eval = skf_eval(test_skf,test_skf.flags,Y2,S2,X2);

% Remove this if you want to watch EM fail
keyboard

% Optionally modify skf parameters before EM
%skf = skf_perturb(skf, [0.01 0.1 0.2 0.2]);

% Constrain Q and R?
%for i=1:skf.nmodels
%    skf.model{i}.Q(1:2,1:2) = 0;
%    skf.model{i}.Q(1,1) = eps;
%    skf.model{i}.Q(2,2) = eps;
%    if det(skf.model{i}.R) < 3*eps
%	skf.model{i}.R = eps*eye(skf.ydims,skf.ydims);
%    end
%
%end

% Run EM !
fprintf('Running %d iterations of EM...\n',EM_iters);
[em_skf, EMSKF] = gpb2_em(ls_skf,EM_iters,Y,X,S);


%

% Evaluate performance in terms of RMSE and SERR
fprintf('Evaluating each iteration of EM on test data...\n');
for i=1:EM_iters
   %skf2 = gpb2_change_obs(SKF{i},3:4);
   %Y3 = [0 0 1 0; 0 0 0 1]*Y2;
   skf2 = gpb2_init(EMSKF{i},T2);
   tskf{i} = gpb2_filter(skf2,Y2,T2);
   disp(['>>>> Performance of EM iteration ' num2str(i)]);
   tskf{i}.test = skf_eval(tskf{i}, tskf{i}.flags, Y2, S2, X2);

end
skf = tskf{EM_iters};

plot_state_preds;

  %  figure(5),clf,hold all;
  %  m2 = skf.M(2,:) > 0.5;
  %  m1 = skf.M(1,:) >= 0.5;
  %  plot(X2(1,:),X2(2,:));
  %  plot(skf.X(1,m1),skf.X(2,m1),'r+:');
  %  plot(skf.X(1,m2),skf.X(2,m2),'gx:');
  %  legend('true','m1','m2');

  %  figure(7),clf,hold all;
  %  m2s = skf.smooth.M(2,:) > 0.5;
  %  m1s = skf.smooth.M(1,:) >=0.5;
  %  plot(X2(1,:),X2(2,:));
  %  plot(skf.smooth.X(1,m1),skf.smooth.X(2,m1),'r+:');
  %  plot(skf.smooth.X(1,m2),skf.smooth.X(2,m2),'gx:');
  %  legend('true','smoothed m1','smoothed m2');


   % figure(6),clf, hold all;
   % plot(1:t,2-S2(1:t),'linewidth',5);plot(skf.M(1,1:t)','Linewidth',2);
   % legend('true m1','P(m1)');
   % axis([0 T -0.3 1.3]);



   % figure(2);
   % plot(X2(3:4,:)');
   % plot(skf.X(3:4,:)');
   % legend('true_x','true_y','pred_x','pred_y', 'Location','southoutside');
   % title('Velocities');
   % %pause
   % pause
