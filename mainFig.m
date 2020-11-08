function varargout = mainFig(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainFig_OpeningFcn, ...
                   'gui_OutputFcn',  @mainFig_OutputFcn, ...
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
h = findall(groot, 'Type', 'figure');
set(h,'Color', [0.5 0.5 0.5]);
% End initialization code - DO NOT EDIT


% --- Executes just before mainFig is made visible.
function mainFig_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for mainFig
handles.output = hObject;
handles.axes1.YAxis.Visible = 'off';
handles.axes1.XAxis.Visible = 'off';
handles.axes2.YAxis.Visible = 'off';
handles.axes2.XAxis.Visible = 'off';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainFig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mainFig_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function openImages_Callback(hObject, ~, handles)
[file, ~] = uigetfile('*.png;*.jpeg;*.jpg', 'Image Selection');
handles.imLoaded =(imread(file)); 
[~,~,c] = size(handles.imLoaded);
axes(handles.axes1);
if c >1 
    handles.imLoaded =(handles.imLoaded);
else
    handles.imLoaded =double(handles.imLoaded);
end
colormap gray
imagesc(handles.imLoaded);
handles.noisyImage = handles.imLoaded;
set(handles.original, 'Value', 1);
handles.isMaskLoaded = false;
handles.activate = 0;
guidata(hObject, handles)



% --------------------------------------------------------------------
function defaultIm_Callback(hObject, ~, handles)
handles.imLoaded = double(imread('cameraman.tif'));
handles.noisyImage = handles.imLoaded;
axes(handles.axes1);
imagesc(handles.imLoaded);
colormap gray; 
set(handles.original, 'Value', 1);
handles.isMaskLoaded = false;
guidata(hObject, handles)


% --------------------------------------------------------------------
function noised_Callback(hObject, ~, handles)
    [~,~,c] = size(handles.imLoaded);
if isfield(handles,'imLoaded') && c ==1
    
    sd= inputdlg({'Standard Deviation'},'Sd', [1 7]); 
    handles.noisyImage= add_gaussian_noise(handles.imLoaded, str2num(sd{1}));
    axes(handles.axes1);

    imagesc(handles.noisyImage);
    colormap gray;
    guidata(hObject, handles);
else
    set(handles.info, 'String', 'Load a gray scaled Image first')
end


% --- Executes during object creation, after setting all properties.
function lambdaVal_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function K_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function e1_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function t_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function enableDisable(hObject, handles,tVal, aVal, eVal, KVal, lVal)
set(handles.t, 'enable', tVal);
set(handles.a, 'enable', aVal);
set(handles.e1, 'enable', eVal)
set(handles.K, 'enable', KVal);
set(handles.lambdaVal, 'enable', lVal);
guidata(hObject, handles)

% --- Executes on button press in original.
function tk_Callback(hObject, event, handles)
enableDisable(hObject, handles,'off', 'off', 'off', 'on', 'on');
set(handles.K, 'String', '100');
set(handles.lambdaVal, 'String', '0.1');
guidata(hObject, handles);
update_Callback(hObject,event, handles);
set(handles.info,'String', 'Tikhonov method done');

% --- Executes on button press in tv.
function tv_Callback(hObject, event, handles)
enableDisable(hObject, handles,'on', 'off', 'on', 'on', 'on');
set(handles.K, 'String', '200');
set(handles.e1, 'String', '1');
set(handles.lambdaVal, 'String', '0.01');
set(handles.t, 'String', num2str(1/(handles.lambdaVal.Value+4)));
guidata(hObject, handles);
update_Callback(hObject, event, handles);
set(handles.info,'String', 'Denoise-TV method done');


% --- Executes on button press in fourierM.
function fourierM_Callback(hObject, event, handles)
enableDisable(hObject, handles,'off', 'off', 'off', 'off', 'on');
%img = fourier(handles.noisyImage,handles.lambdaVal);
axes(handles.axes2)
set(handles.info,'String', 'Wait...');
%handles.denoised= real(ifft2((img)));
%imagesc(handles.denoised);
update_Callback(hObject, event, handles);
set(handles.info,'String', 'Fourier method applied');
colormap gray


% --- Executes on button press in noisy.
function noisy_Callback(~, eventdata, handles)
if isfield(handles, 'noisyImage')
axes(handles.axes1)
imagesc(handles.noisyImage);
set(handles.info,'String', 'Noisy image displayed in the right Label');
colormap gray
else 
    set(handles.info, 'String', 'Load an Image firsrt')
end


% --- Executes on button press in original.
function original_Callback(hObject, eventdata, handles)
axes(handles.axes1)
imagesc(handles.imLoaded);
set(handles.info,'String', 'Original image displayed in the right Label');
colormap gray


% --- Executes on button press in heat_eq.
function heat_eq_Callback(hObject, eventdata, handles)
enableDisable(hObject, handles,'on', 'off', 'off', 'on', 'off');
set(handles.info,'String', 'Wait..');
set(handles.K, 'String', '100');
set(handles.t, 'String', num2str(0.05));
guidata(hObject, handles);
update_Callback(hObject, eventdata, handles);
set(handles.info,'String', 'Heat Equation done');


% --- Executes on button press in pm.
function pm_Callback(hObject, event, handles)
enableDisable(hObject, handles,'on', 'on', 'off', 'on', 'off');
set(handles.K, 'String', '100');
set(handles.t, 'String', num2str(0.05));
set(handles.a, 'String', num2str(15));
guidata(hObject, handles);
update_Callback(hObject, event, handles);
set(handles.info, 'String', 'Perona Malik Equation applied');


% --- Executes during object creation, after setting all properties.
function a_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
if isfield(handles, 'imLoaded')
l = str2double(get(handles.lambdaVal, 'String'));
K = str2double(get(handles.K, 'String'));
e = str2double(get(handles.e1, 'String'));
t = str2double(get(handles.t, 'String'));
a = str2double(get(handles.a, 'String'));
axes(handles.axes2)
set(handles.info,'String', 'Wait..');
if get(handles.tk, 'Value') ==1.0
handles.denoised =Denoise_Tikhonov(handles.noisyImage, K, l);
elseif get(handles.tv, 'Value') ==1.0
handles.denoised = Denoise_TV(handles.noisyImage,t , K, l, e);
elseif get(handles.heat_eq, 'Value') ==1.0
heat_equation(handles.noisyImage, t, K);
elseif get(handles.pm, 'Value') ==1.0
Perona_Malik(handles.noisyImage, t, K, a);
elseif get(handles.fourierM, 'Value') == 1.0
 img = fourier(handles.noisyImage,l);
 handles.denoised = real(ifft2((img)));
 imagesc(handles.denoised);
 colormap gray;
elseif get(handles.denoiseg1, 'Value') == 1.0
    handles.denoise = Denoise_g1(handles.noisyImage, t, K, l, e);
elseif get(handles.denoiseg2, 'Value') == 1.0
    handles.denoise = Denoise_g2(handles.noisyImage, t, K, l,e );
elseif get(handles.inpaint, 'Value') == 1.0
    if ~handles.isMaskLoaded
        axes(handles.axes1)      
        if ~ isfield(handles, 'roi')
            handles.roi = imfreehand;
            axes(handles.axes2)
            M = createMask(handles.roi);
            [rows, col] = find(~M);
            handles.M = zeros(size(M));
            for i = 1:size(rows)
                handles.M(rows(i), col(i)) = 1;
            end
        end
    end
    Inpainting_Tichonov(handles.imLoaded, handles.M, t, K, l);
    set(handles.info, 'String', 'Done');
elseif get(handles.inpaintingTV, 'Value') == 1.0
    if ~handles.isMaskLoaded
        axes(handles.axes1)      
        if ~ isfield(handles, 'roi')
            handles.roi = imfreehand;
            axes(handles.axes2)
            M = createMask(handles.roi);
            [rows, col] = find(~M);
            handles.M = zeros(size(M));
            for i = 1:size(rows)
                handles.M(rows(i), col(i)) = 1;
            end
        end
        axes(handles.axes2)
    end
    Inpainting_TV(handles.imLoaded, handles.M, t,e, K, l)
    set(handles.info, 'String', 'Done');
end
guidata(hObject, handles)
end

% --- Executes on button press in inpaint.
function inpaint_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of inpaint
enableDisable(hObject, handles,'on', 'off', 'off', 'on', 'on');
set(handles.K, 'String', '1000');
set(handles.t, 'String', num2str(0.01));
set(handles.lambdaVal, 'String', num2str(0.05));
guidata(hObject, handles)
update_Callback(hObject, eventdata, handles);


% --- Executes on button press in deconv.
function deconv_Callback(hObject, eventdata, handles)
G = fspecial('gaussian', [7 7], 5);
set(handles.K,  'String', '50');
enableDisable(hObject, handles, 'on', 'off', 'on', 'on', 'on');
im = imfilter(handles.imLoaded,G, 'replicate', 'conv');
e = str2double(get(handles.e1, 'String'));
K =str2double(get(handles.K,  'String')); 
l = str2double(get(handles.lambdaVal, 'String'));
t =  str2double(get(handles.t,  'String')); 
im_noised = add_gaussian_noise(im, 10);
axes(handles.axes1) 
imagesc(im_noised)
colormap gray
axes(handles.axes2);
deconvolution_TV(im_noised,G, t,e, K, l);


% --- Executes on button press in denoiseg1.
function denoiseg1_Callback(hObject, eventdata, handles)
% hObject    handle to denoiseg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of denoiseg1
enableDisable(hObject, handles,'on', 'off', 'on', 'on', 'on');
set(handles.K, 'String', '100');
set(handles.lambdaVal, 'String', '0.001');
set(handles.e1, 'String', '10')
set(handles.t, 'String', num2str(1/(handles.lambdaVal.Value+4)));
guidata(hObject, handles);
update_Callback(hObject, eventdata, handles);
set(handles.info,'String', 'Denoise-TV method done');


% --- Executes on button press in denoiseg2.
function denoiseg2_Callback(hObject, eventdata, handles)
% hObject    handle to denoiseg2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of denoiseg2
enableDisable(hObject, handles,'on', 'off', 'on', 'on', 'on');
set(handles.K, 'String', '500');
set(handles.lambdaVal, 'String', '0.001');
set(handles.t, 'String', '0.75');
guidata(hObject, handles);
update_Callback(hObject, eventdata, handles);
set(handles.info,'String', 'Denoise-TV method done');


% --- Executes on button press in inpaintingTV.
function inpaintingTV_Callback(hObject, eventdata, handles)
enableDisable(hObject, handles,'on', 'off', 'on', 'on', 'on');
set(handles.K, 'String', '1000');
set(handles.t, 'String', num2str(0.01));
set(handles.lambdaVal, 'String', num2str(0.05));
set(handles.e1, 'String', num2str(0.1));
guidata(hObject, handles)
update_Callback(hObject, eventdata, handles);


% --------------------------------------------------------------------
function openPair_Callback(hObject, eventdata, handles)
% hObject    handle to openPair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, ~] = uigetfile('*.png;*.jpeg;*.jpg', 'Image Selection');
handles.imLoaded =double(imread(file)); 
handles.noisyImage = handles.imLoaded;
axes(handles.axes1);
imagesc(handles.imLoaded);
set(handles.original, 'Value', 1);
colormap gray; 
[file, ~] = uigetfile('*.png;*.jpeg;*.jpg', 'Mask Selection');
handles.M =double(imread(file));
handles.isMaskLoaded = true;
guidata(hObject, handles)


% --------------------------------------------------------------------
function uitoggletool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
axes(handles.axes1)
finished = 'NO';
i = 1;
while strcmpi(finished,'NO')
  handles.roi(i) = imfreehand();
  finished = questdlg('Finished?', ...
      'confirmation', ...
      'YES', 'NO', 'UNDO', 'NO');
  if strcmpi(finished, 'UNDO')
      delete(handles.roi(i))
      finished = 'NO';
  else
      i = i + 1;
  end
end
[r,c,~]  = size(handles.imLoaded);
if(~isfield(handles, 'M'))
  handles.M = ones(r,c);
end
sz = size(handles.roi);
for i =1:sz(2)
    M = createMask(handles.roi(i));
   [rows, col] = find(~M);
    M1 = zeros(size(M));
   for j = 1:size(rows)
     M1(rows(j), col(j)) = 255;
   end      
   handles.M = bitand(handles.M(:,:,:), M1(:,:,:));
end
handles.M(handles.M == 1) = 255
handles.isMaskLoaded = true;
guidata(hObject, handles)
axes(handles.axes2)
