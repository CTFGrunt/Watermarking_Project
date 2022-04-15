function varargout = essaigui(varargin)
% ESSAIGUI MATLAB code for essaigui.fig
%      ESSAIGUI, by itself, creates a new ESSAIGUI or raises the existing
%      singleton*.
%
%      H = ESSAIGUI returns the handle to a new ESSAIGUI or the handle to
%      the existing singleton*.
%
%      ESSAIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESSAIGUI.M with the given input arguments.
%
%      ESSAIGUI('Property','Value',...) creates a new ESSAIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before essaigui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to essaigui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help essaigui

% Last Modified by GUIDE v2.5 12-Apr-2022 19:02:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @essaigui_OpeningFcn, ...
                   'gui_OutputFcn',  @essaigui_OutputFcn, ...
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


% --- Executes just before essaigui is made visible.
function essaigui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to essaigui (see VARARGIN)

% Choose default command line output for essaigui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes essaigui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = essaigui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in image_originale.
function image_originale_Callback(hObject, eventdata, handles)
% hObject    handle to image_originale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = uigetfile('.png','.jpg');
if img~=0
    img = imread(img);
    axes(handles.axes1);
    handles.img=img;
    imshow(img);
    setappdata(0,'Originale',img);
else
    warndlg('Veuillez sélectionner une image');
end
guidata(hObject,handles);


% --- Executes on button press in watermark.
function watermark_Callback(hObject, eventdata, handles)
% hObject    handle to watermark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msq = uigetfile('*.png','*.jpg');
if msq ~=0
    msq = imread(msq);
    axes(handles.axes1);
    handles.msq=msq;
    imshow(msq);
    setappdata(0,'Filigrane',msq);
else
    warndlg('Veuillez sélectionner une image');
end
guidata(hObject,handles);


% --- Executes on button press in Appliquer_le_watermark.
function Appliquer_le_watermark_Callback(hObject, eventdata, handles)
% hObject    handle to Appliquer_le_watermark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.img; msq=handles.msq;

modified = imresize(msq,[150,150],'bilinear');
disp(size(modified));
temp = zeros(size(img),'uint8');
%[rows, cols, depth] = size(modified);
temp(351:500,351:500,:) = modified;

alpha = 0.8; %definit le degré de transparence
watermarked_image = alpha * img  + (1-alpha)*temp;
imwrite(watermarked_image,'V_Watmk.jpg')
imshow(watermarked_image);
setappdata(0,'Filigrane',watermarked_image);


% --- Executes on button press in enlever_watermark.
function enlever_watermark_Callback(hObject, eventdata, handles)
% hObject    handle to enlever_watermark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.img
imshow(img);
setappdata(0,'initiale',img);


% --- Executes on key press with focus on enlever_watermark and none of its controls.
function enlever_watermark_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to enlever_watermark (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
