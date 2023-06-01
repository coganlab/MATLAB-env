function Session = MFFtoM(InputSession)
%
%   Session = MFFtoM(InputSession)
%

ProjectDir = sessProjectDir(InputSession);


Session = loadMultiunit_Database(ProjectDir);
Session = Session{InputSession{6}(1)};




