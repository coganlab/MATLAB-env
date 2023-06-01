function nyu_ieeg_elec_plot(varargin)

% a stand-alone program that shows ieeg electrode coordinates on the pial
% surface
% required:
% elec_text: text file with xyz electrode coordinates
% pial_mat: matlab structure with pial surface
%
% Usage: nyu_ieeg_elec_plot(elec_text,pial_mat) or nyu_ieeg_elec_plot(pial_mat, elec_text);
% if no input arguments are given, user is prompted for file selection
%
% also see: http://ieeg.pbworks.com/Viewing-Electrode-Locations
%
% written by  Hugh Wang, wangxiuyuan85@gmail.com, May 13, 2009

% modified on May 14, 2009 by Hugh
% make judgement on the input file type and not sensitive to the order of 
% input variable. add the option to show the electrodes' labels or not.

%% Get the elec info
if nargin==0
    [FileName,PathName] = uigetfile('*.txt','Select the electrode text file');
    [surfname, surfpath] = uigetfile('*.mat','Select the patient brain surface',PathName);
elseif nargin==2
    [path{1} name{1} ext{1}] = fileparts(varargin{1});
    [path{2} name{2} ext{2}] = fileparts(varargin{2});
    a = strmatch('.txt', strvcat(ext{1},ext{2}));
    b = strmatch('.mat', strvcat(ext{1},ext{2}));
    if isempty(a) || isempty(b)
        error('not correct input files');
    else
        PathName = [path{a} '/'];
        FileName = [name{a} ext{a}];

        surfpath = [path{b} '/'];
        surfname = [name{b} ext{b}];
    end
%     textfile = varargin{1};
%     ind = max(findstr(textfile,'/'));
%     PathName = textfile(1:ind);
%     FileName = textfile(ind+1:end);        
%     matfile = varargin{2};
%     ind2 = max(findstr(matfile,'/'));
%     surfpath = matfile(1:ind2);
%     surfname = matfile(ind2+1:end);
else 
    error('not the correct number of input');
end
    
[name x y z] = textread([PathName, FileName],'%s %f %f %f');    
elec_cell = [name,num2cell(x),num2cell(y),num2cell(z)];
g = strmatch('G',name);
elec_grid = elec_cell(g,:);
d = strmatch('D',name);
elec_cell([g;d],:) = [];

%% Get the surf info

a = findstr(surfname,'_')+1;
sph = surfname(a(1):a(1)+1);

%% Plot the elecs
plt = menu('Do you want to plot the result?','Grid only', 'Strip only',...
    'Both Grid and Strip','No, thanks');
labelshow = menu('Do you want to show the labels?','Yes','No');
if plt==1
    load([surfpath surfname]);
    nyu_plot(surf_brain,sph,cell2mat(elec_grid(:,2:4)),char(elec_grid(:,1)),'r',labelshow);
elseif plt==2
    load([surfpath surfname]);
    nyu_plot(surf_brain,sph,cell2mat(elec_cell(:,2:4)),char(elec_cell(:,1)),'b',labelshow);
elseif plt ==3
    load([surfpath surfname]);
    elec = cell2mat(elec_cell(:,2:4));
    elec_name = char(elec_cell(:,1));
    nyu_plot(surf_brain,sph,cell2mat(elec_grid(:,2:4)),char(elec_grid(:,1)),'r',labelshow); hold on;
    
    for i=1:length(elec)
        plot3(elec(i,1),elec(i,2),elec(i,3),'bo','MarkerFaceColor','b');
        if labelshow==1
            text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elec_name(i,:),'Color','w');
        end
    end
    hold off;
else 
    return;
end

%% nyu_plot
function nyu_plot(surf_brain,sph,elec,elecname,color,label)
sub.vert = surf_brain.coords;
sub.tri = surf_brain.faces;

tripatch(sub, '', [.7 .7 .7]);

shading interp;
lighting gouraud;
material dull;
l=light;
axis off
hold on

for i=1:length(elec)
    plot3(elec(i,1),elec(i,2),elec(i,3),[color 'o'],'MarkerFaceColor',color);
    if label==1
        text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elecname(i,:),'Color','w');
    end
end
if strcmp(sph,'lh')
    view(270, 0);
    set(l,'Position',[-1 0 1]); % left hemi
elseif strcmp(sph,'rh') 
    view(90,0);
    set(l,'Position',[1 0 1]); % right hemi
end
set(gcf, 'color','black','InvertHardCopy', 'off');

%% Tripatch
function handle=tripatch(struct, nofigure, varargin)
% TRIPATCH handle=tripatch(struct, nofigure)

if nargin<2 || isempty(nofigure)
   figure
end% if
if nargin<3
   handle=trisurf(struct.tri, struct.vert(:, 1), struct.vert(:, 2), struct.vert(:, 3));
else
   if isnumeric(varargin{1})
      col=varargin{1};
      varargin(1)=[];
      if [1 3]==sort(size(col))
         col=repmat(col(:)', [size(struct.vert, 1) 1]);
      end% if
      handle=trisurf(struct.tri, struct.vert(:, 1), struct.vert(:, 2), struct.vert(:, 3), ...
         'FaceVertexCData', col, varargin{:});
      if length(col)==size(struct.vert, 1)
         set(handle, 'FaceColor', 'interp');
      end% if
   else
      handle=trisurf(struct.tri,struct.vert(:,1),struct.vert(:,2),struct.vert(:,3),varargin{:});
   end% if
end% if
% axis tight
% axis equal
hold on
if version('-release')>=12
   cameratoolbar('setmode', 'orbit')
else
   rotate3d on
end% if