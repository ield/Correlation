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

% Last Modified by GUIDE v2.5 16-Apr-2020 14:55:13

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Here starts the part I have modified %%

%% Main Function
% This function is executed at the beginning of the program.
% It initializes some values. Their explaination is written next to them.
% 
function main_OpeningFcn(hObject, eventdata, handles, varargin)
handles.n = 1.468;          %Fiber refraction index

handles.c = 2.9979e8;       %Speed of light in vacuum

handles.pulse = 80;         %Ideal number of points per pulse
handles.m = 255;            %Length of the M-Sequence
handles.isAir = 0;

handles.fFPGA = 25;         %Ideal frequency of FPGA
handles.fReal = 25.0134;    %Real frequency of FPGA

% This is done to execute things
handles.output = hObject;
guidata(hObject, handles);

%% Correlate Button
% This funtion describes what happens when the correlate button is pressed.
% 1.    It is done the correlation between the two files which have been
%       selected previously (if the files have not been selected there is
%       an error).
% 2.    Plots the normal correlation, using the results from the functions.
%       In the function managePlot, the axis and the tile are properly
%       configured.
% 3.    Displays in the boxes on the right the results received (SNR values
%       and distance), all of them provided by the correlation function.
% 4.    Performs the same job with the Fourier correlation. Seeing the
%       result obtained is the same, probably this correlation will not be
%       done in the future.
function correlateButton_Callback(hObject, eventdata, handles)
%1. 
[handles.xaxis, handles.norCor, handles.norDis, handles.norDisInter, handles.norSnrCor, handles.norSnrSig, handles.norSupRatio] = correlate(handles.filename1, handles.filename2, handles.pulse, handles.m, handles.fFPGA, handles.fReal, handles.n, handles.c, handles.isAir);
[handles.xaxis, handles.fouCor, handles.fouDis, handles.fouDisInter, handles.fouSnrCor, handles.fouSnrSig, handles.fouSupRatio] = correlateFourier(handles.filename1, handles.filename2, handles.pulse, handles.m, handles.fFPGA, handles.fReal, handles.n, handles.c, handles.isAir);

%-%-Normal Correlation-%-%

% Selects the first axes of the program, so that the plot is done in the
%   first one.
axes(handles.normalCorrelation);

% Plots and manages the plot titles and axis
plot(handles.xaxis, handles.norCor, 'k');
managePlot(handles.xaxis, false);

% Displays the results received
set(handles.norCorTx, 'String', num2str(handles.norSnrCor));
set(handles.norSigTx, 'String', num2str(handles.norSnrSig));
set(handles.norDisTx, 'String', num2str(handles.norDis));
set(handles.norSupTx, 'String', num2str(handles.norSupRatio));
set(handles.norDisInterTx, 'String', num2str(handles.norDisInter));

%-%-Fourier Correlation-%-%

% Selects the second axes of the program, so that the plot is done in the
%   second one.
axes(handles.fourierCorrelation);

% Plots and manages the plot titles and axis
plot(handles.xaxis, handles.fouCor, 'k');
managePlot(handles.xaxis, true);

% Displays the results received
set(handles.fouCorTx, 'String', num2str(handles.fouSnrCor));
set(handles.fouSigTx, 'String', num2str(handles.fouSnrSig));
set(handles.fouDisTx, 'String', num2str(handles.fouDis));
set(handles.fouSupTx, 'String', num2str(handles.fouSupRatio));
set(handles.fouDisInterTx, 'String', num2str(handles.fouDisInter));

% Finally, it refreshes all the values
guidata(hObject, handles)

%% Points menu
% This funtion describes what happens when a different number of points is
%   selected: the value of the string which is visible is transformed into
%   a number and that number is the new value of pulse. The value of the
%   string which is visible is the one which has been selected by the user.
function pointsMenu_Callback(hObject, eventdata, handles)
% Gets the value of the menu
str = get(hObject, 'String');
val = get(hObject, 'Value');

% Transforms the value to a number
handles.pulse =  str2num(str{val});

% Finally, it refreshes all the values
guidata(hObject, handles)

%% Frequency menu
% This funtion describes what happens when a different frequency is
%   selected: depending on the value of the string which is visible both
%   the real and the fpga frequencies are transformed
function freqMenu_Callback(hObject, eventdata, handles)
% Gets the value of the menu
str = get(hObject, 'String');
val = get(hObject, 'Value');

% Transforms the value of the real and fpga frequencies (these are
%   constants of course, the fpga is not modified)
switch str{val}
    case '25'
        handles.fFPGA = 25;
        handles.fReal = 25.0134;
    case '32'
        handles.fFPGA = 32;      
        handles.fReal = 31.978; 
    case '50'
        handles.fFPGA = 50;      
        handles.fReal = 50.25;   
end

% Finally, it refreshes all the values
guidata(hObject, handles)

%% Select File Button
% These two functions describe how to select a file. First, a file browser
%   opens, and the user selects a file. Then, with the name of the file
%   chosen, it is refreshed either filename 1 or 2 (depending on the
%   function) for the correlation. Finally, the text in the button changes
%   so that it displays the name of the file selected.
function txSelector_Callback(hObject, eventdata, handles)
% Opens file browser
[filename, filepath] = uigetfile({'*.txt'}, 'Search file');

% Updates filename1
handles.filename1 = [filepath filename];

% Changes the text in the button so that it displays the name of the file
%   selected.
set(hObject,'String',filename);

% Finally, it refreshes all the values
guidata(hObject, handles)


function rxSelector_Callback(hObject, eventdata, handles)
% Opens file browser
[filename, filepath] = uigetfile({'*.txt'}, 'Search file');

% Updates filename1
handles.filename2 = [filepath filename];

% Changes the text in the button so that it displays the name of the file
%   selected.
set(hObject,'String',filename);

% Finally, it refreshes all the values
guidata(hObject, handles)


%% Check box air vs fiber.
% This checkbox decides whether the measurements is done in air or fiber.
% The value is stored in a boolean isAir.
function airCB_Callback(hObject, eventdata, handles)

handles.isAir = get(handles.airCB, 'value');
guidata(hObject, handles)


%% Here ends the part I have done. The rest is done by default
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


% --- Executes during object creation, after setting all properties.
function pointsMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function freqMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freqMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

