function varargout = OCT_processor(varargin)
% OCT_PROCESSOR M-file for OCT_processor.fig
%      OCT_PROCESSOR, by itself, creates a new OCT_PROCESSOR or raises the existing
%      singleton*.
%
%      H = OCT_PROCESSOR returns the handle to a new OCT_PROCESSOR or the handle to
%      the existing singleton*.
%
%      OCT_PROCESSOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OCT_PROCESSOR.M with the given input arguments.
%
%      OCT_PROCESSOR('Property','Value',...) creates a new OCT_PROCESSOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OCT_processor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OCT_processor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OCT_processor

% Last Modified by GUIDE v2.5 18-Mar-2011 11:26:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @OCT_processor_OpeningFcn, ...
    'gui_OutputFcn',  @OCT_processor_OutputFcn, ...
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

% --- Executes just before OCT_processor is made visible.
function OCT_processor_OpeningFcn(hObject, eventdata, handles, varargin)
handles.variablenames={'frame_select';'Rwindow';'Zwindow';'HPF';'max_depth';...
    'HPF_struct';'min_depth';'kernel_sigma';'blur_window_diameter';...
    'threshold_db';'noise_lower_fraction';'flow_thickness';...
    'surf_time';'time_gates'};
[handles]=getallnumbers(handles);
handles=hann_check_Callback(hObject, eventdata, handles);

handles.automaticmode=0; %Controls some ui elements if the GUI is running with a user or not

waitbar_pos=get(handles.wait_bar_panel,'position');
handles.wb_handle=uiwaitbar(waitbar_pos);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OCT_processor wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = OCT_processor_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

function Rwindow_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Zwindow_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function File_Callback(hObject, eventdata, handles)

function view_struct_push_Callback(hObject, eventdata, handles)
set(handles.graph_pop,'Value',1)
handles=refresh_display(handles);

guidata(hObject,handles)

function edit10_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%% Loading and saving and stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%

function extract_bin_toolbar_ClickedCallback(hObject, eventdata, handles)
%Executes when clicking on the New File button this will extract data from
%.bin files. Multiple files can be selected

[acqui_info]=Process_bin2dat;
if isstruct(acqui_info)
    assignin('base','acqui_info',acqui_info);
    handles.acqui_info=acqui_info;
else
    if acqui_info==0
        writemsg(handles,'')
    else
        writemsg(handles,acqui_info)
    end
    if isfield(handles,'acqui_info')
        handles=rmfield(handles,'acqui_info');
    end
end

handles=configure_gui(handles);

guidata(hObject,handles);

function load_mat_toolbar_ClickedCallback(hObject, eventdata, handles)

[filenames,pathname]=uigetfile('.mat','Choose a mat file to load or multiple mat files to fix','Multiselect','on');
if isequal(filenames,0) || isequal(pathname,0)
else
    if ~iscell(filenames)
        temp=filenames;
        clear filenames
        filenames{1}=temp; clear temp
    end
    
    for i=1:length(filenames)
        current_filename=filenames{i};
        writemsg(handles,['Loading ' current_filename])
        drawnow
        load([pathname current_filename]);
        handles.acqui_info=acqui_info;
        [pathname_temp,filename,ext]=fileparts([pathname current_filename]);
        handles.acqui_info.filename=[pathname filename];
        
        %handles.acqui_info=fix_acqui_info(handles.acqui_info);
        handles.acqui_info=define_dimensions(handles.acqui_info);
        acqui_info=handles.acqui_info;
        resave_acqui_info;
    end
    
    if length(filenames)>1
        writemsg(handles,[ 'Resaved ' num2str(length(filenames)) ' files'])
        handles=rmfield(handles,'acqui_info');
    else
        writemsg(handles,'')
    end
    handles=configure_gui(handles);
end

guidata(hObject,handles)

function ecg_check_Callback(hObject, eventdata, handles)
if isfield(handles,'acqui_info')
    handles.acqui_info.ecg=get(hObject,'Value');
    acqui_info=handles.acqui_info;
    resave_acqui_info;
end
handles=configure_gui(handles);

guidata(hObject,handles)

function extract_bin_menu_Callback(hObject, eventdata, handles)
extract_bin_toolbar_ClickedCallback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%% Step 1 : Make CPX and get structure %%%%%%%%%%%%%%%%%%%%
function struct_push_Callback(hObject, eventdata, handles)
handles=dat2cpx(handles);

writemsg(handles,'Getting Structure')

%[hpf_struct.b,hpf_struct.a]=butter(2,handles.HPF_struct,'high');
%struct_prop.hpf_struct=hpf_struct;
%struct_prop.noise_lower_fraction=0.1;
struct_prop.temp=1;

Process_cpx2struct(struct_prop,handles.acqui_info.filename)
writemsg(handles,'Structure obtained')

handles=refresh_display(handles);

guidata(hObject,handles)

function handles=dat2cpx(handles)
dat2cpx_prop.HP=handles.HPF;
dat2cpx_prop.window=handles.hann;
dat2cpx_prop.wb=handles.wb_handle;
dat2cpx_prop.msg_handle=handles.messagearea;

% if isfield(handles,'acqui_info')
%     writemsg(handles,'Processing frames to get complex data...')
%     drawnow
%     Process_dat2cpx(dat2cpx_prop,handles.acqui_info.filename)
% else
%     writemsg(handles,'No file loaded')
% end
%
% writemsg(handles,'Complex data obtained.')

function handles=hann_check_Callback(hObject, eventdata, handles)
handles.hann=get(handles.hann_check,'Value');
guidata(hObject,handles)

function HPF_struct_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.HPF_struct]=...
    getnumber(handles,hObject,handles.HPF_struct,[0 1]);
guidata(hObject,handles)

%%%%%%%%%%%%%%%%%% Step 2 : Make  Doppler %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function noise_lower_fraction_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.noise_lower_fraction]=...
    getnumber(handles,hObject,handles.noise_lower_fraction,[0 1]);
guidata(hObject,handles)

function threshold_db_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.threshold_db]=...
    getnumber(handles,hObject,handles.threshold_db);
guidata(hObject,handles)

function blur_window_diameter_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.blur_window_diameter]=...
    getnumber(handles,hObject,handles.blur_window_diameter);
guidata(hObject,handles)

function Rwindow_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.Rwindow]=...
    getnumber(handles,hObject,handles.Rwindow);
guidata(hObject,handles)

function Zwindow_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.Zwindow]=...
    getnumber(handles,hObject,handles.Zwindow);
guidata(hObject,handles)

function kernel_sigma_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.kernel_sigma]=...
    getnumber(handles,hObject,handles.kernel_sigma,[handles.acqui_info.line_period_us*1e-6 inf]);
guidata(hObject,handles)

function dop1_push_Callback(hObject, eventdata, handles)
if isfield(handles,'Dop1')
    disp(handles.Dop1)
    handles=rmfield(handles,'Dop1');
end
fclose all

guidata(hObject,handles)

dop1_prop=create_dop1_prop(handles.Rwindow,handles.Zwindow,handles.kernel_sigma);
mask_prop=create_mask_prop(handles.noise_lower_fraction,handles.threshold_db,handles.blur_window_diameter);
mask_prop.enable=get(handles.mask_check,'Value');

process_cpx_to_dop1(dop1_prop,mask_prop,handles.acqui_info.filename);

guidata(hObject,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions for controlling the graphical display

function handles=refresh_display(handles)
%This function will be called everytime a control that affects the
%display is touched

if ~isfield(handles,'Structure3D')
    [handles.Structure3D,handles.Dop1_angle3D]=map_3D_files(handles.acqui_info);
end

% This will set the parameters for the direction of the image
switch get(handles.slider_type_pop,'Value')
    case 1 %This goes through the x axis
        
        slices=handles.acqui_info.resolution-1;
        i=round(handles.frame_select/handles.acqui_info.x_FOV_um*slices);
        
        x_title='Y (um)';
        x_range=[0 handles.acqui_info.y_FOV_um];
        y_title='Z (um)';
        y_range=[0 handles.acqui_info.z_FOV_um];
        
        struct=squeeze(handles.Structure3D.Data.frames(:,i,:));
        dop=squeeze(handles.Dop1_angle3D.Data.frames(:,i,:));
    case 2 %This goes through the y axis
        
        slices= handles.acqui_info.nframes;
        i=round(handles.frame_select/handles.acqui_info.y_FOV_um*slices);
        
        x_title='X (um)';
        x_range=[0 handles.acqui_info.x_FOV_um];
        y_title='Z (um)';
        y_range=[0 handles.acqui_info.z_FOV_um];
        
        struct=squeeze(handles.Structure3D.Data.frames(:,:,i));
        dop=squeeze(handles.Dop1_angle3D.Data.frames(:,:,i));
        
    case 3 %This goes through the z axis
        
        slices=handles.acqui_info.frame_depth/2;
        
        i=round(handles.frame_select/handles.acqui_info.z_FOV_um*slices);
        
        x_title='Y (um)';
        x_range=[0 handles.acqui_info.y_FOV_um];
        y_title='X (um)';
        y_range=[0 handles.acqui_info.x_FOV_um];
        struct=squeeze(handles.Structure3D.Data.frames(i,:,:));
        dop=squeeze(handles.Dop1_angle3D.Data.frames(i,:,:));
end

% This will set the parameters for the type of image (doppler or
% structural)

axes(handles.axes1)
switch get(handles.graph_pop,'Value')
    case 1
        colormap_text='gray';
        image_range=[];
        imagesc(x_range, y_range,struct,double(intmax('int16'))*[0 1]);
    case 2
        if isfield(handles,'doppler_color_map')
        else
            load('doppler_color_map')
            handles.doppler_color_map=doppler_color_map;
        end
        colormap_text=handles.doppler_color_map;
        imagesc(x_range, y_range,dop,double(intmax('int16'))*[-1 1]/2);
end

axis image
colormap(colormap_text)
colorbar
h(1)=xlabel(x_title);
h(2)=ylabel(y_title);
set(h,'Fontsize',18)


function frame_select_slider_Callback(hObject, eventdata, handles)
%This function will get the value from the slider apply it to the box and
%update the graph
handles.frame_select=round(get(hObject,'Value'));
set(hObject,'Value',handles.frame_select)
[handles]=reset_slider(handles);
handles=refresh_display(handles);
guidata(hObject,handles);

function frame_select_edit_Callback(hObject, eventdata, handles)

[handles,hObject,handles.frame_select]=...
    getnumber(handles,hObject,handles.frame_select,[handles.min_slider_position handles.max_slider_position]);
handles.frame_select=round(handles.frame_select);

set(handles.frame_select_slider,'Value',handles.frame_select)

handles=refresh_display(handles);
guidata(hObject,handles)

function graph_pop_Callback(hObject, eventdata, handles)
handles=refresh_display(handles);
guidata(hObject,handles);

function max_depth_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.max_depth]=...
    getnumber(handles,hObject,handles.max_depth,[handles.min_depth round(handles.acqui_info.z_FOV_um)]);
handles=refresh_display(handles);
guidata(hObject,handles)

function min_depth_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.min_depth]=...
    getnumber(handles,hObject,handles.min_depth,[0 round(handles.max_depth)]);
handles=refresh_display(handles);
guidata(hObject,handles)

function angle_range_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.angle_range]=...
    getnumber(handles,hObject,handles.angle_range,[0 pi]);
handles=refresh_display(handles);
guidata(hObject,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI Specific functions

function []=writemsg(handles,String)
%Fonction that writes a message in the message area
set(handles.messagearea,'String',String);
guidata(handles.messagearea,handles)

function [handles]=reset_slider(handles)

current_dimension=get(handles.slider_type_pop,'Value');

handles.max_slider_position=handles.acqui_info.dimensions{current_dimension}.FOV;
slider_step=1/(handles.acqui_info.dimensions{current_dimension}.size-1);
handles.min_slider_position=handles.max_slider_position/handles.acqui_info.dimensions{current_dimension}.size;
current_dimension=get(handles.slider_type_pop,'Value');

handles.max_slider_position=handles.acqui_info.dimensions{current_dimension}.FOV;
slider_step=1/(handles.acqui_info.dimensions{current_dimension}.size-1);
handles.min_slider_position=handles.max_slider_position/handles.acqui_info.dimensions{current_dimension}.size;

set(handles.frame_select_slider,'Max',handles.max_slider_position);
set(handles.frame_select_slider,'SliderStep',[slider_step slider_step*10]);
set(handles.frame_select_slider,'Min',handles.min_slider_position);

if handles.frame_select>handles.max_slider_position
    handles.frame_select=handles.max_slider_position;
elseif handles.frame_select<handles.min_slider_position
    handles.frame_select=handles.min_slider_position;
end

set(handles.frame_select_slider,'Value',handles.frame_select);
set(handles.frame_select_edit,'String',num2str(handles.frame_select));

function handles=configure_gui(handles)
%This function should be called everytime a new dataset is loaded in the
%GUI
if isfield(handles,'acqui_info')
    if handles.acqui_info.version>3
        set(handles.ecg_check,'Value',handles.acqui_info.ecg);
        if handles.acqui_info.ecg
            [handles.periods_after_QRS_peak,handles.acqui_info.bpm]=Find_ECG_peaks(handles.acqui_info,0);
        end
    end
    
    [handles]=reset_slider(handles);
    
    if isfield(handles,'Structure3D')
        handles=rmfield(handles,'Structure3D');
    end
    
    if isfield(handles,'Dop1_angle3D')
        handles=rmfield(handles,'Dop1_angle3D');
    end
    
    
    
end

write_acqui_properties(handles);

function [handles]=getallnumbers(handles)
%Function that reads all the variables currently displayed
for i=1:length(handles.variablenames)
    eval(['handles.',handles.variablenames{i},'=str2num(get(handles.',handles.variablenames{i},'_edit,''String''));'])
end

function [handles,hObject,variablename]=getnumber(handles,hObject,variablename,varargin)
% This function will update a variable only if a number is specified in the
% field
old=variablename;
new=get(hObject,'String');
new=regexprep(new,',','.');
new=str2num(new);

if isempty(new)
    writemsg(handles,'Please enter a number.');
    set(hObject,'String',num2str(old));
else
    if nargin>3
        max_value=max(varargin{1});
        min_value=min(varargin{1});
        if new>max_value||new<min_value
            writemsg(handles,['Please enter a value between '...
                num2str(min_value) ' and ' num2str(max_value) '.']);
            set(hObject,'String',num2str(old));
        else
            variablename=new;
            writemsg(handles,' ');
        end
    else
        variablename=new;
        writemsg(handles,' ');
    end
end

function write_acqui_properties(handles)
if isfield(handles,'acqui_info')
    [pathstr, name, ext, versn] = fileparts(handles.acqui_info.filename);
    properties_text{1}=['Filename : ' name];
    properties_text{end+1}=['Frames : ' num2str(handles.acqui_info.nframes)];
    switch handles.acqui_info.ramp_type
        case 1
            scantype='2D';
        case 4
            scantype='3D';
            %             if acqui_info.3D
        case 6
            scantype='3D HD';
        otherwise
            scantype='Other';
    end
    
    properties_text{end+1}=['Scan Type : ' scantype];
    properties_text{end+1}=['Resolution : ' num2str(handles.acqui_info.resolution)];
    properties_text{end+1}=['Dimensions : '];
    for dimension=1:3
        properties_text{end+1}=[handles.acqui_info.dimensions{dimension}.type ' : '...
            num2str(handles.acqui_info.dimensions{dimension}.FOV) ' '...
            handles.acqui_info.dimensions{dimension}.units ' (' num2str(handles.acqui_info.dimensions{dimension}.size) ' pixels)'];
    end
    properties_text{end+1}=['A-line acquisition time : ' num2str(handles.acqui_info.line_period_us) ' us'];
    if isfield(handles.acqui_info,'bpm')
        properties_text{end+1}=['Heart Rate : ' num2str(handles.acqui_info.bpm) ' BPM'];
    end
else
    properties_text='';
end

set(handles.acqui_properties_text,'String',properties_text)

function ecg_push_Callback(hObject, eventdata, handles)

if handles.acqui_info.ecg==1
    [handles.periods_after_QRS_peak,handles.acqui_info.bpm]=Find_ECG_peaks(handles.acqui_info,1);
    %     resave_acqui_info(handles.acqui_info)
end
guidata(hObject,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Processing functions

function process_3D_push_Callback(hObject, eventdata, handles)
Processing_3D

function process_2D_push_Callback(hObject, eventdata, handles)
Processing_2D

function process_3DHD_push_Callback(hObject, eventdata, handles)
Processing_3DHD2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Unused functions

function graph_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graph_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function frame_select_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function frame_select_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function edit10_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox7_Callback(hObject, eventdata, handles)

function edit9_Callback(hObject, eventdata, handles)

function edit9_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox6_Callback(hObject, eventdata, handles)

function pushbutton10_Callback(hObject, eventdata, handles)

function edit8_Callback(hObject, eventdata, handles)

function edit8_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox5_Callback(hObject, eventdata, handles)

function pushbutton7_Callback(hObject, eventdata, handles)

function checkbox3_Callback(hObject, eventdata, handles)

function edit6_Callback(hObject, eventdata, handles)

function edit6_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox2_Callback(hObject, eventdata, handles)

function HPF_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.HPF]=getnumber(handles,hObject,handles.HPF,[0 1]);
guiData(hObject,handles)

function HPF_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function preview_push_Callback(hObject, eventdata, handles)
handles=generate_preview(handles);

%set(handles.preview_check,'Value',1)
%handles=refresh_display(handles);
load('doppler_color_map')
figure(5)
subplot(1,2,1)
imagesc(handles.preview_frame_struct)
subplot(1,2,2)
imagesc(handles.preview_dop1)
colormap(doppler_color_map)

guidata(hObject,handles)

function handles=generate_preview(handles)
Gamma=map_cpx_file(handles.acqui_info);

fi=handles.frame_select;

complex_frame.real=Gamma.data(fi).real;
complex_frame.imag=Gamma.data(fi).imag;

struct_prop.temp=1;
dop1_prop=create_dop1_prop(handles.Rwindow,handles.Zwindow,handles.kernel_sigma);

if get(handles.mask_check,'Value')
    mask_prop=create_mask_prop(handles.noise_lower_fraction,handles.threshold_db,handles.blur_window_diameter);
    mask_prop.enable=1;
else
    mask_prop.enable=0;
end

[handles.preview_frame_struct,handles.preview_dop1]=...
    preview_processing(complex_frame,struct_prop,handles.acqui_info,dop1_prop,mask_prop);

function listbox2_Callback(hObject, eventdata, handles)

function listbox2_CreateFcn(hObject,eventdata , handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function max_depth_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function HPF_struct_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function min_depth_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function kernel_sigma_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function noise_lower_fraction_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function threshold_db_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function blur_window_diameter_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function angle_range_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mask_check_Callback(hObject, eventdata, handles)

function slider_type_pop_Callback(hObject, eventdata, handles)
handles=reset_slider(handles);
handles=refresh_display(handles);
guidata(hObject,handles)

function slider_type_pop_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function surf_push_Callback(hObject, eventdata, handles)


current_dimension=get(handles.slider_type_pop,'Value');

resolution=handles.acqui_info.dimensions{current_dimension}.FOV/handles.acqui_info.dimensions{current_dimension}.size;

beginning_frame=round(handles.min_depth/resolution);
ending_frame=round(handles.max_depth/resolution);

original_frame=handles.frame_select;

for z=beginning_frame:ending_frame
    handles.frame_select=round(z*resolution);
    handles=refresh_display(handles);
end

handles.frame_select=original_frame;
handles=reset_slider(handles);

% surf_through_frames(handles.acqui_info,get(handles.slider_type_pop,'Value'),[z_min z_max],10,handles.axes1)

function get_flow_push_Callback(hObject, eventdata, handles)

flow_Lpm=getflow(handles.acqui_info,handles.frame_select,handles.flow_thickness,-1);

function flow_thickness_edit_Callback(hObject, eventdata, handles)

[handles,hObject,handles.flow_thickness]=...
    getnumber(handles,hObject,handles.flow_thickness,[handles.min_slider_position 200]);
handles=refresh_display(handles);
guidata(hObject,handles)

function flow_thickness_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function shift_push_ClickedCallback(hObject, eventdata, handles)
shift_acquisition

function convert_directory_push_ClickedCallback(hObject, eventdata, handles)
Convert_directory_to_dat

function surf_time_edit_Callback(hObject, eventdata, handles)

[handles,hObject,handles.surf_time]=...
    getnumber(handles,hObject,handles.surf_time,[1 60]);
handles=refresh_display(handles);
guidata(hObject,handles)

function surf_time_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function split_files_push_ClickedCallback(hObject, eventdata, handles)
split_files

function time_gates_edit_Callback(hObject, eventdata, handles)
[handles,hObject,handles.time_gates]=...
    getnumber(handles,hObject,handles.time_gates,[1 400]);
handles=refresh_display(handles);
guidata(hObject,handles)

function time_gates_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
