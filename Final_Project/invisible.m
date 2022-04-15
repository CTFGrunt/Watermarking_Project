function varargout = invisible(varargin)
% INVISIBLE MATLAB code for invisible.fig
%      INVISIBLE, by itself, creates a new INVISIBLE or raises the existing
%      singleton*.
%
%      H = INVISIBLE returns the handle to a new INVISIBLE or the handle to
%      the existing singleton*.
%
%      INVISIBLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INVISIBLE.M with the given input arguments.
%
%      INVISIBLE('Property','Value',...) creates a new INVISIBLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before invisible_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to invisible_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help invisible

% Last Modified by GUIDE v2.5 12-Apr-2022 01:22:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @invisible_OpeningFcn, ...
                   'gui_OutputFcn',  @invisible_OutputFcn, ...
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


% --- Executes just before invisible is made visible.
function invisible_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to invisible (see VARARGIN)

% Choose default command line output for invisible
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes invisible wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = invisible_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in originale.
function originale_Callback(hObject, eventdata, handles)
% hObject    handle to originale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = uigetfile('.png','.jpg');
if img~=0
    img = imread(img);
    axes(handles.axes1);
    handles.img=img;
    imshow(img);
    setappdata(0,'IOriginale',img);
else
    warndlg('Veuillez sélectionner une image');
end
guidata(hObject,handles);


% --- Executes on button press in applWatmk.
function applWatmk_Callback(hObject, eventdata, handles)
% hObject    handle to applWatmk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.img; msq=handles.msq;

if length(size(img))>2
    img=rgb2gray(img);
end

im        = imresize(img,[512 512]); 
watermark = imresize(im2bw((msq)),[32 32]);

x={}; 
dct_img=blkproc(img,[8,8],@dct2);% DCT of image using 8X8 block
m=dct_img;
k=1; dr=0; dc=0;
% dr is to address 1:8 row every time for new block in x
% dc is to address 1:8 column every time for new block in x
% k is to change the no. of cell

%%%%%%%%%%%%%%%%% To divide image in to 4096---8X8 blocks %%%%%%%%%%%%%%%%%%
for ii=1:8:512 % To address row -- 8X8 blocks of image
    for jj=1:8:512 % To address columns -- 8X8 blocks of image
        for i=ii:(ii+7) % To address rows of blocks
            dr=dr+1;
            for j=jj:(jj+7) % To address columns of block
                dc=dc+1;
                z(dr,dc)=m(i,j);
            end
            dc=0;
        end
        x{k}=z; k=k+1;
        z=[]; dr=0;
    end
end
nn=x;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% To insert watermark in to  blocks %%%%%
i=[]; j=[]; w=1; wmrk=watermark; welem=numel(wmrk); % welem - no. of elements
for k=1:4096
    kx=(x{k}); % Extracting block into kx for processing
    for i=1:8 % To address row of block
        for j=1:8 % To adress column of block
            if (i==8) && (j==8) && (w<=welem) % Eligiblity condition to insert watremark
                % i=1 and j=1 - means embedding element in first bit of every block                             
                 if wmrk(w)==0
                    kx(i,j)=kx(i,j)+35;
                elseif wmrk(w)==1
                    kx(i,j)=kx(i,j)-35;
                 end                                
            end            
        end        
    end
    w=w+1;
    x{k}=kx; kx=[]; % Watermark value will be replaced in block
end     

i=[]; j=[]; data=[]; count=0;
embimg1={}; % Changing complete row cell of 4096 into 64 row cell 
for j=1:64:4096
    count=count+1;
    for i=j:(j+63)
        data=[data,x{i}];
    end
    embimg1{count}=data;
    data=[];
end

% Change 64 row cell in to particular columns to form image
i=[]; j=[]; data=[]; 
embimg=[];  % final watermark image 
for i=1:64
    embimg=[embimg;embimg1{i}];
end
embimg=(uint8(blkproc(embimg,[8 8],@idct2)));
imwrite(embimg,'outgray.jpg')
handles.embimg=embimg;
embimg = ind2rgb(embimg, copper(256));
imwrite(embimg,'outcolor.jpg')
axes(handles.axes1);
    imshow(embimg);
    setappdata(0,'Matermarked',embimg);
%p=psnr(img,embimg);
guidata(hObject,handles);


% --- Executes on button press in extrMsq.
function extrMsq_Callback(hObject, eventdata, handles)
% hObject    handle to extrMsq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
embimg = handles.embimg;
[row clm]=size(embimg);
m=embimg;

%%%%%%%%%%%%%%%%% To divide image in to 4096---8X8 blocks %%%%%%%%%%%%%%%%%%
k=1; dr=0; dc=0;
% dr is to address 1:8 row every time for new block in x
% dc is to address 1:8 column every time for new block in x
% k is to change the no. of cell
for ii=1:8:row % To address row -- 8X8 blocks of image
    for jj=1:8:clm % To address columns -- 8X8 blocks of image
        for i=ii:(ii+7) % To address rows of blocks
            dr=dr+1;
            for j=jj:(jj+7) % To address columns of block
                dc=dc+1;
                z(dr,dc)=m(i,j);
            end
            dc=0;
        end
        x{k}=z; k=k+1;
        z=[]; dr=0;
    end
end
nn=x;
wm=[]; wm1=[]; k=1; wmwd=[]; wmwd1=[]
while(k<1025)
    for i=1:32
    kx=x{k}; % Extracting Blocks one by one
    dkx=blkproc(kx,[8 8],@dct2); % Applying Dct
    nn{k}=dkx; % Save DCT values in new block to cross check
    
    %% Change me for pixel location
    wm1=[wm1 dkx(8,8)]; % Forming a row of 32 by 8,8 element
   
    % Extracting water mark without dct
     wmwd1=[wmwd1 kx(8,8)];
      k=k+1;
    end
    wm=[wm;wm1]; wm1=[]; % Forming columns of 32x32
    wmwd=[wmwd;wmwd1]; wmwd1=[];
end
for i=1:32
    for j=1:32
        diff=wm(i,j); 
        if diff >=0
            wm(i,j)=0;
        elseif diff < 0
            wm(i,j)=1;
        end
    end
end

wm=wm';
imwrite(wm,'masque.jpg')
extr = imread('masque.jpg');
axes(handles.axes1);
    imshow(extr);
    setappdata(0,'Masque',extr);


% --- Executes on key press with focus on extrMsq and none of its controls.
function extrMsq_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to extrMsq (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in filigrane.
function filigrane_Callback(hObject, eventdata, handles)
% hObject    handle to filigrane (see GCBO)
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


% --- Executes on key press with focus on applWatmk and none of its controls.
function applWatmk_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to applWatmk (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on filigrane and none of its controls.
function filigrane_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to filigrane (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on key press with focus on originale and none of its controls.
function originale_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to originale (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
