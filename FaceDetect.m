function varargout = FaceDetect(varargin)
% FACEDETECT MATLAB code for FaceDetect.fig
%      FACEDETECT, by itself, creates a new FACEDETECT or raises the existing
%      singleton*.
%
%      H = FACEDETECT returns the handle to a new FACEDETECT or the handle to
%      the existing singleton*.
%
%      FACEDETECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACEDETECT.M with the given input arguments.
%
%      FACEDETECT('Property','Value',...) creates a new FACEDETECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FaceDetect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FaceDetect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FaceDetect

% Last Modified by GUIDE v2.5 10-Jul-2014 13:21:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FaceDetect_OpeningFcn, ...
                   'gui_OutputFcn',  @FaceDetect_OutputFcn, ...
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


% --- Executes just before FaceDetect is made visible.
function FaceDetect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FaceDetect (see VARARGIN)

% Choose default command line output for FaceDetect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FaceDetect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FaceDetect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%Global Variables


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global original;
FDetect = vision.CascadeObjectDetector();
I = original;
%I = imresize(I,scale);
BB = step(FDetect,I)
imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',3,'LineStyle','-','EdgeColor','r');
end
title('Face Detection');
hold off;    
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
global original;
global phase1;
global phase2;
global phase3;
global phase4;
rgbInputImage = original;
labInputImage = applycform(rgbInputImage,makecform('srgb2lab'));
Lbpdfhe = fcnBPDFHE(labInputImage(:,:,1));
labOutputImage = cat(3,Lbpdfhe,labInputImage(:,:,2),labInputImage(:,:,3));
rgbOutputImage = applycform(labOutputImage,makecform('lab2srgb'));
img=rgbOutputImage;
phase1=img;
final_image = zeros(size(img,1), size(img,2));
if(size(img, 3)>1)
for i = 1:size(img,1)
for j = 1:size(img,2)
R = img(i,j,1);
G = img(i,j,2);
B = img(i,j,3);
if(R > 92 && G > 40 && B > 20)
v = [R,G,B];
if((max(v)-min(v))>15)
if(abs(R-G) > 15 && R > G && R > B)
%it is a skin
final_image(i,j) = 1;
end
end
end
end
end
%Grayscale To Binary.
binaryImage=im2bw(final_image,0.6);
phase2=binaryImage;
%Filling The Holes.
binaryImage = imfill(binaryImage, 'holes');
phase3=binaryImage;
binaryImage = bwareaopen(binaryImage,1890);   
phase4=binaryImage;
labeledImage = bwlabel(binaryImage, 8);
blobMeasurements = regionprops(labeledImage, final_image, 'all');
numberOfPeople = size(blobMeasurements, 1)
%axis square;
hold on;
imshow(rgbInputImage);
title('Final Image with bounding boxes');
for k = 1 : numberOfPeople % Loop through all blobs.
thisBlobsBox = blobMeasurements(k).BoundingBox; % Get list of pixels in current blob.
rectangle('Position',thisBlobsBox,'EdgeColor','B','LineWidth',2);
end
end





% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
    global phase1;
    global phase2;
    global phase3;
    global phase4;
    figure, imshow(phase1),title('Histogram Equlization');
    figure, imshow(phase2),title('Skin Detection and Segmentation');
    figure, imshow(phase3),title('Filling the holes');
    figure, imshow(phase4),title('Threshold Image');

% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    global original;
    imshow(original);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
    global original;
    scale = [350,250];
    [path,user_can] = imgetfile
    if user_can
        errordlg('Invalid Input','File Error');
    else
        original = imread(path);
        original = imresize(original,scale);
        imshow(original),title('Original Image');
    end
        
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
clear all;
close all;
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
