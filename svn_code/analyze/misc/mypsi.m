function [f] = psi(z)
%Psi     Psi (or Digamma) function valid in the entire complex plane.
%
%                 d
%        Psi(z) = --log(Gamma(z))
%                 dz
%
%usage: [f] = psi(z)
%
%tested under version 5.3.1
%
%        Z may be complex and of any size.
%
%        This program uses the analytical derivative of the
%        Log of an excellent Lanczos series approximation
%        for the Gamma function.
%        
%References: C. Lanczos, SIAM JNA  1, 1964. pp. 86-96
%            Y. Luke, "The Special ...", 1969 pp. 29-31
%            J. Spouge,  SIAM JNA 31, 1994. pp. 931
%            W. Press,  "Numerical Recipes"
%
%see also:   GAMMA GAMMALN GAMMAINC
%see also:   mhelp psi
%see also:   mhelp GAMMA

%Paul Godfrey
%pgodfrey@intersil.com
%8-23-00

[row, col] = size(z);
z=z(:);
zz=z;

f = 0.*z; % reserve space in advance

%reflection point
p=find(real(z)<0.5);
if ~isempty(p)
   z(p)=1-z(p);
end

%Lanczos approximation for the complex plane
c = [    0.9999999999995183;
       676.5203681218835;
     -1259.139216722289;
       771.3234287757674;
      -176.6150291498386;
        12.50734324009056;
        -0.1385710331296526;
         0.000009934937113930748;
         0.0000001659470187408462];

n=0;
d=0;
for k=9:-1:2
    dz=1./(z+k-2);
    dd=c(k).*dz;
    d=d+dd;
    n=n-dd.*dz;
end
d=d+c(1);

f = n./d + (z-0.5)./(z+6.5) - 1 + log(z+6.5);

if ~isempty(p)
   f(p) = f(p)-pi*cot(pi*zz(p));
end

p=find(round(zz)==zz & real(zz)<=0 & imag(zz)==0);
if ~isempty(p)
   f(p) = Inf;
end

f=reshape(f,row,col);

return

%A demo of this routine is:
clc
clear all
close all
x=-4:1/16:4.5;
y=-4:1/16:4;
[X,Y]=meshgrid(x,y);
z=X+i*Y;
f=psi(z);
p=find(abs(f)>10);
f(p)=10;

mesh(x,y,abs(f),phase(f));
view([45 10]);
rotate3d;

figure(2);
ezplot psi;
grid on;

return
