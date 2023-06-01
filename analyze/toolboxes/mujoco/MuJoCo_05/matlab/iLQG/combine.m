function [y,c,yx,yu,yxx,yxu,yuu,cx,cu,cxx,cxu,cuu] = combine(DYN, CST, x, u, t, gamma)

final    = isnan(u(1,:));
N        = sum(~final);

if nargout == 2
   c  = CST(x, u, t);
   if N > 0
      y  = DYN(x, u, t);
   else
      y  = 0;
   end
else
   [y,yx,yu,yxx,yxu,yuu]   = DYN(x(:,~final), u(:,~final), t);
   [c,cx,cu,cxx,cxu,cuu]   = CST(x,        u,              t);
end

% apply discounting
if nargin > 5
	discount = gamma.^t;
	c = c .* discount;
	if nargout > 2
		cx = bsxfun(@times,cx,discount);
		cu = bsxfun(@times,cu,discount);
		cxx= bsxfun(@times,cxx,permute(discount,[1 3 2]));
		cxu= bsxfun(@times,cxu,permute(discount,[1 3 2]));
		cuu= bsxfun(@times,cuu,permute(discount,[1 3 2]));
	end
end

function c = tt(a,b)
c = bsxfun(@times,a,b);
