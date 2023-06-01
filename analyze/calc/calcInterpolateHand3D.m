function InterpHand3D = calcInterpolateHand3D(Hand3D, timeaxis)
%  calcInterpolateHand3D interpolates the Hand3D data from Phasespace
%  as loaded by trialHand3D and returns interpolated data on the time axis
%  specifid
%
%  InterpHand3D = calcInterpolateHand3D(Hand3D, timeaxis)
%
%   Inputs: Hand3D      =  4D (time,x,y,z) data or a cell array of such
%                           data
%           Timeaxis    =  Time points of sampling
%
%   Outputs: InterpHand3D = (x,y,z) data at interpolated time points.
%                           [Trial,x,time];
%

if iscell(Hand3D)
    InterpHand3D = zeros(length(Hand3D),size(Hand3D{1},1)-1,length(timeaxis));
    for iTrial = 1:length(Hand3D)
        Hand3D_trial = Hand3D{iTrial};
        for iAxis = 1:size(Hand3D_trial,1)-1
            InterpHand3D(iTrial,iAxis,:) = csapi(Hand3D_trial(1,:),Hand3D_trial(iAxis+1,:),timeaxis);
        end
    end
else
    InterpHand3D = zeros(size(Hand3D,1)-1,length(timeaxis));
    for iAxis = 1:size(Hand3D,1)-1
        InterpHand3D(iAxis,:) = csapi(Hand3D(1,:),Hand3D(iAxis+1,:),timeaxis);
    end
end
