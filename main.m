function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 14-Mar-2020 19:37:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
n = 1.468;          %Fiber refraction index
c = 2.9979e8;       %Speed of light in vacuum

pulse = 80;         %Ideal number of points per pulse
m = 255;            %Length of the M-Sequence

fFPGA = 25;         %Ideal frequency of FPGA
fReal = 25.0134;    %Real frequency of FPGA

%%Importing signals

filename1 = 'tx.txt';
filename2 = '1000mrx.txt';

[handles.xaxis, handles.norCor, handles.norDis, handles.norSnrCor, handles.norSnrSig] = correlate(filename1, filename2, pulse, m, fFPGA, fReal, n, c);
[handles.xaxis, handles.fouCor, handles.fouDis, handles.fouSnrCor, handles.fouSnrSig] = correlateFourier(filename1, filename2, pulse, m, fFPGA, fReal, n, c);
% plot(handles.xaxis, handles.norCor);

handles.output = hObject;


guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in correlateButton.
function correlateButton_Callback(hObject, eventdata, handles)

axes(handles.normalCorrelation);
plot(handles.xaxis, handles.norCor);
managePlot(handles.xaxis, false);
set(handles.norCorTx, 'String', num2str(handles.norSnrCor));
set(handles.norSigTx, 'String', num2str(handles.norSnrSig));
set(handles.norDisTx, 'String', num2str(handles.norDis));

axes(handles.fourierCorrelation);
plot(handles.xaxis, handles.fouCor);
managePlot(handles.xaxis, true);
set(handles.fouCorTx, 'String', num2str(handles.fouSnrCor));
set(handles.fouSigTx, 'String', num2str(handles.fouSnrSig));
set(handles.fouDisTx, 'String', num2str(handles.fouDis));



function boxCorFou_Callback(hObject, eventdata, handles)
% hObject    handle to boxCorFou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxCorFou as text
%        str2double(get(hObject,'String')) returns contents of boxCorFou as a double


% --- Executes during object creation, after setting all properties.
function boxCorFou_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxCorFou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boxSigFou_Callback(hObject, eventdata, handles)
% hObject    handle to boxSigFou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxSigFou as text
%        str2double(get(hObject,'String')) returns contents of boxSigFou as a double


% --- Executes during object creation, after setting all properties.
function boxSigFou_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxSigFou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boxSigNor_Callback(hObject, eventdata, handles)
% hObject    handle to boxSigNor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxSigNor as text
%        str2double(get(hObject,'String')) returns contents of boxSigNor as a double


% --- Executes during object creation, after setting all properties.
function boxSigNor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxSigNor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boxCorNor_Callback(hObject, eventdata, handles)
% hObject    handle to boxCorNor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxCorNor as text
%        str2double(get(hObject,'String')) returns contents of boxCorNor as a double


% --- Executes during object creation, after setting all properties.
function boxCorNor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxCorNor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boxDisFou_Callback(hObject, eventdata, handles)
% hObject    handle to boxDisFou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxDisFou as text
%        str2double(get(hObject,'String')) returns contents of boxDisFou as a double


% --- Executes during object creation, after setting all properties.
function boxDisFou_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxDisFou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boxDisNor_Callback(hObject, eventdata, handles)
% hObject    handle to boxDisNor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boxDisNor as text
%        str2double(get(hObject,'String')) returns contents of boxDisNor as a double


% --- Executes during object creation, after setting all properties.
function boxDisNor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boxDisNor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    
