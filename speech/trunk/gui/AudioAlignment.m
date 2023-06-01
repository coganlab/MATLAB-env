function varargout = AudioAlignment(varargin)
% AUDIOALIGNMENT M-file for AudioAlignment.fig
%      AUDIOALIGNMENT, by itself, creates a new AUDIOALIGNMENT or raises the existing
%      singleton*.
%
%      H = AUDIOALIGNMENT returns the handle to a new AUDIOALIGNMENT or the handle to
%      the existing singleton*.
%
%      AUDIOALIGNMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUDIOALIGNMENT.M with the given input arguments.
%
%      AUDIOALIGNMENT('Property','Value',...) creates a new AUDIOALIGNMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AudioAlignment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AudioAlignment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AudioAlignment

% Last Modified by GUIDE v2.5 06-May-2009 17:10:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AudioAlignment_OpeningFcn, ...
                   'gui_OutputFcn',  @AudioAlignment_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AudioAlignment is made visible.
function AudioAlignment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AudioAlignment (see VARARGIN)

% Choose default command line output for AudioAlignment
set(hObject,'Menubar','figure','Toolbar','figure');
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AudioAlignment wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AudioAlignment_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popSubject.
function popSubject_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to popSubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popSubject contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSubject

SubjectString = get(handles.popSubject,'String');
SubjectValue = get(handles.popSubject,'Value');
Subject = SubjectString{SubjectValue};
setDay(handles,Subject);


% --- Executes during object creation, after setting all properties.
function popSubject_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to popSubject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global NYUMCDIR

Subj = dir([NYUMCDIR '/NY*']);

for iSubject = 1:length(Subj)
    Subjects{iSubject} = Subj(iSubject).name; %#ok<AGROW>
end

set(hObject,'String',Subjects);



function setDay(handles,Subject)
global NYUMCDIR 

Ds = dir([NYUMCDIR '/' Subject '/0*']);
for iDay = 1:length(Ds)
    Days{iDay} = Ds(iDay).name; %#ok<AGROW>
end

set(handles.popDay,'String',Days);


% --- Executes on selection change in popDay.
function popDay_Callback(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to popDay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popDay contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popDay


% --- Executes during object creation, after setting all properties.
function popDay_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to popDay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global NYUMCDIR

Subject = dir([NYUMCDIR '/NY*']);

Ds = dir([NYUMCDIR '/' Subject(1).name '/0*']);
for iDay = 1:length(Ds)
    Days{iDay} = Ds(iDay).name; %#ok<AGROW>
end

set(hObject,'String',Days);

% --- Executes on button press in pbLoad.
function pbLoad_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to pbLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global NYUMCDIR experiment %#ok<NUSED>

SubjectString = get(handles.popSubject,'String');
SubjectValue = get(handles.popSubject,'Value');
Subject = SubjectString{SubjectValue};

DayString = get(handles.popDay,'String');
DayValue = get(handles.popDay,'Value');
Day = DayString{DayValue};

load([NYUMCDIR '/' Subject '/' Day '/mat/Trials.mat']);
load([NYUMCDIR '/' Subject '/mat/experiment.mat']);

set(handles.pbLoad,'UserData',Trials);
set(handles.edTrialNumber,'String',num2str(1));
set(handles.stTotalTrials,'String',[num2str(length(Trials)) ' Trials']);
DrawAudioTrial(handles);

% --- Executes on button press in pbForward.
function pbForward_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to pbForward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

trialnum = str2double(get(handles.edTrialNumber,'String'));
Trials  = get(handles.pbLoad,'UserData');
if trialnum < length(Trials)
    set(handles.edTrialNumber,'String',num2str(trialnum+1));
end
DrawAudioTrial(handles);

% --- Executes on button press in pbBackward.
function pbBackward_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to pbBackward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


trialnum = str2double(get(handles.edTrialNumber,'String'));
if trialnum > 1
    set(handles.edTrialNumber,'String',num2str(trialnum-1));
end
DrawAudioTrial(handles);

% --- Executes on button press in pbAlign.
function pbAlign_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to pbAlign (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Onset = ginput(1);
Onset = Onset(1);

Trials = get(handles.pbLoad,'UserData');
TrialNumber = str2double(get(handles.edTrialNumber,'String'));
TypeString = get(handles.popType,'String');
TypeValue = get(handles.popType,'Value');
TypeName = TypeString{TypeValue};

switch TypeName
    case 'Cue'
       Trials(TrialNumber).AuditoryStart = Onset*30 + Trials(TrialNumber).Auditory;
       Trials(TrialNumber).Manual.AuditoryStart = 1;
    case 'Response'
       Trials(TrialNumber).ResponseStart = Onset*30 + Trials(TrialNumber).Go;
       Trials(TrialNumber).Manual.ResponseStart = 1;
end

set(handles.pbLoad,'UserData',Trials);

DrawAudioTrial(handles);

% --- Executes on selection change in popType.
function popType_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to popType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popType

DrawAudioTrial(handles);

% --- Executes during object creation, after setting all properties.
function popType_CreateFcn(hObject, eventdata, handles) %#ok<INUSD,DEFNU>
% hObject    handle to popType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',{'Cue','Response'});

function DrawAudioTrial(handles)

global experiment;

Trials = get(handles.pbLoad,'UserData');
TrialNumber = str2double(get(handles.edTrialNumber,'String'));

set(handles.ckNoisy,'Value',Trials(TrialNumber).Noisy);
set(handles.ckNoResponse,'Value',Trials(TrialNumber).NoResponse);

TypeString = get(handles.popType,'String');
TypeValue = get(handles.popType,'Value');
TypeName = TypeString{TypeValue};

Onset = 0; Offset = 0;
switch TypeName
    case 'Cue'
        field = 'Auditory';
        bn = [0,600];
        if isfield(Trials,'AuditoryStart') && ~isempty(Trials(TrialNumber).AuditoryStart)
            Onset = Trials(TrialNumber).AuditoryStart - Trials(TrialNumber).Auditory;
        end
        if isfield(Trials,'AuditoryStop') && ~isempty(Trials(TrialNumber).AuditoryStop)
            Offset = Trials(TrialNumber).AuditoryStop - Trials(TrialNumber).Auditory;
        end
        set(handles.ckManualStart,'Value',Trials(TrialNumber).Manual.AuditoryStart);
        set(handles.ckManualStop,'Value',Trials(TrialNumber).Manual.AuditoryStop);
    case 'Response'
        field = 'Go';
        bn = [0,30e2];
        if isfield(Trials,'ResponseStart') && ~isempty(Trials(TrialNumber).ResponseStart);
            Onset = Trials(TrialNumber).ResponseStart - Trials(TrialNumber).Go;
        end
        if isfield(Trials,'ResponseStop') && ~isempty(Trials(TrialNumber).ResponseStop);
            Offset = Trials(TrialNumber).ResponseStop - Trials(TrialNumber).Go;
        end
        set(handles.ckManualStart,'Value',Trials(TrialNumber).Manual.ResponseStart);
        set(handles.ckManualStop,'Value',Trials(TrialNumber).Manual.ResponseStop);
end

Onset = Onset./30;
Offset = Offset./30;
FS = experiment.processing.comedi.audio.sample_rate; %#ok<NASGU>
Audio = trialComediAudio(Trials(TrialNumber),field,bn);
% Audio = mtfilter(Audio,[0.01,2000],FS,1000+2000);
Envelope = smooth(abs(hilbert(Audio)),20);

time = linspace(bn(1),bn(2),length(Audio));
axes(handles.axGraph);
hold off;
plot(time,Audio); hold on;
plot(time,Envelope,'k');
hh = line([Onset,Onset],[min(Audio),max(Audio)]);
set(hh,'Color','g','Linewidth',2);
hh = line([Offset,Offset],[min(Audio),max(Audio)]);
set(hh,'Color','r','Linewidth',2);

ylabel('Audio');
xlabel('Time (ms)');


% --- Executes on button press in pbSave.
function pbSave_Callback(hObject, eventdata, handles) %#ok<DEFNU,INUSL>
% hObject    handle to pbSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global NYUMCDIR

Trials = get(handles.pbLoad,'UserData'); %#ok<NASGU>
SubjectString = get(handles.popSubject,'String');
SubjectValue = get(handles.popSubject,'Value');
Subject = SubjectString{SubjectValue};

DayString = get(handles.popDay,'String');
DayValue = get(handles.popDay,'Value');
Day = DayString{DayValue};

disp(['Saving ' NYUMCDIR '/' Subject '/' Day '/mat/Trials.mat']);
save([NYUMCDIR '/' Subject '/' Day '/mat/Trials.mat'],'Trials');


% --- Executes on button press in pbAlignStop.
function pbAlignStop_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to pbAlignStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


Offset = ginput(1);
Offset = Offset(1);

Trials = get(handles.pbLoad,'UserData');
TrialNumber = str2double(get(handles.edTrialNumber,'String'));
TypeString = get(handles.popType,'String');
TypeValue = get(handles.popType,'Value');
TypeName = TypeString{TypeValue};

switch TypeName
    case 'Cue'
       Trials(TrialNumber).AuditoryStop = Offset*30 + Trials(TrialNumber).Auditory;
       Trials(TrialNumber).Manual.AuditoryStop = 1;
    case 'Response'
       Trials(TrialNumber).ResponseStop = Offset*30 + Trials(TrialNumber).Go;
       Trials(TrialNumber).Manual.ResponseStop = 1;
end

set(handles.pbLoad,'UserData',Trials);

DrawAudioTrial(handles);



function edTrialNumber_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to edTrialNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edTrialNumber as text
%        str2double(get(hObject,'String')) returns contents of edTrialNumber as a double

DrawAudioTrial(handles);


% --- Executes on button press in ckManualStart.
function ckManualStart_Callback(hObject, eventdata, handles)
% hObject    handle to ckManualStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ckManualStart


Trials = get(handles.pbLoad,'UserData');
TrialNumber = str2double(get(handles.edTrialNumber,'String'));
TypeString = get(handles.popType,'String');
TypeValue = get(handles.popType,'Value');
TypeName = TypeString{TypeValue};

switch TypeName
    case 'Cue'
       Trials(TrialNumber).Manual.AuditoryStart = get(handles.ckManualStart,'Value');
    case 'Response'
       Trials(TrialNumber).Manual.ResponseStart = get(handles.ckManualStart,'Value');
end

set(handles.pbLoad,'UserData',Trials);


% --- Executes on button press in ckManualStop.
function ckManualStop_Callback(hObject, eventdata, handles)
% hObject    handle to ckManualStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ckManualStop

Trials = get(handles.pbLoad,'UserData');
TrialNumber = str2double(get(handles.edTrialNumber,'String'));
TypeString = get(handles.popType,'String');
TypeValue = get(handles.popType,'Value');
TypeName = TypeString{TypeValue};

switch TypeName
    case 'Cue'
       Trials(TrialNumber).Manual.AuditoryStop = get(handles.ckManualStop,'Value');
    case 'Response'
       Trials(TrialNumber).Manual.ResponseStop = get(handles.ckManualStop,'Value');
end
set(handles.pbLoad,'UserData',Trials);


% --- Executes on button press in ckNoResponse.
function ckNoResponse_Callback(hObject, eventdata, handles)
% hObject    handle to ckNoResponse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ckNoResponse

Trials = get(handles.pbLoad,'UserData');
TrialNumber = str2double(get(handles.edTrialNumber,'String'));
Value = get(handles.ckNoResponse,'Value');
Trials(TrialNumber).NoResponse = Value;
set(handles.pbLoad,'UserData',Trials);


% --- Executes on button press in ckNoisy.
function ckNoisy_Callback(hObject, eventdata, handles)
% hObject    handle to ckNoisy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ckNoisy

Trials = get(handles.pbLoad,'UserData');
TrialNumber = str2double(get(handles.edTrialNumber,'String'));
Value = get(handles.ckNoisy,'Value');
Trials(TrialNumber).Noisy = Value;
set(handles.pbLoad,'UserData',Trials);
