function varargout = Select_Electrode_Dialog_Box(varargin)
% SELECT_ELECTRODE_DIALOG_BOX M-file for Select_Electrode_Dialog_Box.fig
%      SELECT_ELECTRODE_DIALOG_BOX, by itself, creates a new SELECT_ELECTRODE_DIALOG_BOX or raises the existing
%      singleton*.
%
%      H = SELECT_ELECTRODE_DIALOG_BOX returns the handle to a new SELECT_ELECTRODE_DIALOG_BOX or the handle to
%      the existing singleton*.
%
%      SELECT_ELECTRODE_DIALOG_BOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT_ELECTRODE_DIALOG_BOX.M with the given input arguments.
%
%      SELECT_ELECTRODE_DIALOG_BOX('Property','Value',...) creates a new SELECT_ELECTRODE_DIALOG_BOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Select_Electrode_Dialog_Box_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Select_Electrode_Dialog_Box_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Select_Electrode_Dialog_Box

% Last Modified by GUIDE v2.5 10-Dec-2008 16:05:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Select_Electrode_Dialog_Box_OpeningFcn, ...
                   'gui_OutputFcn',  @Select_Electrode_Dialog_Box_OutputFcn, ...
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


% --- Executes just before Select_Electrode_Dialog_Box is made visible.
function Select_Electrode_Dialog_Box_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Select_Electrode_Dialog_Box (see VARARGIN)

% Choose default command line output for Select_Electrode_Dialog_Box
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Select_Electrode_Dialog_Box wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Select_Electrode_Dialog_Box_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Select_Electrode_Number.
function Select_Electrode_Number_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Electrode_Number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Select_Electrode_Number contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_Electrode_Number


% --- Executes during object creation, after setting all properties.
function Select_Electrode_Number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Electrode_Number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Select_Microdrive_Number.
function Select_Microdrive_Number_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Microdrive_Number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Select_Microdrive_Number contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_Microdrive_Number


% --- Executes during object creation, after setting all properties.
function Select_Microdrive_Number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Select_Microdrive_Number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


