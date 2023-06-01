function Session = SFtoS(InputSession)
%
%   Session = SFtoS(InputSession)
%

ProjectDir = sessProjectDir(InputSession);

Session = loadSpike_Database(ProjectDir);
Session = Session{InputSession{6}(1)};




