% fin_diff: vectorized subspace finite-differencing 
function [f,fx,fxx] = fin_diff(fun, x, h, order, pp, dd, n)
% usage:
%
% [f, fx] = fin_diff(fun, x) 
%			computes the first derivatives (Jacobian) of fun at x
%
% [f, fx, fxx] = fin_diff(fun, x) 
%			also computes second derivatives (Hessian)
%
% [f, fx, fxx] = fin_diff(fun, x, h) 
%			choose the size of the perturbation (default == 2^-17)
%
% ...	  = fin_diff(fun, x, h, order) chooses the order of finite
%			differenceing. 0: forward, no Hessian; 1: central, diagonal
%			of Hessian.	2: second derivatives with one sample per 
%			off-diagonal element. 3: two samples per off-diagonal. 
%			4: four samples per off-diagonal
%
% ...	  = fin_diff(..., pp, dd, n) subspace differention. pp() and dd()
%			are respectively the add and diff function for lifting out of
%			and projecting into the subspace. n is the subspace dimension.
%
% This function will be much faster if the mmx package is installed:
% http://www.mathworks.com/matlabcentral/fileexchange/37515

if nargin < 7
   pp = @(a,b) pp0(a,b);
   dd = @(a,b) dd0(a,b);
   n  = size(x,1);   % size(x) = size(dx)
end

if isempty(dd)
   dd = @(a,b) dd0(a,b);
end

sort = 1;

if nargout == 1
   f  = fun(x);
   return
end

if nargin < 3
   h  = 2^-17;
end
if nargin < 4
   order = 4;
end

N           = size(x,2);
p           = (n^2-n)/2;
I           = eye(n);

if nargout == 2
   Q        = [zeros(n,1) I -I];
   D        = [I -I]';
   dX       = h*Q;
   x        = permute(x,[1 3 2]);
   X        = pp(x, dX);
   F        = fun(X);
   f        = F(:,1,:);
   dF       = dd(F(:,2:end,:), f);   
   fx       = mm(dF, D)*(2*h)^-1;
   f        = permute(f, [1 3 2]);
   return
end

T        = triu(ones(n),1);
[n1,n2]  = find(T);
Q1       = I(:,n1);
Q2       = I(:,n2);

switch order
   case 0
      Q        = [zeros(n,1) I];
      D        = I;
      hh       = h*ones(1,n);   
   case 1
      Q        = [zeros(n,1) I -I];
      D        = [[I; -I] [I; I]];
      hh       = [2*h*ones(1,n) h^2*ones(1,n)];
   case 2
      Q        = [zeros(n,1) I -I Q1+Q2];
      D        = [[I I; -I I; zeros(p,2*n)] [-Q1-Q2; zeros(n,p); eye(p)]];
      hh       = [2*h*ones(1,n) h^2*ones(1,n) h^2*ones(1,p)];
   case 3      
      Q        = [zeros(n,1) I -I Q1+Q2 -Q1-Q2];
      D        = [[I I; -I I; zeros(2*p,2*n)] [-Q1-Q2; -Q1-Q2; eye(p); eye(p)]];
      hh       = [2*h*ones(1,n) h^2*ones(1,n) 2*h^2*ones(1,p)];
   otherwise
      Q        = [zeros(n,1) I -I Q1+Q2 -Q1-Q2 Q1-Q2 Q2-Q1];
      B        = (n+1)*I - 2;
      D        = [[I;-I; zeros(4*p,n)]...      
                  [B; B; repmat((Q1+Q2)',[4 1])]...
                  [zeros(2*n, p); eye(p); eye(p); -eye(p); -eye(p)]];
      hh       = [2*h*ones(1,n) (3*n-3)*h^2*ones(1,n) 4*h^2*ones(1,p)];                         
end

if sort
   [Qs,iQ]  = sortrows(Q(:,2:end)');
   Q        = [Q(:,1) Qs'];
   D        = D(iQ,:);
end

dX       = h*Q;
x        = permute(x,[1 3 2]);
X        = pp(x, dX);
F        = fun(X);
f        = F(:,1,:);
dF       = dd(F(:,2:end,:), f);
m        = size(dF,1);

if exist('mmx','file') == 3
    FX   = mmx('mult',dF, D); 
else
    FX  = zeros(size(dF,1), size(D,2), N);
    for i = 1:N
        FX(:,:,i) = dF(:,:,i)*D;
    end    
end

FX       = tt(FX, hh.^-1); 
fx       = FX(:,1:n,:);
yxx      = FX(:,n+1:end,:);
f        = permute(f, [1 3 2]);

if order == 0
   fxx                  = [];   
elseif order == 1
   T                    = logical(eye(n));
   fxx                  = zeros(m,n*n,N);
   fxx(:,T(:),:)        = yxx;   
   fxx                  = reshape(fxx,[m n n N]);
else
   T(logical(T))        = n+(1:p);
   T                    = T+T';
   T(logical(eye(n)))   = 1:n;
   fxx                  = yxx(:,T(:),:);
   fxx                  = reshape(fxx,[m n n N]);
end

function ab = pp0(a,b) 

ab = bsxfun(@plus,a,b);

function ab = dd0(a,b) 

ab = bsxfun(@plus,a,-b);

function ab = tt(a,b)

ab = bsxfun(@times,a,b);
