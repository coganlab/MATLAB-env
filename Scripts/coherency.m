function [ result ] = coherency( x,y,N )
  % divide data in N equal length blocks for averaging later on
  L  = floor(length(x)/N);
  xt = reshape(x(1:L*N), L, N);
  yt = reshape(y(1:L*N), L, N);

  % transform to frequency domain
  Xf = fft(xt,L,1);
  Yf = fft(yt,L,1);

  % estimate expectations by taking the average over N blocks
  xy = sum(Xf .* conj(Yf), 2)/N;
  xx = sum(Xf .* conj(Xf), 2)/N;
  yy = sum(Yf .* conj(Yf), 2)/N;

  % combine terms to get final result
  result=xy./sqrt(xx.*yy);
end