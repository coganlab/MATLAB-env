function createArrayElectrodeGrid(Microdrive)
%
% createArrayElectrodeGrid(Microdrive)
%
% Creates face and vertex information for electrode grids from coordinate
% information. Creates a faces for each electrode and each color of the
% colorbar. Face and vertex information is used by plotArrary to showarray
% data on MRI underlays.
%
%   Microdrive: 
% String. Specifies the microdrive e.g. 'SC96'. Specifies which
% channelmap and coordinates are loaded.
%
% Requires manually created information about electrode coordinates and
% mapping. See SC96_channelmap.m. Works for SC32 and SC96
%
% See: createArrayMRIUnderlay, plotArray

global MONKEYDIR MONKEYNAME

MRIDIR = [MONKEYDIR '/MRI'];
if ~exist(MRIDIR); error(sprintf('%s/MRI not found. Please see the WIKI for instructions for setting up a monkey specific MRI dir.\n',MONKEYDIR));else addpath(MRIDIR);end

if nargin<1
    Microdrive = 'SC32';
end

if strcmp(Microdrive,'SC96')
    [EX,EY,eidx,esub,spacing]=SC96_channelmap;
elseif strcmp(Microdrive,'SC32')
    [EX,EY,eidx,esub,spacing]=SC32_channelmap;
elseif strcmp(Microdrive,'vSUBNETS220')
    [EX,EY,eidx,esub,spacing]=vSUBNETS220_channelmap;
else
    error('Unknown Microdrive');
end

nelec = numel(eidx);
[x, y] = ndgrid(EX,EY); % for linear index eidx
centers=[x(eidx) y(eidx)];

% grow vertices for n electrode faces, reuse vertices
vert = []; fac = nan(nelec,4);
for ielec = 1:nelec
   % go to each electrode center and create equidistant vertices at half
   % the electrode spacing around it, forming a square face for each
   % electrode
   center = [x(eidx(ielec)) y(eidx(ielec))];
   vtc(1,:) = center + [-spacing/2 -spacing/2];
   vtc(2,:) = center + [-spacing/2 spacing/2]; 
   vtc(3,:) = center + [spacing/2 spacing/2];
   vtc(4,:) = center + [spacing/2 -spacing/2];
   
   % create faces, check whether identical vertices exist already, reuse
   vkill=[];
   if ielec>1
       for iv=1:4
           i = find(sum((vert - repmat(vtc(iv,:),size(vert,1),1)).^2)==0); % check whether vertex exists already
           if ~isempty(i)
               fac(ielec,iv) = i; % reuse vertex
               vkill = iv;
           else
               fac(ielec,iv) = size(vert,1)+iv-numel(vkill);
           end
       end
       vtc(vkill,:)=[];
       vert = [vert;vtc];
   else
       fac(ielec,:)=1:4;
       vert(1:4,:)=vtc;
   end
   
end


% Define colorbar size and position based on the electrode grid
ysizecb = abs(EY(2)-EY(end-1))./2; % half the electrode grid high
xsizecb = ysizecb./6; % aspect ratioy/x 6/1

xposcb = EX(end-1)+ysizecb/3;
yposcb = (EY(2)+EY(end-1))./2;
yposcb = linspace(yposcb-ysizecb/2,yposcb+ysizecb/2,300);
tickysizecb = mean(diff(yposcb));

% grow vertices for colorbar faces, reuse vertices
vertcb = []; faccb = nan(300,4);
for icb = 1:300
   % 
   center = [xposcb yposcb(icb)];
   vtc(1,:) = center + [-xsizecb/2 -tickysizecb/2];
   vtc(2,:) = center + [-xsizecb/2 tickysizecb/2]; 
   vtc(3,:) = center + [xsizecb/2 tickysizecb/2];
   vtc(4,:) = center + [xsizecb/2 -tickysizecb/2];
   
   % create faces, check whether identical vertices exist already, reuse
   vkill=[];
   if icb>1
       for iv=1:4
           i = find(sum((vertcb - repmat(vtc(iv,:),size(vertcb,1),1)).^2)==0); % check whether vertex exists already
           if ~isempty(i)
               faccb(icb,iv) = i; % reuse vertex
               vkill = iv;
           else
               faccb(icb,iv) = size(vertcb,1)+iv-numel(vkill);
           end
       end
       vtc(vkill,:)=[];
       vertcb = [vertcb;vtc];
   else
       faccb(icb,:)=1:4;
       vertcb(1:4,:)=vtc;
   end
   
end

% Define circular colorbar size and position based on the electrode grid
outradcb = abs(EY(2)-EY(end-1))./4; % quarter the height of the electrode grid the electrode grid
inradcb = outradcb./3; %

xposcirccb = EX(end-1)+spacing+outradcb;
yposcirccb = (EY(2)+EY(end-1))./2;

rads=linspace(0,2.*pi,300)';
unitcirc=[cos(rads) sin(rads)];
circin=unitcirc.*inradcb+repmat([xposcirccb yposcirccb],300,1);
circout=unitcirc.*outradcb+repmat([xposcirccb yposcirccb],300,1);

vertcirccb = []; faccirccb = nan(300,4);
for ifaccirccb = 1:300
    if ifaccirccb<300
        vtc(1,:) = circin(ifaccirccb,:);
        vtc(2,:) = circin(ifaccirccb+1,:);
        vtc(3,:) = circout(ifaccirccb+1,:);
        vtc(4,:) = circout(ifaccirccb,:);
    else
        vtc(1,:) = circin(ifaccirccb,:);
        vtc(2,:) = circin(1,:);
        vtc(3,:) = circout(1,:);
        vtc(4,:) = circout(ifaccirccb,:);
        
    end
   
   % create faces, check whether identical vertcirccbices exist already, reuse
   vkill=[];
   if ifaccirccb>1
       for iv=1:4
           i = find(sum((vertcirccb - repmat(vtc(iv,:),size(vertcirccb,1),1)).^2)==0); % check whether vertcirccbex exists already
           if ~isempty(i)
               faccirccb(ifaccirccb,iv) = i; % reuse vertcirccbex
               vkill = iv;
           else
               faccirccb(ifaccirccb,iv) = size(vertcirccb,1)+iv-numel(vkill);
           end
       end
       vtc(vkill,:)=[];
       vertcirccb = [vertcirccb;vtc];
   else
       faccirccb(ifaccirccb,:)=1:4;
       vertcirccb(1:4,:)=vtc;
   end
   
end

save(sprintf('%s/%s_grid.mat',MRIDIR,Microdrive),'vert','fac','EX','EY','centers','vertcb','faccb','xposcb','xsizecb','yposcb','ysizecb','vertcirccb','faccirccb','circin','circout','xposcirccb','yposcirccb','outradcb','inradcb')