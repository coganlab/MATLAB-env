function SessionNumberString = saveSessionNumberStringHelper(Session)
%
%  SessionNumberString = saveSessionNumberStringHelper(Session)
%


SessionType = getSessionType(Session);

SessionNumberString = '';
switch SessionType
  case 'Spike'
    SessionNumberString = num2str(Session{6}(1));
  case 'Field'
    SessionNumberString = num2str(Session{6}(1));
  case 'SpikeField'
    SessionNumberString = [num2str(Session{6}(1)) '_' num2str(Session{6}(2))];
  case 'FieldField'
    SessionNumberString = [num2str(Session{6}(1)) '_' num2str(Session{6}(2))];
  case 'SpikeSpike'
    SessionNumberString = [num2str(Session{6}(1)) '_' num2str(Session{6}(2))];
  case 'Multiunit'
    SessionNumberString = num2str(Session{6}(1));
end