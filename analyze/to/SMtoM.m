function Session = SMtoM(InputSession)
%
%   Session = SMtoM(InputSession)
%

ProjectDir = sessProjectDir(InputSession);

Session = loadMultiunit_Database(ProjectDir);
Session = Session{InputSession{6}(2)};




