function updateMultiunit_NumTrialsConds(SessNum)
%
%   updateMultiunit_NumTrialsConds(SessNum)
%
%   Adds NumTrialsConds data structure to the Multiunit_NumTrialsConds file
%
%   Modified to accept sessnum list

if nargin == 0
  updateType_NumTrialsConds('Multiunit');
else
  updateType_NumTrialsConds('Multiunit',SessNum);
end
