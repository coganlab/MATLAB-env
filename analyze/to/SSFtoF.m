function Session = SSFtoF(InputSession)
%
%   Session = SSFtoF(InputSession)
%


Session = loadField_Database;
Session = Session{InputSession{6}(3)};




