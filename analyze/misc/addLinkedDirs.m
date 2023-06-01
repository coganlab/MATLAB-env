function addLinkedDirs(targetpath,sourcepath,dirprefix)
%  Creates links in the targetpath to the directories with prefixes in the sourcepath.
%
%  addLinkedDirs(TARGETPATH, SOURCEPATH, DIRPREFIX)
%
%  Inputs:  TARGETPATH = String.  Complete path where links should go.
%				eg '/mnt/raid/monkey';
%	    SOURCEPATH = String.  Complete path for directory where links should point.
%				eg '/mnt/y7/raid/monkey'
%	    DIRPREFIX = String.  Stub for directories to link to.  Accepts wildcards
%				eg '1220*'

Dirs = dir([sourcepath '/' dirprefix]);

olddir = pwd;
cd(targetpath);

for iDir = 1:length(Dirs)
  if ~isdir([targetpath '/' Dirs(iDir).name])
    cmd = ['ln -s ' sourcepath '/' Dirs(iDir).name ];
    disp(cmd);
    unix(cmd);
  else
    disp([sourcepath '/' Dirs(iDir).name ' already exists']);
  end
end

cd(olddir);
