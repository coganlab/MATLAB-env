function Session = SFFtoS(InputSession)
%
%   Session = SFFtoS(InputSession)
%

ProjectDir = sessProjectDir(InputSession);

Session = loadSpike_Database(ProjectDir);
Session = Session{InputSession{6}(1)};




