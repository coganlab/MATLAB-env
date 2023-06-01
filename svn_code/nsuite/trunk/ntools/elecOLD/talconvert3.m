function TalairachXFM=talconvert3(hemi)
% NEW AVG attempt: takes actual average of Talairach coords from
% subjects, outputs coordinate transform only!
nyumc
if strcmp(hemi,'rh')
    
%filename=[NYUMCDIR '/' sub '/mri/transforms/talairach.xfm'];
filename=[NYUMCDIR '/NY149/mri/transforms/talairach.xfm'];
fid=fopen(filename,'r');
gotit = 0;
string2match='Linear_Transform';
for i=1:20
    temp=fgetl(fid);
    if strmatch(string2match,temp),
        gotit = 1;
        break;
    end
end
    
    if gotit,
    TXFM149 = fscanf(fid,'%f',[4,3])';
    TXFM149(4,:)=[0 0 0 1];
    fclose(fid);
    else
   fclose(fid);
   error('fail2')
    end

    %filename=[NYUMCDIR '/' sub '/mri/transforms/talairach.xfm'];
filename=[NYUMCDIR '/NY192/mri/transforms/talairach.xfm'];
fid=fopen(filename,'r');
gotit = 0;
string2match='Linear_Transform';
for i=1:20
    temp=fgetl(fid);
    if strmatch(string2match,temp),
        gotit = 1;
        break;
    end
end
    
    if gotit,
    TXFM192 = fscanf(fid,'%f',[4,3])';
    TXFM192(4,:)=[0 0 0 1];
    fclose(fid);
    else
   fclose(fid);
   error('fail2')
    end
    
        %filename=[NYUMCDIR '/' sub '/mri/transforms/talairach.xfm'];
filename=[NYUMCDIR '/NY273/mri/transforms/talairach.xfm'];
fid=fopen(filename,'r');
gotit = 0;
string2match='Linear_Transform';
for i=1:20
    temp=fgetl(fid);
    if strmatch(string2match,temp),
        gotit = 1;
        break;
    end
end
    
    if gotit,
    TXFM273 = fscanf(fid,'%f',[4,3])';
    TXFM273(4,:)=[0 0 0 1];
    fclose(fid);
    else
   fclose(fid);
   error('fail2')
    end
    
        %filename=[NYUMCDIR '/' sub '/mri/transforms/talairach.xfm'];
filename=[NYUMCDIR '/NY311/mri/transforms/talairach.xfm'];
fid=fopen(filename,'r');
gotit = 0;
string2match='Linear_Transform';
for i=1:20
    temp=fgetl(fid);
    if strmatch(string2match,temp),
        gotit = 1;
        break;
    end
end
    
    if gotit,
    TXFM311 = fscanf(fid,'%f',[4,3])';
    TXFM311(4,:)=[0 0 0 1];
    fclose(fid);
    else
   fclose(fid);
   error('fail2')
    end
    
        %filename=[NYUMCDIR '/' sub '/mri/transforms/talairach.xfm'];
filename=[NYUMCDIR '/NY311/mri/transforms/talairach.xfm'];
fid=fopen(filename,'r');
gotit = 0;
string2match='Linear_Transform';
for i=1:20
    temp=fgetl(fid);
    if strmatch(string2match,temp),
        gotit = 1;
        break;
    end
end
    
    if gotit,
    TXFM311 = fscanf(fid,'%f',[4,3])';
    TXFM311(4,:)=[0 0 0 1];
    fclose(fid);
    else
   fclose(fid);
   error('fail2')
    end
    
        %filename=[NYUMCDIR '/' sub '/mri/transforms/talairach.xfm'];
filename=[NYUMCDIR '/NY313/mri/transforms/talairach.xfm'];
fid=fopen(filename,'r');
gotit = 0;
string2match='Linear_Transform';
for i=1:20
    temp=fgetl(fid);
    if strmatch(string2match,temp),
        gotit = 1;
        break;
    end
end
    
    if gotit,
    TXFM313 = fscanf(fid,'%f',[4,3])';
    TXFM313(4,:)=[0 0 0 1];
    fclose(fid);
    else
   fclose(fid);
   error('fail2')
    end
    
    TalairachXFM=(TXFM149+TXFM192+TXFM273+TXFM311+TXFM313)./5;
    
elseif strcmp(hemi,'lh')
    
        %filename=[NYUMCDIR '/' sub '/mri/transforms/talairach.xfm'];
filename=[NYUMCDIR '/NY212/mri/transforms/talairach.xfm'];
fid=fopen(filename,'r');
gotit = 0;
string2match='Linear_Transform';
for i=1:20
    temp=fgetl(fid);
    if strmatch(string2match,temp),
        gotit = 1;
        break;
    end
end
    
    if gotit,
    TXFM212 = fscanf(fid,'%f',[4,3])';
    TXFM212(4,:)=[0 0 0 1];
    fclose(fid);
    else
   fclose(fid);
   error('fail2')
    end
    
        %filename=[NYUMCDIR '/' sub '/mri/transforms/talairach.xfm'];
filename=[NYUMCDIR '/NY226/mri/transforms/talairach.xfm'];
fid=fopen(filename,'r');
gotit = 0;
string2match='Linear_Transform';
for i=1:20
    temp=fgetl(fid);
    if strmatch(string2match,temp),
        gotit = 1;
        break;
    end
end
    
    if gotit,
    TXFM226 = fscanf(fid,'%f',[4,3])';
    TXFM226(4,:)=[0 0 0 1];
    fclose(fid);
    else
   fclose(fid);
   error('fail2')
    end
    
        %filename=[NYUMCDIR '/' sub '/mri/transforms/talairach.xfm'];
filename=[NYUMCDIR '/NY273/mri/transforms/talairach.xfm'];
fid=fopen(filename,'r');
gotit = 0;
string2match='Linear_Transform';
for i=1:20
    temp=fgetl(fid);
    if strmatch(string2match,temp),
        gotit = 1;
        break;
    end
end
    
    if gotit,
    TXFM273 = fscanf(fid,'%f',[4,3])';
    TXFM273(4,:)=[0 0 0 1];
    fclose(fid);
    else
   fclose(fid);
   error('fail2')
    end
    
    TalairachXFM=(TXFM212+TXFM226+TXFM273)./3;
end
%     %  read coordinates
%     filename2dir=[NYUMCDIR '/' sub '/loc/'];
%     filename2dir2=dir([filename2dir '/*_T1_*.txt']);
%     fid = fopen([filename2dir filename2dir2.name]);
%     elec_all = textscan(fid,'%s %f %f %f %s');
%     elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
%     
%     if isempty(char(elec_all{5}(:)))
%     g = strmatch('G',upper(elec_cell(:,1)));
%     d = strmatch('D',upper(elec_cell(:,1)));
% else
%     g = strmatch('G',upper(elec_all{5}));
%     d = strmatch('D',upper(elec_all{5}));
% end
% 
% if ~isempty(g) && ~isempty(d)
%     elec_grid = elec_cell(g,:);
%     elec_depth = elec_cell(d,:);
%     elec_cell([g;d],:) = [];    
% elseif isempty(d)
%     elec_depth = [];
%     elec_grid = elec_cell(g,:);
%     elec_cell(g,:) = [];
% elseif isempty(g)
%     elec_grid = [];
%     elec_depth = elec_cell(d,:);
%     elec_cell(d,:) = [];
% end
% 
% elec_grid=elec_grid(:,2:4);
% elec_grid=cell2num(elec_grid);
% elec_grid=cat(2,elec_grid,ones(64,1));

%newtal2=inv(TalairachXFM)*newtal;


