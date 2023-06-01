function [r, p] = rankcorrelation(x, y)
%  RANKCORRELATION calculates Spearman's rank correlation coefficient
%
% [r, p] = rankcorrelation(x, y)
%
%

[sortx_STs,x_inds]=sort(x,'ascend');
[sorty_STs,y_inds]=sort(y,'ascend');
x_ranks(x_inds) = 1:length(x_inds);
y_ranks(y_inds) = 1:length(y_inds);

clear dx_ranks dy_ranks
STs = unique(sortx_STs);
dx_ranks = zeros(1,length(STs));
for iST = 1:length(STs)
    ind = find(x==STs(iST));
    dx_ranks(ind) = mean(x_ranks(ind));
end
STs = unique(sorty_STs);
dy_ranks = zeros(1,length(STs));
for iST = 1:length(STs)
    ind = find(y==STs(iST));
    dy_ranks(ind) = mean(y_ranks(ind));
end
tmp = corrcoef(dx_ranks,dy_ranks);
r = tmp(1,2);
rperm = zeros(1,1e4);
for iPerm = 1:1e4
    tmp = corrcoef(dx_ranks,dy_ranks(randperm(length(dy_ranks))));
    rperm(iPerm) = tmp(1,2);
end
p = length(find(abs(rperm) > abs(r)))./1e4;

