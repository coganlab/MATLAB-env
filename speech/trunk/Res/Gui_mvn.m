% interface for creating mvn data from mvngrps



figure('Color',[0.8 0.8 0.8], ...
    'Name','Multivariate Normal Data Generator',...
    'Units','normalized');	
%initial values
n=3;
k=2;
betw=0;
r=0;
%create 
uicontrol('Units','normalized',...
     'BackgroundColor',[ 0.0941176470588235 0.133333333333333 0.803921568627451 ],...
	'Callback','p=3;[x,g,m] = mvngrps(k,n,p,2,r);cla;x=x+design(g)*(betw.*(rand(k,p)-.5));plotgrps(x(:,1),x(:,2),g);', ...
	'Position',[ 0.699619771863118 0.319634703196347 0.216730038022814 0.0981735159817352 ], ...
	'String','create');

	
% correlation r=
uicontrol('Units','normalized',...
    'Max',1,  'Min',0,  ...
	'Callback','Value=get(gcbo,''Value'');r=Value;uicontrol(''Units'',''normalized'',''Position'',[ 0.5476 0.31513 0.11609 0.06451 ],''String'',strcat(''r='',''....'',num2str(r)),''Style'',''text'');',...
	'Position',[ 0.089709 0.32258 0.414248 0.05459 ], ...
	'Style','slider', ...
	'Tag','number in groups', ...
	'Value',0);
uicontrol('Units','normalized',...
	'Position',[ 0.5476 0.31513 0.11609 0.06451 ], ...
	'String',strcat('r=','... ',num2str(r)),...
	'Style','text', ...
	'Tag','none');	
% number in group
uicontrol('Units','normalized',...
    'Max',1,  'Min',0,  ...
	'Callback','Value=get(gcbo,''Value'');n=round(100*Value)+3;uicontrol(''Units'',''normalized'',''Position'',[ 0.547 0.1247 0.359 0.0646 ],''String'',strcat(''NUMBER IN GROUP'',''....'',num2str(n)),''Style'',''text'');',...
	'Position',[ 0.093478260 0.12527027027027 0.415217 0.0646540540540541 ], ...
	'Style','slider', ...
	'Tag','number in groups', ...
	'Value',0);
uicontrol('Units','normalized',...
	'Position',[ 0.547 0.1247 0.359 0.0646 ], ...
	'String',strcat('NUMBER IN GROUP','... ',num2str(n)),...
	'Style','text', ...
	'Tag','none');
% number of groups
uicontrol('Units','normalized',...
    'Max',1,  'Min',0,  ...
	'BackgroundColor',[1 1 1], ...
	'Callback','Value=get(gcbo,''Value'');k=round(5*Value)+2;uicontrol(''Units'',''normalized'',''Position'',[ 0.5423 0.2078 0.3518 0.069 ],''String'',strcat(''NUMBER OF GROUPS'',''....'',num2str(k)),''Style'',''text'');',...
	'Position',[ 0.093478260 0.229189189189189 0.415217 0.058513513513514 ], ...
	'Style','slider', ...
	'Tag','number of groups', ...
	'Value',0);
uicontrol('Units','normalized',...
    'Max',1,  'Min',0,  ...
	'Position',[ 0.542320 .2078521 0.351851851851852 0.069284064665127 ], ...
	'String',strcat('NUMBER OF GROUPS','... ',num2str(k)),...
	'Style','text', ...
	'Tag','none');
% distance among groups
uicontrol('Units','normalized',...
	'Callback','Value=get(gcbo,''Value'');betw=100.*Value;uicontrol(''Units'',''normalized'',''Position'',[ 0.560 0.0207 0.357 0.0692 ],''String'',strcat(''DISTANCE AMONG GROUPS'',''....'',num2str(betw)),''Style'',''text'');', ...
	'Position',[ 0.093478260 0.04571 0.415217  0.054285 ], ...
	'Style','slider', ...
	'Tag','Slider2', ...
	'Value',0);
uicontrol('Units','normalized',...
	'Position',[ 0.560 0.0207 0.357 0.0692 ], ...
	'String',strcat('DISTANCE AMONG GROUPS','....',num2str(betw)), ...
	'Style','text');
% plot 
axes('Units','normalized',...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'Position',[ 0.0936170 0.483253 0.85957446 0.4808612 ], ...
	'Tag','Axes1');

