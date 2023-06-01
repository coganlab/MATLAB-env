function fig = psthreadfig()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
% This problem is solved by saving the output as a FIG-file.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.
% 
% NOTE: certain newer features in MATLAB may not have been saved in this
% M-file due to limitations of this format, which has been superseded by
% FIG-files.  Figures which have been annotated using the plot editor tools
% are incompatible with the M-file/MAT-file format, and should be saved as
% FIG-files.

load psthreadfig

h0 = figure('Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'FileName','D:\Matlab\user\psthreadfig.m', ...
	'Name','PSTH-Read V1.0a', ...
	'NumberTitle','off', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperType','A4', ...
	'PaperUnits','points', ...
	'Position',[7 75 1015 557], ...
	'Resize','off', ...
	'Tag','psthreadfig', ...
	'ToolBar','none', ...
	'DefaultlineLineWidth',1.5);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'ListboxTop',0, ...
	'Position',[1.5 1.5 760.5 27.75], ...
	'Style','frame', ...
	'Tag','Frame1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'Callback','psthread(''Load'')', ...
	'ListboxTop',0, ...
	'Position',[3 5.25 29.25 20.25], ...
	'String','Load', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'Callback','psthread(''Exit'')', ...
	'ListboxTop',0, ...
	'Position',[734.25 4.5 24.75 21], ...
	'String','Exit', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','psthread(''Phase'');', ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[452.25 8.25 29.25 15], ...
	'String','0', ...
	'Style','edit', ...
	'Tag','EditPhaseBox', ...
	'TooltipString','Enter the phase for the model to match the raw PSTH for the centre');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[420.75 6.75 30 15.75], ...
	'String','Phase:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback',mat1, ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[549 7.5 29.25 15], ...
	'String','0', ...
	'Style','edit', ...
	'Tag','EditSelectBox', ...
	'TooltipString','Just look at one PSTH in greater detail');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[518.25 6 30 15.75], ...
	'String','Select:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'Callback','psthread(''FFT'')', ...
	'ListboxTop',0, ...
	'Position',[33.75 5.25 23.25 20.25], ...
	'String','FFT', ...
	'Tag','Pushbutton2', ...
	'TooltipString','Perform FFT calculation');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'Callback','psthread(''Simplex'')', ...
	'ListboxTop',0, ...
	'Position',[58.5 5.25 25.5 20.25], ...
	'String','Splex', ...
	'Tag','Pushbutton3', ...
	'TooltipString','Perform Ratio calculation');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[84 8.25 32.25 14.25], ...
	'String','0.992', ...
	'Style','edit', ...
	'Tag','EditRatio', ...
	'TooltipString','The ratio from which to find the peaks for the inner alone');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'ListboxTop',0, ...
	'Position',[372 9 42.75 15], ...
	'String','Rectify', ...
	'Style','checkbox', ...
	'Tag','RectifyBox', ...
	'TooltipString','Rectifies the inner and outer before interaction model calculation', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','psthread(''Phase'');', ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[332.25 9 38.25 15], ...
	'String','-0.9', ...
	'Style','edit', ...
	'Tag','EditLevel', ...
	'TooltipString','Enter the level for rectification for the centre / surround');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'Callback','psthread(''Minimise'')', ...
	'ListboxTop',0, ...
	'Position',[126 4.5 33 20.25], ...
	'String','Minimise', ...
	'Tag','Pushbutton1', ...
	'TooltipString','Find optimal rectification and phase for a cell');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.35 0.35 0.4], ...
	'ListboxTop',0, ...
	'Position',[118.5 3 6 24.75], ...
	'Style','frame', ...
	'Tag','Frame2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.35 0.35 0.4], ...
	'ListboxTop',0, ...
	'Position',[411.75 3 7.5 24.75], ...
	'Style','frame', ...
	'Tag','Frame2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.35 0.35 0.4], ...
	'ListboxTop',0, ...
	'Position',[695.25 3 6 24.75], ...
	'Style','frame', ...
	'Tag','Frame2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'Callback','psthread(''Spawn'')', ...
	'ListboxTop',0, ...
	'Position',[704.25 4.5 28.5 21], ...
	'String','Spawn', ...
	'Tag','Pushbutton1', ...
	'TooltipString','Output to a new figure');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[159.75 5.25 69 18.75], ...
	'String',mat2, ...
	'Style','popupmenu', ...
	'Tag','MinimiseMenu', ...
	'TooltipString','Use the Inner or Outer when minimising on single PSTHor FFT', ...
	'Value',1);
h1 = axes('Parent',h0, ...
	'Units','pixels', ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat3, ...
	'GridLineStyle','-', ...
	'Layer','top', ...
	'LineWidth',1.5, ...
	'Position',[55 99 911 416], ...
	'Tag','Axes1', ...
	'TickDirMode','manual', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4989010989010989 -0.05783132530120483 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.03186813186813187 0.4963855421686747 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',mat4, ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'FontSize',12, ...
	'FontWeight','bold', ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4989010989010989 1.016867469879518 9.160254037844386], ...
	'String',mat5, ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','psthread(''Phase'');', ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[262.5 9 38.25 15], ...
	'String','0', ...
	'Style','edit', ...
	'Tag','EditLevel2', ...
	'TooltipString','Enter the level for rectification for the interaction, usually 0');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[231.75 8.25 30 15.75], ...
	'String','Model:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[303 8.25 30 15.75], ...
	'String','Input:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','psthread(''Phase'');', ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[483.75 8.25 29.25 15], ...
	'String','0', ...
	'Style','edit', ...
	'Tag','EditPhaseBox2', ...
	'TooltipString','Enter the phase for the model to match the raw PSTH for the surround');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','psthread(''Phase'');', ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[621.75 7.5 24.75 15], ...
	'String','1', ...
	'Style','edit', ...
	'Tag','EditStrength', ...
	'TooltipString','Scales the surround to vary its strength, 1=equal / 0.5=half');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.7 0.7 0.7], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[582 6.75 40.5 15.75], ...
	'String','Strength:', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','psthread(''Phase'');', ...
	'Enable','off', ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[669 7.5 24.75 15], ...
	'String','0', ...
	'Style','edit', ...
	'Tag','EditScale', ...
	'TooltipString','Use to scale the whole model to the data, if 0 it is set automagically');
if nargout > 0, fig = h0; end
