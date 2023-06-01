function ntools_elec_plotAVGLHFIG2_130317

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
 %   [FileName,PathName] = uigetfile('*.txt','Select the electrodes text file','/home/ccarlson/loc/');
  %  [surfname, surfpath] = uigetfile('*.mat','Select the patient brain surf',PathName,'MultiSelect','on');
   % surf = strcat(surfpath,surfname);    
    surf = '/mnt/raid/NYUMC/RHSUBJ_130316/loc/RH.AVG.rh.pial.mat';
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

%fid = fopen([PathName, FileName]);
%elec_all = textscan(fid,'%s %f %f %f %s');
%elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];

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
 %    sph = regexp(surf,'[r,l]h','match');
 %   sph = char(sph{:});
% end
sph='lh';
% 
%% Separate Grid, Strip and Depth electrodes
% if strcmp(sph,'lh')
%     c = find(cell2mat(elec_cell(:,2))>0);
% elseif strcmp(sph,'rh')
%     c = find(cell2mat(elec_cell(:,2))<0);
% elseif strcmp(sph,'both')
%     c = [];
% end
% elec_cell(c,:) = [];
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
% plt = menu('What part do you want to plot?','Grid only', 'Strip only','Depth Only','Both Grid and Strip');
% labelshow = menu('Do you want to show the label?','Yes','No');
% genimg = menu('Do you want to save the images?','Yes', 'No');

% if strcmp(sph,'both')
%     surf_brain.sph1 = load(surf{1});
%     surf_brain.sph2 = load(surf{2});
% else 
    surf_brain = load(surf);
% end
load('/mnt/raid/NYUMC/RHSUBJ_130316/ALLELECS_RH.mat');
%elec2=cell2mat(elec_grid(:,2:4));
elec2(:,1)=elec2(:,1)+25;

% if plt==1 && ~isempty(elec_grid)
%         showpart = 'G';
nyu_plot(surf_brain,sph,elec2,[],'w',[]);
       % nyu_plot(surf_brain,sph,elec2,char(elec_grid(:,1)),'w',labelshow);
% elseif plt==2 && ~isempty(elec_cell)
%     showpart = 'S';
%     nyu_plot(surf_brain,sph,cell2mat(elec_cell(:,2:4)),char(elec_cell(:,1)),'b',labelshow);
% elseif plt==3 && ~isempty(elec_depth)
%     showpart = 'D';
%     nyu_plot(surf_brain,sph,cell2mat(elec_depth(:,2:4)),char(elec_depth(:,1)),'g',labelshow,0.3,6);
% elseif plt==4 && ~isempty(elec_grid) && ~isempty(elec_cell)
%     showpart = 'GS';
%     elec = cell2mat(elec_cell(:,2:4));
%     elec_name = char(elec_cell(:,1));
%     nyu_plot(surf_brain,sph,cell2mat(elec_grid(:,2:4)),char(elec_grid(:,1)),'r',labelshow); hold on;
%     for i=1:size(elec,1)
%         plot3(elec(i,1),elec(i,2),elec(i,3),'bo','MarkerFaceColor','b','MarkerSize',11.3);
%         if labelshow==1
%             text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elec_name(i,:),'Color','w');
%         end
%     end
    hold off;   
% else
%     disp('sorry, the electrodes you choose to show are not on the surface you loaded');
%     return;
% end

% %% save images
% 
% if genimg==1
%     if ~exist([PathName 'images/'],'dir')
%         mkdir([PathName 'images/']);
%     end
%     format = 'png';
%     if strcmp(sph,'lh')
%         view(270, 0);
%         saveas(gcf,[PathName,'images/',Pname,space,showpart,'_lateral_',sph],format);
%         view(90,0);
%         saveas(gcf,[PathName,'images/',Pname,space,showpart,'_mesial_',sph],format);
%         
%     elseif strcmp(sph,'rh')
%         view(270, 0);
%         saveas(gcf,[PathName,'images/',Pname,space,showpart,'_mesial_',sph],format);
%         view(90,0);
%         saveas(gcf,[PathName,'images/',Pname,space,showpart,'_lateral_',sph],format);
%         
%     elseif strcmp(sph,'both')
%         view(270, 0);
%         saveas(gcf,[PathName,'images/',Pname,space,showpart,'_left_',sph],format);
%         view(90,0);
%         saveas(gcf,[PathName,'images/',Pname,space,showpart,'_right_',sph],format);
%     end
%     view(0,0);
%     saveas(gcf,[PathName,'images/',Pname,space,showpart,'_posterior_',sph],format);
% 
%     view(180,0);
%     saveas(gcf,[PathName,'images/',Pname,space,showpart,'_frontal_',sph],format);
% 
%     view(90,90);
%     saveas(gcf,[PathName,'images/',Pname,space,showpart,'_dorsal_',sph],format);
% 
%     view(90,-90);
%     set(light,'Position',[1 0 -1]);
%     saveas(gcf,[PathName,'images/',Pname,space,showpart,'_ventral_',sph],format);
% else 
%     return;
% end
% 
% end
%% nyu_plot
function nyu_plot(surf_brain,sph,elec,elecname,color,label,alpha,marksize)

if ~exist('color','var')
    color = 'b';
end
if ~exist('label','var')
    label = 2;
end
if ~exist('alpha','var')
    alpha = 1;
end
if ~exist('marksize','var')
   %marksize = 11.3; %OLD ACTUAL SIZE NO!
   %marksize=50; % NEW PAPER
   marksize=30; % actual size (who knew?)
end

figure;

col = [.7 .7 .7];
col = [.8 .8 .8];
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
    
    
    % load label
    labelfile='/mnt/raid/NYUMC/RHSUBJ_130316/label/rh.aparc.annot';
    [vertices,label,colortable]=read_annotation(labelfile);
   
    STGidx=find(label==14474380);
    %STGcol=[0 1 0]; % green
    STGcol=[152/255 251/255 152/255]; % pale green 
    STGcol=[46/255 139/255 87/255]; % sea green
    STGcol=[143/255 188/255 143/255]; % dark sea green
    STGcol=[60/255 179/255 113/255]; % medium sea green
    %PREcol=[0 0 1]; % blue
    %POSTcol=[0 0 1]; % blue
    PREcol=[135/255 206/255 250/255]; % light sky blue
    POSTcol=[135/255 206/255 250/255]; % light sky blue
    
    PREcol=[65/255 105/255 225/255]; % royal blue 
    POSTcol=[65/255 105/255 225/255]; % royal blue 
    PREcol=[30/255 144/255 255/255]; % dodger blue
    POSTcol=[30/255 144/255 255/255]; % dodger blue
    TRIcol=[0/255 191/255 255/255]; % deep sky blue
    OPERcol=[0/255 191/255 255/255]; % deep sky blue
    SUPRAcol=[205/255 92/255 92/255]; % indian red
    LANGcol=[255/255 255/255 100/255]; % made up yello
    % STG = label 31, 14474380
    % precentral label 25, 14423100
    % postcentral label 23, 1316060
    % Pars Triangularis label 21, 1326300
    % Pars opercularis label 19, 9221340
    % Supramarginal label 32, 1351760
    % bank sts label 2, 2647065
    % transverse temp labe 35, 13145750
    
    PREidx=find(label==14423100);
    POSTidx=find(label==1316060);
    TRIidx=find(label==1326300);
    OPERidx=find(label==9221340);
    SUPRAidx=find(label==1351760);
    TRANSTEMPidx=find(label==13145750);
    BANKSTSidx=find(label==2647065);

    SMcol=[223/255 82/255 92/255];
    
    
    
    % % weird language part for post STG
%     STGidx2=sub.vert(STGidx,2);
%     [vals index]=sort(STGidx2,'ascend');
%     STGidx=STGidx(index(1:round(length(STGidx)/3)));
%     STGcol=LANGcol;
%     TRIcol=LANGcol;
%     OPERcol=LANGcol;
    

STGcol=SMcol;
PREcol=SMcol;
POSTcol=SMcol;
TRIcol=SMcol;
OPERcol=SMcol;
SUPRAcol=SMcol;

    
%     col(STGidx,:)=repmat(STGcol(:)',[size(STGidx,1) 1]);
%     col(PREidx,:)=repmat(PREcol(:)',[size(PREidx,1) 1]);
%     col(POSTidx,:)=repmat(POSTcol(:)',[size(POSTidx,1) 1]); 
%     col(TRIidx,:)=repmat(TRIcol(:)',[size(TRIidx,1) 1]);
%     col(OPERidx,:)=repmat(OPERcol(:)',[size(OPERidx,1) 1]); 
%     col(SUPRAidx,:)=repmat(SUPRAcol(:)',[size(SUPRAidx,1) 1]); 
%     col(TRANSTEMPidx,:)=repmat(STGcol(:)',[size(TRANSTEMPidx,1) 1]);
%     col(BANKSTSidx,:)=repmat(STGcol(:)',[size(BANKSTSidx,1) 1]);
%    
    
    
    
    
    
    
    trisurf(sub.tri, sub.vert(:, 1), sub.vert(:, 2), sub.vert(:, 3),...
        'FaceVertexCData', col,'FaceColor', 'interp','FaceAlpha',alpha);
end

shading interp;
lighting gouraud;
material dull;
light;
axis off
hold on;


% % TEST LINES
% AUDL=[1:7,11:15,29:25];
% for i=1:length(AUDL) % AUD
%     hold on;
%         plot3(elec(AUDL(i),1),elec(AUDL(i),2),elec(AUDL(i),3),['g' 'o'],'MarkerFaceColor','g','MarkerSize',marksize);
% end





% for i=1:31 % AUD
%     
%     hold on;
%     plot3(elec(i,1),elec(i,2),elec(i,3),['k' 'o'],'MarkerFaceColor','g','MarkerSize',marksize,'LineWidth',1);
% end
% 
% 
% hold on; 
% 
% for i=32:94 % PROD
%    % for i=90:
%    % if i==42
%       %  display('got it')
%   %  else
 %    hold on;
 %         plot3(elec(i,1),elec(i,2),elec(i,3),['k' 'o'],'MarkerSize',marksize,'LineWidth',1,'MarkerFaceColor','b');
%  % hold on 
%   %        plot3(elec(i,1),elec(i,2),elec(i,3),'o','MarkerEdgeColor',[0.1 0.1 1],'MarkerFaceColor',[0.1 0.1 1],'MarkerSize',marksize);
%   
 % end
% % 
% hold on
% %for i=95:97 % SM
 for i=95:116 % SMA recast as just red for simplicity  
     if i==105
         elec(i,3)=elec(i,3)+10;
     end
     
     
 hold on;     
     plot3((elec(i,1)+15),elec(i,2),elec(i,3),['k' 'o'],'MarkerFaceColor','r','MarkerSize',marksize,'LineWidth',1); % SM
 end

% hold on;
%    for i=98:116 % SMA
%   %     for i=98:99
% %   if i==105 || i==106 || i==107 || i==110 || i==111 || i==112 || i==113 
%     if i==105 || i==106 || i==107 || i==110 || i==111 
%       elec(i,2)=elec(i,2)-3;
%       elec(i,3)=elec(i,3)+3;
%     end
%   
%       hold on
%          plot3((elec(i,1)+15),elec(i,2),elec(i,3),['g' 'o'],'MarkerFaceColor','r','MarkerSize',marksize,'LineWidth',7);
%    end
% %    
  end


set(light,'Position',[-1 0 1]); 
   % if strcmp(sph,'lh')
    %    view(270, 0);      
    %elseif strcmp(sph,'rh')
        view(90,0);        
    %elseif strcmp(sph,'both')
    %    view(90,90);
    %end
set(gcf, 'color','black','InvertHardCopy', 'off'); % used to be black
axis tight;
axis equal;
end