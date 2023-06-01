function varargout = filterGraphGUI(varargin)
% FILTERGRAPHGUI M-file for filterGraphGUI.fig
%      FILTERGRAPHGUI, by itself, creates a new FILTERGRAPHGUI or raises the existing
%      singleton*.
%
%      H = FILTERGRAPHGUI returns the handle to a new FILTERGRAPHGUI or the handle to
%      the existing singleton*.
%
%      FILTERGRAPHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTERGRAPHGUI.M with the given input arguments.
%
%      FILTERGRAPHGUI('Property','Value',...) creates a new FILTERGRAPHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filterGraphGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filterGraphGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help filterGraphGUI

% Last Modified by GUIDE v2.5 18-Mar-2009 17:17:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filterGraphGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @filterGraphGUI_OutputFcn, ...
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

% --- Executes just before filterGraphGUI is made visible.
function filterGraphGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to filterGraphGUI (see VARARGIN)

% Choose default command line output for filterGraphGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using filterGraphGUI.
if strcmp(get(hObject,'Visible'),'off')
 
    
end

% UIWAIT makes filterGraphGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = filterGraphGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbuttonUpdate.
function pushbuttonUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
%cla;

popup_sel_index = get(handles.popupmenu1, 'Value'); 
dataFilesString = dir(['./DataFiles/*']);
filterID = get(handles.popupmenu2, 'Value');

filepath = sprintf('%s%s','./DataFiles/',char(dataFilesString(filterID).name));


makegraphs(popup_sel_index, filepath); %makes image 

axis fill;

set(hObject,'units','normalized') %%trying to normalize graph units

load(filepath);
wt_it = filterInfo.wt_it;
wf_it = filterInfo.wf_it;
wt_high = filterInfo.wt_high;
wf_high = filterInfo.wf_high;
method = sprintf('Filter Method: %i', filterInfo.method);
wt_string = sprintf('wt_high: %g Hz;\n  wt_it: %g Hz', wt_high, wt_it);
wf_string = sprintf('wf_high: %g cycles/Hz;\n wf_it: %g cycles/Hz', wf_high, wf_it); 
set(handles.text7, 'String', wt_string);
set(handles.text9, 'String', wf_string);
set(handles.text10, 'String', method);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
popup_sel_index = get(handles.popupmenu1, 'Value');  %%JUST CHANGED POSSIBLY REMOVE
dataFilesString = dir(['./DataFiles/*']);
filterID = get(handles.popupmenu2, 'Value');
filepath = sprintf('%s%s','./DataFiles/',char(dataFilesString(filterID).name));

makegraphs(popup_sel_index, filepath); %makes image 

axis fill;

set(hObject,'units','normalized') 
load(filepath);
wt_it = filterInfo.wt_it;
wf_it = filterInfo.wf_it;
wt_high = filterInfo.wt_high;
wf_high = filterInfo.wf_high;
method = sprintf('Filter Method: %i', filterInfo.method);
wt_string = sprintf('wt_high: %g Hz;\n  wt_it: %g Hz', wt_high, wt_it);
wf_string = sprintf('wf_high: %g cycles/Hz;\n wf_it: %g cycles/Hz', wf_high, wf_it); 
set(handles.text7, 'String', wt_string);
set(handles.text9, 'String', wf_string);
set(handles.text10, 'String', method);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'Initial Spectrogram', 'Initial Amplitude',...
    'Initial Phase', 'Resultant Amplitude', 'Resultant Phase','Mean Amplitude vs Frequency',...
    'Mean Amplitude vs Time','Desired Spectrogram','Obtained Spectrogram','Obtained Amplitude Spectrum',...
    'Obtained Phase Spectrum'});


function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of popupmenu2 as text
%        str2double(get(hObject,'String')) returns contents of popupmenu2 as a double



% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
dataFilesString = dir(['./DataFiles/*']);
set(hObject, 'String', char(dataFilesString.name));


% --- Executes on button press in pushbutton4. Plays initial soundfile
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = get(handles.popupmenu2, 'String');
load(filename);
song_name = filter.song_name;
[song_in fs]= wavread(song_name);
soundsc(song_in, fs);

% --- Executes on button press in pushbutton5. Plays filtered soundfile
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


filename = get(handles.popupmenu2, 'String');
load(filename);
song_name_mod = filter.song_name_mod;
[song_in fs]= wavread(song_name_mod);
soundsc(song_in, fs);

