function Session = MFtoM(InputSession)
%
%   Session = MFtoM(InputSession)
%

ProjectDir = sessProjectDir(InputSession);


Session = loadMultiunit_Database(ProjectDir);
Session = Session{InputSession{6}(1)};




