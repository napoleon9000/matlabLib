function varargout = POSCARstructureCompare(varargin)
% POSCARSTRUCTURECOMPARE MATLAB code for POSCARstructureCompare.fig
%      POSCARSTRUCTURECOMPARE, by itself, creates a new POSCARSTRUCTURECOMPARE or raises the existing
%      singleton*.
%
%      H = POSCARSTRUCTURECOMPARE returns the handle to a new POSCARSTRUCTURECOMPARE or the handle to
%      the existing singleton*.
%
%      POSCARSTRUCTURECOMPARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POSCARSTRUCTURECOMPARE.M with the given input arguments.
%
%      POSCARSTRUCTURECOMPARE('Property','Value',...) creates a new POSCARSTRUCTURECOMPARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before POSCARstructureCompare_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to POSCARstructureCompare_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help POSCARstructureCompare

% Last Modified by GUIDE v2.5 16-Apr-2015 15:38:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @POSCARstructureCompare_OpeningFcn, ...
                   'gui_OutputFcn',  @POSCARstructureCompare_OutputFcn, ...
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



% --- Executes just before POSCARstructureCompare is made visible.
function POSCARstructureCompare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to POSCARstructureCompare (see VARARGIN)

% Choose default command line output for POSCARstructureCompare
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global P1Path;
global P2Path;
P1Path='POSCAR1';
P2Path='POSCAR2';
% UIWAIT makes POSCARstructureCompare wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = POSCARstructureCompare_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
global P1Path;
parentPath=pwd;
select=get(hObject,'Value');
String=get(hObject,'String');
P1Path=strcat(parentPath,'\',String(select));
P1Path=char(P1Path);
set(handles.text11,'String',P1Path);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
fileListCell=struct2cell(dir);
fileList=fileListCell(1,3:end)';
set(hObject,'String',fileList);

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
global P2Path;
parentPath=pwd;
select=get(hObject,'Value');
String=get(hObject,'String');
P2Path=strcat(parentPath,'\',String(select));
P2Path=char(P2Path);
set(handles.text12,'String',P2Path);

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
fileListCell=struct2cell(dir);
fileList=fileListCell(1,3:end)';
set(hObject,'String',fileList);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global P1Path;
global P2Path;

hold off
ratio1=str2num(get(handles.edit1,'String'));
ratio2=str2num(get(handles.edit2,'String'));
ratio3=str2num(get(handles.edit3,'String'));
file=fopen(P1Path,'r');
lineContent=0;
dataStr1='';
while(lineContent~=-1)                  %%Reading POSCAR1 File
    lineContent=fgetl(file);
    dataStr1=char(dataStr1,num2str(lineContent));
end
fclose(file);
dataStr1(dataStr1=='F')=' ';            %% Delete F and T
dataStr1(dataStr1=='T')=' ';

                                        %Extract data from POSCAR1
data1=zeros(size(dataStr1,1),3);
for i=1:size(dataStr1)
    if(~isempty(str2num(dataStr1(i,:))))
        data1(i,:)=str2num(dataStr1(i,:));
    end
end
data1(end,:)=[];
atom1=data1(8,1);
atom2=data1(8,2);
atom3=data1(8,3);
atomNum1=sum(data1(8,:));

a1=data1(4,1);                            % cell parameters
b1=data1(5,2);
c1=data1(6,3);
if(dataStr1(10)=='D')
    coordinate1=data1(11:10+atomNum1,:);              % extract coordinates of atoms that need to calculate
    coordinate1=[a1*coordinate1(:,1),b1*coordinate1(:,2),c1*coordinate1(:,3)];
elseif(dataStr1(9)=='D')
    coordinate1=data1(10:9+atomNum1,:);              % extract coordinates of atoms that need to calculate
    coordinate1=[a1*coordinate1(:,1),b1*coordinate1(:,2),c1*coordinate1(:,3)];
elseif(dataStr1(10)=='C')
    coordinate1=data1(11:10+atomNum1,:);              % extract coordinates of atoms that need to calculate
elseif(dataStr1(9)=='C')
    coordinate1=data1(10:9+atomNum1,:);              % extract coordinates of atoms that need to calculate   
else
    disp('Can not read POSCAR');
end


file=fopen(P2Path,'r');
lineContent=0;
dataStr2='';
while(lineContent~=-1)                  %%Reading POSCAR2 File
    lineContent=fgetl(file);
    dataStr2=char(dataStr2,num2str(lineContent));
end
fclose(file);
dataStr2(dataStr2=='F')=' ';
dataStr2(dataStr2=='T')=' ';
                                        %Extract data from POSCAR2
data2=zeros(size(dataStr2,1),3);
for i=1:size(dataStr2,1)
    if(~isempty(str2num(dataStr2(i,:))))
        data2(i,:)=str2num(dataStr2(i,:));
    end
end
data2(end,:)=[];
atomNum2=sum(data2(8,:));
%coordinate2=data2(11:10+atomNum2,:);             % extract coordinates of atoms that need to calculate
a2=data2(4,1);                            % cell parameters
b2=data2(5,2);
c2=data2(6,3);

if(dataStr2(10)=='D')
    coordinate2=data2(11:10+atomNum2,:);              % extract coordinates of atoms that need to calculate
    coordinate2=[a2*coordinate2(:,1),b2*coordinate2(:,2),c2*coordinate2(:,3)];
elseif(dataStr2(9)=='D')
    coordinate2=data2(10:9+atomNum2,:);              % extract coordinates of atoms that need to calculate
    coordinate2=[a2*coordinate2(:,1),b2*coordinate2(:,2),c2*coordinate2(:,3)];
elseif(dataStr2(10)=='C')
    coordinate2=data2(11:10+atomNum2,:);              % extract coordinates of atoms that need to calculate
elseif(dataStr2(9)=='C')
    coordinate2=data2(10:9+atomNum2,:);              % extract coordinates of atoms that need to calculate   
else
    disp('Can not read POSCAR');
end


if(a1~=a2||b1~=b2||c1~=c2||atomNum1~=atomNum2)
    disp('The cell parameters does not match');
end
dcoordinate=coordinate2-coordinate1;




quiver3([coordinate1(1:atom1,1);0],[coordinate1(1:atom1,2);0],[coordinate1(1:atom1,3);0],[dcoordinate(1:atom1,1);.057735],[dcoordinate(1:atom1,2);.057735],[dcoordinate(1:atom1,3);.057735],ratio1,'b');
hold on
quiver3([coordinate1(atom1+1:atom1+atom2,1);1],[coordinate1(atom1+1:atom1+atom2,2);1],[coordinate1(atom1+1:atom1+atom2,3);1],[dcoordinate(atom1+1:atom1+atom2,1);.057735],[dcoordinate(atom1+1:atom1+atom2,2);.057735],[dcoordinate(atom1+1:atom1+atom2,3);.057735],ratio2,'r');
quiver3([coordinate1(atom1+atom2+1:atom1+atom2+atom3,1);2],[coordinate1(atom1+atom2+1:atom1+atom2+atom3,2);2],[coordinate1(atom1+atom2+1:atom1+atom2+atom3,3);2],[dcoordinate(atom1+atom2+1:atom1+atom2+atom3,1);.057735],[dcoordinate(atom1+atom2+1:atom1+atom2+atom3,2);.057735],[dcoordinate(atom1+atom2+1:atom1+atom2+atom3,3);.057735],ratio3,'k');
legend('O','Ca','C');

plot3(coordinate2(1:data2(8,1),1),coordinate2(1:data2(8,1),2),coordinate2(1:data2(8,1),3),'bo');
plot3(coordinate2(data2(8,1)+1:data2(8,1)+data2(8,2),1),coordinate2(data2(8,1)+1:data2(8,1)+data2(8,2),2),coordinate2(data2(8,1)+1:data2(8,1)+data2(8,2),3),'ro');
plot3(coordinate2(data2(8,2)+data2(8,1)+1:data2(8,2)+data2(8,1)+data2(8,3),1),coordinate2(data2(8,2)+data2(8,1)+1:data2(8,2)+data2(8,1)+data2(8,3),2),coordinate2(data2(8,2)+data2(8,1)+1:data2(8,2)+data2(8,1)+data2(8,3),3),'ko');
%{
%}
plot3(coordinate1(1:data1(8,1),1),coordinate1(1:data1(8,1),2),coordinate1(1:data1(8,1),3),'b*');
plot3(coordinate1(data1(8,1)+1:data1(8,1)+data1(8,2),1),coordinate2(data1(8,1)+1:data1(8,1)+data1(8,2),2),coordinate1(data1(8,1)+1:data1(8,1)+data1(8,2),3),'r*');
plot3(coordinate1(data1(8,2)+data1(8,1)+1:data1(8,2)+data1(8,1)+data1(8,3),1),coordinate1(data1(8,2)+data1(8,1)+1:data1(8,2)+data1(8,1)+data1(8,3),2),coordinate1(data1(8,2)+data1(8,1)+1:data1(8,2)+data1(8,1)+data1(8,3),3),'k*');

rotate3d on
grid on;
axis equal
title('The difference of SFE slab with full relaxtion and X Y axis constrains');
axis([0 a1 0 b1 0 c1]);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exit;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global P1Path;
[filename pathname filter] = uigetfile('*.*','Choose POSCAR1');
if filter == 0
return
end
P1Path = fullfile(pathname,filename);
set(handles.text11,'String',P1Path);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global P2Path;
[filename pathname filter] = uigetfile('*.*','Choose POSCAR1');
if filter == 0
return
end
P2Path = fullfile(pathname,filename);
set(handles.text12,'String',P2Path);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
status=get(hObject,'Value');
if(status==1)
    rotate3d on
    zoom off
    set(handles.radiobutton3,'Value',0)
else
    rotate3d off
    zoom on
    set(handles.radiobutton3,'Value',1)
end

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
status=get(hObject,'Value');
if(status==1)
    rotate3d off
    zoom on
    set(handles.radiobutton2,'Value',0)
else
    rotate3d on
    zoom off
    set(handles.radiobutton2,'Value',1)
end

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider1Max=str2num(get(handles.edit4,'String'));
slider1=slider1Max*get(hObject,'Value');
set(handles.edit1,'String',num2str(slider1));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider2Max=str2num(get(handles.edit5,'String'));
slider2=slider2Max*get(hObject,'Value');
set(handles.edit2,'String',num2str(slider2));

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider3Max=str2num(get(handles.edit6,'String'));
slider3=slider3Max*get(hObject,'Value');
set(handles.edit3,'String',num2str(slider3));


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)       %% TODO: save as fig format: saveas
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FG=getframe(gcf);
imwrite(FG.cdata,'FG.jpg')
%saveas(gcf,'StructureDifference.jpg','jpg')


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
positionFigure1=get(hObject,'Position');
positionAxes1=get(handles.axes1,'Position');
positionAxes1(3)=positionFigure1(3)-(246.0-152.6);
positionAxes1(4)=positionFigure1(4)-(59.923-46.385);
set(handles.axes1,'Position',positionAxes1);
