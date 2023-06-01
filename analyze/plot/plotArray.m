function IMG=plotArray(y,opt)
% IMG=plotArray(y,opt)
%
% Plots data of electrode arrays onto MRI underlays. When called without
% output it shows the plot in a matlab figure. If called with output the
% function returns an image matrix. Needs opengl as renderer for displaying
% transparency.
%
% Required:
% y: Nx1 data vector, one value per electrode. SC32 and SC96 are known and
% automatically loaded. Other microdrives must be specified accordingly.
%
% Optional:
% opt: Structure with fields containing ploting options
%
%   opt.underlay: 
% String. Name of MRI underlay in the monkey's MRIDIR, defaults to 'none'.
% See createArrayMRIUnderlay.m
%
%   opt.electrodegrid: 
% String. Name of electrodegrid in monkey's MRIDIR, defaults to the
% standard grids for SC32 in case of numel(y)==32 and the SC96 grid for
% numel(y)==96. The standard files are part of the analyze repository. See
% createArrayElectrodeGrid.m
% 
%   opt.depth: 
% Scalar. Depth of the MRI underlay in mm. Defaults to half of maximal depth.
%
%   opt.maxval: 
% Scalar. Maximum value for colorscale. Symmetric for positive and negative
% values.
%
%   opt.threshold: 
%  Scalar. Minimum value for colorscale. Symmetric for positive and
%  negative values.
% 
%   opt.facealpha: 
% Scalar between 0 and 1. Transparency of the data overlay.Defaults to 0.4
%
%   opt.plotelectrodes: 
% 0 or 1. Plot electrode centers.
% 
%   opt.electrodemarkers: 
% String. Ploting style of electrode markers. Defaults to 'k.'. If
% 'numbers' electrode numbers are ploted in addition to 'k.' for each
% electrode.
%
%   opt.colormap:
% String or matrix of size [300 3] specifying RGB values. possible options:
% 'default','chique' or any of matlabs colormaps. First half of the
% colormap is reserved to negative values. Second half of the colormap is
% reserved to positive values. 
% 
%   opt.mrixlim:
% Two element vector. Specifies the spatial X range in which MRI underlay is
% shown in mm. E.g. [-15 15]. Defaults to scaled to electrode grid.
%
%   opt.mriylim:
% Two element vector. Specifies the spatial Yrange in which MRI underlay is
% shown in mm. E.g. [-15 15]. Defaults to scaled to electrode grid.
%
%   opt.mricscale:
% Two element vector. [Min Max] intensity for colorscale of MRI. Defaults
% to [prctile(mri(:),2.5) prctile(mri(:),97.5)].
%
%   opt.plotcolorbar:
% 0 or 1. Shows or hides the colorbar. Defaults to 1.
%
%   opt.plotcolorbarlabels:
% 0 or 1. Shows or hides the colorbar tick labels. Defaults to 0.
%
%   opt.plotsizebar:
% 0 or 1. Shows or hides the 1mm size bars for X/Y. Defaults to 1.
%
%   opt.circularcolorbar:
% 0 or 1. Assumes data to be in radians, scales to -pi:pi, uses hsv as
% colormap Defaults to 0.
%
%   opt.plotsizebar:
% Scalar. Resolution of image output in DPI.
%
%   opt.showfigure:
% 0 or 1. Show the figure after ploting or keep it invisible.



global MONKEYDIR MONKEYNAME

% uses patch and transparency to display data on MRI underlay. open gl is
% required.
ogl = opengl('info');
if ~ogl; error('Please make sure opengl is installed properly and matlab is started using the -softwareopengl flag.\n Alternatively add the command <opengl software> at the top of your startup.m file\n');end

% set default options
if nargin<2; opt = []; end
if ~isfield(opt,'underlay'); opt.underlay = 'none'; end
if ~isfield(opt,'electrodegrid'); opt.electrodegrid = nan'; end
if ~isfield(opt,'depth'); opt.depth = nan; end
if ~isfield(opt,'facealpha'); opt.facealpha = 0.4'; end
if ~isfield(opt,'plotelectrodes'); opt.plotelectrodes = 1; end
if ~isfield(opt,'electrodemarkers'); opt.electrodemarkers = 'k.'; end
if ~isfield(opt,'maxval'); opt.maxval = max(abs(y)); end
if ~isfield(opt,'threshold'); opt.threshold = 0; end
if ~isfield(opt,'colormap'); opt.colormap = 'default'; end % default, chique
if ~isfield(opt,'mrixlim'); opt.mrixlim = nan; end % spatial x extent of underlay, default scaled to grid
if ~isfield(opt,'mriylim'); opt.mriylim = nan; end % spatial y extent of underlay, default scaled to grid
if ~isfield(opt,'mricscale'); opt.mricscale = nan; end % spatial y extent of underlay, default scaled to grid
if ~isfield(opt,'plotcolorbar'); opt.plotcolorbar = 1; end % show the colorbar
if ~isfield(opt,'plotcolorbarlabels'); opt.plotcolorbarlabels = 1; end
if ~isfield(opt,'circularcolorbar'); opt.circularcolorbar = 0; end
if ~isfield(opt,'plotsizebar'); opt.plotsizebar = 1; end 
if ~isfield(opt,'res'); opt.res = 200; end % DPI
if ~isfield(opt,'showfigure'); opt.showfigure = 1; end % DPI

if ~strcmp(opt.underlay,'none')
    MRIDIR = [MONKEYDIR '/MRI'];
    if ~exist(MRIDIR); error(sprintf('MONKEYDIR/MRI not found. Please see the WIKI for instructions for setting up a monkey specific MRI dir.\n'));else addpath(MRIDIR);end
end

% linearize
y=y(:);
nd=numel(y);

% load up the right electrode grid
if ischar(opt.electrodegrid)
    load(sprintf('%s/%s',MRIDIR,opt.electrodegrid))
    fprintf('Electrodegrid: %s\n',opt.electrodegrid)
    if size(fac,1)~=nd
       error('Electrode grid does not match input') 
    end
else
    if nd == 96 % SC96
        load('SC96_standard_grid.mat')
        fprintf('Electrodegrid: SC96 standard grid\n')
    elseif nd == 32 % SC32
        load('SC32_standard_grid.mat')
        fprintf('Electrodegrid: SC32 standard grid\n')
    elseif nd == 220 % vSUBNETS220
        load('vSUBNETS220_grid.mat')
        fprintf('Electrodegrid: vSUBNETS220 grid\n')
    else
        error('unknown microdrive')
    end
end


% load up MRI underlay
if ~strcmp(opt.underlay,'none') 
    load(sprintf('%s/%s.mat',MRIDIR,opt.underlay))
    if ~isnan(opt.depth)
        mri = MRI(:,:,DEPTH==opt.depth);
    else
        mri = MRI(:,:,ceil(end/2));
        opt.depth = DEPTH(ceil(end/2));
    end
    fprintf('MRI underlay: %s at %.1fmm\n',opt.underlay,opt.depth)
    
    Xmri = SIZE(1):RES:SIZE(2);
    Ymri = SIZE(3):RES:SIZE(4);
    if isnan(opt.mricscale)
        mricscale = [prctile(MRI(:),2.5) prctile(MRI(:),97.5)];
    else
        mricscale = opt.mricscale;
    end
else % otherwise specify white background
    mri = ones(5);
    Xmri = EX;
    Ymri = EY;
    mricscale = [0 1];
end

% extent of the underlay
if any(isnan(opt.mrixlim))
    if opt.plotcolorbar==1
        if ~opt.circularcolorbar
            mrixlim = [EX(1)-0.5 xposcb+2*xsizecb]; % include colorbar
        else
            mrixlim = [EX(1)-0.5 xposcirccb+outradcb+0.5]; % include colorbar
        end
    else
        mrixlim = [EX(1)-0.5 EX(end)+0.5];
    end
else
   mrixlim=opt.mrixlim;
end
if any(isnan(opt.mriylim))
   mriylim = [EY(1)-0.5 EY(end)+0.5]; 
else
   mriylim=opt.mriylim;
end

% create figure or reuse the figure specified by user
f1 = gcf;
set(f1,'Visible','off')
set(f1,'Renderer','OpenGL')

% plot MRI underlay
tvimage(mri,'XRange',[Xmri(1) Xmri(end)],'YRange',[Ymri(1) Ymri(end)]);
h1=gca;
% set(h1,'CDataMapping','scaled')
caxis(mricscale)
xlabel('mm');  ylabel('mm')
xlim(mrixlim)
ylim(mriylim)
axis square

% data colormap
if ischar(opt.colormap)
    if ~opt.circularcolorbar
        if strcmp(opt.colormap,'default')
            colmap_pos = [...
                [linspace(1,1,70)';   linspace(1,1,40)';     linspace(1,0.5,40)'],...
                [linspace(1,0.5,70)'; linspace(0.5,0,40)';   linspace(0,0,40)'],...
                [linspace(0,0,70)';   linspace(0,0,40)';     linspace(0,0,40)']];
            colmap_neg = [...
                [linspace(0,0,40)';      linspace(0,0,70)';      linspace(0,0.75,40)'],...
                [linspace(0,0,40)';      linspace(0,1,70)';      linspace(1,1,40)'],...
                [linspace(0.75,1,40)';    linspace(1,1,70)';      linspace(1,1,40)']];
            colmap = cat(1,colmap_neg,colmap_pos);
            nsteps = size(colmap,1)./2;
            colmap=[colmap;[1 1 1]]; % add white for nan, thresholded values
        elseif strcmp(opt.colormap,'chique')
            colmap_pos = [...
                [linspace(0.75,1,50)';    linspace(1,1,100)'],...
                [linspace(0,0,50)';    linspace(0,1,100)'],...
                [linspace(0.75,0,50)'; linspace(0,0,100)']];
            colmap_neg = [...
                [linspace(0,0,60)';    linspace(0,0,50)';      linspace(0,0,40)'],...
                [linspace(1,1,60)';    linspace(1,0,50)';      linspace(0,0,40)'],...
                [linspace(0,1,60)';    linspace(1,1,50)';      linspace(1,0.5,40)']];
            colmap = cat(1,colmap_neg,colmap_pos);
            nsteps = size(colmap,1)./2;
            colmap=[colmap;[1 1 1]]; % add white for nan, thresholded values
        else
            eval(sprintf('colmap = %s(300);',opt.colormap));
            nsteps = size(colmap,1)./2;
            colmap=[colmap;[1 1 1]]; % add white for nan, thresholded values
        end
    else
        colmap = hsv(300);
        nsteps = size(colmap,1);
        colmap=[colmap;[1 1 1]];
    end
else
    if sum(size(opt.colormap)==[300 3])~=2
        error('colormap must have size 300x3')
    end
    colmap = opt.colormap;
    nsteps = size(colmap,1)./2;
    colmap=[colmap;[1 1 1]];
end

% map functional values to colormap
if opt.threshold > opt.maxval
   opt.threshold = opt.maxval*(1-1e-14);
end

if ~opt.circularcolorbar
    ypos = (y-opt.threshold)/(opt.maxval-opt.threshold);
    ypos(ypos<0) = nan;
    ypos(ypos==0) = 1e-7;
    ypos(ypos>=1) = 1;
    yhalf = 0.5.*opt.maxval+opt.threshold;
    idx_pos = ceil(ypos*nsteps);
    
    yneg = (-y-opt.threshold)/(opt.maxval-opt.threshold);
    yneg(yneg<0) = nan;
    yneg(yneg>=1) = 1-1e-7;
    idx_neg = ceil((1-yneg)*nsteps);
    
    idx_color = nanmean(cat(2,idx_neg(:),idx_pos(:)+nsteps),2);
    idx_color(isnan(idx_color)) = nsteps.*2+1;
    col = colmap(round(idx_color),:);
else
    % wrap data to -pi/pi
    ys=y./(2.*pi); % multiples of 2pi
    ysr=ys;ysr(ysr<0)=ceil(ysr(ysr<0));ysr(ysr>0)=floor(ysr(ysr>0)); % remove multiples of 2 pi
    y=ys-ysr;  % remove multiples of 2 pi
    y=y.*2.*pi;
    y(y<-pi)=y(y<-pi)+2.*pi; % wrap to range -pi, pi
    y(y>pi)=y(y>pi)-2.*pi;
    y=(y+pi)./(2.*pi); % normalize to 0-1;
    idx_color = round(y.*nsteps);
    idx_color(idx_color==0)=1;
    idx_color(isnan(idx_color))=nsteps+1;
    col = colmap(idx_color,:);
end

% set data patch transparency
adata = ones(numel(y),1).*opt.facealpha;adata(find(idx_color==nsteps.*2+1))=0;

% data patch
h2 = patch('Vertices', vert, 'Faces', fac, 'FaceVertexCData', col, 'FaceColor', 'flat','FaceVertexAlphaData',adata,'FaceAlpha','flat','EdgeColor','none');
alim([0 1])
% h1 = patch('Vertices', [vert(:,2) vert(:,1)], 'Faces', fac, 'FaceVertexCData', col, 'FaceColor', 'interp');
set(h2,'Facelighting','none')

% colorbar patch, ticks and labels
if opt.plotcolorbar==1
    if ~opt.circularcolorbar
        h3 = patch('Vertices', vertcb, 'Faces', faccb, 'FaceVertexCData', colmap(1:end-1,:), 'FaceColor', 'flat','FaceAlpha',1,'EdgeColor','none');
        alim([0 1])
        % ticks
        ticky=linspace(yposcb(1)-mean(diff(yposcb))/2,yposcb(end)+mean(diff(yposcb))/2,5);
        ticklabels = [-opt.maxval -yhalf opt.threshold yhalf opt.maxval];
        hold on
        for itick=1:5
            plot([xposcb-xsizecb./2 xposcb+xsizecb./2],[ticky(itick), ticky(itick)],'k-')
            if opt.plotcolorbarlabels
                tcb=text(xposcb+xsizecb./2, ticky(itick),sprintf('%.2f',ticklabels(itick)),'HorizontalAlignment','Left','VerticalAlignment','Middle');
                %             set(tcb,'rotation',90)
            end
        end
    else
        h3 = patch('Vertices', vertcirccb, 'Faces', faccirccb, 'FaceVertexCData', colmap(1:end-1,:), 'FaceColor', 'flat','FaceAlpha',1,'EdgeColor','none');
        alim([0 1])
        % ticks
        tick_right = [[xposcirccb+inradcb xposcirccb+outradcb]'  [yposcirccb yposcirccb]'];
        tick_top   = [[xposcirccb xposcirccb]'  [yposcirccb+inradcb yposcirccb+outradcb]'];
        tick_left = [[xposcirccb-inradcb xposcirccb-outradcb]'  [yposcirccb yposcirccb]'];
        tick_down = [[xposcirccb xposcirccb]'  [yposcirccb-inradcb yposcirccb-outradcb]'];
        
        hold on
        plot(tick_right(:,1),tick_right(:,2),'k-')
        plot(tick_top(:,1),tick_top(:,2),'k-')
        plot(tick_left(:,1),tick_left(:,2),'k-')
        plot(tick_down(:,1),tick_down(:,2),'k-')
        
        halfrad = inradcb+outradcb/2;
        if opt.plotcolorbarlabels
            text(xposcirccb+halfrad, yposcirccb,'-pi','HorizontalAlignment','Right','VerticalAlignment','Bottom'); % right, up
            text(xposcirccb+halfrad, yposcirccb,'pi','HorizontalAlignment','Right','VerticalAlignment','Top'); % right, down
            tcb=text(xposcirccb, yposcirccb+halfrad,'-pi/2','HorizontalAlignment','Right','VerticalAlignment','Top','Rotation',90); % top
            tcb=text(xposcirccb-halfrad, yposcirccb,'0','HorizontalAlignment','Left','VerticalAlignment','Bottom'); % left
            tcb=text(xposcirccb, yposcirccb-halfrad,'pi/2','HorizontalAlignment','Right','VerticalAlignment','Top','Rotation',-90); % down
        end


    end
end

% add electrodes on top
hold on
if opt.plotelectrodes
    if strcmp(opt.electrodemarkers,'numbers')
        for iel=1:numel(y)
            text(centers(iel,1),centers(iel,2),sprintf('%d',iel))
        end
        plot(centers(:,1),centers(:,2),'.k')
    else
        plot(centers(:,1),centers(:,2),opt.electrodemarkers)
    end
end

% add size bars
if opt.plotsizebar ==1
    plot([EX(1)+1 EX(1), EX(1)], [EY(1) EY(1), EY(1)+1],'k-','LineWidth',1)
    text(EX(1),EY(1),'1mm','HorizontalAlignment','Left','VerticalAlignment','Bottom')
end

% no axes, white background
axis off
set(f1,'Color',[1 1 1])

% set underlay colormap back to bone
colormap(f1,'bone')

% set aspect ratio to be equal for x/y
ar = daspect;
daspect([max(ar) max(ar) 1])

% add information in the title
if ~opt.circularcolorbar
    title(sprintf('MRI: %s | Depth: %.1f\nmax: %.2f | half: %.2f | thresh: %.2f',opt.underlay,opt.depth,opt.maxval,yhalf,opt.threshold))
else
    title(sprintf('MRI: %s | Depth: %.1f',opt.underlay,opt.depth))
end

% show figure or return IMG matrix
if nargout == 1
    tmpname = sprintf('./%d%d%d%d%d.png',ceil(rand(1).*1000),ceil(rand(1).*1000),ceil(rand(1).*1000),ceil(rand(1).*1000),ceil(rand(1).*1000));
    print('-dpng',tmpname,sprintf('-r%i',opt.res));
    IMG=imread(tmpname);
    eval(sprintf('!rm %s',tmpname))
    close(f1)
elseif opt.showfigure
    set(f1,'Visible','on')
else
    fprintf('done, invisible figure\n')
end


