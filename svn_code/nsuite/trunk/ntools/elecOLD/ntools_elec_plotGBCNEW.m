function ntools_elec_plotGBCNEW(sub2,hemi,newtal2,chanindx)
% 
% GBC ADDS 110318%
% ntools_elec_plotGBC(sub2,hemi)
% sub2 = subject
% hemi = hemisphere ('lh' or 'rh')
% NB: Doesn't really have a both function anymore.....life will go on.
% Also, make sure that the surfgen script has been run first, otherwise it
% won't be able to read the colormatrix
% Still some stuff to do I imagine

chanindx2=[1:(size(newtal2,2))];

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

nyumc;

newtal2=newtal2';

%% Get the elec info

%     [FileName,PathName] = uigetfile('*.txt','Select the electrodes text file','/home/ccarlson/loc/');
%     [surfname, surfpath] = uigetfile('*.mat','Select the patient brain surf',PathName,'MultiSelect','on');
%     surf = strcat(surfpath,surfname);      
% 
% 
% fid = fopen([PathName, FileName]);
% elec_all = textscan(fid,'%s %f %f %f %s');
% elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];

elec_cell=newtal2;
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
% 
% %% Separate Grid, Strip and Depth electrodes
% % if strcmp(sph,'lh')
% %     c = find(cell2mat(elec_cell(:,2))>0);
% % elseif strcmp(sph,'rh')
% %     c = find(cell2mat(elec_cell(:,2))<0);
% % elseif strcmp(sph,'both')
% %     c = [];
% % end
% % elec_cell(c,:) = [];
% 
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
plt = menu('What part do you want to plot?','Grid only', 'Strip only','Depth Only','Both Grid and Strip');
labelshow = menu('Do you want to show the label?','Yes','No');
genimg = menu('Do you want to save the images?','Yes', 'No');

%elec_grid2=cell2mat(elec_grid(:,2:4));
%elec_grid2(:,1)=elec_grid2(:,1)-25; % this adjusts the grid location so that all labels can be read.  Paramater 25 can be adjusted
newtal2(:,1)=newtal2(:,1)-25;
surf=[NYUMCDIR '/fsaverage/loc/fsaverage_lh_pial_surf.mat'];
 sph = regexp(surf,'[r,l]h','match');
sph = char(sph{:});

% if strcmp(sph,'both')
%     surf_brain.sph1 = load(surf{1});
%     surf_brain.sph2 = load(surf{2});
% else 
    surf_brain = load(surf);
% end
load([NYUMCDIR '/elec_gridNAMEOLD.mat']);
%if plt==1 && ~isempty(elec_grid)
    showpart = 'G';
    %nyu_plot2(surf_brain,sph,cell2mat(elec_grid(:,2:4)),char(elec_grid(:,1)),'rNY226_lh_pial_surf.mat',labelshow,1,11.3,sub2,hemi);
     nyu_plot2(surf_brain,sph,newtal2(chanindx,1:3),char(elec_gridNAME(chanindx2,1)),'r',labelshow,1,11.3,sub2,hemi);
%elseif plt==2 && ~isempty(elec_cell)
%     showpart = 'S';
%     nyu_plot2(surf_brain,sph,cell2mat(elec_cell(:,2:4)),char(elec_cell(:,1)),'b',labelshow,1,11.3,sub2,hemi);
% elseif plt==3 && ~isempty(elec_depth)
%     showpart = 'D';
%     nyu_plot2(surf_brain,sph,cell2mat(elec_depth(:,2:4)),char(elec_depth(:,1)),'g',labelshow,0.3,6,sub2,hemi);
% elseif plt==4 && ~isempty(elec_grid) && ~isempty(elec_cell)
%     showpart = 'GS';
%     elec = cell2mat(elec_cell(:,2:4));
%     elec_name = char(elec_cell(:,1));
%     %nyu_plot2(surf_brain,sph,cell2mat(elec_grid(:,2:4)),char(elec_grid(:,1)),'r',labelshow,1,11.3,sub2,hemi); hold on;
%     nyu_plot2(surf_brain,sph,elec_grid2,char(elec_grid(:,1)),'r',labelshow,1,11.3,sub2,hemi); hold on;
%     for i=1:size(elec,1)
%         plot3(elec(i,1),elec(i,2),elec(i,3),'bo','MarkerFaceColor','b','MarkerSize',11.3);
%         if labelshow==1
%             text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elec_name(i,:),'Color','w');
%         end
%     end
%     hold off;   
% else
%     disp('sorry, the electrodes you choose to show are not on the surface you loaded');
%     return;
% end

%% save images

if genimg==1
    if ~exist([PathName 'images/'],'dir')
        mkdir([PathName 'images/']);
    end
    format = 'png';
    if strcmp(sph,'lh')
        view(270, 0);
        saveas(gcf,[PathName,'images/',Pname,space,showpart,'_lateral_',sph],format);
        view(90,0);
        saveas(gcf,[PathName,'images/',Pname,space,showpart,'_mesial_',sph],format);
        
    elseif strcmp(sph,'rh')
        view(270, 0);
        saveas(gcf,[PathName,'images/',Pname,space,showpart,'_mesial_',sph],format);
        view(90,0);
        saveas(gcf,[PathName,'images/',Pname,space,showpart,'_lateral_',sph],format);
        
    elseif strcmp(sph,'both')
        view(270, 0);
        saveas(gcf,[PathName,'images/',Pname,space,showpart,'_left_',sph],format);
        view(90,0);
        saveas(gcf,[PathName,'images/',Pname,space,showpart,'_right_',sph],format);
    end
    view(0,0);
    saveas(gcf,[PathName,'images/',Pname,space,showpart,'_posterior_',sph],format);

    view(180,0);
    saveas(gcf,[PathName,'images/',Pname,space,showpart,'_frontal_',sph],format);

    view(90,90);
    saveas(gcf,[PathName,'images/',Pname,space,showpart,'_dorsal_',sph],format);

    view(90,-90);
    set(light,'Position',[1 0 -1]);
    saveas(gcf,[PathName,'images/',Pname,space,showpart,'_ventral_',sph],format);
else 
    return;
end

end
%% nyu_plot2
function nyu_plot2(surf_brain,sph,elec,elecname,color,label,alpha,marksize,sub2,hemi)
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
    marksize = 11.3;
end

figure;

%col = [.7 .7 .7];
if strcmp(sph,'both')
    sub_sph1.vert = surf_brain.sph1.coords;
    sub_sph1.tri = surf_brain.sph1.faces;

    sub_sph2.vert = surf_brain.sph2.coords;
    sub_sph2.tri = surf_brain.sph2.faces;
    
    %col1=repmat(col(:)', [size(sub_sph1.vert, 1) 1]);
    %col2=repmat(col(:)', [size(sub_sph2.vert, 1) 1]);
    %load([NYUMCDIR '/NY226/surf/colormatrix.mat']);
    
    colormatrix=colorgen('fsaverage',hemi);
    col1=colormatrix;
    col2=colormatrix;
    trisurf(sub_sph1.tri, sub_sph1.vert(:, 1), sub_sph1.vert(:, 2),sub_sph1.vert(:, 3),...
    'FaceVertexCData', col1,'FaceColor', 'interp','FaceAlpha',alpha);
    hold on;
    trisurf(sub_sph2.tri, sub_sph2.vert(:, 1), sub_sph2.vert(:, 2), sub_sph2.vert(:, 3),...
    'FaceVertexCData', col2,'FaceColor', 'interp','FaceAlpha',alpha);
    
%     trisurf(sub_sph1.tri, sub_sph1.vert(:, 1), sub_sph1.vert(:, 2),sub_sph1.vert(:, 3),...
%         'FaceVertexCData', col1,'FaceAlpha',alpha);
%     hold on;
%     trisurf(sub_sph2.tri, sub_sph2.vert(:, 1), sub_sph2.vert(:, 2), sub_sph2.vert(:, 3),...
%         'FaceVertexCData', col2,'FaceAlpha',alpha);
    
else    
    if isfield(surf_brain,'coords')==0
        sub.vert = surf_brain.surf_brain.coords;
        sub.tri = surf_brain.surf_brain.faces;
    else
        sub.vert = surf_brain.coords;
        sub.tri = surf_brain.faces;
    end
    %col=repmat(col(:)', [size(sub.vert, 1) 1]);
    %col=load([NYUMCDIR '/NY226/surf/colormatrix.mat']);
     colormatrix=colorgen(sub2,hemi);
    col=colormatrix;
    %   color=col.colormatrix % arg
%     trisurf(sub.tri, sub.vert(:, 1), sub.vert(:, 2), sub.vert(:, 3),...
%     'FaceVertexCData', col,'FaceColor', 'interp','FaceAlpha',alpha);
trisurf(sub.tri, sub.vert(:, 1), sub.vert(:, 2), sub.vert(:, 3),...
        'FaceVertexCData', col,'FaceColor','flat');

end

shading interp;
lighting gouraud;
material dull;
light;
axis off
hold on;
for i=1:size(elec,1)
    plot3(elec(i,1),elec(i,2),elec(i,3),[color 'o'],'MarkerFaceColor',color,'MarkerSize',marksize);
    if label==1
        text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elecname(i,:),'Color','w', 'FontSize', 24);
    end
end
set(light,'Position',[-1 0 1]); 
    if strcmp(sph,'lh')
        view(270, 0);      
    elseif strcmp(sph,'rh')
        view(90,0);        
    elseif strcmp(sph,'both')
        view(90,90);
    end
    if strcmp(hemi,'lh')
        view(270,0);
    end
%set(gcf, 'color','black','InvertHardCopy', 'off');
axis tight;
axis equal;
end

%% colorgen
function colormatrix = colorgen(sub2,hemi)
nyumc;
[vertices2, label, colortable]=read_annotation([NYUMCDIR '/fsaverage/label/' hemi '.aparc.a2009s.annot']);

colormatrix=zeros(length(label),3);
for A=1:length(label)
    clear dummy*
    labeltemp=label(A);
    dummy=(colortable.table(:,5) == labeltemp);
    dummy2=colortable.table(dummy,:);
    colormatrix(A,:)=dummy2(1:3);
end
colormatrix=colormatrix./255;

end