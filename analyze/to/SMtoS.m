function Session = SMtoS(InputSession)
%
%   Session = SFtoS(InputSession)
%


Session = loadSpike_Database;
Session = Session{InputSession{6}(1)};




