function MuPower = calcMuPower(Mu,sm)
%
%  MuPower = calcMuPower(Mu,sm)
%
%  INPUT: Mu = Array in Trial, Time format from one channel.
%         sm = Scalar.  Number of bins to smooth powre estimate over

a = reshape(Mu,[size(Mu,1),sm,size(Mu,2)./sm]);
MuPower = sq(std(a,[],2));