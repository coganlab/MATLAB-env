function Session = MFtoF(InputSession)
%
%   Session = MFtoF(InputSession)
%

ProjectDir = sessProjectDir(InputSession);

Session = loadField_Database(ProjectDir);
Session = Session{InputSession{6}(2)};




