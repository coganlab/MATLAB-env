function updateFieldField_NumTrialsConds(SessNum)
%
%   updateFieldField_NumTrialsConds(SessNum)
%
%   Adds NumTrialsConds data structure to the FieldField_NumTrialsConds file
%
%   Modified to accept sessnum list

if nargin == 0
  updateType_NumTrialsConds('FieldField');
else
  updateType_NumTrialsConds('FieldField',SessNum);
end
