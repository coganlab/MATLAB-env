function D = isodist(y,class,c)
%
%  D = isodist(y,class,c)
%
%  Inputs:  Y     = All data
%	    CLASS = Classes
%	    C     = Class of interest
%

if nargin < 3 c = 1; end

ind1 = find(class(:,c)==1);
ind2 = find(class(:,c)~=1);

if length(ind1) > 2
    bcl = zeros(1,size(class,1));
    bcl(ind1) = 1;
    bcl(ind2) = -1;
    
    m = mahal(y,y(ind1,:));
    m1 = mahal(y(ind1,:),y(ind1,:));
    m2 = mahal(y(ind2,:),y(ind1,:));
    
    mmax = max(m); mmin = min(m);
    xm = linspace(mmin,mmax,100);
    for ix = 1:100
        n1 = length(find(m1<xm(ix)));
        n2 = length(find(m2<xm(ix)));
        n(ix) = n1-n2;
    end
    
    D = xm(max(find(n>0)));
else 
    D = 0;
end