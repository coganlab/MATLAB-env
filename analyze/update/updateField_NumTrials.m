function updateField_NumTrials(SessNum)
%
%   updateField_NumTrials(SessNum)
%
%   Adds NumTrials data structure to Field_Database Session file
%

if nargin == 0
  updateType_NumTrials('Field');
else
  updateType_NumTrials('Field',SessNum);
end



