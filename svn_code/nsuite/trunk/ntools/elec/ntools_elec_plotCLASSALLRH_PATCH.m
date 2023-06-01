function ntools_elec_plotCLASSALLRH(varargin)
nyumc;
load([NYUMCDIR '/LHRHidxALLELECS.mat']);
% load classifier data
load([NYUMCDIR '/classifier/Data/Allway_ClassALLCHAN_PROD_EACHCHAN_5SVDS_1to200_OUT12_130619.mat'])
testvals1=sq(mean(PmatrixFULL(:,:,:,1:72),4));
load([NYUMCDIR '/classifier/Data/Allway_ClassALLCHAN_PROD_EACHCHAN_5SVDS_1to200_OUT12_130619.mat'])
%testvals1B=sq(mean(PmatrixFULL(:,:,:,1:72),4));

%testvals1=(testvals1+testvals1B)./2;



 % MAX
 for iChan=1:size(testvals1,1);
    testvals2A(:,iChan)=diag(sq(testvals1(iChan,:,:)));
 %    testvals2B(:,iChan)=diag(sq(testvals1B(iChan,:,:)));
 end
 testvals2=max(testvals2A,[],1);
% testvals2C=max(testvals2B,[],1);

% % AVG
% for iChan=1:size(testvals1,1);
%     testvals2(iChan)=mean(diag(sq(testvals1(iChan,:,:))));
%    % testvals2B(iChan)=mean(diag(sq(testvals1B(iChan,:,:))));
% end

% testvals2=(testvals2+testvals2C)./2;



testvals3=testvals2(RHidx);

% Plot the elecs
% plt = menu('What part do you want to plot?','Grid only', 'Strip only','Depth Only','Both Grid and Strip');
% labelshow = menu('Do you want to show the label?','Yes','No');
% genimg = menu('Do you want to save the images?','Yes', 'No');
sph='rh';
 surf = [NYUMCDIR '/RHSUBJ_130316/loc/RH.AVG.rh.pial.mat'];


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
PathName=NYUMCDIR;
FileName='/NY273/loc/NY273_fmri_070810_coor_T1_080310.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
%g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell([113:122,131,132,161,162],:);
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

elecT(:,1)=elecT(:,1)+25;
elec2=cat(1,elec2,elecT);


% NY149
PathName=NYUMCDIR;
FileName='/NY149/loc/NY149_coor_T1_.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
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
PathName=NYUMCDIR;
FileName='/NY192/loc/NY192_coor_T1_102209_GBC.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
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
PathName=NYUMCDIR;
FileName='/NY311/loc/NY311_fmri_032811_coor_T1_042211.txt';
fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));

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
PathName=NYUMCDIR;
FileName='/NY313/loc/NY313_fmri_050511_coor_T1_052411.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elecT=cell2mat(elec_grid(:,2:4));
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
PathName=NYUMCDIR;
FileName='/NY255v2/loc/locNY255v2_coor_T1_031113.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elec_grid = elec_grid(setdiff(1:64,[1,2,16,27,33,34,35,50:53]),:);
elecT=cell2mat(elec_grid(:,2:4));
filename=[NYUMCDIR '/NY255v2/mri/transforms/talairach.xfm'];
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
PathName=NYUMCDIR;
FileName='/NY329/loc/NY329_rh_T1.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
%g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(1:42,:);
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

elecT(:,1)=elecT(:,1)+25;
elecT(:,2)=elecT(:,2)+10;
elecT(:,3)=elecT(:,3)+25;
elec2=cat(1,elec2,elecT);



% 
% NY346
PathName=NYUMCDIR;
FileName='/NY346/loc/NY346_fmri_071212_coor_T1_130204_GBC_2.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elec_grid = elec_grid(setdiff(1:64,[1,7:11,16:19,25,26,55,56,61:64]),:);
elecT=cell2mat(elec_grid(:,2:4));
filename=[NYUMCDIR '/NY346/mri/transforms/talairach.xfm'];
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
PathName=NYUMCDIR;
FileName='/NY359/loc/locNY359_coor_T1_031913.txt';

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
g = strmatch('G',upper(elec_cell(:,1)));
elec_grid = elec_cell(g,:);
elec_grid = elec_grid([1,2,5,6,11,12,15,16,17,18,21,22,27,28,31,32,33,34,37,38,43,44,47,48,49,50,53,54,59,60,63,64],:);
elecT=cell2mat(elec_grid(:,2:4));
filename=[NYUMCDIR '/NY359/mri/transforms/talairach.xfm'];
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

% elec2 is elec data and testvals3 is actual data
load([NYUMCDIR '/RHSUBJ_130316/loc/RH.AVG.rh.pial.mat']);
%[vertex_coords, faces]=read_surf([NYUMCDIR '/LHSUBJ_130316/surf/lh.pial_avg']);


KER=10;
counterCH=zeros(163842,1);
dataCH=zeros(163842,1);
for iElec=1:length(elec2)
    tmpE1=elec2(iElec,:);
    tmpE1R=tmpE1(1)-KER:tmpE1(1)+KER;
    tmpE1A=tmpE1(2)-KER:tmpE1(2)+KER;
    tmpE1S=tmpE1(3)-KER:tmpE1(3)+KER;
    
    iiA=find(coords(:,2)>=min(tmpE1A) & coords(:,2)<=max(tmpE1A));
    iiS=find(coords(:,3)>=min(tmpE1S) & coords(:,3)<=max(tmpE1S));
    iiAS=intersect(iiA,iiS); % 
    dataCH(iiAS)=testvals3(iElec)+dataCH(iiAS);
    counterCH(iiAS)=counterCH(iiAS)+1;
end

iC2=find(counterCH==1);

%iC=find(counterCH==0);
%counterCH(iC)=1;
newvals2=dataCH./counterCH;
newvals2(iC2)=0;


%newvals2=dataCH;

%newvals2=counterCH;

topval=[0 max(newvals2)]
topval=[0.15 0.35];



figure;
%nyumc;

cmap=colormap('jet');
% for A=1:24
%     cmap(A,:)=cmap(A,:).*0.7;
% end


%if ~exist('color','var')
    color = 'w';
%end
%if ~exist('label','var')
    label = 2;
%end
%if ~exist('alpha','var')
    alpha = 1;
%end
%if ~exist('marksize','var')
   marksize = 11.3;
   
%end

% remove this line later

%cmap(1:63,:)=repmat([0.75 0.75 0.75],63,1);



colorscale=[topval(1):(topval(2)-topval(1))/64:topval(2)];

%standard
%colorscale=[0:22/6400:0.22];

%new colorscale that varies with max of index (140 %)
%colorscale=[0:(max(newvals2)*140)/6400:(max(newvals2)*1.40)];

%exponential?
% colorscale=[0:(max(newvals2)*100)/6400:(max(newvals2)*1.00)];
% colorscalefit=pdf('normal',1:130,65,40);
% colorscalefit=colorscalefit./max(colorscalefit);
% colorscale=colorscale.*colorscalefit(1:65);

% for A=1:32
%     cmap(32+A,:)=cmap(A*2,:);
% end
% for A=1:32
%     cmap(A,:)=[0.7 0.7 0.7];
% end
    
%col=0.7*ones(length(newvals2),3);
col=zeros(length(newvals2),3);
col(:,3)=cmap(1,3);

for A=1:64
    if A==64
        newidx=find(newvals2>=colorscale(A));
    elseif A>1 && A<64
    newidx=find(newvals2>=colorscale(A) & newvals2<=colorscale(A+1));
    elseif A==1
        newidx=find(newvals2<=colorscale(A));
    end
    for ic=1:length(newidx);
    col(newidx(ic),:)=cmap(A,:);
    end
    clear newidx
end

    
    
    


        sub.vert = coords;
        sub.tri = faces;
    
    %col=repmat(col(:)', [size(sub.vert, 1) 1]);
%     trisurf(sub.tri, sub.vert(:, 1), sub.vert(:, 2), sub.vert(:, 3),...
%         'FaceVertexCData', col','FaceColor', 'interp','FaceAlpha',alpha);
    
    trisurf(sub.tri, sub.vert(:, 1), sub.vert(:, 2), sub.vert(:, 3),...
        'FaceVertexCData', col,'FaceColor','interp');
    
%end

shading interp;
lighting gouraud;
material dull;
light;
axis off
% hold on;
% for i=1:length(elec)
%     plot3(elec(i,1),elec(i,2),elec(i,3),[color 'o'],'MarkerFaceColor',color,'MarkerSize',marksize);
%     if label==1
%         text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elecname(i,:),'Color','w');
%     end
% end
set(light,'Position',[-1 0 1]); 
%     if strcmp(sph,'lh')
%if strcmp(hemi,'LH')      
%view(270, 0);      
%     elseif strcmp(sph,'rh')
%elseif strcmp(hemi,'RH')
       view(90,0);  %
%end
%     elseif strcmp(sph,'both')
%         view(90,90);
%   end
set(gcf, 'color','white','InvertHardCopy', 'off');
axis tight;
axis equal;
%end






    
    
    
    
