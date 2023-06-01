function ntools_elec_plotCLASSALLLH_VOWEL(varargin)
for iV=1:7
  
nyumc;

% load LHidx
load([NYUMCDIR '/LHRHidxALLELECS.mat']);
% load classifier data
load([NYUMCDIR '/classifier/Data/Allway_ClassALLCHAN_PROD_EACHCHAN_5SVDS_1to200_OUT12_130619.mat'])
testvals1=sq(mean(PmatrixFULL(:,:,:,1:72),4));
% for iChan=1:size(testvals1,1);
%     testvals2(iChan)=mean(diag(sq(testvals1(iChan,:,:))));
% end
testvals2=sq(testvals1(:,iV,iV));
testvals3=testvals2(LHidx);

% Plot the elecs
% plt = menu('What part do you want to plot?','Grid only', 'Strip only','Depth Only','Both Grid and Strip');
% labelshow = menu('Do you want to show the label?','Yes','No');
% genimg = menu('Do you want to save the images?','Yes', 'No');
sph='lh';
 surf = [NYUMCDIR '/LHSUBJ_130316/loc/LH.AVG.lh.pial.mat'];


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
% NY212
PathName=NYUMCDIR;
FileName='/NY212/loc/NY212_coor_T1_021210.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
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
PathName=NYUMCDIR;
FileName='/NY226/loc/NY226_coor_T1_121409.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
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

% NY273
PathName=NYUMCDIR;
FileName='/NY273/loc/NY273_fmri_070810_coor_T1_080310.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
%g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(1:64,:);
elecT=cell2mat(elec_grid(:,2:4));
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
% NY329
PathName=NYUMCDIR;
FileName='/NY329/loc/NY329_T1_lh.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
%g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(1:41,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=[NYUMCDIR '/NY329/mri/transforms/talairach.xfm'];
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
% 
% NY332
PathName=NYUMCDIR;
FileName='/NY332/loc/locNY332_coor_T1_031113.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
filename=[NYUMCDIR '/NY332/mri/transforms/talairach.xfm'];
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
PathName=NYUMCDIR;
FileName='/NY347v4/NY347v4NY347v4_coor_T1_031813.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elec_grid = elec_grid(setdiff(1:64,[3,4,7,8,9,10,13,14,19,20,25,26,51,52,61,62]),:);
elec_grid = elec_grid([1:2,3:end],:);
elecT=cell2mat(elec_grid(:,2:4));
filename=[NYUMCDIR '/NY347/mri/transforms/talairach.xfm'];
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

% 
% NY351
PathName=NYUMCDIR;
FileName='//NY351/loc/locNY351_coor_T1_031013.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elec_grid=elec_grid(setdiff(1:64,[3,4,7-10,13,14,19,20,23,24,29,30,57,58,61,62]),:);
elec_grid=elec_grid([1:34,40:42,45],:);
elecT=cell2mat(elec_grid(:,2:4));
filename=[NYUMCDIR '/NY351/mri/transforms/talairach.xfm'];
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

elec2=elec2(2:end,:);


[testvals4 idxvals4]=sort(testvals3,'descend');

elec2(idxvals4(1:20),1)=elec2(idxvals4(1:20),1)-40; % move highest 20 vals to top

nyu_plot(surf_brain,sph,elec2,[],'w',[],1,20,testvals3);


end
end
%% nyu_plot
function nyu_plot(surf_brain,sph,elec,elecname,color,label,alpha,marksize,testvals3)
nyumc;
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
load([NYUMCDIR '/JetColorMap.mat'])
%cscale1=[0.1:0.00315:0.3];
%cscale1=[0.15:0.00235:0.3];
%cscale1=[0:0.0047:0.29999];
%cscale1=[0.05:0.004:0.3];
%cscale1=cscale1(1:64);
cscale1=[0.151:.0039:0.4];
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
    if strcmp(sph,'lh')
        view(270, 0);      
    elseif strcmp(sph,'rh')
        view(90,0);        
    elseif strcmp(sph,'both')
        view(90,90);
    end
set(gcf, 'color','black','InvertHardCopy', 'off');
axis tight;
axis equal;
fclose('all');
end