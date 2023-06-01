load fisheriris
X = meas;
mu = mean(X);

[eigenvectors, scores] = pca(X);

nComp = 2;
Xhat = scores(:,1:nComp) * eigenvectors(:,1:nComp)';
Xhat = bsxfun(@plus, Xhat, mu);

Xhat(1,:)