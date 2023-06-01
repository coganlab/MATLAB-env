% MSTreePartitions: Given a set of 2D points (vertices) and edges specifying a minimum 
%     spanning tree, determines the sizes and identities of point partitions resulting from 
%     the removal of each edge.
%
%     Usage: [partsizes,partitions,pt_type] = MSTreePartitions(pts,edges)
%
%         pts =        [N x 2] matrix of point coordinates specifying vertices.
%         edges =      [N-1 x 2] list of points defining edges, in arbitrary sequence.
%         ---------------------------------------------------------------------------------
%         partsizes =  [N-1 x 1] vector of partition size corresponding to each edge, where
%                        the size is that of the smaller of the two groups.
%         partitions = [N-1 x N] (edge x point) boolean matrix of corresponding partitioned 
%                        point identifiers, with partitions indicated by 0's and 1's.
%         pt_type =    [N x 1] vector of point-type indicators: 1 = tip point, 2 = tip-to-node
%                        branch point, 3 = internodal branch point, 4 = node.                    
%       
    
% RE Strauss, 10/14/03

function [partsizes,partitions,pt_type] = MSTreePartitions(pts,edges)
  [Np,Pp] = size(pts);
  if (Pp~=2)
    error('  MSTreePartitions: 2D points only.');
  end;
  
  [Ne,Pe] = size(edges);
  if (Ne ~= Np-1)
    error('  MSTreePartitions: invalid number of points or edges.');
  end;
  
  partsizes = zeros(Ne,2);              % Allocate output matrices
  partitions = zeros(Ne,Np);    
n_edges = [[1:size(edges,1)]',edges]  
  
  [u,f] = uniquef(edges(:),1);          % Classify points as tip, branch or node
  tips = u(f==1);
  branches = u(f==2);
  nodes = u(f>2);
  ntips = length(tips);
  
  pt_type = zeros(Np,1);               
  pt_type(tips) = ones(length(tips),1);
  pt_type(branches) = 3*ones(length(branches),1);
  pt_type(nodes) = 4*ones(length(nodes),1);
n_pt_type = [[1:length(pt_type)]',pt_type]  
  
  nodesfound = zeros(Np,4);             % Points leading to internal nodes
  
  for it = 1:ntips                      % Classify points along tip branches till reach node
    curpt = tips(it);                     % Begin with tip point

    next_is_branch = 1;
    prevpt = [];
    tipset = [];
    bingrp = zeros(1,Np);
    
    while (next_is_branch)                % Follow pts along branch till reach node
      [nextpt,curedge] = FindMSTEdgePt(edges,curpt,prevpt);   % Follow edge to next point
      
      tipset = [tipset; curpt];
      bingrp(curpt) = 1;
      partsizes(curedge,:) = [sum(bingrp==0),sum(bingrp)];    % Add point to partition
      partitions(curedge,:) = bingrp;
      
      prevpt = curpt;                                         % Update points
      curpt = nextpt;

      if (isin(nextpt,nodes))               % If next pt is a node, stash partition for node and quit
        next_is_branch = 0;
        i = find(nodesfound(curpt,:)==0);
        nodesfound(curpt,i(1)) = prevpt;
      else
        pt_type(curpt) = 2;                 % Else label cur pt as a branch pt
      end;
    end;  % while
  end;  % for
  
  more_edges = 1;
  while (more_edges)                    % Follow branches between internal nodes
    curpt = find(nodesfound(:,2)>0);    
    if (isempty(curpt))
      more_edges = 0;
    else
      curpt = curpt(1);
      prevpt = nodesfound(curpt,nodesfound(curpt,:)>0);
      nodesfound(curpt,:) = zeros(1,size(nodesfound,2));

      tipset = [];
      for ip = 1:length(prevpt)           % Accum pts from all branches leading to node
        ie = find(edges(:,1)==min([curpt,prevpt(ip)]) & edges(:,2)==max([curpt,prevpt(ip)]));
        tipset = [tipset; find(partitions(ie,:))'];
      end;
      bingrp = zeros(1,Np);
      bingrp(tipset) = ones(1,length(tipset));

      next_is_branch = 1;
      while (next_is_branch)
        [nextpt,curedge] = FindMSTEdgePt(edges,curpt,prevpt);   % Follow edge to next point
prevpt
curpt
nextpt
curedge

        if (isempty(nextpt))
          next_is_branch = 0;
        else
          tipset = [tipset; curpt];
          bingrp(curpt) = 1;
bingrp
partsizes
          partsizes(curedge,:) = [sum(bingrp==0),sum(bingrp)];
          partitions(curedge,:) = bingrp;
        
          prevpt = curpt;
          curpt = nextpt;

          if (isin(nextpt,nodes))   % If next pt is a node, stash partition for node and quit
            next_is_branch = 0;
            i = find(nodesfound(curpt,:)==0);
            nodesfound(curpt,i(1)) = prevpt;
          end;  % if
        end;  % if else
      end;  % while
    end;  % if else
  end;  % while
  
  ip = find(partsizes(:,2)>partsizes(:,1));     % Report smaller of partition sizes
  for i = 1:length(ip)                          % Change group identity of points if necessary
    partitions(ip(i),:) = abs(partitions(ip(i),:)-1);
  end;
  partsizes = min(partsizes')';
  
  return;
  