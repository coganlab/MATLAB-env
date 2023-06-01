function varargout = LfpDatabase(varargin)
% LFPDATABASE Application M-file for LfpDatabase.fig
%    FIG = LFPDATABASE launch SpikeSort GUI.
%    LFPDATABASE('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 26-Apr-2012 13:59:06

global MONKEYDIR

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

    set(fig,'Name','LFP Database')
    set(fig,'DoubleBuffer','on','MenuBar','fig');
    
    %  Generate recording day list
    Dir = getRecordingDays;
    set(handles.popDay,'String',Dir(end).name)
    day = get(handles.popDay,'String');
    UpdateDay(handles,day);

    %Turn on Figure Toolbar
    set(fig,'Toolbar','figure');
    
	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.


% --------------------------------------------------------------------
function varargout = pbLoad_Callback(h, eventdata, handles, varargin)

global MONKEYDIR

day = get(handles.popDay,'String');
recs = dayrecs(day);
load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
    load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
end
ChString = get(handles.popChannel,'String');
ChValue = get(handles.popChannel,'Value');
ch = str2num(ChString{ChValue});
SysString = get(handles.popSys,'String');
SysValue = get(handles.popSys,'Value');
sys = SysString{SysValue};
% if length(Rec.Ch)==0 Rec.Ch = [2,2]; end
% if strcmp(Rec.MT1,sys)
%     SysCh = ch;
% elseif strcmp(Rec.MT2,sys)
%     if Rec.Ch(1) > 4
%         SysCh = 1+ch;
%     else
%         SysCh = Rec.Ch(1)+ch;
%     end
% end
SysCh = 0;
SysValue
if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
    SysCh = 0;
    for i = 1:(SysValue-1)
        SysCh = SysCh + length(experiment.hardware.microdrive(i).electrodes);
    end
    SysCh = SysCh +ch
else
    if length(Rec.Ch)==0 Rec.Ch = [2,2]; end
    if strcmp(Rec.MT1,sys)
        SysCh = ch;
    elseif strcmp(Rec.MT2,sys)
        if Rec.Ch(1) > 4
            SysCh = 1+ch;
        else
            SysCh = Rec.Ch(1)+ch;
        end
    end
end

Trials = dbSelectTrials(day,dayrecs(day));
set(handles.frTrials,'UserData',Trials);
set(handles.stRecTrials,'String',num2str(length(Trials)));
% set(handles.stSTrials,'String',num2str(length(TaskTrials(Trials,'Sacc'))));
% set(handles.stLRTrials,'String',num2str(length(TaskTrials(Trials,'LR1T'))));
% set(handles.stRTrials,'String',num2str(length(TaskTrials(Trials,'Fix1T'))));
% set(handles.stSRFTrials,'String',num2str(length(TaskTrials(Trials,'SaccRF'))));
% set(handles.stLRRFTrials,'String',num2str(length(TaskTrials(Trials,'LRRF'))));
% set(handles.stRRFTrials,'String',num2str(length(TaskTrials(Trials,'ReachRF'))));
% set(handles.st3TTrials,'String',num2str(length(TaskTrials(Trials,'Free3T'))));
% set(handles.stISTrials,'String',num2str(length(TaskTrials(Trials,'IntSacc'))));
% set(handles.stFreeCh3TTrials,'String',num2str(length(TaskTrials(Trials,'FreeCh3T'))));
% set(handles.stFixCh3TTrials,'String',num2str(length(TaskTrials(Trials,'FixCh3T'))));
% set(handles.stFreeInst3TTrials,'String',num2str(length(TaskTrials(Trials,'FreeInst3T'))));
% set(handles.stFixInst3TTrials,'String',num2str(length(TaskTrials(Trials,'FixInst3T'))));

Depth = getDepth(Trials);
Depth = Depth(:,SysCh);
axes(handles.axEPos);
plot(Depth);
xlabel('Trial number'); ylabel('Depth (um)')
set(gca,'XLim',[0,length(Trials)])
Delta = str2num(get(handles.edRange,'String'));

axes(handles.axDepth);
N = [min(Depth)-Delta:5:max(Depth)+Delta];
for iN = 1:length(N)
    ind = find(Depth>N(iN)-Delta & Depth<N(iN)+Delta);
    DepthProfile(iN) = length(ind);
end
plot(N,DepthProfile);
[dum,ind] = max(DepthProfile);
set(handles.stDepth,'String',num2str(N(ind)));
ylabel('Number of trials'); xlabel('Depth (um)')

% --------------------------------------------------------------------
function varargout = popChannel_Callback(h, eventdata, handles, varargin)

global MONKEYDIR

day = get(handles.popDay,'String');
recs = dayrecs(day);

SysString = get(handles.popSys,'String');
SysValue = get(handles.popSys,'Value');
sys = SysString{SysValue};

ch = get(handles.popChannel,'Value');

%load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
    load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
end
% if strcmp(Rec.MT1,sys)
%     systring = 'a';
% elseif strcmp(Rec.MT2,sys)
%     systring = 'b';
% end

% --------------------------------------------------------------------
function varargout = popSys_Callback(h, eventdata, handles, varargin)

global MONKEYDIR

day = get(handles.popDay,'String');
recs = dayrecs(day);
SysString = get(handles.popSys,'String');
SysValue = get(handles.popSys,'Value');
sys = SysString{SysValue};

ch = get(handles.popChannel,'Value');

load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
    load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
end

% if strcmp(Rec.MT1,sys)
%     systring = 'a';
% elseif strcmp(Rec.MT2,sys)
%     systring = 'b';
% end

% --------------------------------------------------------------------
function varargout = popDay_Callback(h, eventdata, handles, varargin)

day = get(h,'String');
% DayValue = get(h,'Value');
% day = DayString{DayValue};
UpdateDay(handles,day);


% --------------------------------------------------------------------
function UpdateDay(handles,day)
%
%
%

global MONKEYDIR

recs = dayrecs(day);
disp(['Update System list for ' day]);
load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
    load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
    if(isfield(experiment.hardware,'microdrive'))
        SysString = {experiment.hardware.microdrive.name};
        disp(['Update Channel list for ' day]);
        for i = 1:length(experiment.hardware.microdrive(1).electrodes) ChannelString{i} = num2str(i); end
    else
        SysString = {'No microdrive'};
        ChannelString{1} = '';
    end
elseif isfield(Rec,'MT1') & isfield(Rec,'Ch') 
    SysString = {Rec.MT1,Rec.MT2};
    if ~isempty(Rec.Ch)
        for i = 1:Rec.Ch(1) ChannelString{i} = num2str(i); end
    else
        ChannelString{1} ='';
    end
else
    SysString = {'No microdrive'};

    ChannelString{1} = '';
end
set(handles.popSys,'String',SysString);
set(handles.popChannel,'String',ChannelString);
% 
% day = get(handles.popDay,'String');
% recs = dayrecs(day);
% SysString = get(handles.popSys,'String');
% SysValue = get(handles.popSys,'Value');
% sys = SysString{SysValue};
% % 
% ch = get(handles.popChannel,'Value');
% 
% load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
% 
% if strcmp(Rec.MT1,sys)
%     systring = 'a';
% elseif strcmp(Rec.MT2,sys)
%     systring = 'b';
% end

% 
% % --------------------------------------------------------------------
% function handles = setFrameTrials(handles, FrameNumber)
% 
% Trials = get(handles.frTrials,'UserData');
% IsoWin = 1e3*str2num(get(handles.edIsoWin,'String'));
% 
% StartOn = getStartOn(Trials);
% Start = (FrameNumber-1)*IsoWin;
% Stop = FrameNumber*IsoWin;
% 
% ind = find(StartOn>Start & StartOn<Stop);
% set(handles.stFrTrials,'String',length(ind));
% if length(ind)
%     set(handles.stSFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'Sacc'))));
%     set(handles.stRFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'Fix1T'))));
%     set(handles.stSRFFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'SaccRF'))));
%     set(handles.stRRFFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'ReachRF'))));
%     set(handles.st3TFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'Free3T'))));
%     set(handles.stISFrTrials,'String',num2str(length(TaskTrials(Trials(ind),'IntSacc'))));
% else
%     set(handles.stSFrTrials,'String','0');
%     set(handles.stRFrTrials,'String','0');
%     set(handles.stSRFFrTrials,'String','0');
%     set(handles.stRRFFrTrials,'String','0');
%     set(handles.st3TFrTrials,'String','0');
%     set(handles.stISFrTrials,'String','0');
% end
% --------------------------------------------------------------------
function varargout = pbPauseMovie_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edIsoWin_Callback(h, eventdata, handles, varargin)




% 
% % --------------------------------------------------------------------
% function varargout = pbUpdate_Callback(h, eventdata, handles, varargin)
% 
% global MONKEYDIR
% 
% disp('Updating Field_Database file')
% 
% day = get(handles.popDay,'String');
% recs = dayrecs(day);
% load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
% SysString = get(handles.popSys,'String');
% SysValue = get(handles.popSys,'Value');
% sys = SysString{SysValue};
% if strcmp(Rec.MT1,sys)
%     systring = 'a';
% elseif strcmp(Rec.MT2,sys)
%     systring = 'b';
% end
% ChString = get(handles.popChannel,'String');
% ChValue = get(handles.popChannel,'Value');
% ch = str2num(ChString{ChValue});
% 
% NewSession = get(handles.frSession,'UserData');
% 
% filename = [MONKEYDIR '/m/Field_Database.m' ];
% Session = UpdateSession(filename,NewSession);
% 

% --------------------------------------------------------------------
function varargout = edDepth_Callback(h, eventdata, handles, varargin)

global MONKEYDIR

disp('Inside edDepth')

myDepth = str2num(get(handles.edDepth,'String'));
Range = str2num(get(handles.edRange,'String'));

day = get(handles.popDay,'String');
recs = dayrecs(day);
load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
  load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
end
ChString = get(handles.popChannel,'String');
ChValue = get(handles.popChannel,'Value');
ch = str2num(ChString{ChValue})
SysString = get(handles.popSys,'String');
SysValue = get(handles.popSys,'Value');
sys = SysString{SysValue};

Trials = get(handles.frTrials,'UserData');
% if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
%     SysCh = 0;
%     for i = 1:(SysValue-1)
%         SysCh = SysCh + length(experiment.hardware.microdrive(i).electrodes);
%     end
%     SysCh = SysCh +ch
% else
%     if strcmp(Rec.MT1,sys)
%         SysCh = ch;
%     elseif strcmp(Rec.MT2,sys)
%         SysCh = Rec.Ch(1)+ch;
%     end
% end
Depth = getDepth(Trials,SysValue,ChValue);

ind = find(Depth>myDepth-Range & Depth<myDepth+Range);
set(handles.stFrTrials,'String',length(ind));
if length(ind)
%     set(handles.stSSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'Sacc'))));
%     set(handles.stLRSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'LR1T'))));
%     set(handles.stRSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'Fix1T'))));
%     set(handles.stSRFSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'SaccRF'))));
%     set(handles.stLRRFSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'LRRF'))));
%     set(handles.stRRFSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'ReachRF'))));
%     set(handles.st3TSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'Free3T'))));
%     set(handles.stISSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'IntSacc'))));
else
%     set(handles.stSSessTrials,'String','0');
%     set(handles.stLRSessTrials,'String','0');
%     set(handles.stRSessTrials,'String','0');
%     set(handles.stSRFSessTrials,'String','0');
%     set(handles.stLRRFSessTrials,'String','0');
%     set(handles.stRRFSessTrials,'String','0');
%     set(handles.st3TSessTrials,'String','0');
%     set(handles.stISSessTrials,'String','0');
end
axes(handles.axEPos);
cla; plot(Depth(:,ch));
set(gca,'XLim',[0,length(Trials)]);
Linehandle = line([0,length(Trials)],[myDepth,myDepth]);
set(Linehandle,'LineStyle','--','Color',mycolors(1));
% Patchhandle = patch([0,length(Trials),length(Trials),0],...
%     myDepth+[-Range,-Range,Range,Range],mycolors(2));
% % set(Patchhandle,'FaceAlpha',0);
% set(Patchhandle,'FaceAlpha',0.2,'EdgeAlpha',0)
xlabel('Trial number'); ylabel('Depth (um)');
% get(Patchhandle)
drawnow


% --------------------------------------------------------------------
function varargout = axEPos_Callback(h, eventdata, handles, varargin)


disp('Click!')

CP = get(h,'CurrentPoint')

get(handles.axEPos,'YLim')

axes(handles.axEPos)
line([CP(1,1),CP(1,1)],get(handles.axEPos,'YLim'));



% --------------------------------------------------------------------
function varargout = pushbutton16_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = text50_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = edRange_Callback(h, eventdata, handles, varargin)


global MONKEYDIR

disp('Inside edDepth')

myDepth = str2num(get(handles.edDepth,'String'));
Range = str2num(get(handles.edRange,'String'));

day = get(handles.popDay,'String');
recs = dayrecs(day);
load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
    load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
end

disp('here')
SysString = get(handles.popSys,'String');
SysValue = get(handles.popSys,'Value');
sys = SysString{SysValue};
ChString = get(handles.popChannel,'String');
ChValue = get(handles.popChannel,'Value');
ch = str2num(ChString{ChValue});

% BIjan:  If there are problems accessing depths let me know
% if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
% %     SysCh = 0;
% %     for i = 1:(SysValue-1)
% %         SysCh = SysCh + length(experiment.hardware.microdrive(i).electrodes);
% %     end
% %     SysCh = SysCh +ch
% 
% else
%     if strcmp(Rec.MT1,sys)
%         SysCh = ch;
%     elseif strcmp(Rec.MT2,sys)
%         SysCh = Rec.Ch(1)+ch;
%     end
% end
Trials = get(handles.frTrials,'UserData');

Depth = getDepth(Trials,SysValue,ChValue);

ind = find(Depth>myDepth-Range & Depth<myDepth+Range);
set(handles.stFrTrials,'String',length(ind));
if length(ind)
%     set(handles.stSSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'Sacc'))));
%     set(handles.stLRSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'LR1T'))));
%     set(handles.stRSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'Fix1T'))));
%     set(handles.stSRFSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'SaccRF'))));
%     set(handles.stLRRFSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'LRRF'))));
%     set(handles.stRRFSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'ReachRF'))));
%     set(handles.st3TSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'Free3T'))));
%     set(handles.stISSessTrials,'String',num2str(length(TaskTrials(Trials(ind),'IntSacc'))));
else
%     set(handles.stSSessTrials,'String','0');
%     set(handles.stLRSessTrials,'String','0');
%     set(handles.stRSessTrials,'String','0');
%     set(handles.stSRFSessTrials,'String','0');
%     set(handles.stLRRFSessTrials,'String','0');
%     set(handles.stRRFSessTrials,'String','0');
%     set(handles.st3TSessTrials,'String','0');
%     set(handles.stISSessTrials,'String','0');
end

axes(handles.axEPos);
cla; plot(Depth);
set(gca,'XLim',[0,length(Trials)]);
Linehandle = line([0,length(Trials)],[myDepth,myDepth]);
set(Linehandle,'LineStyle','--','Color',mycolors(1));
% Patchhandle = patch([0,length(Trials),length(Trials),0],...
%     myDepth+[-Range,-Range,Range,Range],mycolors(2));
% % set(Patchhandle,'FaceAlpha',0);
% set(Patchhandle,'FaceAlpha',0.2,'EdgeAlpha',0)
xlabel('Trial number'); ylabel('Depth (um)');
% get(Patchhandle)
drawnow




% --------------------------------------------------------------------
% function varargout = pbFixLog_Callback(h, eventdata, handles, varargin)
% 
% global MONKEYDIR
% 
% day = get(handles.popDay,'String');
% recs = dayrecs(day);
% 
% load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
% SysString = get(handles.popSys,'String');
% SysValue = get(handles.popSys,'Value');
% sys = SysString{SysValue};
% if strcmp(Rec.Chamber1(1),sys)
%     SysString = 'a';
%     Sys = 1;
% elseif strcmp(Rec.Chamber2(1),sys)
%     SysString = 'b';
%     Sys = 2;
% end
% ChString = get(handles.popChannel,'String');
% ChValue = get(handles.popChannel,'Value');
% ch = str2num(ChString{ChValue});
% 
% for iRec = 1:length(recs)
%     Filename = [MONKEYDIR '/' day '/' ...
%             recs{iRec} '/rec' recs{iRec} SysString '.log.txt'];
%     a = load(Filename);
%     ind = find(a(:,ch+1)<100);
%     length(ind)
%     if length(ind)
%         a(ind,ch+1)=a(ind,ch+1)*100;
%         eval(['save ' Filename ' a -ascii']);
%     end
% end
% 
% 
% for iRec = 1:length(recs)
%     Filename = [MONKEYDIR '/' day '/' ...
%             recs{iRec} '/rec' recs{iRec} SysString '.log.txt'];
%     a = load(Filename);
%     ind = find(a(:,ch+1)>11000);
%     if length(ind)
%         a(ind,ch+1)=a(ind,ch+1)/10;
%         eval(['save ' Filename ' a -ascii']);
%     end
% end
% 
% 
% saveTrials(day);
% pbLoad_Callback(h, eventdata, handles);


% --- Executes on button press in pbSaveSession.
function pbSaveSession_Callback(hObject, eventdata, handles)
% hObject    handle to pbSaveSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global MONKEYDIR

myDepth = str2num(get(handles.edDepth,'String'));
Range = str2num(get(handles.edRange,'String'));

day = get(handles.popDay,'String');
recs = dayrecs(day);
load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
    load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
end
SysString = get(handles.popSys,'String');
SysValue = get(handles.popSys,'Value');
sys = SysString{SysValue};

ChString = get(handles.popChannel,'String');
ChValue = get(handles.popChannel,'Value');
ch = str2num(ChString{ChValue});

nMicrodrive = length(experiment.hardware.microdrive);
for iMicrodrive = 1:nMicrodrive
    if strcmp(experiment.hardware.microdrive(iMicrodrive).name,sys)
        elec = experiment.hardware.microdrive(iMicrodrive).electrodes(ch);
    end
end

if isfield(elec,'numContacts')
    nContacts = elec.numContacts;
else
    nContacts = 1;
end

for iContact = 1:nContacts
    addFieldDatabaseText(day, recs, sys, ch, iContact, myDepth, Range);
end


% --- Executes on button press in pbSaveLaminar.
function pbSaveLaminar_Callback(hObject, eventdata, handles)
% hObject    handle to pbSaveLaminar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global MONKEYDIR

myDepth = str2num(get(handles.edDepth,'String'));
Range = str2num(get(handles.edRange,'String'));

day = get(handles.popDay,'String');
recs = dayrecs(day);
load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.Rec.mat']);
if isfile([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat'])
    load([MONKEYDIR '/' day '/' recs{1} '/rec' recs{1} '.experiment.mat']);
end
SysString = get(handles.popSys,'String');
SysValue = get(handles.popSys,'Value');
sys = SysString{SysValue};

ChString = get(handles.popChannel,'String');
ChValue = get(handles.popChannel,'Value');
ch = str2num(ChString{ChValue});

nMicrodrive = length(experiment.hardware.microdrive);
for iMicrodrive = 1:nMicrodrive
    if strcmp(experiment.hardware.microdrive(iMicrodrive).name,sys)
        elec = experiment.hardware.microdrive(iMicrodrive).electrodes(ch);
    end
end

if isfield(elec,'numContacts')
    nContacts = elec.numContacts;
else
    nContacts = 1;
end


if nContacts > 1
  addLaminarDatabaseText(day, recs, sys, ch, nContacts, myDepth, Range);
else
  disp('Only one contact - no Laminar data')
end
