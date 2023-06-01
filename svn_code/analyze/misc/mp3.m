%  Program to rename directories of raw .au data and .hyd data

DirName='lmem34';
Files=dir;

Files=Files(3:end);
nloop=length(Files);

for i=1:nloop
tmp=Files(i).name;
if length(tmp) > 3 
  if strmatch(tmp(4:5),'au') 
  cmd=['mv ' tmp ' ' DirName tmp(1:3) 'raw.au']
  unix(cmd);
  end
end
if length(tmp) > 3
  if strmatch(tmp(1:2),'me') 
  cmd=['mv ' tmp ' ' DirName tmp(9:10) '.hyd']
  unix(cmd);
  end
end
end



Files=dir;
Files=Files(3:end);
nloop=length(Files);

for i=1:nloop
FileName=Files(i).name
  if strmatch(FileName(10:end),'raw.au') 
    lp200_filter(FileName(1:8)); 
  end
end


Files=dir;
Files=Files(3:end);
nloop=length(Files);
for i=1:nloop
FileName=Files(i).name;
  if strmatch(FileName(10:end),'raw.au')
    FileName(1:9)
    unix(['mkdir ../' FileName(1:9)]);
    unix(['mv ' FileName(1:9) '.* ../' FileName(1:9)]);
  end
end




