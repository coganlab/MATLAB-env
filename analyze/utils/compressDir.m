function compressDir(ProjectDir,DirType);
%
%  compressCDir(ProjectDir);
%

days = dir([ProjectDir '/1*']);

for iDay = 1:length(days)
  disp([ProjectDir '/' days(iDay).name]);
  cd([ProjectDir '/' days(iDay).name]);
  if exist(DirType,'file')
    unix(['tar -zcf ' DirType '.tgz ' DirType]);
    unix(['rm -rf ' DirType]);
  else
    disp([DirType ' not found']);
  end
end
