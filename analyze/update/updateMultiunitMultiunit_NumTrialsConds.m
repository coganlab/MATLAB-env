function updateMultiunitMultiunit_NumTrialsConds(SessNum)
%
%   updateMultiunitMultiunit_NumTrialsConds(SessNum)
%
%   Adds NumTrialsConds data structure to the MultiunitMultiunit_NumTrialsConds file
%
%   Modified to accept sessnum list

if nargin == 0
  updateType_NumTrialsConds('MultiunitMultiunit');
else
  updateType_NumTrialsConds('MultiunitMultiunit',SessNum);
end
