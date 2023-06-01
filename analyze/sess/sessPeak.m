function Peak = sessPeak(Session)
%
%   Peak = sessPeak(Session)
%

Type = sessType(Session)
switch Type
  case {'Multiunit')
    Peak = Session{5}{1}[3];
  otherwise
    error('Session is not Multiunit Session');
end
