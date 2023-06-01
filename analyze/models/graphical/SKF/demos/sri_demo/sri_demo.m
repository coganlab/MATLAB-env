SEED = 1;
rand('seed',SEED),randn('seed',SEED);

T = 2000;
EM_iters = 10;

%%% Load and initialize SKF %%%
skf = gpb2_init(sri_model(), T);

%%% Load training and testing data %%%
[X,Y,S] = sri_data(skf, T,[0 0 1 0; 0 0 0 1]);
[X2,Y2,S2] = sri_data(skf, T,[0 0 1 0; 0 0 0 1]);

%XXX: Sets X_0 to known initial state
skf = gpb2_set_initial(skf, X(:,1));

% Use least squares solution as initial parameters
% (Overwrites previoiusly specified model)
skf = gpb2_leastsquares(skf,Y,X,T,S);


% Optionally modify skf parameters before EM
%skf = skf_perturb(skf, [0.01 0.1 0.2 0.2]);

% Constrain Q and R
for i=1:skf.nmodels
    skf.model{i}.Q(1:2,1:2) = 0;
    skf.model{i}.Q(1,1) = eps;
    skf.model{i}.Q(2,2) = eps;
    if det(skf.model{i}.R) < 3*eps
	skf.model{i}.R = eps*eye(skf.ydims,skf.ydims);
    end

end

% Run EM !
[em_skf, EMSKF] = gpb2_em(skf,EM_iters,Y,X,S);

%

% Evaluate performance in terms of RMSE and SERR
for i=1:EM_iters
   %skf2 = gpb2_change_obs(SKF{i},3:4);
   %Y3 = [0 0 1 0; 0 0 0 1]*Y2;
   skf2 = EMSKF{i};
   tskf{i} = gpb2_filter(skf2,Y2,T);
   disp(['>>>> Iteration ' num2str(i)]);
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
