function Session = SMFtoF(InputSession)
%
%   Session = SMFtoF(InputSession)
%


Session = loadField_Database;
Session = Session{InputSession{6}(3)};




