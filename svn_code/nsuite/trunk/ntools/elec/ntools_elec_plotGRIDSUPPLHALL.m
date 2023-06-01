function ntools_elec_plotGRIDSUPPRHALL(varargin)

% a stand-alone program that shows ieeg electrodes on the pial surface and
% save the images into textfile folder/images/. Default saving name is
% PatientID(NYxx)_space_elecLabel_viewpoint_hemisphere.png
% 
% space could be T1 or MNI
% elecLabel could be grid, strip, depth, or grid and strip
% viewpoint could be left, right, top, below, back or front
% hemisphere could be lh, rh, or both
% 
% requires:
% elec_text: text file with xyz electrode coordinates
% pial_mat: matlab structure with pial surface
%
% Usage: run ntools_elec_plot in command window
% the gui is prompted out for file selection
% or: ntools_elec_plot(textfilename, lh.mat, rh.mat)
%       ntools_elec_plot(textfilename, l(r)h.mat);
%
% also see: http://ieeg.pbworks.com/Viewing-Electrode-Locations
%
% written by  Hugh Wang, wangxiuyuan85@gmail.com, May 13, 2009

% modified on May 14, 2009 by Hugh
% make judgement on the input file type and not sensitive to the order of 
% input variable. add the option to show the electrodes' labels or not.

% modified on July 22nd, 2009 by Hugh
% for subjects who has electrodes on both hemisphere, loading the both
% pial.mat file will generate the image with whole brain and save the
% images from 6 views (left, right, top, below, back & front)

% modified on Aug 8th, 2009 by Hugh
% show only lh(rh)'s electrodes if choose lh(rh)_surf.mat

% modified on Jan 28th, 2010 by Hugh
% default saving name

%% Get the elec info
% if nargin==0
%     [FileName,PathName] = uigetfile('*.txt','Select the electrodes text file','/home/ccarlson/loc/');
%     [surfname, surfpath] = uigetfile('*.mat','Select the patient brain surf',PathName,'MultiSelect','on');
%     surf = strcat(surfpath,surfname);      
% elseif nargin==2
%     aa = findstr(varargin{1},'/');
%     FileName = varargin{1}(aa(end)+1:end);
%     PathName = varargin{1}(1:aa(end));
%     surf = varargin{2};  
% elseif nargin==3
%     aa = findstr(varargin{1},'/');
%     FileName = varargin{1}(aa(end)+1:end);
%     PathName = varargin{1}(1:aa(end));
%     surf = varargin(2:3);
% elseif nargin>3
%     disp('not correct input');
%     return;
% end

% fid = fopen([PathName, FileName]);
% elec_all = textscan(fid,'%s %f %f %f %s');
% elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];

%% Get the filename info
% b = findstr(FileName,'_');
% Pname = FileName(1:b(1)-1);
% 
% if ~isempty(findstr(upper(FileName),'T1'))
%     space = '_T1_';
% elseif ~isempty(findstr(upper(FileName),'MNI'))
%     space = '_MNI_';
% else
%     space = '_';
% end
% 
% if length(surf)==2
%     sph = 'both';
% else
%     sph = regexp(surf,'[r,l]h','match');
%     sph = char(sph{:});
% end

%% Separate Grid, Strip and Depth electrodes
% if strcmp(sph,'lh')
%     c = find(cell2mat(elec_cell(:,2))>0);
% elseif strcmp(sph,'rh')
%     c = find(cell2mat(elec_cell(:,2))<0);
% elseif strcmp(sph,'both')
%     c = [];
% end
% elec_cell(c,:) = [];

% if isempty(char(elec_all{5}(:)))
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


%% Plot the elecs
% plt = menu('What part do you want to plot?','Grid only', 'Strip only','Depth Only','Both Grid and Strip');
% labelshow = menu('Do you want to show the label?','Yes','No');
% genimg = menu('Do you want to save the images?','Yes', 'No');
sph='lh';
 surf = '/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/LHSUBJ_130724/loc/LH.AVG.lh.pial.mat';


% if strcmp(sph,'both')
%     surf_brain.sph1 = load(surf{1});
%     surf_brain.sph2 = load(surf{2});
% else 
    surf_brain = load(surf);
%end

elec2=zeros(1,3);
% NY212
PathName='/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/';
FileName='NY212/loc/NY212_coor_T1_021210.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/NY212/mri/transforms/talairach.xfm'];
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
    TalairachXFM = fscanf(fid,'%f',[4,3])';
    TalairachXFM(4,:)=[0 0 0 1];
    fclose(fid);
else
    fclose(fid);
    error('fail2')
end

[elecT newtalTAL]=freesurfer_surf2tal(elecT,TalairachXFM);

elecT(:,1)=elecT(:,1)-25;
elec2=cat(1,elec2,elecT);

% NY226
PathName='/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/';
FileName='NY226/loc/NY226_coor_T1_121409.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/NY226/mri/transforms/talairach.xfm'];
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
    TalairachXFM = fscanf(fid,'%f',[4,3])';
    TalairachXFM(4,:)=[0 0 0 1];
    fclose(fid);
else
    fclose(fid);
    error('fail2')
end

[elecT newtalTAL]=freesurfer_surf2tal(elecT,TalairachXFM);

elecT(:,1)=elecT(:,1)-25;
elec2=cat(1,elec2,elecT);
% 
% NY332
PathName='/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/';
FileName='NY332/loc/locNY332_coor_T1_031113.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/NY332/mri/transforms/talairach.xfm'];
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
    TalairachXFM = fscanf(fid,'%f',[4,3])';
    TalairachXFM(4,:)=[0 0 0 1];
    fclose(fid);
else
    fclose(fid);
    error('fail2')
end

[elecT newtalTAL]=freesurfer_surf2tal(elecT,TalairachXFM);

elecT(:,1)=elecT(:,1)-25;
elec2=cat(1,elec2,elecT);

% NY347
PathName='/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/';
FileName='NY347v4/NY347v4NY347v4_coor_T1_031813.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/NY347/mri/transforms/talairach.xfm'];
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
    TalairachXFM = fscanf(fid,'%f',[4,3])';
    TalairachXFM(4,:)=[0 0 0 1];
    fclose(fid);
else
    fclose(fid);
    error('fail2')
end

[elecT newtalTAL]=freesurfer_surf2tal(elecT,TalairachXFM);

elecT(:,1)=elecT(:,1)-25;
elecT(:,2)=elecT(:,2)+10;
elecT(:,3)=elecT(:,3)+10;
elec2=cat(1,elec2,elecT);

% 
% NY351
PathName='/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/';
FileName='NY351/loc/locNY351_coor_T1_031013.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/NY351/mri/transforms/talairach.xfm'];
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
    TalairachXFM = fscanf(fid,'%f',[4,3])';
    TalairachXFM(4,:)=[0 0 0 1];
    fclose(fid);
else
    fclose(fid);
    error('fail2')
end

[elecT newtalTAL]=freesurfer_surf2tal(elecT,TalairachXFM);

elecT(:,1)=elecT(:,1)-25;
elec2=cat(1,elec2,elecT);
% 
% 
% 
% NY329
PathName='/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/';
FileName='NY329/loc/NY329_T1_lh.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
%g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(1:42,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/NY329/mri/transforms/talairach.xfm'];
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
    TalairachXFM = fscanf(fid,'%f',[4,3])';
    TalairachXFM(4,:)=[0 0 0 1];
    fclose(fid);
else
    fclose(fid);
    error('fail2')
end

[elecT newtalTAL]=freesurfer_surf2tal(elecT,TalairachXFM);

elecT(:,1)=elecT(:,1)-25;
  
elecT(:,2)=elecT(:,2)+20;
elecT(:,3)=elecT(:,3)+35;
elec2=cat(1,elec2,elecT);


% 
% 
% NY334
PathName='/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/';
FileName='NY334/loc/NY334_T1_lh.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
%g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(1:75,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/NY334/mri/transforms/talairach.xfm'];
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
    TalairachXFM = fscanf(fid,'%f',[4,3])';
    TalairachXFM(4,:)=[0 0 0 1];
    fclose(fid);
else
    fclose(fid);
    error('fail2')
end

[elecT newtalTAL]=freesurfer_surf2tal(elecT,TalairachXFM);

elecT(:,1)=elecT(:,1)-25;
%elecT(:,2)=elecT(:,2)-13;
%elecT(:,3)=elecT(:,3)+33;
elec2=cat(1,elec2,elecT);

% NY273
PathName='/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/';
FileName='NY273/loc/NY273_fmri_070810_coor_T1_080310.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
%g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(1:64,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/NY273/mri/transforms/talairach.xfm'];
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
    TalairachXFM = fscanf(fid,'%f',[4,3])';
    TalairachXFM(4,:)=[0 0 0 1];
    fclose(fid);
else
    fclose(fid);
    error('fail2')
end

[elecT newtalTAL]=freesurfer_surf2tal(elecT,TalairachXFM);

elecT(:,1)=elecT(:,1)-25;
elec2=cat(1,elec2,elecT);

% 
% NY351
PathName='/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/';
FileName='NY339/loc/NY339_fmri_041712_coor_T1_2013-06-24.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/nim1_backup/nim1-raid-backup/NYUMC/NY351/mri/transforms/talairach.xfm'];
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
    TalairachXFM = fscanf(fid,'%f',[4,3])';
    TalairachXFM(4,:)=[0 0 0 1];
    fclose(fid);
else
    fclose(fid);
    error('fail2')
end

[elecT newtalTAL]=freesurfer_surf2tal(elecT,TalairachXFM);

elecT(:,1)=elecT(:,1)-25;
elecT(97:128,3)=elecT(97:128,3)-15;
elecT(97:128,2)=elecT(97:128,2)-20;
elec2=cat(1,elec2,elecT);
% 
% 
% 





elec2=elec2(2:end,:);

nyu_plot(surf_brain,sph,elec2,[],'w',[]);


end
%% nyu_plot
function nyu_plot(surf_brain,sph,elec,elecname,color,label,alpha,marksize)

if ~exist('color','var')
    color = 'w';
end
if ~exist('label','var')
    label = 2;
end
if ~exist('alpha','var')
    alpha = 1;
end
if ~exist('marksize','var')
   %marksize = 11.3;
   marksize=60;
end

figure;

col = [.7 .7 .7];
if strcmp(sph,'both')
    sub_sph1.vert = surf_brain.sph1.coords;
    sub_sph1.tri = surf_brain.sph1.faces;

    sub_sph2.vert = surf_brain.sph2.coords;
    sub_sph2.tri = surf_brain.sph2.faces;
    
    col1=repmat(col(:)', [size(sub_sph1.vert, 1) 1]);
    col2=repmat(col(:)', [size(sub_sph2.vert, 1) 1]);
    
    trisurf(sub_sph1.tri, sub_sph1.vert(:, 1), sub_sph1.vert(:, 2),sub_sph1.vert(:, 3),...
        'FaceVertexCData', col1,'FaceColor', 'interp','FaceAlpha',alpha);
    hold on;
    trisurf(sub_sph2.tri, sub_sph2.vert(:, 1), sub_sph2.vert(:, 2), sub_sph2.vert(:, 3),...
        'FaceVertexCData', col2,'FaceColor', 'interp','FaceAlpha',alpha);
else    
    if isfield(surf_brain,'coords')==0
        sub.vert = surf_brain.surf_brain.coords;
        sub.tri = surf_brain.surf_brain.faces;
    else
        sub.vert = surf_brain.coords;
        sub.tri = surf_brain.faces;
    end
    col=repmat(col(:)', [size(sub.vert, 1) 1]);
    trisurf(sub.tri, sub.vert(:, 1), sub.vert(:, 2), sub.vert(:, 3),...
        'FaceVertexCData', col,'FaceColor', 'interp','FaceAlpha',alpha);
end

shading interp;
lighting gouraud;
material dull;
light;
axis off
hold on;
for i=1:length(elec)
    %if i==65 % AUD
        %plot3(elec(i,1),elec(i,2),elec(i,3),['g' 'o'],'MarkerFaceColor','g','MarkerSize',marksize);
    %elseif i==51 || i==52 || i==57 || i==58 || i==59 || i==60 || i==61  % PROD
          %plot3(elec(i,1),elec(i,2),elec(i,3),'o','MarkerEdgeColor',[0.1 0.1 1],'MarkerFaceColor',[0.1 0.1 1],'MarkerSize',marksize);
    %elseif i==47 || i==50  % SM and Aud
                  %plot3(elec(i,1),elec(i,2),elec(i,3),['g' 'o'],'MarkerFaceColor','r','MarkerSize',marksize,'LineWidth',7);
          %plot3(elec(i,1),elec(i,2),elec(i,3),['r' 'o'],'MarkerFaceColor','r','MarkerSize',marksize);
    %else
    %plot3(elec(i,1),elec(i,2),elec(i,3),[color 'o'],'MarkerFaceColor',color,'MarkerSize',marksize);
                plot3(elec(i,1),elec(i,2),elec(i,3),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',30);

   % end
%     if label==1
%         text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elecname(i,:),'Color','w');
%     end
end
set(light,'Position',[-1 0 1]); 
    if strcmp(sph,'lh')
        view(270, 0);      
    elseif strcmp(sph,'rh')
        view(90,0);        
    elseif strcmp(sph,'both')
        view(90,90);
    end
%set(gcf, 'color','black','InvertHardCopy', 'off');
set(gcf, 'color','white','InvertHardCopy', 'off');
axis tight;
axis equal;
fclose('all');
end