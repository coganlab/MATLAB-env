% ContigGroups: Given a 2D scatter of points, randomly divides them into k contiguous groups 
%               of specified sample sizes by partitioning the space via a minimum spanning tree.  
%               See also mstgrp().
%
%     Usage: grps = contiggroups(pts,{sizes},{doplot})
%
%         pts =     [n x 2] matrix of point coordinates for n points.
%         sizes =   vector of sample sizes per group, or scalar indicating number of
%                     groups [default = sizes as equal as possible].
%         doplot =  optional boolean flag indicating, if true, that a scatterplots of
%                     the tree and partitions of points are to be produced [default = 0].
%         -------------------------------------------------------------------------------
%         grps =    corresponding [n x 1] vector of group memberships.
%

% RE Strauss, 9/16/03

function grps = contiggroups(pts,sizes,doplot)
  if (nargin < 2) ngrps = []; end;
  if (nargin < 3) doplot = []; end;
  
  if (isempty(doplot)) doplot = 0; end;
  if (isempty(sizes))
    error('  ContigGroups: missing number of groups or vector of sample sizes.');
  end;
  
  N = size(pts,1);
  k = length(sizes);
  grps = [];
 
  if (k==1)
    k = sizes;
    probs = ones(1,k)*(1/k);
    probs(k) = 1-sum(probs(1:(k-1)));
    sizes = prbcount(probs,N,[],[],1);
  end;
  sizes = -sort(-sizes);                        % Sort grp sizes into descending sequence
sizes
  
  if (sum(sizes)~=N)
    error('  ContigGroups: sum of sample sizes must match number of points.');
  end;

  edges = MSTree(pts,doplot);                             % Find minimum spanning tree
%   edges = MSTree(pts);                                    % Find minimum spanning tree
  [partsizes,partitions,pt_type] = MSTreePartitions(pts,edges);   % Find partitions
% point_types = [[1:length(pt_type)]',pt_type]

  partsizes = [partsizes; N-partsizes];                   % Reverse binary membership codes and stash
  partitions = [partitions; abs(partitions-1)];
  i = randperm(size(partitions,1));                       % Randomly permute
  partsizes = partsizes(i);
  partitions = partitions(i,:);
% [[1:length(partsizes)]' partsizes partitions]

  grpmem = zeros(k,N);                          % Allocate binary group-membership matrix

  for ik = 1:k-1                                % For each group except the last,
% ik    
    ip = find(partsizes == sizes(ik));            % Find first partition of desired size
% ip    

    if (isempty(ip))                              % If none,
      rs = partsizes - sizes(ik);                   % Find partition with least greater size
      i = find(rs<0);
      rs(i) = 1e6*ones(length(i),1);
      [rs,ip] = min(rs);                            % Residual size and position
% rs
% ip
      
      pt_ids = find(partitions(ip,:))';
      pt_scores = pt_type(pt_ids);
      i = randperm(length(pt_ids));
      pt_scores = pt_scores(i);
      pt_ids = pt_ids(i);
pt_ids_scores = [pt_ids,pt_scores]      
      
      for ir = 1:rs
        [minscore,i] = max(pt_scores)
        partitions(ip,pt_ids(i)) = 0
        pt_scores(pt_ids(i)) = 0
      end;

%       pt_scores = partitions(ip,:);                 % Preferentially exclude nodes and
%       i = find(pt_scores);                          %   internodal points from group
%       pt_scores(i) = pt_type(pt_scores(i));
%       for ir = 1:rs
%         [minscore,i] = min(pt_scores);
%         partitions(ip,i) = 0;
%         pt_scores(i) = 0;
%       end;
      
% %       irs = find(partsizes==rs & IsBooleanSubset(partitions,partitions(ip,:)))
% % [[1:length(partsizes)]' partsizes partitions]
% %       partitions(ip,:) = partitions(ip,:) - partitions(irs(1),:); % Substitute complement of subset
% %       partsizes(ip) = sizes(ik);
% [[1:length(partsizes)]' partsizes partitions]
    end;
    ip = ip(1);
    grpmem(ik,:) = partitions(ip,:);              % Stash binary memberships for current group
% grpmem

    is = find(IsBooleanSubset(partitions(ip,:),partitions)); % Remove from all partitions that include members
    i = find(is~=ip);                                        %   of this group
    is = is(i);
% is
    for i = 1:length(is)                                                   
      partitions(is(i),:) = partitions(is(i),:) - partitions(ip,:);
      partsizes(is(i)) = partsizes(is(i)) - partsizes(ip);
    end;
    
    excl = [];
    c = find(partitions(ip,:));
% c    
    for i = 1:length(partsizes)
      if (partsizes(i)==0 | any(partitions(i,c)==1))
        excl = [excl; i];
      end;
    end;
    partitions(excl,:) = [];
    partsizes(excl) = [];
    
% [[1:length(partsizes)]' partsizes partitions]
  end;
  grpmem(k,:) = (sums(grpmem(1:k-1,:))==0);
% grpmem  

  grps = zeros(N,1);
  for ik = 1:k
    i = find(grpmem(ik,:));
    grps(i) = ik*ones(length(i),1);
  end;

  if (doplot)
    figure;
    plotgrps(pts(:,1),pts(:,2),grps);
  end;


  return;
  