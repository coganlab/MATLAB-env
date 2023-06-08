function [XX] = customKernel2(X1,X2,Y1,Y2,gamma1,gamma2, alpha)
n1 = size(X1,1);
n2 = size(X2,1);

XX = zeros(n1,n2);

% for i = 1:n1
%     for j = 1:n2
%         dist = sum((X1(i,:)-X2(j,:)).^2);
%         XX(i,j) = exp(-dist*gamma);
%     end
% end

for i = 1:n1
    dist1 = sum((repmat(X1(i,:),n2,1)-X2).^2,2);
    dist2 = sum((repmat(Y1(i,:),n2,1)-Y2).^2,2);
    XX(i,:) = alpha.*exp(-dist1*gamma1) + (1-alpha).*exp(-dist2*gamma2);
end
