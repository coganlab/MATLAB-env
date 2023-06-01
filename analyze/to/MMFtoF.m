function Session = MMFtoF(InputSession)
%
%   Session = MMFtoF(InputSession)
%


Session = loadField_Database;
Session = Session{InputSession{6}(3)};




