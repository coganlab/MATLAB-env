function ntools_elec_plotBLANKLH(varargin)

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
 surf = '/mnt/nim1/NYUMC/LHSUBJ_130316/loc/LH.AVG.lh.pial.mat';


% if strcmp(sph,'both')
%     surf_brain.sph1 = load(surf{1});
%     surf_brain.sph2 = load(surf{2});
% else 
    surf_brain = load(surf);
%end

elec2=zeros(1,3);
% NY149

nyu_plot(surf_brain,sph,elec2,[],'w',[]);

%     nyu_plot(surf_brain,sph,cell2mat(elec_grid(:,2:4)),char(elec_grid(:,1)),'r',labelshow); hold on;
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
%col = [.8 .8 .8];
%col = [248/255 248/255 255/255];
%col = [240/255 255/255 240/255];
%col = [244/255 238/255 224/255];
%col = [193/255 205/255 193/255];
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
    
    cname=(['/mnt/nim1/NYUMC/LHSUBJ_130316/label/lh.aparc.a2009s.annot']);
    [vertices label colortable]=read_annotation(cname);
    % get labels 
    % PROD
  %  prem1=find(label==15733781); %
   % prem2=find(label==13112341);
    postg=find(label==9221140); % 8
    preg=find(label==11832380); % 9
    subg=find(label==14423103); % 1
   % cents=find(label==660701);
    operc=find(label==6558940); % 2
    orbital=find(label==3947660); % 3
    triang=find(label==9231540); % 4
    GFM=find(label==11822220); % 5
    angg=find(label==14433300); % 6
    supra=find(label==3957860); % 7
    gtinf=find(label==6610140); % 10
    gtmid=find(label==3947700); % 11
    sts=find(label==3988703); % 12
    stg1=find(label==14433500); % 
    %stga=find(label==14433500);
    
    tmp=sub.vert(stg1,:);
    [tmpS idx]=sort(tmp(:,2),'ascend');
    Plab=idx(1:floor(length(tmp)/2));
    Alab=idx(ceil(length(tmp)/2)+1:end);
    
    stgA=stg1(Alab); % 13
    stgP=stg1(Plab); % 14
    
    
    
    col=repmat(col(:)', [size(sub.vert, 1) 1]);
    col2=col;
    col3=col;
    col2(operc,:)=repmat([102/255 0 102/255],[length(operc) 1]);
    col2(orbital,:)=repmat([1 1 0],[length(orbital) 1]);
    col2(triang,:)=repmat([102/255 1 1 ], [length(triang) 1]);
    col2(GFM,:)=repmat([1/255 51/255 51/255], [length(GFM) 1]);
    col2(angg,:)=repmat([1/255 153/255 153/255], [length(angg) 1]);
    col2(supra,:)=repmat([0 102/255 204/255], [length(supra) 1]);
    col2(gtinf,:)=repmat([102/255 1 102/255], [length(gtinf) 1]);
    col2(gtmid,:)=repmat([0 51/255 0], [length(gtmid) 1]);
    col2(sts,:)=repmat([178/255 102/255 1], [length(sts) 1]);
    col2(stgA,:)=repmat([51/255 25/255 0], [length(stgA) 1]);
    col2(stgP,:)=repmat([1 153/255 51/255], [length(stgP) 1]);
    
    %col(prem1,:)=repmat([0 0 1], [length(prem1) 1]);
    %col(prem2,:)=repmat([0 0 1], [length(prem2) 1]);
    col2(postg,:)=repmat([1 0 0], [length(postg) 1]);
    col2(preg,:)=repmat([0 0 1], [length(preg) 1]);
    col2(subg,:)=repmat([0 1 0], [length(subg) 1]);
    %col2(cents,:)=repmat([0 0 1], [length(cents) 1]);
    
    
  %   col3(postg,:)=repmat([1 0 0], [length(postg) 1]);
    
    trisurf(sub.tri, sub.vert(:, 1), sub.vert(:, 2), sub.vert(:, 3),...
        'FaceVertexCData', col,'FaceColor', 'interp','FaceAlpha',0.5);
    hold on;
    trisurf(sub.tri, sub.vert(:,1), sub.vert(:, 2), sub.vert(:, 3),  'FaceVertexCData', col3,'FaceColor', 'interp','FaceAlpha',1); % alpha was 0.5
     hold on;
    trisurf(sub.tri, sub.vert(:,1), sub.vert(:, 2), sub.vert(:, 3),  'FaceVertexCData', col2,'FaceColor', 'interp','FaceAlpha',1); % alpha was 0.5
end

shading interp;
lighting gouraud;
material dull;
light;
axis off
hold on;
% for i=1:length(elec)
%     %if i==65 % AUD
%         %plot3(elec(i,1),elec(i,2),elec(i,3),['g' 'o'],'MarkerFaceColor','g','MarkerSize',marksize);
%     %elseif i==51 || i==52 || i==57 || i==58 || i==59 || i==60 || i==61  % PROD
%           %plot3(elec(i,1),elec(i,2),elec(i,3),'o','MarkerEdgeColor',[0.1 0.1 1],'MarkerFaceColor',[0.1 0.1 1],'MarkerSize',marksize);
%     %elseif i==47 || i==50  % SM and Aud
%                   %plot3(elec(i,1),elec(i,2),elec(i,3),['g' 'o'],'MarkerFaceColor','r','MarkerSize',marksize,'LineWidth',7);
%           %plot3(elec(i,1),elec(i,2),elec(i,3),['r' 'o'],'MarkerFaceColor','r','MarkerSize',marksize);
%     %else
%     %plot3(elec(i,1),elec(i,2),elec(i,3),[color 'o'],'MarkerFaceColor',color,'MarkerSize',marksize);
%                 plot3(elec(i,1),elec(i,2),elec(i,3),'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',30);
% 
%    % end
% %     if label==1
% %         text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elecname(i,:),'Color','w');
% %     end
% end
set(light,'Position',[-1 0 1]); 
    if strcmp(sph,'lh')
        view(270, 0);      
    elseif strcmp(sph,'rh')
        view(90,0);        
    elseif strcmp(sph,'both')
        view(90,90);
    end
set(gcf, 'color','white','InvertHardCopy', 'off');
axis tight;
axis equal;
end