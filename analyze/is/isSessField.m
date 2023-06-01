function flag = isSessField(Session)
%
%  flag = isSessField(Session)
%

if iscell(Session{5})
  flag = 1;
else 
  flag = 0;
end
