function varargout = demo(varargin)
% DEMO MATLAB code for demo.fig
%      DEMO, by itself, creates a new DEMO or raises the existing
%      singleton*.
%
%      H = DEMO returns the handle to a new DEMO or the handle to
%      the existing singleton*.
%
%      DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO.M with the given input arguments.
%
%      DEMO('Property','Value',...) creates a new DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demo

% Last Modified by GUIDE v2.5 27-Aug-2018 23:14:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
	'gui_Singleton',  gui_Singleton, ...
	'gui_OpeningFcn', @demo_OpeningFcn, ...
	'gui_OutputFcn',  @demo_OutputFcn, ...
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

end
% --- Executes just before demo is made visible.
function demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demo (see VARARGIN)

% Choose default command line output for demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = demo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

img = imread('img01.jpg');
axes(handles.axes1);
imshow(img);
handles.img = img;
guidata(hObject,handles);
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 获取鼠标位置及子图
pt = get(gca,'CurrentPoint');
x = round(pt(1,1));
y = round(pt(1,2));
width = 200;
handles.width = width;
guidata(hObject,handles);
img = handles.img;
axes(handles.axes2);
up = y-width/2;
down = y+width/2;
left = x-width/2;
right = x+width/2;
if up < 1
	up = 1;
end
if down > size(img,1)
	down = size(img,1);
end
if left < 1
	left = 1;
end
if right > size(img,2)
	right = size(img,2);
end
subimg = img(up:down,left:right);
imshow(subimg);
% imwrite(subimg,'line01.jpg');
hold on
%% 检测元件
thresh = graythresh(subimg);     %自动确定二值化阈值
subimgBW = im2bw(subimg,thresh);       %对图像二值化
tempImage=imread('switch01.jpg');
[m,n]=size(subimg);
[tm,tn] = size(rgb2gray(tempImage));
tempImageBW = im2bw(tempImage,thresh);       %对图像二值化
tempImageBW = ~tempImageBW;
result = searchTemplate(tempImage,subimgBW);
[tx,ty]=find( roundn(result,-2)>=0.94);
for i = 1:length(tx)
	iMaxPos = tx(i);
	jMaxPos = ty(i);
	plot([jMaxPos,jMaxPos+tn-1],[iMaxPos,iMaxPos],'-r','linewidth',1);
	plot([jMaxPos+tn-1,jMaxPos+tn-1],[iMaxPos,iMaxPos+tm-1],'-r','linewidth',1);
	plot([jMaxPos,jMaxPos+tn-1],[iMaxPos+tm-1,iMaxPos+tm-1],'-r','linewidth',1);
	plot([jMaxPos,jMaxPos],[iMaxPos,iMaxPos+tm-1],'-r','linewidth',1);
end
if isempty(tx)~=1
	pos = [ty(1),tx(1)];
	subimgBW(pos(2):pos(2)+tm-1,pos(1):pos(1)+tn-1) = ~(xor((~subimgBW(pos(2):pos(2)+tm-1,pos(1):pos(1)+tn-1)),(tempImageBW)));
% 	subimgBW=filter2(fspecial('average',3),subimgBW.*255)/255; %模板尺寸为1
end

tempImage=imread('arrow01.jpg');
[m,n]=size(subimg);
[tm,tn] = size(rgb2gray(tempImage));
tempImageBW = im2bw(tempImage,thresh);       %对图像二值化
tempImageBW = ~tempImageBW;
result = searchTemplate(tempImage,subimgBW);
[tx,ty]=find( roundn(result,-2)>=0.94);
for i = 1:length(tx)
	iMaxPos = tx(i);
	jMaxPos = ty(i);
	plot([jMaxPos,jMaxPos+tn-1],[iMaxPos,iMaxPos],'-g','linewidth',1);
	plot([jMaxPos+tn-1,jMaxPos+tn-1],[iMaxPos,iMaxPos+tm-1],'-g','linewidth',1);
	plot([jMaxPos,jMaxPos+tn-1],[iMaxPos+tm-1,iMaxPos+tm-1],'-g','linewidth',1);
	plot([jMaxPos,jMaxPos],[iMaxPos,iMaxPos+tm-1],'-g','linewidth',1);
end
if isempty(tx)~=1
	pos = [ty(1),tx(1)];
	subimgBW(pos(2):pos(2)+tm-1,pos(1):pos(1)+tn-1) = ~(xor((~subimgBW(pos(2):pos(2)+tm-1,pos(1):pos(1)+tn-1)),(tempImageBW)));
% 	subimgBW=filter2(fspecial('average',7),subimgBW.*255)/255; %模板尺寸为1
end

se = strel('disk',1);%结构元素se
subimgBW=~(imopen(~subimgBW,se));

% 直线标记
L = bwlabel(~subimgBW,4);% 四连通区域标记
num = max(max(L));
pos = zeros(num,4);% 标记每个单连通区域的边界
lmark = zeros(num,1);% 标记是否为连接线
for i = 1:num
	[m,n]=find(L==i);
	pos(i,:) = [max(m),min(m),max(n),min(n)];
	if max(m)-min(m)>30||max(n)-min(n)>30
		lmark(i) = 1;
	end
end

for i = 1:num
	if lmark(i) == 1
		[m,n]=find(L==i);
		for j = 1:length(m)
			subimgBW(m(j),n(j))=1;
		end
	end
end
% s = regionprops(~subimgBW,'centroid');
% centroids = cat(1, s.Centroid);

axes(handles.axes3);
imshow(subimgBW)
% hold on
% plot(centroids(:,1),centroids(:,2), 'b*')
fprintf('%d\n',length(tx));

end
