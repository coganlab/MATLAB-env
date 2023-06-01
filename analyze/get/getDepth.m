function Depth = getDepth(Trials,sys,ch)
%   Returns depth for trials
%
%   Depth = getDepth(Trials,sys,ch)
%
%   Inputs:     Trials
%               Sys     = Scalar.  System number.
%               Ch      = Scalar.  Channel number.
%               
%   Outputs:    Depth = Depths (Trial,Ch,Sys)
%

disp('Inside getDepth')
if(nargin < 4)
    depth_flag = 0;
end

nTrials = length(Trials);
[Depth{1:nTrials}] = deal(Trials.Depth);
nTower = length(Depth{1});
NSYS = length(Trials(1).Ch);
NCH = Trials(1).Ch;

DepthTowerandTrial = cell2num(Depth);

if sum(diff(NCH))==0
  NCH = Trials(1).Ch(1);
  % All systems have same number of electrodes
  %  Depth output is array.
  DTowerandTrialandElectrode = cell2num(DepthTowerandTrial);
  %  Check old system or new system
  if NSYS == nTower  %  New Depth cell array
    Depth = reshape(DTowerandTrialandElectrode,[nTrials,NSYS,NCH]);
    Depth = permute(Depth,[1,3,2]);
  else
    Depth = reshape(DTowerandTrialandElectrode,[nTrials,NCH,NSYS]);
  end
  if nargin > 1
    Depth = Depth(:,ch,sys);
  end
else
  % Systems have different numbers of electrodes - NOT DEBUGGED
  %  Depth output is cell array unless request sys or ch.

  if NCH(1) == 24 && NCH(2) == 4 %Heather's multicontact experiments
      pause
%       NCH(1) = 4;
%       D2 = DepthTowerandTrial(1:length(Trials));
%       DepthTowerandTrial = [D2 D2 D2 DepthTowerandTrial];
  end
  
  Depth = reshape(DepthTowerandTrial,[nTrials,NSYS]);
  if nargin > 1
	  Depth = Depth(:,sys);
	  if nargin > 2
		  Depth = cell2num(Depth);
		  Depth = reshape(Depth,[nTrial,NCH(sys)]);
		  Depth = Depth(:,ch);
	  end
  end
  
  if iscell(Depth)
      [a b] = size(Depth);
      towerChannels = zeros(1,b);
      for iTow = 1:b
          towerChannels(iTow) = size(Depth{1,iTow},2);
      end
      
      maxCh = max(towerChannels);
      
      DTest = zeros(a, maxCh, b);
      
      for iTow = 1:b
          nCh = towerChannels(iTow);
          for iRow = 1:a
              depthData = Depth{iRow,iTow};
              DTest(iRow, :, iTow) = depthData;
          end
      end
      Depth = DTest;
  end
end


