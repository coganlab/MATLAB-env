% Anova2way: Balanced or unbalanced two-factor anova, either conventional (assuming normal 
%            residuals) or based on permutation tests (Anderson & ter Braak 2003).  Factors 
%            A and B may be fixed or random, in any combination, or B may be nested within 
%            A (B assumed to be random).  Ignores missing data.
%
%     Usage: [F,Fdf,pr,ss,df,ms] = Anova2way(X,A,B,{Atype},{Btype},{iter})
%
%         X =     [n x 1] vector of observations for a single variable.
%         A =     corresponding [n x 1] classification variable for factor A.
%         B =     corresonding [n x 1] classification variable for factor B.
%         Atype = optional boolean variable indicating state of factor A:
%                       0 = fixed [default], 1 = random.
%         Btype = optional boolean variable indicating state of factor B:
%                       0 = fixed [default], 1 = random, 2 = nested within A.
%         iter =  optional number of randomization iterations [default = 0].
%         ------------------------------------------------------------------------------------
%         F =     [3 x 1] vector of F-statistic values for main effects and interaction: 
%                   [F_A, F_B, F_AB].
%         Fdf =   [3 x 2] matrix of degrees-of-freedom corresponding to F-statistics.
%         pr =    [3 x 1] vector of significance levels, either asymptotic (if iter=0)
%                       or randomized (if iter>0): P(A), P(B), P(AB).
%         ss =    [5 x 1] vector of sums-of-squares: ssA, ssB, ssAB, ss_error, ss_total.
%         df =    [5 x 1] vector of degrees-of-freedom: dfA, dfB, dfAB, df_error, df_total.
%         ms =    [4 x 1] vector of mean-squares: msA, msB, msAB, mse.
%

% RE Strauss, 3/31/04

function [F,Fdf,pr,ss,df,ms] = Anova2way(X,A,B,Atype,Btype,iter)
  if (~nargin) help Anova2way; return; end;
  
  if (nargin < 4) Atype = []; end;
  if (nargin < 5) Btype = []; end;
  if (nargin < 6) iter = []; end;
  
  if (isempty(Atype)) Atype = 0; end;       % Default argument values
  if (isempty(Btype)) Btype = 0; end;
  if (isempty(iter))  iter = 0; end;
    
  i = find(isfinite(X));                    % Delete missing data
  [X,A,B] = submatrows(i,X,A,B); 
  N = length(X);
  
  if (Atype==0 & Btype==0)                  % Model I: A fixed, B fixed
    [F,Fdf,ss,df,ms] = Anova2FF(X,A,B);       % ANOVA statistics
    if (iter==0)                              % Asymptotic probabilities
      prA = 1-Fcdf(F(1),Fdf(1,1),Fdf(1,2));
      prB = 1-Fcdf(F(2),Fdf(2,1),Fdf(2,2));
      prAB = 1-Fcdf(F(3),Fdf(3,1),Fdf(3,2));
      pr = [prA; prB; prAB];
    else                                      % Randomized probabilities
      Frand = zeros(iter,3);
      Frand(1,:) = F';
      [mean_tot,meanA,meanB,resids] = CalcResids(X,A,B);
% X_meantot_meanA_meanB_resids = [X mean_tot meanA meanB resids]   
% mean_X_meantot_meanA_meanB_resids = mean([X mean_tot meanA meanB resids])   

      for it = 2:iter
%         Xp = PermuteResids(mean_tot,meanA,meanB,resids);
Xp = X(randperm(N));
        Fp = Anova2FF(Xp,A,B);
        Frand(it,:) = Fp';
      end;
      Frand = sort(Frand);
      pr = randprob(F,Frand)';
    end;
    
  end;
  
  
% CalcResids: Calculate residuals, by decomposing the anova model, 
%             to prepare for random permutation of residuals.
%
%     Usage: [mean_tot,meanA,meanB,resids] = CalcResids(X,A,B)
%
%         X =     [n x 1] vector of observations for a single variable.
%         A =     corresponding [n x 1] classification variable for factor A.
%         B =     corresonding [n x 1] classification variable for factor B.
%         -------------------------------------------------------------------
%         mean_tot = [n x 1] vector of overall mean.
%         meanA =    [n x 1] vector of means of levels of A.
%         meanB =    [n x 1] vector of means of levels of B.
%         resids =   [n x 1] vector of residuals.
%

% RE Strauss, 3/31/04

function [mean_tot,meanA,meanB,resids] = CalcResids(X,A,B)
  N = length(X);
  meanA = zeros(N,1);
  meanB = zeros(N,1);
  
  mean_tot = mean(X)*ones(N,1);
  
  [mA,s,v,idA] = means(X,A);
  for im = 1:length(mA)
    i = find(A==idA(im));
    meanA(i) = mA(im)*ones(length(i),1);
  end;

  [mB,s,v,idB] = means(X,B);
  for im = 1:length(mB)
    i = find(B==idB(im));
    meanB(i) = mB(im)*ones(length(i),1);
  end;
  
  resids = X + mean_tot - meanA - meanB;  
  return;
  
  
% PermuteResids: Randomly permute residuals and reconstruct data values.
%
%     Usage: Xp = PermuteResids(mean_tot,meanA,meanB,resids)
%
%         mean_tot = [n x 1] vector of overall mean.
%         meanA =    [n x 1] vector of means of levels of A.
%         meanB =    [n x 1] vector of means of levels of B.
%         resids =   [n x 1] vector of residuals.
%         -------------------------------------------------------
%         Xp =       [n x 1] vector of reconstructed data values.
%

% RE Strauss, 3/31/04

function Xp = PermuteResids(mean_tot,meanA,meanB,resids)
  N = length(resids);
  resids = resids(randperm(N));
  Xp = resids + meanA + meanB - mean_tot;
  return;
  
  
% Anova2FF: Model I anova, with both factors being fixed.
%
%     Usage: [F,Fdf,ss,df,ms] = Anova2FF(X,A,B)
%
%         X =     [n x 1] vector of observations for a single variable.
%         A =     corresponding [n x 1] classification variable for factor A.
%         B =     corresonding [n x 1] classification variable for factor B.
%         ------------------------------------------------------------------------------
%         F =     [3 x 1] vector of F-statistic values for main effects and interaction: 
%                   [F_A, F_B, F_AB].
%         Fdf =   [3 x 2] matrix of degrees-of-freedom corresponding to F-statistics.
%         ss =    [5 x 1] vector of sums-of-squares: ssA, ssB, ssAB, ss_error, ss_total.
%         df =    [5 x 1] vector of degrees-of-freedom: dfA, dfB, dfAB, df_error, df_total.
%         ms =    [4 x 1] vector of mean-squares: msA, msB, msAB, mse.
%         

% RE Strauss, 3/31/04

function [F,Fdf,ss,df,ms] = Anova2FF(X,A,B)
  [u_Alevels,n_Alevels] = uniquef(A);       % Factor levels
  [u_Blevels,n_Blevels] = uniquef(B);
  nlevA = length(u_Alevels);
  nlevB = length(u_Blevels);
    
  cell_id = rowtoval([A B]);                % Cell identifiers
  [u_cell_id,n_cell] = uniquef(cell_id);    % Cell sizes
  [uA,nA] = uniquef(A);                     % Factor sizes
  [uB,nB] = uniquef(B);
  N = length(X);                            % Total sample size

  tot_cell = sums(X,cell_id);               % Cell totals
  totA = sums(X,A);                         % Factor A level totals
  totB = sums(X,B);                         % Factor B level totals
  tot_grand = sum(X);                       % Grand totals
  tot_grand2 = sum(X.^2);
  
  C = tot_grand^2/N;                        % Sums of squares
  ss_tot = tot_grand2 - C;
  ss_cell = sum((tot_cell.^2)./n_cell) - C;
  ss_error = ss_tot - ss_cell;
  ssA = sum((totA.^2)./nA) - C;
  ssB = sum((totB.^2)./nB) - C;
  ssAB = ss_cell - ssA - ssB;

  df_tot = N-1;                             % Degrees of freedom for sums of squares
  dfA = nlevA-1;
  dfB = nlevB-1;
  dfAB = dfA*dfB;
  df_cell = nlevA*nlevB - 1;
  df_error = sum(n_cell-1);
  
  msA = ssA/dfA;                            % Mean squares
  msB = ssB/dfB;
  msAB = ssAB/dfAB;
  mse = ss_error/df_error;
  
  FA = msA/mse;                             % F-statistics
  FB = msB/mse;
  FAB = msAB/mse;

  df_FA = [dfA df_error];                   % Degrees of freedom for F-statistics
  df_FB = [dfB df_error];
  df_FAB = [dfAB df_error];
  
  F = [FA; FB; FAB];
  Fdf = [df_FA; df_FB; df_FAB];
  ss = [ssA; ssB; ssAB; ss_error; ss_tot];
  df = [dfA; dfB; dfAB; df_error; df_tot];
  ms = [msA; msB; msAB; mse];
  
  return;
  