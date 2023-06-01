function varargout = NTools_Process(varargin)
% NTOOLS_PROCESS M-file for NTools_Process.fig
%      NTOOLS_PROCESS, by itself, creates a new NTOOLS_PROCESS or raises the existing
%      singleton*.
%
%      H = NTOOLS_PROCESS returns the handle to a new NTOOLS_PROCESS or the handle to
%      the existing singleton*.
%
%      NTOOLS_PROCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NTOOLS_PROCESS.M with the given input arguments.
%
%      NTOOLS_PROCESS('Property','Value',...) creates a new NTOOLS_PROCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NTools_Process_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NTools_Process_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NTools_Process

% Last Modified by GUIDE v2.5 30-Nov-2008 23:23:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NTools_Process_OpeningFcn, ...
                   'gui_OutputFcn',  @NTools_Process_OutputFcn, ...
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


% --- Executes just before NTools_Process is made visible.
function NTools_Process_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NTools_Process (see VARARGIN)

% Choose default command line output for NTools_Process
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NTools_Process wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NTools_Process_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in procIEEG.
function procIEEG_Callback(hObject, eventdata, handles)
% hObject    handle to procIEEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global experiment
if(isempty(experiment))
    warnh = warndlg('experiment variable is not set. Please press button 1 to select a .mat file containing the experiment variable.', 'ExperimentWarning', 'modal');
    uiwait(warnh);
else
    [filename, pathname] = uigetfile('*.nspike.dat', 'Select a .nspike.dat file');
    ntools_procIEEG(fullfile(pathname, filename));
end

% --- Executes on button press in procCleanIEEG.
function procCleanIEEG_Callback(hObject, eventdata, handles)
% hObject    handle to procCleanIEEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global experiment
if(isempty(experiment))
    warnh = warndlg('experiment variable is not set. Please press button 1 to select a .mat file containing the experiment variable.', 'ExperimentWarning', 'modal');
    uiwait(warnh);
else
    [filename, pathname] = uigetfile('*.ieeg.dat', 'Select a .ieeg.dat file');
    ntools_procCleanIEEG(fullfile(pathname, filename));
end

% --- Executes on button press in procDecimateIEEG.
function procDecimateIEEG_Callback(hObject, eventdata, handles)
% hObject    handle to procDecimateIEEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global experiment
if(isempty(experiment))
    warnh = warndlg('experiment variable is not set. Please press button 1 to select a .mat file containing the experiment variable.', 'ExperimentWarning', 'modal');
    uiwait(warnh);
else
    [filename, pathname] = uigetfile('*.nspike.dat', 'Select a .nspike.dat file');
    ntools_procDecimateIEEG(fullfile(pathname, filename));
end

% --- Executes on button press in select_expt.
function select_expt_Callback(hObject, eventdata, handles)
% hObject    handle to select_expt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global experiment

[filename, pathname] = uigetfile('*.mat', 'Select a .mat file containing an experiment variable');
load(fullfile(pathname, filename));


% --- Executes on button press in gen_epoch_data.
function gen_epoch_data_Callback(hObject, eventdata, handles)
% hObject    handle to gen_epoch_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global experiment
if(isempty(experiment))
    warnh = warndlg('experiment variable is not set. Please press button 1 to select a .mat file containing the experiment variable.', 'ExperimentWarning', 'modal');
    uiwait(warnh);
else
    [filename, pathname] = uigetfile('*.ieeg.dat', 'Select a .ieeg.dat file');
    recording_filename_root = make_filename_root(fullfile(pathname, filename));
    recording = ntools_gen_recording_data(recording_filename_root);
    epoch_data = ntools_gen_ieeg_epoch_data(recording);
    
    [filename, pathname] = uiputfile('*.mat', 'Save file as', [recording_filename_root '_epoch_data.mat']);
    save(fullfile(pathname, filename), '-v7.3', 'epoch_data');
end


