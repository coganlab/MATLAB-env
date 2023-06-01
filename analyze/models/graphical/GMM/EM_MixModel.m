% EM for Gaussian Mixtures
% for K clusters

function [Mu, Sigma, pibar,scaling_vals] = EM_MixModel(data, mukbar,Sigmabar,pibar,scaling_vals,flag);


% E step
%%%%%%%%

% Initialization
% Estimated Initial parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



N = size(data,1);
Dim = size(data,2); % Number of modes
k = length(pibar); % Number of components




% for j = 1:k
%     origlengthmu(j) = norm(mukbar(j,:));
% end

origlengthmu = mukbar;
lengthmu = origlengthmu;
eps = 1;
iter = 1;


while eps > 0.005 % convergence 


    p = zeros(N,k);
    prob = zeros(1,N);
    
    for i = 1:N
        [prob(i),p(i,:)] = prob_mixmodel(data(i,:), mukbar, Sigmabar, pibar);
    end
    p_sumoverk = sum(p,2);
    
    
    
   
    
    % M Step
    %%%%%%%%
    %%%%%%%%

    % Gamma
    %%%%%%%

    gamma = zeros(N,k);
    for i = 1:N
        for j = 1:k
            gamma(i,j) = p(i,j)./p_sumoverk(i);
        end
    end
  
    %Estimating Nk: number of data points belonging to cluster K
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Nk = sum(gamma,1);
    
    
    % Estimating mukbar
    %%%%%%%%%%%%%%%%%%%%%%

    mukbar = zeros(k,Dim);
    origlengthmu = lengthmu;
%     lengthmu = zeros(k);
    lengthmu = zeros(k,Dim);
   
    for j=1:k
        for i = 1:N
        mukbar(j,:) =  mukbar(j,:) + (gamma(i,j)*data(i,:));
        end
        mukbar(j,:) = (1./Nk(j)) *mukbar(j,:);
%         lengthmu(j) = norm(mukbar(j,:));
        lengthmu(j,:) = mukbar(j,:);
    end
  

    % Estimating Pi
    %%%%%%%%%%%%%%%%%%
    pibar = Nk./N;



    % Estimating Sigmabar
    %%%%%%%%%%%%%%%%%%%%%%

    Sigmabar = zeros(Dim,Dim,k);

    for j = 1:k
        for i = 1:N
            Sigmabar(:,:,j) =  Sigmabar(:,:,j) + gamma(i,j) .* (data(i,:)-mukbar(j,:))'*(data(i,:)-mukbar(j,:));
        end
            Sigmabar(:,:,j) = (1/Nk(j)) * squeeze(Sigmabar(:,:,j));
    end


%    eps  = max((lengthmu-origlengthmu)./origlengthmu)
 
   eps = (origlengthmu - lengthmu)./origlengthmu;
   eps = abs(eps);
   eps_total = sum(eps');
   eps_av = eps_total/k;
   iter = iter + 1;
  
end
Mu = mukbar;
Sigma = Sigmabar;

% Normalization of the Covariance Matrix
% Saving the largest singular value to scale the data
% Normalization of the covariance Matrix if flag = 1

if (flag==1)

    for i=1:k
        [U S V] = svd(Sigma(:,:,i));
        Sing_vals = diag(Sigma(:,:,i));
        Sing_vals_norm = Sing_vals/max(Sing_vals);
        scaling_vals(i) = max(Sing_vals)
        S_norm = diag([Sing_vals_norm]);
        % Reconstruct the matrix
        Sigma(:,:,i) = U*S_norm*V';
    end

end


return



