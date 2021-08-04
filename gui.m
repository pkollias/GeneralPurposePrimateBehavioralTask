function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

global specs devs cache
global pause_gui exit_gui kb_gui block_gui calib_gui

axes(handles.('figPerf'));
xlabel('Trials','FontSize',10);
ylabel('Performance','FontSize',8);
title('Performance over trials','FontSize',8);

axes(handles.('figPerfNDs'));
xlabel('NumPostDist','FontSize',10);
ylabel('NumPreDist','FontSize',8);
title('Performance per number of distactors','FontSize',8);

axes(handles.('figRT'));
xlabel('Trials','FontSize',10);
ylabel('RT (sec)','FontSize',8);
title('Reaction Time over trials','FontSize',8);

axes(handles.('figIdle'));
xlabel('Trials','FontSize',10);
ylabel('Idle Time (mins)','FontSize',8);
title('Idling','FontSize',8);

axes(handles.('figMCond'));
xlabel('MetaCondition','FontSize',10);
ylabel('Percent of Trials','FontSize',8);
title('Performance per MetaCondition','FontSize',8);

% Choose default command line output for gui
handles.output = hObject;
handles.windowh = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonExit.
function buttonExit_Callback(hObject, eventdata, handles)
% hObject    handle to buttonExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global specs devs
global pause_gui exit_gui kb_gui block_gui calib_gui

exit_gui = 1;
guidata(hObject,handles);
set(hObject,'String','Terminated');
set(hObject,'BackgroundColor',[0.99 0.99 0.99]);
set(hObject,'ForegroundColor',[0.5 0.5 0.5]);


% --- Executes on button press in buttonRun.
function buttonRun_Callback(hObject, eventdata, handles)
% hObject    handle to buttonRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global specs devs
global pause_gui exit_gui kb_gui block_gui calib_gui

pause_gui = ~pause_gui;
guidata(hObject,handles);
pauseStr = {'Pause' 'Run'};
set(hObject,'String',pauseStr{pause_gui+1});


% --- Executes on button press in buttonReward.
function buttonReward_Callback(hObject, eventdata, handles)
% hObject    handle to buttonReward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global specs devs
global pause_gui exit_gui kb_gui block_gui calib_gui

RewardDeliver(specs.ParallelPort.Address,specs.ParallelPort.RewardBit,devs.ioObj,2,40,100);


% --- Executes on button press in buttonClose.
function buttonClose_Callback(hObject, eventdata, handles)
% hObject    handle to buttonClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global specs devs
global pause_gui exit_gui kb_gui block_gui calib_gui

if exit_gui
    close(handles.windowh);
end


% --- Executes on button press in buttonKb.
function buttonKb_Callback(hObject, eventdata, handles)
% hObject    handle to buttonKb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global specs devs
global pause_gui exit_gui kb_gui block_gui calib_gui

kb_gui = 1;
guidata(hObject,handles);


% --- Executes on button press in buttonBlock.
function buttonBlock_Callback(hObject, eventdata, handles)
% hObject    handle to buttonBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global specs devs
global pause_gui exit_gui kb_gui block_gui calib_gui

block_gui = 1;
guidata(hObject,handles);


% --- Executes on button press in buttonCalib.
function buttonCalib_Callback(hObject, eventdata, handles)
% hObject    handle to buttonCalib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global specs devs
global pause_gui exit_gui kb_gui block_gui calib_gui

calib_gui = 1;
guidata(hObject,handles);