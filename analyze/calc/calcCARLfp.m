function [car_lfp, car] = calcCARLfp(Lfp)
%
%  [CAR_LFP, CAR] = calcCARLFP(Lfp)
%
%  Inputs:  LFP = Multichannel lfp data.  [Trial, Channel, Time]
%
%  Outputs: CAR_LFP = Common average referenc removed LFP
%           CAR = Common average reference.

nCh = size(Lfp,2);

CAR = sum(Lfp,2)./nCh;

for iCh = 1:nCh
    car_lfp(:,iCh,:) = Lfp(:,iCh,:) - CAR;
end

car = sq(CAR);