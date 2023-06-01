function Session = SMFtoS(InputSession)
%
%   Session = SMFtoS(InputSession)
%


Session = loadSpike_Database;
Session = Session{InputSession{6}(1)};




