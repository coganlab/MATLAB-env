function updateField_NumTrialsConds(SessNum)
%
%   updateField_NumTrialsConds(SessNum)
%
%   Adds NumTrialsConds data structure to the Field_NumTrialsConds file
%
%   Modified to accept sessnum list

if nargin == 0
  updateType_NumTrialsConds('Field');
else
  updateType_NumTrialsConds('Field',SessNum);
end
