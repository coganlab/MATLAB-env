function procLowPassEye(day,rec)
%
%
%

global MONKEYDIR MONKEYNAME

olddir = pwd;
recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif isstr(rec) 
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1 
    num = [rec,rec];
else
    num = rec;
end


for iRec = num(1):num(2)
    rec = recs{iRec};
    disp(['Lowpass filtering ' day ':' rec]);
    
    cd([MONKEYDIR '/' day '/' rec]);
    load(['rec' rec '.Rec.mat']);
    if isfield(Rec,'BinaryDataFormat')
      format = Rec.BinaryDataFormat;
    else
      format = 'short';
    end
    fid = fopen(['rec' rec '.eye.dat']);
    data = fread(fid,[2,inf],format);
    fclose(fid);
    y = mtfilter(data,[0.05,50],1e3,0,0);
    y(1,1:50) = y(1,50); y(2,1:50) = y(2,50);
    y(1,:) = y(1,:)-mean(y(1,:))+mean(data(1,:));
    y(2,:) = y(2,:)-mean(y(2,:))+mean(data(2,:));
    
    fid = fopen(['rec' rec '.lp.eye.dat'],'w');
    fwrite(fid,y,'short');
    fclose(fid);
end
cd(olddir);
