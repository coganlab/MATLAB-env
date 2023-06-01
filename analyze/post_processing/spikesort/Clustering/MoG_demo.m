function [] = MoG_demo(N_points,N_clusters,dim,scale_mu,scale_cov,no_figure),

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%     Mixture of Gaussians    %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MoG_demo(N_points,N_clusters,dim,scale_mu,scale_cov)  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% N_points   = total number of data points; def: 150      %
%% N_clusters = number of clusters         ; def:  3       %
%% dim        = dimension of data point    ; def:  2       %  
%% scale_mu   = scale factor for the mean  ; def:  3       %
%% scale_cov = scale factor for the cov    ; def:  1       %
%% no_figure [1/0]= update plot/don't update plot; def: 0  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% - When the clustering is concluded , each data point is 
%% colored with the same color of the corresponding cluster.
%% - If a data point is not assigned to the correct cluster 
%% a white square will embed it. If too many points are not 
%% assigned correctly the relabeling routine fails and the 
%% square does not make sense any longer.
%% - In figure 2 is plotted the loglikelihood for each 
%% iteration.
%% - In figure 3 is plotted  the solution proposed by 
%% the Matlab K_means Matlab algorithm - actually very fast but
%% inaccurated when dealing with  low dimension data points
%% (cluster colors for MoG and K-means are in general different)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% S. Savarese   M.Welling     
%%%%%%%%    May 2000 - Caltech 	     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear;
%N_points   = 150;         %
%N_clusters = 3;           %
%dim        = 2;           %  
%scale_mu   = 4;           %
%scale_cov = 1;          %
%no_figure = 0;


if (nargin==0)
   N_clusters = 3; 
   N_points = 150;
   dim =2;
   scale_mu = 3;
   scale_cov = 1;
   no_figure = 0;
end;

load_data=0;
colordef black;
N_iteration=200;
color = ['g' 'r' 'm' 'y' 'c' 'b' 'w' ];

if (load_data==1),
	load MoGdata;
	XX=X;
	dim=size(XX,1);
	N_clusters=3;
	N_points=size(XX,2);

elseif (load_data==0),

	%%% generate data
	mu=zeros(dim,N_clusters);
	sigma=zeros(dim,dim,N_clusters);

	for i=1:N_clusters,
	    mu(:,i)=randMean(dim,scale_mu);
	    sigma(:,:,i)=randCovariance(dim,scale_cov);
	 end;
	 

	pis=rand(N_clusters,1);
	sum_pis=sum(pis);
	pis_n=pis/sum_pis;

	[XX fr] = randMG(N_points,pis_n,mu,sigma);
end;

N_points=size(XX,2);

%rand_point = randvec(N_points,mu,cov);
x1 = XX(1,:);
y1 = XX(2,:);

min_y = min(y1)-2;
min_x = min(x1)-2;
max_y = max(y1)+2;
max_x = max(x1)+2;


%%% init mu, cov, pi
mu_init=zeros(dim,N_clusters);
sigma_init=zeros(dim,dim,N_clusters);

for i=1:N_clusters,
	mu_init(:,i)=randMean(dim,1);
	sigma_init(:,:,i)=eye(dim)*(1); 	
end;
pi_init=ones(1,N_clusters)/N_clusters;

figure(3);
clf;

figure(1);
clf;
title('MoG cluster model');
hold on;
axis([min_x max_x min_y max_y]);
list_cl = [0 cumsum(fr)];

for (i=1:N_clusters),
   plot(x1(list_cl(i)+1:list_cl(i+1)),y1(list_cl(i)+1:list_cl(i+1)),[color(i) 'x'],'linewidth',2);
   drawnow;
end;

if (no_figure==0),
   for i=1:N_clusters,
      hold on;
      plotGauss_color(mu_init(1,i)',mu_init(2,i)',sigma_init(1,1,i),sigma_init(2,2,i),sigma_init(1,2,i),'y');
      drawnow;
   end;
end;

mu_old=mu_init;
sigma_old=sigma_init;
pi_old=pi_init;
mu_new = zeros(dim,N_clusters);
sigma_new = zeros(dim,dim,N_clusters);
pi_new=ones(1,N_clusters);

count=0;

while (count<N_iteration),
      
      if (no_figure==0),
	 figure(1);
	 clf; 
	 title('MoG cluster model');
	 axis([min_x max_x min_y max_y]);
	 hold on;
	 for (i=1:N_clusters),
	    plot(x1(list_cl(i)+1:list_cl(i+1)),y1(list_cl(i)+1:list_cl(i+1)),[color(i) 'x'],'linewidth',2);
	 end;
      end;
      
      %%%%%%%%%% compute the responsabilty matrix
      R_old=zeros(N_clusters,N_points);
      
      for n=1:N_points

	 x_n=XX(:,n);    
	 tot_pr=zeros(1,N_clusters);
    
	 for j=1:N_clusters,
	    tot_pr(j)=gaussian(mu_old(:,j),sigma_old(:,:,j),x_n,dim)* pi_old(j);
	 end;   
	 
	 total_pr=sum( tot_pr);
	 
	 for j=1:N_clusters,
	    num=gaussian(mu_old(:,j),sigma_old(:,:,j),x_n,dim)*pi_old(j);
	    resp_val = num/total_pr;
	    R_old(j,n)=resp_val;
	 end;
      end;
      
     
      for (i=1:N_clusters),

            %%%%%%%% update mean
	    R_old2=ones(dim,1)*R_old(i,:);
            XX_R = R_old2.*XX;
	    num=sum(XX_R,2);
	    den=sum(R_old(i,:));
	    mu_new(:,i)=num/den;
	    XX_R2 = zeros(dim,dim,N_points);
	    
	    for (n=1:N_points)
		XX_R2(:,:,n)= R_old(i,n).*(XX(:,n)*XX(:,n)');
	    end;
	    
	    num2 = sum(XX_R2,3);
	    sigma_new(:,:,i) = num2/den - mu_new(:,i)*mu_new(:,i)'+eye(dim)*10E-6;

	    %%%%% compute pi
	    pi_new(i) = den/N_points;

	    %%%%%show figures
	    if (no_figure==0);
	       figure(1);
	       mu1=mu_new(1,i);
	       mu2=mu_new(2,i);
	       var1=sigma_new(1,1,i);
	       var2=sigma_new(2,2,i);
	       covar=sigma_new(1,2,i);
	       plotGauss_color(mu1,mu2,var1,var2,covar,'y');
	    end;
	    
      end;
      
      %%%%%%%%%%% update parameters
      mu_old = mu_new;
      sigma_old = sigma_new;
      pi_old = pi_new;
      
      %%%%%%%%%%%%% compute and show loglikelihhod
      fprintf('%d - ',count);
      
      alpha=0;
      log_lik=0;
      log_lik_n=zeros(1,N_points);
      log_lik_j=zeros(1,N_clusters);

      for n=1:N_points,
	  x_n=XX(:,n);
	  
	  for j=1:N_clusters,
	      log_lik_j(j) = pi_new(j)*gaussian(mu_new(:,j),sigma_new(:,:,j),x_n,dim);
	  end;
	  
	  log_lik_n(n)=log(sum(log_lik_j));
      end;
      log_lik = sum(log_lik_n);
      
      count=count+1;
      log_lik_list(count)=  log_lik;
      fprintf('LogLik = %4.4f\n',log_lik); 
      
      if(no_figure==0),
	 figure(2);
	 title('Loglikelihood');
	 plot(log_lik_list,'o');
	 drawnow;
      end;
      
      if (count>1)&(log_lik_list(count)<log_lik_list(count-1)),
	 %fprintf('ERROR!\n');
      end;
      
      if (count>1)&(log_lik_list(count)-log_lik_list(count-1)<10E-6),
	 fprintf('Done. \nBye!\n');
	 break;
      end;
      

end; %% end while loop

%%%%%%%%%%%%%%%%%% relabeling clusters
N_state=N_clusters;
tau=N_points;
Y=zeros(1,N_points);

for (i=1:N_clusters),
   Y(list_cl(i)+1:list_cl(i+1))=i;
end;

[max_R Y_resp] = max(R_old,[],1);

y_i3=zeros(1,N_state);
Y_resp2=ones(1,tau)*(N_state+1);
A_ij2 = zeros(N_state,N_state);
ii = ones(1,N_state);

for i=1:N_state,
    for j=1:N_state,

	[index1] = find(Y==i);
	[y_i1] = (Y==i);
        [index2] = find(Y_resp==j);
	[y_i2] = (Y_resp==j);
	y_i3(j) = sum(y_i1.* y_i2);
   end;
   [maxi index3] = max(y_i3);
   j=index3;
   [index2] = find(Y_resp==j);
   Y_resp2(index2)=i;
   ii(j)=i;
end;

%%%%%%%%% compute error
error = not((Y_resp2==Y));
index2 = find(error);

figure(1);
hold on;
plot(XX(1,index2),XX(2,index2),'ws','linewidth',2);

%%%%%%% plot colored gaussians
figure(1);

for i=1:N_clusters,
   mu1=mu_new(1,i);
   mu2=mu_new(2,i);
   var1=sigma_new(1,1,i);
   var2=sigma_new(2,2,i);
   covar=sigma_new(1,2,i);
   plotGauss_color(mu1,mu2,var1,var2,covar,color(ii(i)));

end;

	    %R_old3=zeros(1,1,N_points);
	    %R_old3(1,1,:)=R_old(i,:);
	    %R_old4 = repmat(R_old3(1,1,:),[2 2 1]);
	    %R_old4 = repmat(R_old(i,:),[1 1 2]);
	    
%%%%%%%%% compare with Matlab K-means routine

option(1)= 1;
option(2)=10E-6;
option(3)=10E-6;
option(14)=100;
XX2 = XX';
[CC opt post err]=  kmeans(mu_init',XX2,option);


figure(3);
clf;
title('K-means cluster model');
hold on;
axis([min_x max_x min_y max_y]);
%for (i=1:N_clusters),
%   plot(XX(1,list_cl(i)+1:list_cl(i+1)),XX(2,list_cl(i)+1:list_cl(i+1)),[color(i) 'x'],'linewidth',2);
%end;

[K_resp, Kmean2]=find(post');
for n=1:N_points,
   hold on;
   plot(XX(1,n),XX(2,n),[color(K_resp(n)) 'x'],'linewidth',2);
end;

CC2=CC';
plot(CC2(1,:),CC2(2,:),'w+','linewidth',2);