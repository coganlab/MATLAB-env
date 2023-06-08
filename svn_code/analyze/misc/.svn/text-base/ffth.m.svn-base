function [F] = ffth(T)
%Half space FFT
%Usage: F = ffth(T)
%
%    FFTH(T) performs a FFT on real vector T
%    in half the space (and time) of
%    a regular FFT.
%
%    Tested under version 5.2.0
%
%    See also FFT, IFFT, FFT2, IFFT2, FTSHIFT


%Paul Godfrey
%pjg@mlb.semi.harris.com


[row,col]=size(T);
n=max(row,col);
n2=n/2;


ang=2*pi/n;


if isreal(T)==0
   disp('Warning! Input data is not real!')
   F=fft(T);
else
   k=1:n2;
   tt(k)=(T(k+k-1)+i*T(k+k));
   ff=(fft(tt)/n2);
   rr=real(ff(1))/2;ii=imag(ff(1))/2;
   F(1)   =rr+ii;
   F(n2+1)=rr-ii;
   k=2:n2;
     p=i*exp(-i*ang*(k-1));
     kk=n2+2-k;
     F(k)=(ff(k).*(1-p)+conj(ff(kk)).*(1+p))/4;
   k=n2+2:n;
   F(k)=conj(F(n+2-k));
   F=F*n;
end


F=reshape(F,row,col);


return
