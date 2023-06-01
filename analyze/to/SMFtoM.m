function Session = SMFtoM(InputSession)
%
%   Session = SMFtoM(InputSession)
%


ProjectDir = sessProjectDir(InputSession);

Session = loadMultiunit_Database(ProjectDir);
Session = Session{InputSession{6}(2)};




