function updateMultiunitField_NumTrialsConds(SessNum)
%
%   updateMultiunitField_NumTrialsConds(SessNum)
%
%   Adds NumTrialsConds data structure to the MultiunitField_NumTrialsConds file
%
%   Modified to accept sessnum list

if nargin == 0
  updateType_NumTrialsConds('MultiunitField');
else
  updateType_NumTrialsConds('MultiunitField',SessNum);
end
