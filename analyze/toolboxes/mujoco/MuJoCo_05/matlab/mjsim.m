%MJSIM   Simulate MuJoCo model
%
%  MJSIM							plot and simulate the current model
%									automatically saves a recording in the workspace
%		
%  DATA = MJSIM						saves simulation data in a struct-array
%									see getData() below
%		
%  DATA = MJSIM(callback)			calls the user-defined call back function
%									callback() at every time step.
%
%  DATA = MJSIM(callback, t_max)	no plotting, terminates when t >= t_max
%
% This file is part of the MuJoCo software.
% (C) 2012 Emo Todorov. All rights reserved.

function  DATA = mjsim(callback, t_max)

% --- make sure model is loaded
if ~mj('ismodel'),
	error 'MuJoCo model must be loaded first';
end
model = mj('getmodel');

% --- check inputs
if nargin == 0
	callback = [];
else
	if ~isa(callback,'function_handle')
		callback = [];
	end
end

% --- preallocate DATA struct-array
buffMB			= 1000;       % size of circular buffer in MBytes
data			= getData;
datainfo		= whos('data');
nBuffer			= round(buffMB * 2^20 / datainfo.bytes);
DATA(1:nBuffer)	= data;
bufferFull		= false;

% --- initialize GUI
if nargin < 2
	t_max	= inf;	
	fig		= findobj(0,'Tag','mjplot');
	if isempty(fig)
		fig = mjplot();
	end	
	setappdata(fig,'running_sim',true);
	GUI	= getappdata(fig,'GUI_ax');
	initGUI(GUI);	
else
  	fig = [];
end

% --- initialize counters
step			= 1;		% discrete-time counter
mj('set','time',0);			% simulation time
t				= 0;		% perceived time
tic_frame		= tic;		% last wall-time measurement
tic_start		= tic;		% initial wall-time measurement

% filtered quantities
filter_frame	= 1e-3;
filter_pause	= 0;
filter_plot		= 0;
gamma			= 0.8;		% 0 <= gamma < 1; 0: no filtering;  1: no leakage

% ===================== %
% ====  main loop  ==== %
% ===================== %
running = true;
while running && mj('get','time') < t_max
	% check for user-requested reset
	if ~isempty(fig)
		key = getappdata(fig,'lastkey');
		if ~isempty(key) && strcmp(key,'backspace')
			mj reset
			t			= 0;
			tic_start	= tic;
			mj('set','qvel', 1e-4*randn(model.nv, 1))
			setappdata(fig,'lastkey',[]);
		end
	end
	
	% ====  dynamics  ==== %	
	% --- step1
	mj('set','qfrc_applied',zeros(model.nv,1))
	mj step1;
    
	% --- user callback
	if ~isempty(callback)
		feval(callback, model);
	end
	
	% --- rope impulse
	rope_impulse(fig)	
	
	% --- step2
	mj step2;
	
	% --- reset if any warnings were thrown
	if any(mj('get','nwarning'))
		mj reset
		t	= 0;
		if ~isempty(fig)
			setappdata(fig,'rope',[])
		end
	end
	
	% ====  graphics and/or pausing ==== %
	if ~isempty(fig)
		% get user-set parmeters
		slowdown	= getappdata(GUI,'slowdown');
		frame_dt	= getappdata(GUI,'frame_dt');
		
		% --- graphics --- %
		time		= mj('get','time');		% simulation time
		t_last		= toc(tic_frame);		% time elapsed from last frame
		t_now		= t + t_last/slowdown;	% current perceived time
		sparetime	= time - t_now;			% spare time
		if ( sparetime > 0 && t_last > (frame_dt - filter_plot) ) ... if we have spare time and enough time has elapsed
			|| t_last > 0.2									   ... or if too much time has elapsed (200 ms)
			
			tic_plot	= tic;
			% --- info text 
			plot_text(1000*filter_plot, time, 1/filter_frame, toc(tic_start), filter_pause);
			
			% --- graphics
			mjplot();

			% --- filter plotting and frame time
			filter_plot		= gamma * filter_plot	+ (1 - gamma) * toc(tic_plot);
			filter_frame	= gamma * filter_frame  + (1 - gamma) * toc(tic_frame);
			
			% --- update t
			t				= t + toc(tic_frame)/slowdown;
			tic_frame		= tic; 
		end
		
		% --- pause --- %
		t_now		= t + toc(tic_frame)/slowdown;	% perceived time
		sparetime	= time - t_now;
		tpause		= 0;
		if sparetime > 0
			% --- pause if there's time left and update timers and counters
			tpause	= floor(0.2*sparetime*1000);	% wait for 0.2 * sparetime
			if exist('sleep','file')==3
				sleep(max(0,tpause));					% tpause is in milliseconds
			else
				pause(max(0,tpause)/1000);
			end
		end
		
		filter_pause  = gamma*filter_pause + (1 - gamma) * tpause;
	end
	
	% --- increment step, wrap circular buffer, save data
	step  = step + 1;
	if step > nBuffer
		step		= 1;
		bufferFull	= true;
	end
	DATA(step)	= getData;
	
	% check for stopping
	if ishandle(fig)
		running = getappdata(fig,'running_sim');	
	else
		if ~isempty(fig)
			running = false;
		end
	end
end

% trim or sort output buffer
if ~bufferFull
   DATA  = DATA(1:step);
else
   tt       = [DATA.time];
   [~,ix]   = sort(tt);
   DATA     = DATA(ix);
end

% put user-applied rope force in qfrc_external
function rope_impulse(fig)

if isempty(fig)
	return
end
rope = getappdata(fig,'rope');

% rope stretch reduction time-scale
tau		= 0.05;

%		=== posthoc impulse for unilateral rope-length constraint ===
applied = mj('get','qfrc_applied');
if ~isempty(rope)
	% get position of anchor geom
	geom_xpos	= mj('get','geom_xpos');
	anchor		= geom_xpos(rope.geom,:);
	fromto		= rope.cursor - anchor;
	
	% get normalized force direction
	fdir	= fromto;
	fdir	= fdir ./ norm(fdir);
	
	% position Jacobian of the selected geom
	J		= mj('jacgeom',rope.geom-1); % C-style indexing
	
	% project onto force direction
	Jf		= fdir*J;		
	
	% get the 'A scalar'
	LD		= mj('get','qLD');
	L		= triu(LD,1) + eye(size(LD)); 
	D		= diag(sqrt(diag(LD)));
	P		= (L*D)\Jf';
	A		= P'*P;
	
	% get v0
	v0		= Jf*mj('get','qvel_next');
	
	% get v_min
	stretch = norm(fromto) - rope.length;
	dt		= mj('get','dt');	
	v_min	= stretch/max(tau,dt);
	
	% get the impulse, constrain it to be tensile
	if A > 0
		f = max(0, (v_min - v0) / A ) / dt;	
	else
		f = 0*v0;
	end
	
	% project back onto torques 
	u = Jf' * f;
else
	u = 0*applied;
end
% copy into mujoco
mj('set','qfrc_applied',u + applied);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  GUI functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- make the status text
function plot_text(varargin)
names		= {'plot','mujoco','fps','wall','pause'};
units		= {'ms','s','Hz','s','ms'};
format		= '%-7s%5.1f %-6s';
string		= [format format '\n' format format format];
print_args	= [names; varargin; units];
set(findobj('tag','info_text'),'string', sprintf(string, print_args{:}))


function initGUI(panel)

% --- initialize
if isempty(getappdata(panel,'initialized'))

	% clear the panel
	delete(get(panel,'children'))

	% build the GUI elements of the subpanels
	controls	= make_controls(panel);
	options		= make_options(panel);

	% align all the objects 
	objects		= [controls; options];
	alignHandles(objects(end:-1:1),2,ones(size(objects)),[0.02 0.02])

	% --- set global  properties
	% font size
	fontsize = 8;

	% edit boxes
	edit = findobj(panel,'style','edit');
	set(edit,'FontName','FixedWidth','FontSize',fontsize,'Horiz','Center','BackgroundColor', 'w');

	% text boxes
	text = findobj(panel,'style','text');
	set(text,'FontSize',fontsize,'Horiz','Left');

	% fix heights
	obj = [edit; text];
	for i = 1:length(obj)
		set(obj(i),'units','points');
		pos		= get(obj(i),'pos');
		pos(4)	= 13;
		set(obj(i),'pos',pos);
		set(obj(i),'units','normalized');
	end

	setappdata(panel,'initialized',true)
% 	set(panel,'visible','on');
end

update_panel(panel)


function controls = make_controls(panel)

% framerate panel
framerate_panel	= uipanel(panel,'BorderType','none');
frame_name		= uicontrol(framerate_panel,'Style', 'text','String','framerate');  
frame_Hz_edit	= uicontrol(framerate_panel,'Style', 'edit','user',0);  
frame_Hz		= uicontrol(framerate_panel,'Style', 'text','String','fps');  
frame_ms_edit	= uicontrol(framerate_panel,'Style', 'edit','user',1);  
frame_ms		= uicontrol(framerate_panel,'Style', 'text','String','ms'); 
alignHandles([frame_name frame_Hz_edit frame_Hz frame_ms_edit frame_ms ],1,[5 3 2 3 1.5],[.01 0],0)
% set callbacks and initial framerate
set(frame_Hz_edit,'Callback', @(src,evt) set_framerate(src, frame_ms_edit, panel),'string','25');
set(frame_ms_edit,'Callback', @(src,evt) set_framerate(src, frame_Hz_edit, panel),'string','40');
setappdata(panel,'frame_dt',40/1000)

% slowdown panel
[slowdown_panel,slowdown_edit]	= edit_panel(panel,'slowdown');
set(slowdown_edit,'String', num2str(1),'Callback', @(src,evt) set_slowdown(src, panel))
setappdata(panel,'slowdown',1)			% put in panel for access from mjsim

% dt panel
[dt_panel,dt_edit]		= edit_panel(panel,'timestep (ms)');
set(dt_edit,'Callback', @set_dt )
setappdata(panel,'dt_edit',dt_edit)		% put in panel for access from mjsim

controls = [framerate_panel slowdown_panel dt_panel]';


function option = make_options(panel)
% get options
mjOpt	= getOption();
names	= fieldnames(mjOpt);
nopt	= length(names);

% tooltips
tips	= struct(...
			'algorithm',	sprintf('0: DIAGONAL\n1: JACOBI\n2: GS\n3: GS2\n4: CG\n5: PCG\n6: NEWTON\n7: USER'),...
			'integrator',	sprintf('0: EXPLICIT\n1: MIDPOINT\n2: IMPLICIT\n3: RK4\n4: INTERLEAVE'),...
			'atype',		sprintf('0: NONE\n1: FAST\n2: DIAGONAL\n3: FULL'),...
			'collisionmode',sprintf('0: NONE\n1: BROADPHASE\n2: PAIR\n3: ALL'));

% make the option panel			
[option, edit] = deal(zeros(nopt,1));
for i = 1:nopt
	% get tooltip
	if isfield(tips,names{i})
		tooltip = tips.(names{i});
	else
		tooltip = '';
	end
	% new edit panel
	[option(i),edit(i)] = edit_panel(panel,names{i});
	
	% set tooltip
	set(get(option(i),'children'),'TooltipString', tooltip)
	
	% set string and callback
	set(edit(i),'Callback', @(src,evnt) set_option(src,names{i}))
	
	% put field-name in edit object
	set(edit(i),'userdata',names{i})
end
% put edit boxes in panel
setappdata(panel,'options_edit',edit)


function update_panel(panel)
% set timestep
dt_edit			= getappdata(panel,'dt_edit');
set(dt_edit,'String', num2str(1000*mj('get','dt')));

% set other options
options_edit	= getappdata(panel,'options_edit');
mjOpt			= getOption();
for i = 1:length(options_edit)
	name = get(options_edit(i),'user');
	set(options_edit(i),'String', mat2str(mjOpt.(name)))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set Data->dt 
function set_dt(src,~)
mj('set','dt',eval(get(src,'string'))/1000)
deselect(src);

% set simulation slowdown coefficient
function set_slowdown(src, panel)
setappdata(panel,'slowdown',eval(get(src,'string')));
deselect(src);

% set mjOption 
function set_option(src,name)
% get user input
x     = eval(get(src,'string')); 

% set the corresponding mjOption field
opt			= mj('getoption');
opt.(name)	= x;
mj('setoption',opt);

% update the edit field (reformat)
set(src,'string',mat2str(x))
deselect(src);
   
function set_framerate(src, src2, panel)
if get(src,'user')
	dt	= max(1e-3,eval(get(src,'string'))/1000);
	set(src,'string',sprintf('%-3.0f',1000*dt))		% ms
	set(src2,'string',sprintf('%-3.1f',1/dt))		% Hz
else
	dt	= max(1e-3,1/eval(get(src,'string')));
	set(src2,'string',sprintf('%-3.0f',1000*dt))	% ms
	set(src,'string',sprintf('%-3.1f',1/dt))		% Hz
end
setappdata(panel,'frame_dt',dt)
deselect(src);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  utility functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get mjOption structure, ignore some fields
function opt = getOption()
% list of ignored options
ignore = {'timestep','wind','eqerrreduce','eqsoftweight','expdist'...
		  'disableflags','eqsoft','consolidate','remotecontact',...
          'linesearch'};

% get mjOption
opt		= mj('getoption');
opt		= rmfield(opt, ignore);

% hack for delecting a GUI object
function deselect(obj)
set(obj,'enable','off')
pause(0.001)
set(obj,'enable','on')

% make a container panel with a name and edit box
function [container,edit] = edit_panel(parent,name)

container	= uipanel(parent,'BorderType','none','Borderwidth',0,'Title',''); 
name		= uicontrol(container, 'Style', 'text', 'String', name); 
edit		= uicontrol(container,'Style', 'edit');  

% align name and edit inside the container panel
alignHandles([name edit],1,[1 1],[.01 0])


% utility function to align GUI objects
function alignHandles(handles, dimension, sizes, spacing, edges, offset)
% handles      - objects to be aligned
% dimension    - dimension on which to align (1: rows; 2: columns)
% sizes        - relative sizes along the specified dimension
% spacing      - spacing between the objects (fraction of 1)
% edges        - add edges around the objects of width 'spacing' (0: no; 1: yes)

n        = length(handles);

if nargin < 6
   offset = 0;
end

if nargin < 5
   edges = 1;
end

if nargin < 4
   spacing = [0 0];
end

if nargin < 3
   sizes = ones(n,1);
end

sizes = sizes/sum(sizes);
sizes = [sizes(:) spacing(1)*[ones(n-1,1); edges]]';
sizes = [spacing(1); sizes(:); spacing(1) ];
sizes = sizes/sum(sizes);
ssz   = cumsum(sizes);

for i = 1:n
   set(handles(i),'Units','normalized');
   pos      = [0 0 0 0];
   prime    = [1 3]+(dimension-1);
   sec      = [2 4]+(1-dimension);
   pos(prime) = [ssz(2*i-1) sizes(2*i)];
   pos(sec) = [edges*spacing(2) 1-edges*2*spacing(2)];
   pos(prime(1)) = pos(prime(1)) + offset;
   set(handles(i),'position',pos)
end