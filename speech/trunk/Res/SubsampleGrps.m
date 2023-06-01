% SubsampleGrps: Given a grouping vector and numbers of observations to be subsampled for each
%                group, returns a sorted vector of randomly selected observation indices.
%
%     Usage: obs = subsamplegrps(grps,sampsize)
%
%         grps =     [N x 1] vector of group identifiers.
%         sampsize = vector of sample sizes to be subsampled from the groups.  If a scalar is
%                      passed, it is used for all groups.
%         -----------------------------------------------------------------------------------
%         obs =      sorted [sum(sampsize) x 1] vector of observation indices.
%

% RE Strauss, 9/19/03

function obs = SubsampleGrps(grps,sampsize)
  sampsize = sampsize(:);
  [u,freq] = uniquef(grps);
  ngrps = length(u);
  
  if (isscalar(sampsize))
    sampsize = sampsize * ones(ngrps,1);
  end;
  
  if (any(sampsize > freq))
    error('  SubsampleGrps: one or more subsample sizes are greater than sample sizes.');
  end;
  
  obs = [];
  for ig = 1:ngrps
    i = find(grps==u(ig));
    i = i(randperm(length(i)));
    obs = [obs; i(1:sampsize(ig))];
  end;
  obs = sort(obs);
  
  return;
  