
function [muk,clus,Sigma,Scaling_value] = findkmeans(data,k,B,flag) 
%
%  [muk,clus,Sigma,Scaling_value] = findkmeans(data,k,B,flag)
%
%  Inputs:
%           FLAG = 0/1.  1 = Normalize covariance matrix to avoid
%                           instability.
%                        0 = Do not normalize, assumes data is normalized.
%                        Defaults to 0.
%
%  Outputs:

if nargin < 4 || isempty(flag); flag = 0; end

N = size(data,1);
Dim = size(data,2);
num_iterations = B;



if ( k==1 )
    muk = mean(data);
    clus(1).Data = data;
end
    
if ( k > 1)

% This way of initializing leaves some clusters EMPTY
% for i=1:k
% muk(i,:) = mean(data).*rand(1,Dim);
% end


% Matlab Initialization
for i=1:k
    perm = randperm(N);
    perm = perm(1:k);
    muk  = data(perm,:);
end


% mean_data = mean(data);
% std_data = std(data);
% 
% for i=1:k
%     muk(i,:) = mean_data + std_data.*randn(1,size(data,2));
% end
% 


for iter =1:num_iterations

    r = zeros(N,k);
    

  for i=1:N
      for j=1:k
      sq_diff(j) = norm(data(i,:) - muk(j,:))^2;
      end
      [a,index] = min(sq_diff);
      r(i,index) = 1;
      % cluster Data
      clus(index).Data(i,:) = data(i,:);
  end

  

for j=1:k
    for i=1:N
    num(i,j,:) = r(i,j).*data(i,:);
    end
end

denom = sum(r,1);


 
if ( Dim == 1)
muk = sum(num,1)'./denom';
else
muk = squeeze(sum(num,1))./repmat(denom',1,Dim);
end


if (iter < num_iterations - 1) 
clear clus
end

end


for j = 1:k
if (Dim ==1)
    a =  clus(j).Data;
else
    a = sum(clus(j).Data'); % Good for multidimensional data
end
ind = find(a);
clus(j).Data = clus(j).Data(ind,:);
end


% repeat kmeans if one point per cluster
for j = 1:k
    while (size(clus(j).Data,1) < 15 )
    [mu,clus,Sigma,Scaling_value] = findkmeans(data,k,B,flag);
    disp('Repeat Kmeans');
    end
end
     
end




Dim = size(clus(1).Data,2);
cov_matrix = zeros(Dim,Dim,k); 


% Unbiased Estimation of the covariance Matrix
for i=1:k
    for j=1:size(clus(i).Data,1)
          if ( size(clus(i).Data,1) ==1)
          cov_matrix(:,:,i) = (clus(i).Data(j,:))'*(clus(i).Data(j,:));
          else
          cov_matrix(:,:,i) = cov_matrix(:,:,i) + ((clus(i).Data(j,:))-mean(clus(i).Data))'*((clus(i).Data(j,:))-mean(clus(i).Data)); 
         end
    end
    if (size(clus(i).Data,1) > 1)
    cov_matrix(:,:,i) = cov_matrix(:,:,i)/(size(clus(i).Data,1)-1);
    end
end



Sigma = cov_matrix;

% repeat kmeans if negative determinant
% for j = 1:k
%     while (det(Sigma(:,:,j)) < 0 )
%     [mu,clus,Sigma,Scaling_value] = findkmeans(data,k,B,flag);
%     disp('Repeat Kmeans: Bad covariance');
%     end
% end








if (flag==1)
    
for i=1:k
[U S V] = svd(Sigma(:,:,i));
Sing_vals = diag(Sigma(:,:,i));
Sing_vals_norm = Sing_vals/max(Sing_vals);
Scaling_value(i) = max(Sing_vals)
S_norm = diag([Sing_vals_norm]);
% Reconstruct the matrix
Sigma(:,:,i) = U*S_norm*V';
end

end

if (flag == 0)
Scaling_value = ones(1,k);
end


return
























% Assuming Data is decorrelated: Projections from SVD
% Estimate of Sigma


% for i = 1:k
%     for j=1:size(clus(1).Data,2) % It is seven column (Dim) with either cluster
%     v(i,j) = var(clus(i).Data(:,j));
%     end
% end
% 
% for i=1:k
% Sigma(:,:,i) = diag([v(i,:)]);
% end   


% Normalizing covariance only after EM implementation
% % Normalizing the covariance matrix
% for i=1:k
%     [U S V] = svd(Sigma(:,:,i));
%     Sing_vals = diag(Sigma(:,:,i));
%     Sing_vals_norm = Sing_vals/max(Sing_vals);
%     S_norm = diag([Sing_vals_norm]);
%     % Reconstruct the matrix
%     Sigma(:,:,i) = U*S_norm*V';
% end
 
 
% % Scaling Data
        