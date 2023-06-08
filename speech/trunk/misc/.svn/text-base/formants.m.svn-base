function [fmnts,h] = formants(x,fs,n)
%
% function [fmnts,spec] = formants(x,fs,n)
%
%   returns a column vector containing the locations
%   of the formants of the speech signal x
%   fs is the sampling frequency of x
%   n is the order of the auto-regressive model
%


if nargin < 3 
    n = round(fs/1000) + 5;
end

w = hamming(length(x));
x = x.*w;
% plot(x);
% title('Windowed Speech Data to be Modeled');
% pause

th = ar(x,n);	 	% auto-regressive model of voice
[b,a] = th2tf(th);	% transfer function of vocal tract
[h,w] = freqz(b,a);	% frequency response of vocal tract
f = w.*fs/(2*pi);

%figure
%semilogy(f,abs(h))
%xlabel('Frequency (Hz)')
%ylabel('log scale frequency response')
%title('Auto-Regressive Model of Vocal Tract')
%hold on


[floc,fmag] = myfpeaks(abs(h));
allfmnts = f(floc);
if length(allfmnts)>1
if allfmnts(2)<1e3 allfmnts = allfmnts(2:end); end
%semilogy(allfmnts,fmag,'x');
end
disp('decision');
if ( length(allfmnts) < 3 )
    disp('fmntest');
	fmnts = fmntest1(b,a,fs);
else
	fmnts = allfmnts(1:3);
end % if

%p = roots(a)

