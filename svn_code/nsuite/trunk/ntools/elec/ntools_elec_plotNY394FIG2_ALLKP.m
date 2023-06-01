function ntools_elec_plot(varargin)

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
if nargin==0
    [FileName,PathName] = uigetfile('*.txt','Select the electrodes text file','/home/ccarlson/loc/');
    [surfname, surfpath] = uigetfile('*.mat','Select the patient brain surf',PathName,'MultiSelect','on');
    surf = strcat(surfpath,surfname);      
elseif nargin==2
    aa = findstr(varargin{1},'/');
    FileName = varargin{1}(aa(end)+1:end);
    PathName = varargin{1}(1:aa(end));
    surf = varargin{2};  
elseif nargin==3
    aa = findstr(varargin{1},'/');
    FileName = varargin{1}(aa(end)+1:end);
    PathName = varargin{1}(1:aa(end));
    surf = varargin(2:3);
elseif nargin>3
    disp('not correct input');
    return;
end

fid = fopen([PathName, FileName]);
elec_all = textscan(fid,'%s %f %f %f %s');
elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];

%% Get the filename info
b = findstr(FileName,'_');
Pname = FileName(1:b(1)-1);

if ~isempty(findstr(upper(FileName),'T1'))
    space = '_T1_';
elseif ~isempty(findstr(upper(FileName),'MNI'))
    space = '_MNI_';
else
    space = '_';
end

if length(surf)==2
    sph = 'both';
else
    sph = regexp(surf,'[r,l]h','match');
    sph = char(sph{:});
end

%% Separate Grid, Strip and Depth electrodes
% if strcmp(sph,'lh')
%     c = find(cell2mat(elec_cell(:,2))>0);
% elseif strcmp(sph,'rh')
%     c = find(cell2mat(elec_cell(:,2))<0);
% elseif strcmp(sph,'both')
%     c = [];
% end
% elec_cell(c,:) = [];

if isempty(char(elec_all{5}(:)))
    g = strmatch('G',upper(elec_cell(:,1)));
    d = strmatch('D',upper(elec_cell(:,1)));
else
    g = strmatch('G',upper(elec_all{5}));
    d = strmatch('D',upper(elec_all{5}));
end

if ~isempty(g) && ~isempty(d)
    elec_grid = elec_cell(g,:);
    elec_depth = elec_cell(d,:);
    elec_cell([g;d],:) = [];    
elseif isempty(d)
    elec_depth = [];
    elec_grid = elec_cell(g,:);
    elec_cell(g,:) = [];
elseif isempty(g)
    elec_grid = [];
    elec_depth = elec_cell(d,:);
    elec_cell(d,:) = [];
end


%% Plot the elecs
plt = menu('What part do you want to plot?','Grid only', 'Strip only','Depth Only','Both Grid and Strip');
labelshow = menu('Do you want to show the label?','Yes','No');
genimg = menu('Do you want to save the images?','Yes', 'No');

if strcmp(sph,'both')
    surf_brain.sph1 = load(surf{1});
    surf_brain.sph2 = load(surf{2});
else 
    surf_brain = load(surf);
end

elec2=cell2mat(elec_grid(:,2:4));
elec2(:,1)=elec2(:,1)-25;



if plt==1 && ~isempty(elec_grid)
        showpart = 'G';
        nyu_plot(surf_brain,sph,elec2,char(elec_grid(:,1)),'w',labelshow);
elseif plt==2 && ~isempty(elec_cell)
    showpart = 'S';
    nyu_plot(surf_brain,sph,cell2mat(elec_cell(:,2:4)),char(elec_cell(:,1)),'b',labelshow);
elseif plt==3 && ~isempty(elec_depth)
    showpart = 'D';
    nyu_plot(surf_brain,sph,cell2mat(elec_depth(:,2:4)),char(elec_depth(:,1)),'g',labelshow,0.3,6);
elseif plt==4 && ~isempty(elec_grid) && ~isempty(elec_cell)
    showpart = 'GS';
    elec = cell2mat(elec_cell(:,2:4));
    elec_name = char(elec_cell(:,1));
    nyu_plot(surf_brain,sph,cell2mat(elec_grid(:,2:4)),char(elec_grid(:,1)),'r',labelshow); hold on;
    for i=1:size(elec,1)
        plot3(elec(i,1),elec(i,2),elec(i,3),'bo','MarkerFaceColor','b','MarkerSize',11.3);
        if labelshow==1
            text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elec_name(i,:),'Color','w');
        end
    end
    hold off;   
else
    disp('sorry, the electrodes you choose to show are not on the surface you loaded');
    return;
end

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
   marksize=10;
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
        marksize1=20; % 55
        marksize2=30;
        markblack=35;
        markblackdelay=35;
shading interp;
lighting gouraud;
material dull;
light;
axis off
hold on;

for i=1:length(elec)
    
    if i==8 || i==14 || i==15 || i==20 || i==21 || i==22 || i==24 || i==30 % AUD [8 14 15 20 21 22 24 30]; % AUD
        elec(:,1)=elec(:,1)+30;
        plot3(elec(i,1),elec(i,2),elec(i,3),['k' 'o'],'MarkerFaceColor','k','MarkerSize',markblack);
        hold on;
        plot3(elec(i,1),elec(i,2),elec(i,3),['g' 'o'],'MarkerFaceColor','g','MarkerSize',marksize2);
        
 
    elseif i==27 || i==29 || i==34 || i==36 || i==38 || i==42 || i==55 % PROD [27 29 34 36 38 40 42 49]
        elec(:,1)=elec(:,1)+20;
        plot3(elec(i,1),elec(i,2),elec(i,3),['k' 'o'],'MarkerFaceColor','k','MarkerSize',markblack);
        hold on;
        plot3(elec(i,1),elec(i,2),elec(i,3),['b' 'o'],'MarkerFaceColor','b','MarkerSize',marksize2);
   
        % elseif i==1
        
        %     display(i) % removed bad channels
    elseif  i==47  || i==54  % SM  43 48 % SM
        elec(:,1)=elec(:,1)+10;
        plot3(elec(i,1),elec(i,2),elec(i,3),['k' 'o'],'MarkerFaceColor','k','MarkerSize',markblack);
        hold on;
        plot3(elec(i,1),elec(i,2),elec(i,3),['r' 'o'],'MarkerFaceColor','r','MarkerSize',marksize2);
        
    
        
%     elseif i==41 || i==43 || i==50 || i==59  % DEL 39 41 46 51
%         elec(i,1)=elec(i,1)+45;
%         plot3(elec(i,1),elec(i,2),elec(i,3),['k' 'o'],'MarkerFaceColor','k','MarkerSize',markblack);
%         hold on;
%         plot3(elec(i,1),elec(i,2),elec(i,3),'o','Color',[147/255 112/255 219/255],'MarkerFaceColor',[147/255 112/255 219/255],'MarkerSize',marksize2);
    elseif i==32 || i==63 % AUD DEL
        elec(:,1)=elec(:,1)+120;
        plot3(elec(i,1),elec(i,2),elec(i,3),'o','Color','k','MarkerFaceColor',[147/255 112/255 219/255],'MarkerSize',markblackdelay);
        hold on;
        plot3(elec(i,1),elec(i,2),elec(i,3),['g' 'o'],'MarkerFaceColor','g','MarkerSize',marksize1);
        %    plot3(elec(i,1),elec(i,2),elec(i,3),['y' 'o'],'MarkerFaceColor','g','MarkerSize',marksize);
   elseif i==44 % PROD DEL
        elec(:,1)=elec(:,1)+50;
        plot3(elec(i,1),elec(i,2),elec(i,3),'o','Color','k','MarkerFaceColor',[147/255 112/255 219/255],'MarkerSize',markblackdelay);
        hold on;
        plot3(elec(i,1),elec(i,2),elec(i,3),['b' 'o'],'MarkerFaceColor','b','MarkerSize',marksize1);
        
   elseif i==37 || i==53 % SM DEL
        elec(:,1)=elec(:,1)+120;
        plot3(elec(i,1),elec(i,2),elec(i,3),'o','Color','k','MarkerFaceColor',[147/255 112/255 219/255],'MarkerSize',markblackdelay);
        hold on;
        plot3(elec(i,1),elec(i,2),elec(i,3),['r' 'o'],'MarkerFaceColor','r','MarkerSize',marksize1);
     elseif i==41 || i==43  || i==50  || i==59 % DEL
          elec(i,1)=elec(i,1)+120;
       plot3(elec(i,1),elec(i,2),elec(i,3),['k' 'o'],'MarkerFaceColor','k','MarkerSize',markblack);
        hold on;
         plot3(elec(i,1),elec(i,2),elec(i,3),'o','Color',[147/255 112/255 219/255],'MarkerFaceColor',[147/255 112/255 219/255],'MarkerSize',marksize2);     
    
    
    else
      %  elec(:,1)=elec(:,1)+10;
        if i==16 || i==40 || i==45 || i==46 ||i==57 || i==64
            elec(:,1)=elec(:,1)-80;
        end
        %plot3(elec(i,1),elec(i,2),elec(i,3),[color 'o'],'MarkerFaceColor',color,'MarkerSize',marksize);
        plot3(elec(i,1),elec(i,2),elec(i,3),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0.9 0.9 0.9],'MarkerSize',20);
    end
    if label==1
        text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elecname(i,:),'Color','w');
    end
end
set(light,'Position',[-1 0 1]); 
 %   if strcmp(sph,'lh')
 %       view(270, 0);      
 %   elseif strcmp(sph,'rh')
        view(90,0);        
 %  elseif strcmp(sph,'both')
 %       view(90,90);
 %   end
set(gcf, 'color','black','InvertHardCopy', 'off');
axis tight;
axis equal;
end