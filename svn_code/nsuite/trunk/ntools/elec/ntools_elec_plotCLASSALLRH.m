function ntools_elec_plotCLASSALLRH(varargin)

% load LHidx
load('/mnt/raid/NYUMC/LHRHidxALLELECS.mat');
% load classifier data
load('/mnt/raid/NYUMC/classifier/Data/Allway_ClassALLCHAN_AUD_EACHCHAN_5SVDS_1to200_OUT12_130619.mat')
testvals1=sq(mean(PmatrixFULL(:,:,:,1:26),4));
for iChan=1:size(testvals1,1);
    testvals2(iChan)=mean(diag(sq(testvals1(iChan,:,:))));
end

testvals3=testvals2(RHidx);

% Plot the elecs
% plt = menu('What part do you want to plot?','Grid only', 'Strip only','Depth Only','Both Grid and Strip');
% labelshow = menu('Do you want to show the label?','Yes','No');
% genimg = menu('Do you want to save the images?','Yes', 'No');
sph='lh';
 surf = '/mnt/raid/NYUMC/RHSUBJ_130316/loc/RH.AVG.rh.pial.mat';


% if strcmp(sph,'both')
%     surf_brain.sph1 = load(surf{1});
%     surf_brain.sph2 = load(surf{2});
% else 
    surf_brain = load(surf);
%end



% 212, 64
% 226 % 64
% 273 78
% 149  64
% 192 64
% 313 64
% 311 64
% 255v2 53
% 329 83
% 332 110
% 346 46
% 347 47
% 359 32
% 351 38

elec2=zeros(1,3);

% NY273
PathName='/mnt/raid/NYUMC/';
FileName='NY273/loc/NY273_fmri_070810_coor_T1_080310.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
%g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell([113:122,131,132,161,162],:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/NYUMC/NY273/mri/transforms/talairach.xfm'];
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

elecT(:,1)=elecT(:,1)+25;
elec2=cat(1,elec2,elecT);


% NY149
PathName='/mnt/raid/NYUMC/';
FileName='NY149/loc/NY149_coor_T1_.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/NYUMC/NY149/mri/transforms/talairach.xfm'];
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

elecT(:,1)=elecT(:,1)+25;
elec2=cat(1,elec2,elecT);

% NY192
PathName='/mnt/raid/NYUMC/';
FileName='NY192/loc/NY192_coor_T1_102209_GBC.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/NYUMC/NY192/mri/transforms/talairach.xfm'];
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
elecT(:,1)=elecT(:,1)+25;
elec2=cat(1,elec2,elecT);
% 
% NY311
PathName='/mnt/raid/NYUMC/';
FileName='NY311/loc/NY311_fmri_032811_coor_T1_042211.txt';
fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));

filename=['/mnt/raid/NYUMC/NY311/mri/transforms/talairach.xfm'];
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

elecT(:,1)=elecT(:,1)+25;
elec2=cat(1,elec2,elecT);

% NY313
PathName='/mnt/raid/NYUMC/';
FileName='NY313/loc/NY313_fmri_050511_coor_T1_052411.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/NYUMC/NY313/mri/transforms/talairach.xfm'];
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

elecT(:,1)=elecT(:,1)+25;
%elecT(:,3)=elecT(:,3)+20;
%elecT(:,2)=elecT(:,2)
elec2=cat(1,elec2,elecT);

% NY255v2
PathName='/mnt/raid/NYUMC/';
FileName='NY255v2/loc/locNY255v2_coor_T1_031113.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elec_grid = elec_grid(setdiff(1:64,[1,2,16,27,33,34,35,50:53]),:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/NYUMC/NY255v2/mri/transforms/talairach.xfm'];
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

elecT(:,1)=elecT(:,1)+25;
elec2=cat(1,elec2,elecT);
% 

% NY329
PathName='/mnt/raid/NYUMC/';
FileName='NY329/loc/NY329_rh_T1.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
%g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(1:42,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/NYUMC/NY329/mri/transforms/talairach.xfm'];
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

elecT(:,1)=elecT(:,1)+25;
elecT(:,2)=elecT(:,2)+10;
elecT(:,3)=elecT(:,3)+25;
elec2=cat(1,elec2,elecT);



% 
% NY346
PathName='/mnt/raid/NYUMC/';
FileName='NY346/loc/NY346_fmri_071212_coor_T1_130204_GBC_2.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elec_grid = elec_grid(setdiff(1:64,[1,7:11,16:19,25,26,55,56,61:64]),:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/NYUMC/NY346/mri/transforms/talairach.xfm'];
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

elecT(:,1)=elecT(:,1)+25;
elec2=cat(1,elec2,elecT);
% 
% NY359
PathName='/mnt/raid/NYUMC/';
FileName='NY359/loc/locNY359_coor_T1_031913.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elec_grid = elec_grid([1,2,5,6,11,12,15,16,17,18,21,22,27,28,31,32,33,34,37,38,43,44,47,48,49,50,53,54,59,60,63,64],:);
elecT=cell2mat(elec_grid(:,2:4));
filename=['/mnt/raid/NYUMC/NY359/mri/transforms/talairach.xfm'];
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


elecT(:,1)=elecT(:,1)+25;
elecT(:,3)=elecT(:,3)+35;
 
elec2=cat(1,elec2,elecT);
% 


elec2=elec2(2:end,:);


[testvals4 idxvals4]=sort(testvals3,'descend');

elec2(idxvals4(1:20),1)=elec2(idxvals4(1:20),1)+40; % move highest 20 vals to top

nyu_plot(surf_brain,sph,elec2,[],'w',[],1,20,testvals3);


end
%% nyu_plot
function nyu_plot(surf_brain,sph,elec,elecname,color,label,alpha,marksize,testvals3)

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

% set color parameters
%cmap=colormap('jet');
load('/mnt/raid/NYUMC/JetColorMap.mat')
cscale1=[0.1:0.00315:0.3];
%cscale1=[0.15:0.00235:0.3];
%cscale1=[0:0.0047:0.29999];
%cscale1=[0.05:0.004:0.3];
%cscale1=cscale1(1:64);

colorvals=zeros(length(testvals3),3);
for iC=1:64;
    if iC==1
        idx=find(testvals3<cscale1(iC));
        
    elseif iC==64
        idx=find(testvals3>cscale1(iC));
    else
        idx=find(testvals3>=cscale1(iC-1) & testvals3<cscale1(iC));
    end
    if exist('idx')
    colorvals(idx,:)=repmat(cmap(iC,:),length(idx),1);
    end
end
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
                plot3(elec(i,1),elec(i,2),elec(i,3),'o','MarkerEdgeColor',colorvals(i,:),'MarkerFaceColor',colorvals(i,:),'MarkerSize',marksize);

   % end
%     if label==1
%         text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elecname(i,:),'Color','w');
%     end
end
set(light,'Position',[-1 0 1]); 
   % if strcmp(sph,'lh')
     %   view(270, 0);      
   % elseif strcmp(sph,'rh')
        view(90,0);        
   % elseif strcmp(sph,'both')
     %   view(90,90);
   % end
set(gcf, 'color','black','InvertHardCopy', 'off');
axis tight;
axis equal;
fclose('all');
end