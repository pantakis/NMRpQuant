function varargout = NMRpQuant(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright to Dr. Panteleimon G. Takis, 2022                           % 
%                                                                       %
% National Phenome Centre and Imperial Clinical Phenotyping Centre,     %
% Department of Metabolism, Digestion and Reproduction, IRDB Building,  %
% Imperial College London, Hammersmith Campus,                          %
% London, W12 0NN, United Kingdom                                       %
%                                                                       %
% This program is distributed in the hope that it will be useful,       %
% but WITHOUT ANY WARRANTY; without even the implied warranty of        %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         %
% GNU General Public License for more details.                          %
%                                                                       %
% You should have received a copy of the GNU General Public License     %
% along with this program.  If not, see <https://www.gnu.org/licenses/>.%
%                                                                       %    
% Email: p.takis@imperial.ac.uk                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NMRpQuant MATLAB code for NMRpQuant.fig
%      NMRpQuant, by itself, creates a new NMRpQuant or raises the existing
%      singleton*.
%
%      H = NMRpQuant returns the handle to a new NMRpQuant or the handle to
%      the existing singleton*.
%
%      NMRpQuant('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NMRpQuant.M with the given input arguments.
%
%      NMRpQuant('Property','Value',...) creates a new NMRpQuant or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NMRpQuant_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NMRpQuant_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NMRpQuant

% Last Modified by GUIDE v2.5 20-Apr-2022 13:28:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NMRpQuant_OpeningFcn, ...
                   'gui_OutputFcn',  @NMRpQuant_OutputFcn, ...
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

% --- Executes just before NMRpQuant is made visible.
function NMRpQuant_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NMRpQuant (see VARARGIN)


Image = imread('NMRpQuant.png');
Icon = imresize(Image, [64, 64]);

hM = uimenu('parent',hObject,'Label','Help');
hM2 = uimenu('parent',hObject,'Label','Downloads/Examples');
uimenu(hM,'Label','About the toolbox','Callback',@(~,~)msgbox({'NMRpQuant', 'Version: 1.2', 'License: GNU GPL v3',...
    'Author: Dr. Panteleimon G. Takis','Contact: p.takis@imperial.ac.uk',...
    'National Phenome Centre','Imperial College London'},'About','custom',Icon));
uimenu(hM,'Label','Please also read-cite this article','Callback',@(~,~)web('https://doi.org/10.1021/acs.analchem.1c01618'));
uimenu(hM2,'Label','Download software/details','Callback',@(~,~)web('https://github.com/pantakis/NMRpQuant'));
uimenu(hM2,'Label','Download test spectra & protein data','Callback',@(~,~)web('https://doi.org/10.6084/m9.figshare.18737189.v1'));

% Choose default command line output for NMRpQuant

handles.output = hObject;
str1 = "NMRpQuant is active.";
str2 = "--> The present software allows the automated quantification of Total Protein in urine samples by NMR.";
str3 = "--> Please follow the each step indicated in the software interface.";
str4 = "--> Please note that 4 proteinuria methods are included in the software, where each one requires additional";
str5 = "      inputs except for the Standrard 1H-NMR urine spectra.";
str6 = "--> Further details are included in the guidelines document (provided with the software).";
handles.NOTIFICATIONS_BOX.String = str1 + newline + str2 + newline + str3 + newline + str4 + newline + str5 + newline + str6;
handles.Check_Baseline_plot = 0;
handles.Check_CPMG_plot = 0;
handles.Check_SMolESY_processed_plot = 0;
handles.MethodFLAG = 0;
handles.PASS_SMolESY = 0;
handles.PASS_Fitted_base = 0;
handles.PASS_Standard1D = 0;
handles.Int_NCD_export_FLAG = 0; 
handles.Int_baseline_export_FLAG = 0;
handles.Int_SMolESYfiltered_export_FLAG = 0;
handles.PASS_CPMG = 0;
handles.Int_REGION_flag = 0;
handles.Int_REGION = 0;
handles.BaselineFiltersplot.Value = 0;
handles.ChooseSMolESYdata.Value = 0;
handles.ChooseCPMGdata.Value = 0;
axes(handles.Standard1D_plot);cla
axes(handles.SMolESY_processed_and_or_CPMG);cla
axes(handles.NCD_and_or_SMolESY_filtered);cla
handles.lbfactor = [];
set(handles.Method,'Value',1)
handles.QREF_Int = [];
handles.NCDspectra = [];
handles.plotFOLTERS_FLAG = 0;
handles.Results_folder_path = [];
handles.Parent1D_folder = [];
handles.ParentCPMG_folder = [];
handles.IND_SPECTRA_selection = [];
set(handles.SpectraNAMESTABLE,'Data',[]); % Use the set command to change the uitable properties.
set(handles.SpectraNAMESTABLE,'ColumnName',{'Spectra Titles   '})
handles.hZoom = [];
handles.hZoom2 = [];
handles.hZoom3 = [];
handles.axesLimitsNCD_and_or_SMolESY_filtered = [];
handles.axesLimitsSMolESY_processed_and_or_CPMG = [];
handles.axesLimitsStandard1D_plot = [];
% 
% f1 = handles.Standard1D_plot.Children;
% zoomonbutton = uicontrol('Parent', f1, ...
% 'Style', 'pushbutton', ...
% 'Units', 'Normalized', ...
% 'Position', [231 11 228 22], ...
% 'String', 'Zoom On', ...
% 'Callback', 'zoom on' ...
% );
% zoomoffbutton = uicontrol('Parent', f1, ...
% 'Style', 'pushbutton', ...
% 'Units', 'Normalized', ...
% 'Position', [231 11 228 22], ...
% 'String', 'Zoom Off', ...
% 'Callback', 'zoom off' ...
% );



set(gcf,'position',[181.06666666666666 44.897435897435905 344.2 67.61])
old_screen=[1920,1080];
%Collect information about new screen:
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
%Assign coefficient of reduction/increase:
k_hor=Pix_SS(3)/old_screen(1);
k_vert=Pix_SS(4)/old_screen(2);
k_font=(k_hor+k_vert)/2;
drawnow;

set(findall(handles.MAIN_PROT,'-property','FontSize'),'FontSize',10*k_font)
txtHand = findall(handles.MAIN_PROT, '-property', 'FontUnits'); 
set(txtHand, 'FontUnits', 'normalized')
waitbar2a(0,handles.Progress,' ','g');

guidata(hObject, handles);


% UIWAIT makes NMRpQuant wait for user response (see UIRESUME)
% uiwait(handles.MAIN_PROT);


% --- Outputs from this function are returned to the command line.
function varargout = NMRpQuant_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Method.
function Method_Callback(hObject, eventdata, handles)
% hObject    handle to Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Method


    contents = cellstr(get(hObject,'String'));

    if isequal(contents{get(hObject,'Value')},'Select Filtering Method')

        axes(handles.NCD_and_or_SMolESY_filtered);cla;
        axes(handles.SMolESY_processed_and_or_CPMG);cla;
        handles.MethodFLAG = 0;

    elseif isequal(contents{get(hObject,'Value')},'NCD method')

        axes(handles.NCD_and_or_SMolESY_filtered);cla;
        axes(handles.SMolESY_processed_and_or_CPMG);cla;
        handles.MethodFLAG = 1;    
        uiwait(msgbox('For the NCD method, maromolecules filtered NMR spectra are needed. For instance spin echo 1D 1H NMR experiments (i.e. CPMG) should be loaded in the STEP 3 and should be recorded with SAME TITLES as the Standard 1D spectra.','modal'));

    elseif isequal(contents{get(hObject,'Value')},'SMolESY-filtering')

        axes(handles.NCD_and_or_SMolESY_filtered);cla;
        axes(handles.SMolESY_processed_and_or_CPMG);cla;
        handles.MethodFLAG = 2;

    elseif isequal(contents{get(hObject,'Value')},'Protein signal extraction from 0.2-0.5 ppm')    

        axes(handles.NCD_and_or_SMolESY_filtered);cla;
        axes(handles.SMolESY_processed_and_or_CPMG);cla;
        handles.MethodFLAG = 3;

    elseif isequal(contents{get(hObject,'Value')},'All methods')    

        axes(handles.NCD_and_or_SMolESY_filtered);cla;
        axes(handles.SMolESY_processed_and_or_CPMG);cla;
        handles.MethodFLAG = 4;
        uiwait(msgbox('For the NCD method, maromolecules filtered NMR spectra are needed. For instance spin echo 1D 1H NMR experiments (i.e. CPMG) should be loaded in the STEP 3 and should be recorded with SAME TITLES as the Standard 1D spectra.','modal'));

    end


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% list of methods

set(hObject, 'String',[{'Select Filtering Method'};{'NCD method'};{'SMolESY-filtering'};{'Protein signal extraction from 0.2-0.5 ppm'};{'All methods'}])
guidata(hObject, handles);


% --- Executes on button press in load1D.
function load1D_Callback(hObject, eventdata, handles)
% hObject    handle to load1D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plotFOLTERS_FLAG = 0;
handles.NCDspectra = [];
handles.Check_Baseline_plot = 0;
handles.Check_CPMG_plot = 0;
handles.Check_SMolESY_processed_plot = 0;
handles.MethodFLAG = 0;
handles.Int_REGION_flag = 0;
handles.PASS_SMolESY = 0;
handles.PASS_Fitted_base = 0;
handles.PASS_Standard1D = 0;
handles.Int_NCD_export_FLAG = 0; 
handles.Int_baseline_export_FLAG = 0;
handles.Int_SMolESYfiltered_export_FLAG = 0;
handles.PASS_CPMG = 0;
handles.Int_REGION = 0;
handles.BaselineFiltersplot.Value = 0;
handles.ChooseSMolESYdata.Value = 0;
handles.ChooseCPMGdata.Value = 0;
handles.AskNEWCurve.Value = 0;
handles.UseBuiltInCurves.Value = 0;
handles.GoforABS = 0;
axes(handles.Standard1D_plot);cla
axes(handles.SMolESY_processed_and_or_CPMG);cla
axes(handles.NCD_and_or_SMolESY_filtered);cla
set(handles.Method,'Value',1);
set(handles.ChooseREGIONS_Int,'Value',1);
set(handles.ChooseSMolESYdata,'Value',0);
set(handles.ChooseCPMGdata,'Value',0);
set(handles.BaselineFiltersplot,'Value',0);
handles.QREF_Int = [];

try
    try
        if isempty(handles.Parent1D_folder)
            parentDir1D = uigetdir;
        else
            parentDir1D = uigetdir(handles.Parent1D_folder);
        end     
    catch
        parentDir1D = uigetdir;
    end
    handles.Parent1D_folder = parentDir1D;
    [list_of_spectra_1D,display_names] = prepare_spectra_files1D(parentDir1D);    
    if num2str(length(list_of_spectra_1D)) > 1
        uiwait(msgbox(['The software found ' num2str(length(list_of_spectra_1D)) ' spectra.'],'modal'));
    elseif num2str(length(list_of_spectra_1D)) == 1
        uiwait(msgbox(['The software found ' num2str(length(list_of_spectra_1D)) ' spectrum.'],'modal'));
    end
    mkdir(fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.7 ppm'))
    mkdir(fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.5 ppm'))
    mkdir(fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 8.0-10.0 ppm'))
    mkdir(fullfile(handles.Results_folder_path,'Protein signal extraction from 0.2-0.5 ppm_filter_figures'))
    
    TF = isnumeric(handles.lbfactor);
    if isempty(handles.lbfactor) || TF == 0
        handles.lbfactor = 8; % lb_factor = 8.0 [i.e. 8.0 * (the real processing lb) the default]   
    end
   
    % read real and imaginary NMR data
    for i = 1:length(list_of_spectra_1D)
        str1 = ['Loading/processing (i.e SMolESY/Protein signal extraction filters production) of spectrum: <' list_of_spectra_1D{i} '> started...'];
        handles.NOTIFICATIONS_BOX.String = str1;
        DIKA = waitbar2a(i/(size(list_of_spectra_1D,1)-(0.01*size(list_of_spectra_1D,1))),handles.Progress,['NMR spectra loading (SMolESY/Protein signals filters production)...'],'g');
        G1 = fullfile(parentDir1D,list_of_spectra_1D{i},'pdata','1');
        try
            W(i,1) = getNMRdata(G1);
            Y1D(i,:) = W(i,1).Data';
            X1D(i,:) = W(i,1).XAxis';
            Yim1D(i,:) = W(i,1).IData';
            W_Processed(i,1) = Process_lb_NMRdata(G1,handles.lbfactor); % lb_factor = 8.0 [i.e. 8.0 * (the real processing lb) the default]           
            Y1D_Processed(i,:) = W_Processed(i,1).Data';
            X1D_Processed(i,:) = W_Processed(i,1).XAxis';
            Yim1D_Processed(i,:) = W_Processed(i,1).IData';
            
            % preparing SMolESY and SMolESY processed data (regardless of
            % the chosen Qauntififcation method afterwards)
            try
                [SMolESY_original(i,:),SMolESY_Processed_final(i,:),SMolESY_filtered1D(i,:)] = NMRpQuant_SMolESY(X1D(i,:),Y1D(i,:),Yim1D(i,:),X1D_Processed(i,:),Yim1D_Processed(i,:),0,0.025);                
                f1 = figure('visible','off');
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([0.2 0.5]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                               
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.5]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([0.2 0.5]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.5]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.5 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);
                f1 = figure('visible','off'); 
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([0.2 0.7]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.7]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([0.2 0.7]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.7]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.7 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);
                f1 = figure('visible','off');    
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([8 10]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([8 10]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([8 10]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([8 10]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 8.0-10.0 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);                
                PASS_SMolESY_test(i,1) = 1;
            catch
                PASS_SMolESY_test(i,1) = 0;                
            end
            % end of SMolESY processing production process
            
            % Fitting spectrum baseline at 0.2-0.5 for the removal of any
            % sharp signals of metabolites
            try
                [Tot_protein_Relative(i,1), X_fit(i).data, Y_fit(i).data, fitted_baseline(i).data, baseline_filtered1D(i).data] = NMRpQuant_Baseline_filter(X1D(i,:),Y1D(i,:));
                
                f1 = figure('visible','off');                                    
                plot(X_fit(i).data,Y_fit(i).data);hold on;plot(X_fit(i).data,fitted_baseline(i).data);hold on;plot(X_fit(i).data,baseline_filtered1D(i).data);set(gca,'xdir','reverse');legend('Standard 1D ^1H NMR','Residuals','Protein signal extraction');title('Standard 1D ^1H NMR vs. Protein signal extraction vs. residuals');xlabel('PPM');                               
                saveas(gcf, fullfile(handles.Results_folder_path,'Protein signal extraction from 0.2-0.5 ppm_filter_figures',['Spectrum-' list_of_spectra_1D{i} '-Protein-signal-extraction']), 'tif');hold on;
                close(f1);                                 
                
                PASS_Fitted_base_test(i,1) = 1;                
            catch
                PASS_Fitted_base_test(i,1) = 0;
            end
            
            %end of fitting process
            
        catch
            G11 = fullfile(parentDir1D,list_of_spectra_1D{i});
            [Subfolders,~] = prepare_spectra_files1D(G11);
            G2 = fullfile(G11,Subfolders{1},'pdata','1');
            W(i,1) = getNMRdata(G2);
            Y1D(i,:) = W(i,1).Data';
            X1D(i,:) = W(i,1).XAxis';
            Yim1D(i,:) = W(i,1).IData';  
            W_Processed(i,1) = Process_lb_NMRdata(G2,handles.lbfactor); % lb_factor = 8 [i.e. 8 * (the real processing lb) the default]
            Y1D_Processed(i,:) = W_Processed(i,1).Data';
            X1D_Processed(i,:) = W_Processed(i,1).XAxis';
            Yim1D_Processed(i,:) = W_Processed(i,1).IData';
            
            % preparing SMolESY and SMolESY processed data (regardless of
            % the chosen Qauntififcation method afterwards)
            try
                [SMolESY_original(i,:),SMolESY_Processed_final(i,:),SMolESY_filtered1D(i,:)] = NMRpQuant_SMolESY(X1D(i,:),Y1D(i,:),Yim1D(i,:),X1D_Processed(i,:),Yim1D_Processed(i,:),0,0.025);                
                f1 = figure('visible','off');
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([0.2 0.5]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                               
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.5]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([0.2 0.5]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.5]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.5 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);
                f1 = figure('visible','off'); 
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([0.2 0.7]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.7]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([0.2 0.7]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.7]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.7 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);
                f1 = figure('visible','off');    
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([8 10]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([8 10]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([8 10]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([8 10]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 8.0-10.0 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);                
                PASS_SMolESY_test(i,1) = 1;
            catch
                PASS_SMolESY_test(i,1) = 0;                
            end
            % end of SMolESY processing production process
            
            % Fitting spectrum baseline at 0.2-0.5 for the removal of any
            % sharp signals of metabolites
            try
                [Tot_protein_Relative(i,1), X_fit(i).data, Y_fit(i).data, fitted_baseline(i).data,baseline_filtered1D(i).data] = NMRpQuant_Baseline_filter(X1D(i,:),Y1D(i,:));
                
                f1 = figure('visible','off');                                    
                plot(X_fit(i).data,Y_fit(i).data);hold on;plot(X_fit(i).data,fitted_baseline(i).data);hold on;plot(X_fit(i).data,baseline_filtered1D(i).data);set(gca,'xdir','reverse');legend('Standard 1D ^1H NMR','Residuals','Protein signal extraction');title('Standard 1D ^1H NMR vs. Protein signal extraction vs. residuals');xlabel('PPM');                               
                saveas(gcf, fullfile(handles.Results_folder_path,'Protein signal extraction from 0.2-0.5 ppm_filter_figures',['Spectrum-' list_of_spectra_1D{i} '-Protein-signal-extraction']), 'tif');hold on;
                close(f1);                                                
                PASS_Fitted_base_test(i,1) = 1;
            catch
                PASS_Fitted_base_test(i,1) = 0;
            end
                        
            %end of fitting process
            
        end

    end

    
    handles.Y1D = Y1D;        
    handles.X1D = X1D;       
    handles.Samples_titles1D = list_of_spectra_1D; 
    handles.DISP_NAMES = display_names;
    handles.PASS_Standard1D = 1;
    
    % test_the_spectra Quality - production
    if isempty(find(PASS_SMolESY_test == 0)) && isempty(find(PASS_Fitted_base_test == 0))
        
        handles.PASS_SMolESY = 1;
        handles.PASS_Fitted_base = 1;
        
        handles.Yim1D = Yim1D;
        handles.SMolESY_Processed_final = abs(SMolESY_Processed_final);
        handles.SMolESY_original = SMolESY_original; 
        handles.SMolESY_filtered1D = SMolESY_filtered1D;
        
        handles.X_fit = X_fit;
        handles.Y_fit = Y_fit;
        handles.fitted_baseline = fitted_baseline;
        handles.baseline_filtered1D = baseline_filtered1D;
        handles.Integrals_Baseline_fit = Tot_protein_Relative;

        str1 = "NMR Standard 1D & SMolESY & Protein signal extraction from 0.2-0.5 ppm data are successfully read/produced and loaded on the software.";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + "Please proceed with the next STEPS." + newline + "You could check fitting results in 'OUTPUT FOLDER/..._filter_figures' folders.";
    
    elseif ~isempty(find(PASS_SMolESY_test == 0)) && ~isempty(find(PASS_Fitted_base_test == 0))
    
        handles.PASS_SMolESY = 0;
        handles.PASS_Fitted_base = 0;
        
        str1 = "NMR Standard 1D data is successfully read and loaded on the software.";
        str22 = "ERROR: SMolESY & Protein signal extraction from 0.2-0.5 ppm data could not be produced.";
        str33 = "If you want to proceed with the next STEPS, you can select ONLY NCD filtering method, which requires additional type of NMR spectra (e.g. CPMG).";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + str22 + newline + str33;
    
    elseif ~isempty(find(PASS_SMolESY_test == 0)) && isempty(find(PASS_Fitted_base_test == 0))
        
        handles.PASS_SMolESY = 0;
        handles.PASS_Fitted_base = 1;
        
        handles.X_fit = X_fit;
        handles.Y_fit = Y_fit;
        handles.fitted_baseline = fitted_baseline;
        handles.baseline_filtered1D = baseline_filtered1D;
        handles.Integrals_Baseline_fit = Tot_protein_Relative;
        
        str1 = "NMR Standard 1D & Protein signal extraction from 0.2-0.5 ppm data are successfully read/produced and loaded on the software.";
        str22 = "ERROR: SMolESY data could not be produced.";
        str33 = "If you want to proceed with the next STEPS, you cannot select SMolESY or All methods filtering.";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + str22 + newline + str33;
    
    elseif isempty(find(PASS_SMolESY_test == 0)) && ~isempty(find(PASS_Fitted_base_test == 0))
               
        handles.Yim1D = Yim1D;
        handles.SMolESY_Processed_final = abs(SMolESY_Processed_final);
        handles.SMolESY_original = SMolESY_original; 
        handles.SMolESY_filtered1D = SMolESY_filtered1D;    
        handles.PASS_SMolESY = 1;
        handles.PASS_Fitted_base = 0;
        
        str1 = "NMR Standard 1D & Protein signal extraction from 0.2-0.5 ppm data are successfully read/produced and loaded on the software.";
        str22 = "ERROR: Protein signal extraction from 0.2-0.5 ppm data could not be produced.";
        str33 = "If you want to proceed with the next STEPS, you cannot select Protein signal extraction from 0.2-0.5 ppm or All methods filtering.";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + str22 + newline + str33;

    end
    if i == size(list_of_spectra_1D,1)
        DIKA = waitbar2a(i/size(list_of_spectra_1D,1),handles.Progress,['NMR spectra Loading/Processing is completed.'],'g');
    end
    
    delete(findall(handles.Standard1D_plot,'type','text'))
    delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
    delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
    set(handles.SpectraNAMESTABLE,'Data',handles.Samples_titles1D); % Use the set command to change the uitable properties.    
    set (handles.SpectraNAMESTABLE, 'CellSelectionCallback', @cb_select)

    if handles.PASS_Standard1D == 1
        axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
        set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
        set(handles.Standard1D_plot.Children,'LineWidth',0.5);
        handles.INITaxesLimitsStandard1D_plot = get(handles.Standard1D_plot,{'xlim','ylim'});
    else
        uiwait(msgbox('There are no Standard 1D 1H NMR spectra.','modal'));    
        handles.NOTIFICATIONS_BOX.String = "ERROR: The Standard 1D 1H NMR spectra cannot be plotted. Please try loading them.";   
    end

    
catch
    handles.Parent1D_folder = [];
    handles.PASS_SMolESY = 0;
    handles.PASS_Standard1D = 0;
    handles.PASS_Fitted_base = 0;
    try
        DIKA = waitbar2a(i/size(list_of_spectra_1D,1),handles.Progress,['Something went wrong with Spectrum ' list_of_spectra_1D{i} '...'],'g');   
        str1 = "ERROR: Output folder is not defined AND/OR NMR real and/or imaginary data cannot be found or read correctly. Please check the structure of the NMR spectra containing folder, which should be as indicated in the User's Guide file.";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + "Reminder: Imaginary/FID spectral data is needed to run the SMolESY method of the software.";
    catch
        str1 = "ERROR: Output folder is not defined AND/OR NMR real and/or imaginary data cannot be found or read correctly. Please check the structure of the NMR spectra containing folder, which should be as indicated in the User's Guide file.";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + "Reminder: Imaginary/FID spectral data is needed to run the SMolESY method of the software.";
    end
    
end

guidata(hObject, handles);


function cb_select(hObject,evt)
    clearvars idx didx
    handles = guidata(hObject);
    delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
    delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
    delete(findall(handles.Standard1D_plot,'type','text'))
    set(handles.Standard1D_plot.Children,'LineWidth',0.5);    
    set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
    set (handles.Standard1D_plot.Children, 'ButtonDownFcn', @showTitleOFF)    
    set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
    set (handles.NCD_and_or_SMolESY_filtered.Children, 'ButtonDownFcn', @showTitleOFF)
    set (handles.SMolESY_processed_and_or_CPMG.Children, 'ButtonDownFcn', @showTitleOFF)
    set(handles.DispOnONE,'ForegroundColor','black');
    set(handles.DispOFFOne,'ForegroundColor','green');
    set(handles.DispTitleON,'ForegroundColor','black');
    set(handles.DispTitleOFF,'ForegroundColor','green');
    set(handles.DispONTHREE,'ForegroundColor','black');
    set(handles.DispOFFTHree,'ForegroundColor','green');
%     handles.TitlesStatus.String = 'Titles: OFF';
%     handles.TitlesStatusONE.String = 'Titles: OFF';
%     handles.TitlesStatusTHREE.String = 'Titles: OFF';
    for i = 1:length(handles.Standard1D_plot.Children)
        currentlinesorder1D{i,1} = handles.Standard1D_plot.Children(i).DisplayName;
        try
            currentlinesorder2{i,1} = handles.SMolESY_processed_and_or_CPMG.Children(i).DisplayName;
            currentlinesorder3{i,1} = handles.NCD_and_or_SMolESY_filtered.Children(i).DisplayName;
        catch
        end
    end
    [~,sortedorder1D] = sort(currentlinesorder1D);
    handles.Standard1D_plot.Children = handles.Standard1D_plot.Children(sortedorder1D);
    try
        [~,sortedorder2] = sort(currentlinesorder2);
        handles.SMolESY_processed_and_or_CPMG.Children = handles.SMolESY_processed_and_or_CPMG.Children(sortedorder2);
        [~,sortedorder3] = sort(currentlinesorder3);
        handles.NCD_and_or_SMolESY_filtered.Children = handles.NCD_and_or_SMolESY_filtered.Children(sortedorder3);

    catch
    end
    idx = evt.Indices(:,1);    
    set(handles.Standard1D_plot.Children,'Visible','off');    
    set(handles.Standard1D_plot.Children(idx),'Visible','on');
    try
        set(handles.SMolESY_processed_and_or_CPMG.Children,'Visible','off');    
        set(handles.SMolESY_processed_and_or_CPMG.Children(idx),'Visible','on');
        set(handles.NCD_and_or_SMolESY_filtered.Children,'Visible','off');    
        set(handles.NCD_and_or_SMolESY_filtered.Children(idx),'Visible','on');
    catch
    end
    

% --- Executes on button press in loadCPMG.
function loadCPMG_Callback(hObject, eventdata, handles)
% hObject    handle to loadCPMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Check_CPMG_plot = 0;
handles.Int_NCD_export_FLAG = 0; 
handles.PASS_CPMG = 0;

if handles.MethodFLAG == 1 || handles.MethodFLAG == 4  
    [filepath,~,~] = fileparts(handles.Parent1D_folder);
    try
        if isempty(handles.ParentCPMG_folder)
            parentDir1D_NCD = uigetdir(filepath);
        else
            parentDir1D_NCD = uigetdir(handles.ParentCPMG_folder);
        end
    catch
        parentDir1D_NCD = uigetdir;        
    end
    handles.ParentCPMG_folder = parentDir1D_NCD;     
    [list_of_spectra_1D_CPMG,~] = prepare_spectra_files1D(parentDir1D_NCD);
    mkdir(fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.7 ppm'))
    mkdir(fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.5 ppm'))
    mkdir(fullfile(handles.Results_folder_path,'NCD_filter_figures','region 8.0-10.0 ppm'))
    if num2str(length(list_of_spectra_1D_CPMG)) > 1
        uiwait(msgbox(['The software found ' num2str(length(list_of_spectra_1D_CPMG)) ' spectra.'],'modal'));
    elseif num2str(length(list_of_spectra_1D_CPMG)) == 1
        uiwait(msgbox(['The software found ' num2str(length(list_of_spectra_1D_CPMG)) ' spectrum.'],'modal'));
    end
    
    try
       % read NMR data
        % check if the titles of CPMG and Standard1D are exactly the same!
        if length(list_of_spectra_1D_CPMG) == length(handles.Samples_titles1D)
            TEST_names = strcmpi(list_of_spectra_1D_CPMG,handles.Samples_titles1D);          
            if isempty(find(TEST_names == 0))
                handles.PASS_CPMG = 1;                
                for i = 1:length(list_of_spectra_1D_CPMG)
                    str1 = ['Loading/processing (i.e NCD filter production) of spectrum: <' list_of_spectra_1D_CPMG{i} '> started...'];
                    handles.NOTIFICATIONS_BOX.String = str1;
                    DIKA = waitbar2a(i/(size(list_of_spectra_1D_CPMG,1)-(0.01*size(list_of_spectra_1D_CPMG,1))),handles.Progress,['NMR spectra loading/processing (i.e NCD filter production)...'],'g');        
                    G1 = fullfile(parentDir1D_NCD,list_of_spectra_1D_CPMG{i},'pdata','1');
                    try
                        W(i,1) = getNMRdata(G1);
                        Y1D(i,:) = W(i,1).Data';                

                        % calibrate CPMG to the same reference as Standard1D (i.e.
                        % TSP etc.), in case of any minor shifting

                        CPMG_Y_cal(i,:) = Align_data(handles.X1D(i,:),Y1D(i,:),0,0.02);                

                        % end of calibration process
                        handles.NCDspectra(i,:) = handles.Y1D(i,:) - CPMG_Y_cal(i,:);
                        
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([0.2 0.5]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.5 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([0.2 0.7]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.7 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);    
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([8 10]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 8.0-10.0 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);

                    catch
                        G11 = fullfile(parentDir1D_NCD,list_of_spectra_1D_CPMG{i});
                        [Subfolders,~] = prepare_spectra_files1D(G11);
                        G2 = fullfile(G11,Subfolders{1},'pdata','1');
                        W(i,1) = getNMRdata(G2);
                        Y1D(i,:) = W(i,1).Data';                

                        % calibrate CPMG to the same reference as Standard1D (i.e.
                        % TSP etc.), in case of any minor shifting

                        CPMG_Y_cal(i,:) = Align_data(handles.X1D(i,:),Y1D(i,:),0,0.02);     
                        handles.NCDspectra(i,:) = handles.Y1D(i,:) - CPMG_Y_cal(i,:);
                        
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([0.2 0.5]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.5 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([0.2 0.7]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.7 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);    
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([8 10]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 8.0-10.0 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);
                        
                    end   
                end
                handles.CPMG_Y1D = CPMG_Y_cal;
                handles.Samples_titles1D_CPMG = list_of_spectra_1D_CPMG; 
                if i == size(list_of_spectra_1D_CPMG,1)
                     DIKA = waitbar2a(i/size(list_of_spectra_1D_CPMG,1),handles.Progress,['NMR spectra Loading/Processing/Exporting is completed.'],'g');
                end
                str1 = "Macromolecular-filtered NMR spectra and the NCD data are successfully loaded/calculated.";
                handles.NOTIFICATIONS_BOX.String = str1 + newline + "Please proceed with plotting the spectra by selecting this option below." + newline + "You could check NCD results in 'OUTPUT FOLDER/NCD_filter_figures' folder.";   
            else
               waitbar2a(0,handles.Progress,' ','g');
               str11 = "ERROR: Macromolecules-filtered spectra do not match the TITLES of the Standard 1D 1H NMR spectra. Please check your spectral folders.";
               handles.NOTIFICATIONS_BOX.String = str11; 
               handles.PASS_CPMG = 0;

            end
        else
               str11 = "ERROR: Macromolecules-filtered spectra do not match the number of the Standard 1D 1H NMR spectra. Please check your spectral folders.";
               handles.NOTIFICATIONS_BOX.String = str11; 
               handles.PASS_CPMG = 0;
               
        end
 
    catch
       handles.ParentCPMG_folder = [];
       try
        DIKA = waitbar2a(i/size(list_of_spectra_1D_CPMG,1),handles.Progress,['Something went wrong with Spectrum ' list_of_spectra_1D_CPMG{i} '...'],'g');    
       catch
       end
        str1 = "ERROR: NMR data cannot be found or read correctly. Please check the structure of the NMR spectra containing folder, which should be as indicated in the User's Guide file.";
        handles.NOTIFICATIONS_BOX.String = str1;
        handles.PASS_CPMG = 0;
    end
else
    uiwait(msgbox('The selected method does not require macromolecules filtered NMR spectra.','modal'));    
end
guidata(hObject, handles);    


% --- Executes on button press in PlotFilters.
function PlotFilters_Callback(hObject, eventdata, handles)
% hObject    handle to PlotFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plotFOLTERS_FLAG = 1;


delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
delete(findall(handles.Standard1D_plot,'type','text'))

set (handles.Standard1D_plot, 'ButtonDownFcn', @showTitleOFF)
set (handles.SMolESY_processed_and_or_CPMG, 'ButtonDownFcn', @showTitleOFF)
set (handles.NCD_and_or_SMolESY_filtered, 'ButtonDownFcn', @showTitleOFF)

set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
set(handles.Standard1D_plot.Children,'LineWidth',0.5);
set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);

handles.TitlesStatus.String = 'Titles: OFF';
handles.TitlesStatusONE.String = 'Titles: OFF';
handles.TitlesStatusTHREE.String = 'Titles: OFF';


if handles.MethodFLAG == 0
    
    cla(handles.SMolESY_processed_and_or_CPMG,'reset');
    cla(handles.NCD_and_or_SMolESY_filtered,'reset');
    uiwait(msgbox('Choose one method from STEP2 menu.','modal'));   

elseif handles.MethodFLAG == 4 
      try
        if handles.Check_CPMG_plot == 1 && handles.PASS_CPMG == 0 
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('Macromolecules filtered NMR spectra are not loaded, please load the spectra and see if any ERROR occurs.','modal'));  
        elseif handles.Check_CPMG_plot == 1 && handles.PASS_CPMG == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            axes(handles.SMolESY_processed_and_or_CPMG); plot(handles.X1D',handles.CPMG_Y1D');set(gca,'xdir','reverse');
            axes(handles.NCD_and_or_SMolESY_filtered); plot(handles.X1D',handles.NCDspectra');set(gca,'xdir','reverse')
            
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)));
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)));
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.Standard1D_plot.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
            
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'xy')
            
        elseif handles.Check_SMolESY_processed_plot == 1 && handles.PASS_SMolESY == 0
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('SMolESY data is not successfully produced, please reload Standard1D spectra and see if any ERROR occurs.','modal'));  
        elseif handles.Check_SMolESY_processed_plot == 1 && handles.PASS_SMolESY == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            axes(handles.SMolESY_processed_and_or_CPMG); plot(handles.X1D',handles.SMolESY_Processed_final');set(gca,'xdir','reverse')
            axes(handles.NCD_and_or_SMolESY_filtered); plot(handles.X1D',handles.SMolESY_filtered1D');set(gca,'xdir','reverse')
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'xy')                        
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)));
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)));
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
            set(handles.Standard1D_plot.Children,'LineWidth',0.5);
        elseif handles.Check_Baseline_plot == 1 && handles.PASS_Fitted_base == 0
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('Protein signal extraction from 0.2-0.5 ppm is not successfully performed, please reload Standard1D spectra and see if any ERROR occurs.','modal'));              
        elseif handles.Check_Baseline_plot == 1 && handles.PASS_Fitted_base == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            axes(handles.SMolESY_processed_and_or_CPMG);
            for i = 1:length(handles.Samples_titles1D)                
                plot(handles.X_fit(i).data,handles.fitted_baseline(i).data);set(gca,'xdir','reverse');hold on;
            end
            xlim([0.2 0.5]);
            %hold off

            axes(handles.NCD_and_or_SMolESY_filtered); 
            for i = 1:length(handles.Samples_titles1D)
                plot(handles.X_fit(i).data,handles.baseline_filtered1D(i).data);set(gca,'xdir','reverse');hold on;
            end        
            xlim([0.2 0.5]);
            %hold off
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'x');           
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
        else
            uiwait(msgbox('Data of one or more filtering method(s) ','modal'));  
        end
      catch          
          uiwait(msgbox('Either Macromolecules filtered NMR spectra are not loaded or you did not select the corresponding filtering method (i.e. NCD method or All methods) in STEP 2.','modal'));  
      end
    
    
elseif handles.MethodFLAG == 1 
    try
        if handles.Check_CPMG_plot == 1 && handles.PASS_CPMG == 0 
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('Macromolecules filtered NMR spectra are not loaded, please load the spectra and see if any ERROR occurs.','modal'));  
        elseif handles.Check_CPMG_plot == 1 && handles.PASS_CPMG == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            axes(handles.SMolESY_processed_and_or_CPMG); plot(handles.X1D',handles.CPMG_Y1D');set(gca,'xdir','reverse')
            axes(handles.NCD_and_or_SMolESY_filtered); plot(handles.X1D',handles.NCDspectra');set(gca,'xdir','reverse')
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'xy')
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
            set(handles.Standard1D_plot.Children,'LineWidth',0.5);
        else
            uiwait(msgbox('Either Macromolecules filtered NMR spectra are not loaded or you did not select the corresponding filtering method (i.e. NCD method or All methods) in STEP 2.','modal'));  
        end
    catch
        uiwait(msgbox('Either Macromolecules filtered NMR spectra are not loaded or you did not select the corresponding filtering method (i.e. NCD method or All methods) in STEP 2.','modal'));  
    end
    
elseif handles.MethodFLAG == 2
    try
        if handles.Check_SMolESY_processed_plot == 1 && handles.PASS_SMolESY == 0
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('SMolESY data is not successfully produced, please reload Standard1D spectra and see if any ERROR occurs.','modal'));  
        elseif handles.Check_SMolESY_processed_plot == 1 && handles.PASS_SMolESY == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            axes(handles.SMolESY_processed_and_or_CPMG); plot(handles.X1D',handles.SMolESY_Processed_final');set(gca,'xdir','reverse');
            axes(handles.NCD_and_or_SMolESY_filtered); plot(handles.X1D',handles.SMolESY_filtered1D');set(gca,'xdir','reverse')
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'xy')
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
            set(handles.Standard1D_plot.Children,'LineWidth',0.5);
        else
            uiwait(msgbox('Either SMolESY data were not successfully produced or you did not select the corresponding filtering method (i.e. SMolESY-filtering or All methods) in STEP 2.','modal'));  
        end     
    catch
        uiwait(msgbox('Either SMolESY data were not successfully produced or you did not select the corresponding filtering method (i.e. SMolESY-filtering or All methods) in STEP 2.','modal'));  
    end
    
elseif handles.MethodFLAG == 3    
    try
        if handles.Check_Baseline_plot == 1 && handles.PASS_Fitted_base == 0
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('Protein signal extraction from 0.2-0.5 ppm is not successfully performed, please reload Standard1D spectra and see if any ERROR occurs.','modal'));  
        elseif handles.Check_Baseline_plot == 1 && handles.PASS_Fitted_base == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            axes(handles.SMolESY_processed_and_or_CPMG);
            for i = 1:length(handles.Samples_titles1D)
                plot(handles.X_fit(i).data,handles.fitted_baseline(i).data);set(gca,'xdir','reverse');hold on;
            end
            
            axes(handles.NCD_and_or_SMolESY_filtered); 
            for i = 1:length(handles.Samples_titles1D)
                plot(handles.X_fit(i).data,handles.baseline_filtered1D(i).data);set(gca,'xdir','reverse');hold on;
            end        
            
            %hold off
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'x');xlim([0.2 0.5]);
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
            set(handles.Standard1D_plot.Children,'LineWidth',0.5);
        else
            uiwait(msgbox('Either Protein signal extraction from 0.2-0.5 ppm was not successfully performed or you did not select the corresponding filtering method (i.e. Protein signal extraction from 0.2-0.5 ppm or All methods) in STEP 2.','modal'));  
        end    
    catch
        uiwait(msgbox('Either Protein signal extraction from 0.2-0.5 ppm was not successfully performed or you did not select the corresponding filtering method (i.e. Baseline fit for 0.2-0.5 ppm or All methods) in STEP 2.','modal'));  
    end
    
end    

guidata(hObject, handles);    


% --- Executes on button press in Plot1D.
% function Plot1D_Callback(hObject, eventdata, handles)
% % hObject    handle to Plot1D (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% delete(findall(handles.Standard1D_plot,'type','text'))
% delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
% delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
% set(handles.SpectraNAMESTABLE,'Data',handles.Samples_titles1D); % Use the set command to change the uitable properties.    
% set (handles.SpectraNAMESTABLE, 'CellSelectionCallback', @cb_select)
% if handles.PASS_Standard1D == 1
%         axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
%         set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
%         set(handles.Standard1D_plot.Children,'LineWidth',0.5);        
% else
%     uiwait(msgbox('There are no Standard 1D 1H NMR spectra.','modal'));    
%     handles.NOTIFICATIONS_BOX.String = "ERROR: The Standard 1D 1H NMR spectra cannot be plotted. Please try loading them.";   
% end
% %handles.MAX_Y_ALL = max(handles.Y1D(:));
% guidata(hObject, handles);


% --- Executes on button press in UseBuiltInCurves.
function UseBuiltInCurves_Callback(hObject, eventdata, handles)
% hObject    handle to UseBuiltInCurves (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UseBuiltInCurves

if handles.UseBuiltInCurves.Value == 1
    handles.AskNEWCurve.Value = 0;
    uiwait(msgbox('Before applying built in calibration parameters, please ensure that all urine 1H NMR spectra contain ERETIC (Bruker Quantref or something similar) signal at 12.0 ppm. If this reference signal is not present please deselect this option.','modal'));
    handles.absfactors = [2.7 1.05 0.53];
    handles.absfactorsError = [0.028 0.062 0.033];
    handles.absIntregion = [11.9 12.1];    
    handles.absConRef = 10;
    handles.GoforABS = 1;
    handles.QREF_Int = [];
    for i = 1:length(handles.Samples_titles1D)
        handles.QREF_Int(i,1) = find_region_integrate(handles.X1D(i,:),handles.Y1D(i,:),handles.absIntregion);
    end  
        
else
    handles.absfactors = 0;
    handles.absfactorsError = 0;
    handles.absIntregion = 0;    
    handles.absConRef = 0;
    handles.GoforABS = 0;
end
guidata(hObject, handles);


% --- Executes on button press in AskNEWCurve.
function AskNEWCurve_Callback(hObject, eventdata, handles)
% hObject    handle to AskNEWCurve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AskNEWCurve


if handles.AskNEWCurve.Value == 1
    handles.UseBuiltInCurves.Value = 0;
    try    
        [excel pathexcel] = uigetfile('*.xlsx');
        
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for loading the excel file...'],'windowstyle', 'alwaysontop');
        wbc = allchild(wb);
        jp = wbc(1).JavaPeer;
        wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
        jp.setIndeterminate(1);   
        
        handles.Excelfile_path = [pathexcel excel];
        [num,~,~] = xlsread(handles.Excelfile_path);
        [i,~] = find(isnan(num));
        num(i,:) = 0;
        if length(num) < 9
            num(length(num)+1:9,1) = 0;
        end

        handles.absfactors = num(4:6,1)';  
        handles.absfactorsError = num(7:9,1)';        
        handles.absIntregion = num(1:2,1)';
        handles.absConRef = num(3,1);
        if sum(handles.absfactors) == 0
            figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
            close(figHandles);
            str1 = "ERROR: You have not provided any calibration factor for absolute quantification. Please check the template file provided with the software.";
            handles.NOTIFICATIONS_BOX.String = str1;
            handles.GoforABS = 0;
            handles.AskNEWCurve.Value = 0;
        elseif sum(abs(handles.absIntregion)) == 0
            figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
            close(figHandles);
            str1 = "ERROR: You have not provided correctly the region for reference signal integration. Please check the template file provided with the software.";
            handles.NOTIFICATIONS_BOX.String = str1;
            handles.GoforABS = 0;
            handles.AskNEWCurve.Value = 0;
        elseif sum(handles.absConRef) == 0
            figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
            close(figHandles);
            str1 = "ERROR: You have not provided correctly the concentration represented by the reference signal. Please check the template file provided with the software.";
            handles.NOTIFICATIONS_BOX.String = str1;
            handles.GoforABS = 0;
            handles.AskNEWCurve.Value = 0;
        else
            handles.GoforABS = 1;
            handles.QREF_Int = [];
            for i = 1:length(handles.Samples_titles1D)
                handles.QREF_Int(i,1) = find_region_integrate(handles.X1D(i,:),handles.Y1D(i,:),handles.absIntregion);
            end  
            figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
            close(figHandles);
            str1 = "Excel file is successfully loaded.";
            handles.NOTIFICATIONS_BOX.String = str1;            
        end
        
    catch
        figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
        close(figHandles);
        str1 = "ERROR: Excel file is not loaded correctly. Please check the template file provided with the software.";
        handles.NOTIFICATIONS_BOX.String = str1;
        handles.GoforABSb = 0;
        handles.AskNEWCurve.Value = 0;
    end
else
    handles.absfactors = 0;
    handles.absfactorsError = 0;
    handles.absIntregion = 0;    
    handles.absConRef = 0;
    handles.GoforABS = 0;

end

guidata(hObject, handles);


% --- Executes on button press in ChooseCPMGdata.
function ChooseCPMGdata_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseCPMGdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ChooseCPMGdata
set(handles.SpectraNAMESTABLE,'Data',handles.Samples_titles1D); % Use the set command to change the uitable properties.    
set (handles.SpectraNAMESTABLE, 'CellSelectionCallback', @cb_select)
handles.Check_CPMG_plot = get(hObject,'Value');

if handles.Check_CPMG_plot == 1
    handles.BaselineFiltersplot.Value = 0;
    handles.Check_Baseline_plot = 0;
    handles.ChooseSMolESYdata.Value = 0;
    handles.Check_SMolESY_processed_plot = 0;
end

guidata(hObject, handles);

% --- Executes on button press in ChooseSMolESYdata.
function ChooseSMolESYdata_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseSMolESYdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ChooseSMolESYdata
set(handles.SpectraNAMESTABLE,'Data',handles.Samples_titles1D); % Use the set command to change the uitable properties.    
set (handles.SpectraNAMESTABLE, 'CellSelectionCallback', @cb_select)
handles.Check_SMolESY_processed_plot = get(hObject,'Value');

if handles.Check_SMolESY_processed_plot == 1
    handles.BaselineFiltersplot.Value = 0;
    handles.Check_Baseline_plot = 0;
    handles.ChooseCPMGdata.Value = 0;
    handles.Check_CPMG_plot = 0;
end

guidata(hObject, handles);


% --- Executes on button press in BaselineFiltersplot.
function BaselineFiltersplot_Callback(hObject, eventdata, handles)
% hObject    handle to BaselineFiltersplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BaselineFiltersplot
set(handles.SpectraNAMESTABLE,'Data',handles.Samples_titles1D); % Use the set command to change the uitable properties.    
set (handles.SpectraNAMESTABLE, 'CellSelectionCallback', @cb_select)
handles.Check_Baseline_plot = get(hObject,'Value');

if handles.Check_Baseline_plot == 1
    handles.ChooseCPMGdata.Value = 0;
    handles.Check_CPMG_plot = 0;
    handles.ChooseSMolESYdata.Value = 0;
    handles.Check_SMolESY_processed_plot = 0;
end


guidata(hObject, handles);


% --- Executes on button press in OutputFolder.
function OutputFolder_Callback(hObject, eventdata, handles)
% hObject    handle to OutputFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    if isempty(handles.Results_folder_path)
    Results_folder = uigetdir;
    else
    Results_folder = uigetdir(handles.Results_folder_path);
    end
catch
    Results_folder = uigetdir;
end
try
    handles.Results_folder_path = Results_folder;
    str1 = "Output folder for the exported results is successfully defined.";
    str2 = "Proceed with loading the Standard 1D 1H NMR urine spectra.";
    handles.NOTIFICATIONS_BOX.String = str1 + newline + str2;    
catch        
    handles.Results_folder_path = [];
    str1 = "ERROR: Something went wrong! Please re-select the folder for the exported results";
    handles.NOTIFICATIONS_BOX.String = str1;
end

guidata(hObject, handles);


% --- Executes on button press in ExportRESULTS.
function ExportRESULTS_Callback(hObject, eventdata, handles)
% hObject    handle to ExportRESULTS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.MethodFLAG == 3 && handles.PASS_Fitted_base == 1
        try 
            if handles.GoforABS == 0 || handles.absfactors(1,1) == 0 
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;
            elseif handles.GoforABS == 1 && handles.absfactors(1,1) > 0
                handles.Integrals_Baseline_fitF = (handles.Integrals_Baseline_fit*handles.absConRef*handles.absfactors(1,1))./handles.QREF_Int;
                handles.Integrals_Baseline_fitF = round(handles.Integrals_Baseline_fitF,4);
                if handles.absfactorsError(1,1) > 0
                    ERROR = handles.Integrals_Baseline_fitF*handles.absfactorsError(1,1);
                    ERROR = round(ERROR,4);
                else
                    ERROR(1:length(handles.Integrals_Baseline_fit),1) = NaN;
                end                
                handles.Integrals_Baseline_fitFF = [handles.Integrals_Baseline_fitF ERROR];
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fitFF,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (mg/mL): Prot. sig. extr. method' '+/- Error (mg/mL): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;                    
            else
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;
            end
        catch
            uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));
            handles.Int_baseline_export_FLAG = 0;
            figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
            close(figHandles);
            str1 = "Integration process was not completed successfully.";    
            handles.NOTIFICATIONS_BOX.String = str1;
        end
elseif handles.MethodFLAG == 4 && handles.PASS_SMolESY == 1 && handles.PASS_CPMG == 1 && handles.PASS_Fitted_base == 1
        try 
            if handles.GoforABS == 0 || handles.absfactors(1,1) == 0 
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;
            elseif handles.GoforABS == 1 && handles.absfactors(1,1) > 0
                handles.Integrals_Baseline_fitF = (handles.Integrals_Baseline_fit*handles.absConRef*handles.absfactors(1,1))./handles.QREF_Int;
                handles.Integrals_Baseline_fitF = round(handles.Integrals_Baseline_fitF,4);
                if handles.absfactorsError(1,1) > 0
                    ERROR = handles.Integrals_Baseline_fitF*handles.absfactorsError(1,1);
                    ERROR = round(ERROR,4);
                else
                    ERROR(1:length(handles.Integrals_Baseline_fit),1) = NaN;
                end                
                handles.Integrals_Baseline_fitFF = [handles.Integrals_Baseline_fitF ERROR];
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fitFF,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (mg/mL): Prot. sig. extr. method' '+/- Error (mg/mL): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;                    
            else
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;
            end     
        catch
            uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));
            handles.Int_baseline_export_FLAG = 0;
            figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
            close(figHandles);
            str1 = "Integration process was not completed successfully.";    
            handles.NOTIFICATIONS_BOX.String = str1;
        end
end        

try
    
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for exporting results...'],'windowstyle', 'alwaysontop');
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);    
    
    switch handles.MethodFLAG
        case 0
            uiwait(msgbox('ERROR: There is no data to be exported, select an appropriate method in STEP 2 and proceed accordingly.','modal'));
        case 1
            if handles.Int_NCD_export_FLAG == 1
                fig = uifigure('Name','NCD_based_protein_concentration','Position',[100 100 752 250]);
                fig.WindowStyle = 'alwaysontop';
                RESULTS_TABLE = uitable('Parent',fig,'Position',[25 50 700 200]);
                D = handles.Int_NCD_export.Properties.VariableNames;
                Index = find(contains(D,':'));
                for i = 1:length(Index)
                    K = D(Index(i));
                    D(Index(i)) = {strrep(char(K{1}),':',':|')};
                end
                clearvars K Index
                Index = find(contains(D,'Protein'));
                for i = 1:length(Index)
                    K = D(Index(i));
                    D(Index(i)) = {strrep(char(K{1}),'Total Protein','Total Protein|')};
                end
                set(RESULTS_TABLE,'ColumnName',[{'NMR Spectra / Total Protein| (a.u and/or mg/mL) per region -->'} D]);
                set(RESULTS_TABLE,'Data',[handles.Samples_titles1D table2cell(handles.Int_NCD_export)]);
                clearvars K D Index
                handles.Int_NCD_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';                                
                writetable(handles.Int_NCD_export,fullfile(handles.Results_folder_path,['NCD_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
                close(figHandles);
                str1 = ['Integration results are exported in the following file: ' fullfile(handles.Results_folder_path,'NCD_based_protein_concentration.csv')];    
                handles.NOTIFICATIONS_BOX.String = str1;            
            else
                figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
                close(figHandles);
                uiwait(msgbox('ERROR: There is no data to be exported. Please select NCD or ALL methods in STEP 2 and load the mandatory spectra.','modal'));
                str1 = "ERROR: There is no data to be exported. Please select NCD or ALL methods in STEP 2 and load the mandatory spectra.";    
                handles.NOTIFICATIONS_BOX.String = str1;
            end
        case 2
            if handles.Int_SMolESYfiltered_export_FLAG == 1
                fig = uifigure('Name','SMolESY-filtering_based_protein_concentration','Position',[100 100 752 250]);
                fig.WindowStyle = 'alwaysontop';
                RESULTS_TABLE = uitable('Parent',fig,'Position',[25 50 700 200]);
                D = handles.Int_SMolESYfiltered_export.Properties.VariableNames;
                Index = find(contains(D,':'));
                for i = 1:length(Index)
                    K = D(Index(i));
                    D(Index(i)) = {strrep(char(K{1}),':',':|')};
                end
                clearvars K Index
                Index = find(contains(D,'Protein'));
                for i = 1:length(Index)
                    K = D(Index(i));
                    D(Index(i)) = {strrep(char(K{1}),'Total Protein','Total Protein|')};
                end
                set(RESULTS_TABLE,'ColumnName',[{'NMR Spectra / Total Protein| (a.u and/or mg/mL) per region -->'} D]);
                set(RESULTS_TABLE,'Data',[handles.Samples_titles1D table2cell(handles.Int_SMolESYfiltered_export)]);
                clearvars K D Index
                handles.Int_SMolESYfiltered_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';                
                writetable(handles.Int_SMolESYfiltered_export,fullfile(handles.Results_folder_path,['SMolESY-filtering_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
                close(figHandles);
                str1 = ['Integration results are exported in the following file: ' fullfile(handles.Results_folder_path,'SMolESY-filtering_based_protein_concentration.csv')];    
                handles.NOTIFICATIONS_BOX.String = str1;            
            else
                figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
                close(figHandles);
                uiwait(msgbox('ERROR: There is no data to be exported. Please select SMolESY-filtering or ALL methods in STEP 2.','modal'));
                str1 = "ERROR: There is no data to be exported. Please select SMolESY-filtering or ALL methods in STEP 2 or check if SMolESY data are successfully produced in STEP 1.";    
                handles.NOTIFICATIONS_BOX.String = str1;
            end
        case 3
            if handles.Int_baseline_export_FLAG == 1
                fig = uifigure('Name','Protein_signal_extraction_(0.2-0.5ppm)_based_protein_concentration','Position',[100 100 752 250]);
                fig.WindowStyle = 'alwaysontop';
                RESULTS_TABLE = uitable('Parent',fig,'Position',[25 50 700 200]);
                D = handles.Int_baseline_export.Properties.VariableNames;
                Index = find(contains(D,':'));
                for i = 1:length(Index)
                    K = D(Index(i));
                    D(Index(i)) = {strrep(char(K{1}),':',':|')};
                end
                clearvars K Index
                Index = find(contains(D,'Protein'));
                for i = 1:length(Index)
                    K = D(Index(i));
                    D(Index(i)) = {strrep(char(K{1}),'Total Protein','Total Protein|')};
                end               
                set(RESULTS_TABLE,'ColumnName',[{'NMR Spectra / Total Protein| (a.u and/or mg/mL) per region -->'} D]);
                set(RESULTS_TABLE,'Data',[handles.Samples_titles1D table2cell(handles.Int_baseline_export)]);
                clearvars K D Index

                handles.Int_baseline_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';                
                writetable(handles.Int_baseline_export,fullfile(handles.Results_folder_path,['Protein_signal_extraction_(0.2-0.5ppm)_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
                close(figHandles);
                str1 = ['Integration results are exported in the following file: ' fullfile(handles.Results_folder_path,'Protein_signal_extraction_(0.2-0.5ppm)_based_protein_concentration.csv')];    
                handles.NOTIFICATIONS_BOX.String = str1;
            else
                figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
                close(figHandles);
                uiwait(msgbox('ERROR: There is no data to be exported. Please select Protein signal extraction from 0.2-0.5 ppm or ALL methods in STEP 2.','modal'));
                str1 = "ERROR: There is no data to be exported. Please select Protein signal extraction from 0.2-0.5 ppm or ALL methods in STEP 2 or check if Protein signal extraction from 0.2-0.5 ppm was successfully produced in STEP 1.";    
                handles.NOTIFICATIONS_BOX.String = str1;
            end 
        case 4
            if handles.Int_NCD_export_FLAG == 1 && handles.Int_baseline_export_FLAG == 1 && handles.Int_SMolESYfiltered_export_FLAG == 1

                fig1 = uifigure('Name','NCD_based_protein_concentration','Position',[100 100 752 250]);
                fig1.WindowStyle = 'alwaysontop';
                RESULTS_TABLE1 = uitable('Parent',fig1,'Position',[25 50 700 200]);
                D1 = handles.Int_NCD_export.Properties.VariableNames;
                Index = find(contains(D1,':'));
                for i = 1:length(Index)
                    K = D1(Index(i));
                    D1(Index(i)) = {strrep(char(K{1}),':',':|')};
                end
                clearvars K Index
                Index = find(contains(D1,'Protein'));
                for i = 1:length(Index)
                    K = D1(Index(i));
                    D1(Index(i)) = {strrep(char(K{1}),'Total Protein','Total Protein|')};
                end               
                set(RESULTS_TABLE1,'ColumnName',[{'NMR Spectra / Total Protein| (a.u and/or mg/mL) per region -->'} D1]);
                set(RESULTS_TABLE1,'Data',[handles.Samples_titles1D table2cell(handles.Int_NCD_export)]);
                clearvars K D1 Index

                fig2 = uifigure('Name','SMolESY-filtering_based_protein_concentration','Position',[100 100 752 250]);
                fig2.WindowStyle = 'alwaysontop';
                RESULTS_TABLE2 = uitable('Parent',fig2,'Position',[25 50 700 200]);
                D2 = handles.Int_SMolESYfiltered_export.Properties.VariableNames;
                Index = find(contains(D2,':'));
                for i = 1:length(Index)
                    K = D2(Index(i));
                    D2(Index(i)) = {strrep(char(K{1}),':',':|')};
                end
                clearvars K Index
                Index = find(contains(D2,'Protein'));
                for i = 1:length(Index)
                    K = D2(Index(i));
                    D2(Index(i)) = {strrep(char(K{1}),'Total Protein','Total Protein|')};
                end               

                set(RESULTS_TABLE2,'ColumnName',[{'NMR Spectra / Total Protein| (a.u and/or mg/mL) per region -->'} D2]);
                set(RESULTS_TABLE2,'Data',[handles.Samples_titles1D table2cell(handles.Int_SMolESYfiltered_export)]);

                fig3 = uifigure('Name','Protein_signal_extraction_(0.2-0.5ppm)_based_protein_concentration','Position',[100 100 752 250]);
                fig3.WindowStyle = 'alwaysontop';
                RESULTS_TABLE3 = uitable('Parent',fig3,'Position',[25 50 700 200]);
                D3 = handles.Int_baseline_export.Properties.VariableNames;

                Index = find(contains(D3,':'));
                for i = 1:length(Index)
                    K = D3(Index(i));
                    D3(Index(i)) = {strrep(char(K{1}),':',':|')};
                end
                clearvars K Index
                Index = find(contains(D3,'Protein'));
                for i = 1:length(Index)
                    K = D3(Index(i));
                    D3(Index(i)) = {strrep(char(K{1}),'Total Protein','Total Protein|')};
                end               


                set(RESULTS_TABLE3,'ColumnName',[{'NMR Spectra / Total Protein| (a.u and/or mg/mL) per region -->'} D3]);
                set(RESULTS_TABLE3,'Data',[handles.Samples_titles1D table2cell(handles.Int_baseline_export)]);

                
                handles.Int_NCD_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';
                handles.Int_SMolESYfiltered_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';                
                handles.Int_baseline_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';                
                
                writetable(handles.Int_NCD_export,fullfile(handles.Results_folder_path,['NCD_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                writetable(handles.Int_baseline_export,fullfile(handles.Results_folder_path,['Protein_signal_extraction_(0.2-0.5ppm)_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                writetable(handles.Int_SMolESYfiltered_export,fullfile(handles.Results_folder_path,['SMolESY-filtering_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
                close(figHandles);
                str = ["Integration results are exported to [" handles.Results_folder_path "] in the following files:"];
                str1 = join(str);
                str2 = "1) NCD_based_protein_concentration.csv";
                str3 = "2) Protein_signal_extraction_(0.2-0.5ppm)_based_protein_concentration.csv";
                str4 = "3) SMolESY-filtering_based_protein_concentration.csv";
                handles.NOTIFICATIONS_BOX.String = str1 + newline + str2 + newline + str3 + newline + str4;
            else
                figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
                close(figHandles);
                uiwait(msgbox('ERROR: There is no data to be exported. Please select ALL methods in STEP 2.','modal'));
                str1 = "ERROR: There is no data to be exported. Please select ALL methods in STEP 2 or check all filtering methods data are successfully produced. ";    
                handles.NOTIFICATIONS_BOX.String = str1;
            end             
    end
catch
    
    uiwait(msgbox('ERROR: There is no data to be exported. Please calculate integrals and/or absolute concentrations.','modal'));
    figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
    close(figHandles);
    str1 = "ERROR: There is no data to be exported. Please calculate integrals and/or absolute concentrations.";    
    handles.NOTIFICATIONS_BOX.String = str1;
    
end


% --- Executes on selection change in ChooseREGIONS_Int.
function ChooseREGIONS_Int_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseREGIONS_Int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChooseREGIONS_Int contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChooseREGIONS_Int


contents = cellstr(get(hObject,'String'));

if handles.MethodFLAG == 0 || handles.MethodFLAG == 3
    
    handles.Int_REGION_flag = 0;
    handles.Int_REGION = 0;
    
    uiwait(msgbox('NCD and/or SMolESY filtered NMR spectra are needed. Please be sure that you have selected either one of these or ALL methods in STEP 2.','modal')); 
    str1 = "ERROR: NCD and/or SMolESY filtered NMR spectra are needed. Please be sure that you have selected either one of these or ALL methods in STEP 2.";    
    handles.NOTIFICATIONS_BOX.String = str1;
    
else
    if isequal(contents{get(hObject,'Value')},'Select * spectrum region(s) for integration')

        handles.Int_REGION_flag = 0;
        handles.Int_REGION = 0;

    elseif isequal(contents{get(hObject,'Value')},'0.2 - 0.5 ppm')

        handles.Int_REGION_flag = 1;
        handles.Int_REGION = [0.2 0.5];
        
    elseif isequal(contents{get(hObject,'Value')},'0.2 - 0.7 ppm')

        handles.Int_REGION_flag = 2;
        handles.Int_REGION = [0.2 0.7];
        
% 
%     elseif isequal(contents{get(hObject,'Value')},'0.8 - 2.0 ppm')    
% 
%         handles.Int_REGION_flag = 3;
%         handles.Int_REGION = [0.8 2.0];
% 
%     elseif isequal(contents{get(hObject,'Value')},'6.3 - 7.0 ppm')    
% 
%         handles.Int_REGION_flag = 4;
%         handles.Int_REGION = [6.3 7.0];

    elseif isequal(contents{get(hObject,'Value')},'8.0 - 10.0 ppm')    

%         handles.Int_REGION_flag = 5;
        handles.Int_REGION_flag = 3;
        handles.Int_REGION = [8.0 10.0];
        

    elseif isequal(contents{get(hObject,'Value')},'All the above')

%         handles.Int_REGION_flag = 6;
        handles.Int_REGION_flag = 4;
        %handles.Int_REGION = [0.2 0.5; 0.2 0.7; 0.8 2.0; 6.3 7.0; 8.0 10.0];
        handles.Int_REGION = [0.2 0.5; 0.2 0.7; 8.0 10.0];
        
    else
        uiwait(msgbox('NCD and/or SMolESY filtered NMR spectra are needed. Please be sure that you have selected either one of these or ALL methods in STEP 2.','modal'));
        str1 = "ERROR: NCD and/or SMolESY filtered NMR spectra are needed. Please be sure that you have selected either one of these or ALL methods in STEP 2.";    
        handles.NOTIFICATIONS_BOX.String = str1;
        handles.Int_REGION_flag = 0;
        handles.Int_REGION = 0;
    end
    
end


try
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for the integration process completion...'],'windowstyle', 'alwaysontop');
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);    
    
%     if handles.MethodFLAG == 3 && handles.PASS_Fitted_base == 1
%         try 
%             if handles.GoforABS == 0 || handles.absfactors(1,1) == 0 
%                 handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
%                 handles.Int_baseline_export_FLAG = 1;
%             elseif handles.GoforABS == 1 && handles.absfactors(1,1) > 0
%                 handles.Integrals_Baseline_fitF = (handles.Integrals_Baseline_fit*handles.absConRef*handles.absfactors(1,1))./handles.QREF_Int;
%                 handles.Integrals_Baseline_fitF = round(handles.Integrals_Baseline_fitF,4);
%                 if handles.absfactorsError(1,1) > 0
%                     ERROR = handles.Integrals_Baseline_fitF*handles.absfactorsError(1,1);
%                     ERROR = round(ERROR,4);
%                 else
%                     ERROR(1:length(handles.Integrals_Baseline_fit),1) = NaN;
%                 end                
%                 handles.Integrals_Baseline_fitFF = [handles.Integrals_Baseline_fitF ERROR];
%                 handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fitFF,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (mg/mL): Prot. sig. extr. method' '+/- Error (mg/mL): Prot. sig. extr. method'});
%                 handles.Int_baseline_export_FLAG = 1;                    
%             else
%                 handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
%                 handles.Int_baseline_export_FLAG = 1;
%             end
% 
%         catch
% 
%             uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));
%             handles.Int_baseline_export_FLAG = 0;
%             figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
%             close(figHandles);
%             str1 = "Integration process was not completed successfully.";    
%             handles.NOTIFICATIONS_BOX.String = str1;
%         end

% else
    if handles.MethodFLAG == 1 && handles.PASS_CPMG == 1
        try
            for i = 1:length(handles.Samples_titles1D)
                    Integral_temp_NCD = NMRpQuant_NCD_SMolESY_method_integration(handles.X1D(i,:),handles.NCDspectra(i,:), handles.Int_REGION);
                    Integrals_F_NCD(i,:) = transpose(Integral_temp_NCD);
            end  
            if handles.GoforABS == 0
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (a.u.): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                            Region_names = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',Region_names);
                end   
                handles.Int_NCD_export = Int_NCD_export;    
                handles.Int_NCD_export_FLAG = 1;
            elseif handles.GoforABS == 1
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (mg/mL): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Integrals_F_NCD_F = (Integrals_F_NCD*handles.absConRef*handles.absfactors(1,handles.Int_REGION_flag))./handles.QREF_Int; 
                        Integrals_F_NCD_F = round(Integrals_F_NCD_F,4);
                        if Integrals_F_NCD_F > 0
                            if handles.absfactorsError(1,handles.Int_REGION_flag) > 0
                                ERROR = Integrals_F_NCD_F*handles.absfactorsError(1,handles.Int_REGION_flag);
                                ERROR = round(ERROR,4);
                            else
                                ERROR(1:length(Integrals_F_NCD_F),1) = NaN;
                            end                
                            Integrals_F_NCD_FF = [Integrals_F_NCD_F ERROR];
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',{C ['+/- Error (mg/mL): ' A{1+handles.Int_REGION_flag}]});
                        else
                            A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                            B = 'Total Protein concentration (a.u.): ';            
                            C = [B A{1+handles.Int_REGION_flag}];                            
                            Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                        end
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Integrals_F_NCD_F = (Integrals_F_NCD*handles.absConRef.*handles.absfactors)./handles.QREF_Int; 
                        Region_namesABS = {'Total Protein concentration (mg/mL): 0.2 - 0.5 ppm' 'Total Protein concentration (mg/mL): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (mg/mL): 8.0 - 10.0 ppm' 'Total Protein concentration (mg/mL): All regions'};
                        Region_namesAU = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        ERROR_names = {'+/- Error (mg/mL): 0.2 - 0.5 ppm' '+/- Error (mg/mL): 0.2 - 0.7 ppm'...
                                            '+/- Error (mg/mL): 8.0 - 10.0 ppm' '+/- Error (mg/mL): All regions'};
                        [~,ii] = find(Integrals_F_NCD_F == 0);                        
                        if isempty(ii)
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR
                            ERROR = Integrals_F_NCD_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integrals_F_NCD_F mean(Integrals_F_NCD_F,2)];
                            a = round(a,4); 
                            b = [ERROR mean(ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integrals_F_NCD_FF = reshape([a(:) b(:)]',2*size(a,1), [])';                            
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        else
                            IND = unique(ii);
                            
                            Temp_Integrals_F_NCD_F = Integrals_F_NCD_F;
                            Temp_Integrals_F_NCD_F(:,IND) = [];
                            TEMP_absfactorsError = handles.absfactorsError;
                            
                            TEMP_absfactorsError(:,IND) = [];
                            [~,ooo] = find(TEMP_absfactorsError == 0);                            
                            TEMP_absfactorsError(:,ooo) = NaN;
                            Temp_ERROR = Temp_Integrals_F_NCD_F.*TEMP_absfactorsError; 
                            
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR ooo TEMP_absfactorsError

                            ERROR = Integrals_F_NCD_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integrals_F_NCD_F mean(Temp_Integrals_F_NCD_F,2)];
                            a = round(a,4);
                            a(:,IND) = Integrals_F_NCD(:,IND);
                            b = [ERROR mean(Temp_ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integrals_F_NCD_FF = reshape([a(:) b(:)]',2*size(a,1), [])';     
                            Region_namesABS(IND) = Region_namesAU(IND);
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            INDs = 2*IND;
                            ca3(INDs) = [];
                            Integrals_F_NCD_FF(:,INDs) = [];
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        end
                end   
                handles.Int_NCD_export = Int_NCD_export;    
                handles.Int_NCD_export_FLAG = 1;
            end
        catch
            handles.Int_NCD_export_FLAG = 0;
            uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));
            figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
            close(figHandles);
            str1 = "Integration process was not completed successfully.";    
            handles.NOTIFICATIONS_BOX.String = str1;
        end

    elseif handles.MethodFLAG == 2 && handles.PASS_SMolESY == 1
        try
            for i = 1:length(handles.Samples_titles1D)
                Integral_temp_SMolESYfiltered = NMRpQuant_NCD_SMolESY_method_integration(handles.X1D(i,:),handles.SMolESY_filtered1D(i,:), handles.Int_REGION);
                Integral_F_SMolESYfiltered(i,:) = transpose(Integral_temp_SMolESYfiltered);
            end  
            if handles.GoforABS == 0
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (a.u.): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',{C});                        
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Region_names = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',Region_names);
                end   
                handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;
                handles.Int_SMolESYfiltered_export_FLAG = 1;
            elseif handles.GoforABS == 1
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (mg/mL): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Integral_F_SMolESYfiltered_F = (Integral_F_SMolESYfiltered*handles.absConRef*handles.absfactors(1,handles.Int_REGION_flag))./handles.QREF_Int; 
                        Integral_F_SMolESYfiltered_F = round(Integral_F_SMolESYfiltered_F,4);
                        if Integral_F_SMolESYfiltered_F > 0
                            if handles.absfactorsError(1,handles.Int_REGION_flag) > 0
                                ERROR = Integral_F_SMolESYfiltered_F*handles.absfactorsError(1,handles.Int_REGION_flag);
                                ERROR = round(ERROR,4);
                            else
                                ERROR(1:length(Integral_F_SMolESYfiltered_F),1) = NaN;
                            end                
                            Integral_F_SMolESYfiltered_FF = [Integral_F_SMolESYfiltered_F ERROR];
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',{C ['+/- Error (mg/mL): ' A{1+handles.Int_REGION_flag}]});
                        else
                            A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                            B = 'Total Protein concentration (a.u.): ';            
                            C = [B A{1+handles.Int_REGION_flag}];                            
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                        end
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Integral_F_SMolESYfiltered_F = (Integral_F_SMolESYfiltered*handles.absConRef.*handles.absfactors)./handles.QREF_Int; 
                        Region_namesABS = {'Total Protein concentration (mg/mL): 0.2 - 0.5 ppm' 'Total Protein concentration (mg/mL): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (mg/mL): 8.0 - 10.0 ppm' 'Total Protein concentration (mg/mL): All regions'};
                        Region_namesAU = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        ERROR_names = {'+/- Error (mg/mL): 0.2 - 0.5 ppm' '+/- Error (mg/mL): 0.2 - 0.7 ppm'...
                                            '+/- Error (mg/mL): 8.0 - 10.0 ppm' '+/- Error (mg/mL): All regions'};
                        [~,ii] = find(Integral_F_SMolESYfiltered_F == 0);                        
                        if isempty(ii)
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR
                            ERROR = Integral_F_SMolESYfiltered_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integral_F_SMolESYfiltered_F mean(Integral_F_SMolESYfiltered_F,2)];
                            a = round(a,4);
                            b = [ERROR mean(ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integral_F_SMolESYfiltered_FF = reshape([a(:) b(:)]',2*size(a,1), [])';                            
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        else
                            IND = unique(ii);
                            Temp_Integral_F_SMolESYfiltered_F = Integral_F_SMolESYfiltered_F;
                            Temp_Integral_F_SMolESYfiltered_F(:,IND) = [];
                            TEMP_absfactorsError = handles.absfactorsError;
                            
                            TEMP_absfactorsError(:,IND) = [];
                            [~,ooo] = find(TEMP_absfactorsError == 0);                            
                            TEMP_absfactorsError(:,ooo) = NaN;
                            Temp_ERROR = Temp_Integral_F_SMolESYfiltered_F.*TEMP_absfactorsError;                                                                                   
                            
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR ooo TEMP_absfactorsError
                            
                            ERROR = Integral_F_SMolESYfiltered_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integral_F_SMolESYfiltered_F mean(Temp_Integral_F_SMolESYfiltered_F,2)];
                            a = round(a,4);
                            a(:,IND) = Integral_F_SMolESYfiltered(:,IND);
                            b = [ERROR mean(Temp_ERROR,2)];
                            b = round(b,4);                                                   
                            a = a';
                            b = b';
                            Integral_F_SMolESYfiltered_FF = reshape([a(:) b(:)]',2*size(a,1), [])';     
                            Region_namesABS(IND) = Region_namesAU(IND);
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            INDs = 2*IND;
                            ca3(INDs) = [];
                            Integral_F_SMolESYfiltered_FF(:,INDs) = [];
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        end
                end   
                handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;
                handles.Int_SMolESYfiltered_export_FLAG = 1;
            end
        catch        
            handles.Int_SMolESYfiltered_export_FLAG = 0;
            uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));
            figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
            close(figHandles);
            str1 = "Integration process was not completed successfully.";    
            handles.NOTIFICATIONS_BOX.String = str1;
        end

    elseif handles.MethodFLAG == 4 && handles.PASS_SMolESY == 1 && handles.PASS_CPMG == 1 && handles.PASS_Fitted_base == 1
        try 
%             if handles.GoforABS == 0 || handles.absfactors(1,1) == 0 
%                 handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
%                 handles.Int_baseline_export_FLAG = 1;
%             elseif handles.GoforABS == 1 && handles.absfactors(1,1) > 0
%                 handles.Integrals_Baseline_fitF = (handles.Integrals_Baseline_fit*handles.absConRef*handles.absfactors(1,1))./handles.QREF_Int;
%                 handles.Integrals_Baseline_fitF = round(handles.Integrals_Baseline_fitF,4);
%                 if handles.absfactorsError(1,1) > 0
%                     ERROR = handles.Integrals_Baseline_fitF*handles.absfactorsError(1,1);
%                     ERROR = round(ERROR,4);
%                 else
%                     ERROR(1:length(handles.Integrals_Baseline_fit),1) = NaN;
%                 end                
%                 handles.Integrals_Baseline_fitFF = [handles.Integrals_Baseline_fitF ERROR];
%                 handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fitFF,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (mg/mL): Prot. sig. extr. method' '+/- Error (mg/mL): Prot. sig. extr. method'});
%                 handles.Int_baseline_export_FLAG = 1;                    
%             else
%                 handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
%                 handles.Int_baseline_export_FLAG = 1;
%             end


            for i = 1:length(handles.Samples_titles1D)
                Integral_temp_NCD = NMRpQuant_NCD_SMolESY_method_integration(handles.X1D(i,:),handles.NCDspectra(i,:), handles.Int_REGION);
                Integral_temp_SMolESYfiltered = NMRpQuant_NCD_SMolESY_method_integration(handles.X1D(i,:),handles.SMolESY_filtered1D(i,:), handles.Int_REGION);
                Integrals_F_NCD(i,:) = transpose(Integral_temp_NCD);
                Integral_F_SMolESYfiltered(i,:) = transpose(Integral_temp_SMolESYfiltered);
            end  

            if handles.GoforABS == 0
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (a.u.): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',{C});  
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Region_names = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',Region_names);
                        Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',Region_names);
                end   
                handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;
                handles.Int_SMolESYfiltered_export_FLAG = 1;
            elseif handles.GoforABS == 1
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (mg/mL): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Integral_F_SMolESYfiltered_F = (Integral_F_SMolESYfiltered*handles.absConRef*handles.absfactors(1,handles.Int_REGION_flag))./handles.QREF_Int; 
                        Integral_F_SMolESYfiltered_F = round(Integral_F_SMolESYfiltered_F,4);
                        if Integral_F_SMolESYfiltered_F > 0
                            if handles.absfactorsError(1,handles.Int_REGION_flag) > 0
                                ERROR = Integral_F_SMolESYfiltered_F*handles.absfactorsError(1,handles.Int_REGION_flag);
                                ERROR = round(ERROR,4);
                            else
                                ERROR(1:length(Integral_F_SMolESYfiltered_F),1) = NaN;
                            end                
                            Integral_F_SMolESYfiltered_FF = [Integral_F_SMolESYfiltered_F ERROR];
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',{C ['+/- Error (mg/mL): ' A{1+handles.Int_REGION_flag}]});
                        else
                            A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                            B = 'Total Protein concentration (a.u.): ';            
                            C = [B A{1+handles.Int_REGION_flag}];                            
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                        end
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Integral_F_SMolESYfiltered_F = (Integral_F_SMolESYfiltered*handles.absConRef.*handles.absfactors)./handles.QREF_Int;                         
                        Region_namesABS = {'Total Protein concentration (mg/mL): 0.2 - 0.5 ppm' 'Total Protein concentration (mg/mL): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (mg/mL): 8.0 - 10.0 ppm' 'Total Protein concentration (mg/mL): All regions'};
                        Region_namesAU = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        ERROR_names = {'+/- Error (mg/mL): 0.2 - 0.5 ppm' '+/- Error (mg/mL): 0.2 - 0.7 ppm'...
                                            '+/- Error (mg/mL): 8.0 - 10.0 ppm' '+/- Error (mg/mL): All regions'};
                        [~,ii] = find(Integral_F_SMolESYfiltered_F == 0);                        
                        if isempty(ii)
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR
                            ERROR = Integral_F_SMolESYfiltered_F.*handles.absfactorsError;                            
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integral_F_SMolESYfiltered_F mean(Integral_F_SMolESYfiltered_F,2)];
                            a = round(a,4);
                            b = [ERROR mean(ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integral_F_SMolESYfiltered_FF = reshape([a(:) b(:)]',2*size(a,1), [])';                            
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        else
                            IND = unique(ii);                            
                            Temp_Integral_F_SMolESYfiltered_F = Integral_F_SMolESYfiltered_F;
                            Temp_Integral_F_SMolESYfiltered_F(:,IND) = [];
                            TEMP_absfactorsError = handles.absfactorsError;
                            
                            TEMP_absfactorsError(:,IND) = [];
                            [~,ooo] = find(TEMP_absfactorsError == 0);                            
                            TEMP_absfactorsError(:,ooo) = NaN;
                            Temp_ERROR = Temp_Integral_F_SMolESYfiltered_F.*TEMP_absfactorsError;                                                                                   
                            
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR ooo TEMP_absfactorsError
                            ERROR = Integral_F_SMolESYfiltered_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;                                  
                            a = [Integral_F_SMolESYfiltered_F mean(Temp_Integral_F_SMolESYfiltered_F,2)];
                            a = round(a,4);
                            a(:,IND) = Integral_F_SMolESYfiltered(:,IND);
                            b = [ERROR mean(Temp_ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integral_F_SMolESYfiltered_FF = reshape([a(:) b(:)]',2*size(a,1), [])';     
                            Region_namesABS(IND) = Region_namesAU(IND);
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            INDs = 2*IND;
                            ca3(INDs) = [];
                            Integral_F_SMolESYfiltered_FF(:,INDs) = [];
                            
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        end
                end   
                handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;
                handles.Int_SMolESYfiltered_export_FLAG = 1;
            end

            if handles.GoforABS == 0
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (a.u.): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                            Region_names = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',Region_names);
                end   
                handles.Int_NCD_export = Int_NCD_export;    
                handles.Int_NCD_export_FLAG = 1;
            elseif handles.GoforABS == 1
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (mg/mL): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Integrals_F_NCD_F = (Integrals_F_NCD*handles.absConRef*handles.absfactors(1,handles.Int_REGION_flag))./handles.QREF_Int; 
                        Integrals_F_NCD_F = round(Integrals_F_NCD_F,4);
                        if Integrals_F_NCD_F > 0
                            if handles.absfactorsError(1,handles.Int_REGION_flag) > 0
                                ERROR = Integrals_F_NCD_F*handles.absfactorsError(1,handles.Int_REGION_flag);
                                ERROR = round(ERROR,4);
                            else
                                ERROR(1:length(Integrals_F_NCD_F),1) = NaN;
                            end                
                            Integrals_F_NCD_FF = [Integrals_F_NCD_F ERROR];
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',{C ['+/- Error (mg/mL): ' A{1+handles.Int_REGION_flag}]});
                        else
                            A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                            B = 'Total Protein concentration (a.u.): ';            
                            C = [B A{1+handles.Int_REGION_flag}];                            
                            Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                        end
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Integrals_F_NCD_F = (Integrals_F_NCD*handles.absConRef.*handles.absfactors)./handles.QREF_Int; 
                        Region_namesABS = {'Total Protein concentration (mg/mL): 0.2 - 0.5 ppm' 'Total Protein concentration (mg/mL): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (mg/mL): 8.0 - 10.0 ppm' 'Total Protein concentration (mg/mL): All regions'};
                        Region_namesAU = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        ERROR_names = {'+/- Error (mg/mL): 0.2 - 0.5 ppm' '+/- Error (mg/mL): 0.2 - 0.7 ppm'...
                                            '+/- Error (mg/mL): 8.0 - 10.0 ppm' '+/- Error (mg/mL): All regions'};
                        [i,ii] = find(Integrals_F_NCD_F == 0);                        
                        if isempty(ii)
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR
                            ERROR = Integrals_F_NCD_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integrals_F_NCD_F mean(Integrals_F_NCD_F,2)];
                            a = round(a,4); 
                            b = [ERROR mean(ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integrals_F_NCD_FF = reshape([a(:) b(:)]',2*size(a,1), [])';                            
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        else
                            IND = unique(ii);
                            Temp_Integrals_F_NCD_F = Integrals_F_NCD_F;
                            Temp_Integrals_F_NCD_F(:,IND) = [];
                            TEMP_absfactorsError = handles.absfactorsError;
                            
                            TEMP_absfactorsError(:,IND) = [];
                            [~,ooo] = find(TEMP_absfactorsError == 0);                            
                            TEMP_absfactorsError(:,ooo) = NaN;
                            Temp_ERROR = Temp_Integrals_F_NCD_F.*TEMP_absfactorsError; 
                            
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR ooo TEMP_absfactorsError                                                        
                          
                            ERROR = Integrals_F_NCD_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integrals_F_NCD_F mean(Temp_Integrals_F_NCD_F,2)];
                            a = round(a,4);
                            a(:,IND) = Integrals_F_NCD(:,IND);
                            b = [ERROR mean(Temp_ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integrals_F_NCD_FF = reshape([a(:) b(:)]',2*size(a,1), [])';     
                            Region_namesABS(IND) = Region_namesAU(IND);
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            INDs = 2*IND;
                            ca3(INDs) = [];
                            Integrals_F_NCD_FF(:,INDs) = [];
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        end
                end   
                handles.Int_NCD_export = Int_NCD_export;    
                handles.Int_NCD_export_FLAG = 1;
            end

            handles.Int_NCD_export = Int_NCD_export;
            handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;            
            handles.Int_NCD_export_FLAG = 1; 
            %handles.Int_baseline_export_FLAG = 1;
            handles.Int_SMolESYfiltered_export_FLAG = 1;    
        catch
            handles.Int_NCD_export_FLAG = 0; 
            %handles.Int_baseline_export_FLAG = 0;
            handles.Int_SMolESYfiltered_export_FLAG = 0;
            uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));       
            figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
            close(figHandles);
            str1 = "Integration process was not completed successfully.";    
            handles.NOTIFICATIONS_BOX.String = str1;
        end
    else
       handles.Int_NCD_export_FLAG = 0; 
       handles.Int_baseline_export_FLAG = 0;
       handles.Int_SMolESYfiltered_export_FLAG = 0;
       uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));       
       figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
       close(figHandles);
       str1 = "Integration process was not completed successfully.";    
       handles.NOTIFICATIONS_BOX.String = str1;
    end
    figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
    close(figHandles);
    str1 = "Integration process is completed successfully.";    
    handles.NOTIFICATIONS_BOX.String = str1;
        
catch
    
    uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));       
    figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
    close(figHandles);
    str1 = "ERROR: Integration process cannot be completed. Please check the selected method and if the filtered data are produced.";    
    handles.NOTIFICATIONS_BOX.String = str1;
    
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ChooseREGIONS_Int_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChooseREGIONS_Int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% set(hObject, 'String',[{'Select * spectrum region(s) for integration'};{'0.2 - 0.5 ppm'};{'0.2 - 0.7 ppm'};{'0.8 - 2.0 ppm'};{'6.3 - 7.0 ppm'};{'8.0 - 10.0 ppm'};{'All the above'}]);
set(hObject, 'String',[{'Select * spectrum region(s) for integration'};{'0.2 - 0.5 ppm'};{'0.2 - 0.7 ppm'};{'8.0 - 10.0 ppm'};{'All the above'}]);

guidata(hObject, handles);


% --- Executes on button press in ExportFILTEREDgeneral.
function ExportFILTEREDgeneral_Callback(hObject, eventdata, handles)
% hObject    handle to ExportFILTEREDgeneral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try    
    if handles.MethodFLAG == 3 && handles.PASS_Fitted_base == 1
        
        mkdir(fullfile(handles.Results_folder_path,'Protein_signal_extraction_filtered_spec_data'))
        D = fullfile(handles.Results_folder_path,'Protein_signal_extraction_filtered_spec_data');
        for i = 1:length(handles.Samples_titles1D)
            str1 = ['Please wait for exporting small molecules by Protein signal extraction from 0.2-0.5 ppm filtered NMR spectrum: <' handles.Samples_titles1D{i} '> ...'];
            handles.NOTIFICATIONS_BOX.String = str1;            
            DIKA = waitbar2a(i/(size(handles.Samples_titles1D,1)-(0.01*size(handles.Samples_titles1D,1))),handles.Progress,['Exporting macromolecular filtered NMR data...'],'g');
            temp_mat = [handles.X_fit(i).data;transpose(handles.baseline_filtered1D(i).data)];
            for u = 1:length(handles.X_fit(i).data)
                feature_names(1,u) = {num2str(u)};
            end
            temp_out = array2table(temp_mat,'RowNames',{'PPM' handles.Samples_titles1D{i}},'VariableNames',feature_names);
            temp_out.Properties.DimensionNames{1} = 'Protein signal extraction Filtered Spectrum';
            mkdir(fullfile(D,handles.Samples_titles1D{i}))
            writetable(temp_out,fullfile(D,handles.Samples_titles1D{i},[handles.Samples_titles1D{i} '-spectral_data.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
            clearvars feature_names temp_mat            
        end
        if i == size(handles.Samples_titles1D,1)
            DIKA = waitbar2a(i/size(handles.Samples_titles1D,1),handles.Progress,['Macro-filtered NMR data exporting is completed.'],'g');
        end        
        str1 = ['Protein signal extraction from 0.2-0.5 ppm filtered NMR data exported successfully. Please check results at: [' D ']'];    
        handles.NOTIFICATIONS_BOX.String = str1; 


    elseif handles.MethodFLAG == 1 && handles.PASS_CPMG == 1
    
        mkdir(fullfile(handles.Results_folder_path,'NCD_filtered_spec_data'))
        D = fullfile(handles.Results_folder_path,'NCD_filtered_spec_data');
        for i = 1:length(handles.Samples_titles1D)
            str1 = ['Please wait for exporting small molecules by NCD method filtered NMR spectrum: <' handles.Samples_titles1D{i} '> ...'];
            handles.NOTIFICATIONS_BOX.String = str1;                        
            DIKA = waitbar2a(i/(size(handles.Samples_titles1D,1)-(0.01*size(handles.Samples_titles1D,1))),handles.Progress,['Exporting macromolecular filtered NMR data...'],'g');
            temp_mat = [handles.X1D(i,:);handles.NCDspectra(i,:)];
            for u = 1:length(handles.X1D(i,:))
                feature_names(1,u) = {num2str(u)};
            end
            temp_out = array2table(temp_mat,'RowNames',{'PPM' handles.Samples_titles1D{i}},'VariableNames',feature_names);
            temp_out.Properties.DimensionNames{1} = 'NCD Filtered Spectrum';
            mkdir(fullfile(D,handles.Samples_titles1D{i}))
            writetable(temp_out,fullfile(D,handles.Samples_titles1D{i},[handles.Samples_titles1D{i} '-spectral_data.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
            clearvars feature_names temp_mat
        end    
        if i == size(handles.Samples_titles1D,1)
            DIKA = waitbar2a(i/size(handles.Samples_titles1D,1),handles.Progress,['Macro-filtered NMR data exporting is completed.'],'g');
        end        
        str1 = ['NCD-filtered NMR data exported successfully. Please check results at: [' D ']'];    
        handles.NOTIFICATIONS_BOX.String = str1; 


    elseif handles.MethodFLAG == 2 && handles.PASS_SMolESY == 1
    
        mkdir(fullfile(handles.Results_folder_path,'SMolESY_filtered_spec_data'))
        D = fullfile(handles.Results_folder_path,'SMolESY_filtered_spec_data');
        for i = 1:length(handles.Samples_titles1D)
            str1 = ['Please wait for exporting small molecules by SMolESY method filtered NMR spectrum: <' handles.Samples_titles1D{i} '> ...'];
            handles.NOTIFICATIONS_BOX.String = str1;                                    
            DIKA = waitbar2a(i/(size(handles.Samples_titles1D,1)-(0.01*size(handles.Samples_titles1D,1))),handles.Progress,['Exporting macromolecular filtered NMR data...'],'g');
            temp_mat = [handles.X1D(i,:);handles.SMolESY_filtered1D(i,:)];
            for u = 1:length(handles.X1D(i,:))
                feature_names(1,u) = {num2str(u)};
            end
            temp_out = array2table(temp_mat,'RowNames',{'PPM' handles.Samples_titles1D{i}},'VariableNames',feature_names);
            temp_out.Properties.DimensionNames{1} = 'SMolESY Filtered Spectrum';
            mkdir(fullfile(D,handles.Samples_titles1D{i}))
            writetable(temp_out,fullfile(D,handles.Samples_titles1D{i},[handles.Samples_titles1D{i} '-spectral_data.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
            clearvars feature_names temp_mat
        end    
        if i == size(handles.Samples_titles1D,1)
            DIKA = waitbar2a(i/size(handles.Samples_titles1D,1),handles.Progress,['Macro-filtered NMR data exporting is completed.'],'g');
        end
        str1 = ['SMolESY-filtered NMR data exported successfully. Please check results at: [' D ']'];    
        handles.NOTIFICATIONS_BOX.String = str1;     
    
    elseif handles.MethodFLAG == 4 && handles.PASS_SMolESY == 1 && handles.PASS_CPMG == 1 && handles.PASS_Fitted_base == 1
    
        mkdir(fullfile(handles.Results_folder_path,'Protein_signal_extraction_filtered_spec_data'))
        D = fullfile(handles.Results_folder_path,'Protein_signal_extraction_filtered_spec_data');
        for i = 1:length(handles.Samples_titles1D)   
            str1 = ['Please wait for exporting small molecules by Protein signal extraction from 0.2-0.5 ppm filtered NMR spectrum: <' handles.Samples_titles1D{i} '> ...'];
            handles.NOTIFICATIONS_BOX.String = str1;                                
            DIKA = waitbar2a(i/(size(handles.Samples_titles1D,1)-(0.01*size(handles.Samples_titles1D,1))),handles.Progress,['Exporting macromolecular filtered NMR data (SET 1)...'],'g');
            temp_mat = [handles.X_fit(i).data;transpose(handles.baseline_filtered1D(i).data)];
            for u = 1:length(handles.X_fit(i).data)
                feature_names(1,u) = {num2str(u)};
            end
            temp_out = array2table(temp_mat,'RowNames',{'PPM' handles.Samples_titles1D{i}},'VariableNames',feature_names);
            temp_out.Properties.DimensionNames{1} = 'Protein signal extraction Filtered Spectrum';
            mkdir(fullfile(D,handles.Samples_titles1D{i}))
            writetable(temp_out,fullfile(D,handles.Samples_titles1D{i},[handles.Samples_titles1D{i} '-spectral_data.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
            clearvars feature_names temp_mat            
        end
    
        mkdir(fullfile(handles.Results_folder_path,'NCD_filtered_spec_data'))
        D = fullfile(handles.Results_folder_path,'NCD_filtered_spec_data');
        for i = 1:length(handles.Samples_titles1D)
            str1 = ['Please wait for exporting small molecules by NCD method filtered NMR spectrum: <' handles.Samples_titles1D{i} '> ...'];
            handles.NOTIFICATIONS_BOX.String = str1;                                
            DIKA = waitbar2a(i/(size(handles.Samples_titles1D,1)-(0.01*size(handles.Samples_titles1D,1))),handles.Progress,['Exporting macromolecular filtered NMR data (SET 2)...'],'g');
            temp_mat = [handles.X1D(i,:);handles.NCDspectra(i,:)];
            for u = 1:length(handles.X1D(i,:))
                feature_names(1,u) = {num2str(u)};
            end
            temp_out = array2table(temp_mat,'RowNames',{'PPM' handles.Samples_titles1D{i}},'VariableNames',feature_names);
            temp_out.Properties.DimensionNames{1} = 'NCD Filtered Spectrum';
            mkdir(fullfile(D,handles.Samples_titles1D{i}))
            writetable(temp_out,fullfile(D,handles.Samples_titles1D{i},[handles.Samples_titles1D{i} '-spectral_data.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
            clearvars feature_names temp_mat
        end    
    
        mkdir(fullfile(handles.Results_folder_path,'SMolESY_filtered_spec_data'))
        D = fullfile(handles.Results_folder_path,'SMolESY_filtered_spec_data');
        for i = 1:length(handles.Samples_titles1D)
            str1 = ['Please wait for exporting small molecules by SMolESY method filtered NMR spectrum: <' handles.Samples_titles1D{i} '> ...'];
            handles.NOTIFICATIONS_BOX.String = str1;                                                        
            DIKA = waitbar2a(i/(size(handles.Samples_titles1D,1)-(0.01*size(handles.Samples_titles1D,1))),handles.Progress,['Exporting macromolecular filtered NMR data (SET 3)...'],'g');
            temp_mat = [handles.X1D(i,:);handles.SMolESY_filtered1D(i,:)];
            for u = 1:length(handles.X1D(i,:))
                feature_names(1,u) = {num2str(u)};
            end
            temp_out = array2table(temp_mat,'RowNames',{'PPM' handles.Samples_titles1D{i}},'VariableNames',feature_names);
            temp_out.Properties.DimensionNames{1} = 'SMolESY Filtered Spectrum';
            mkdir(fullfile(D,handles.Samples_titles1D{i}))
            writetable(temp_out,fullfile(D,handles.Samples_titles1D{i},[handles.Samples_titles1D{i} '-spectral_data.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
            clearvars feature_names temp_mat          
        end
        if i == size(handles.Samples_titles1D,1)
            DIKA = waitbar2a(i/size(handles.Samples_titles1D,1),handles.Progress,['Macro-filtered NMR data exporting is completed.'],'g');
        end
        str1 = ['ALL methods filtered NMR data exported successfully. Please check results at: [' handles.Results_folder_path '...filtered_spec_data folders]'];    
        handles.NOTIFICATIONS_BOX.String = str1; 

    else
    
        uiwait(msgbox('ERROR: Please check the selected method(s) and if the filtered data are produced.','modal'));
        figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
        close(figHandles);
        str1 = "Exported data process was not completed successfully.";    
        handles.NOTIFICATIONS_BOX.String = str1;
    
    end
catch
    uiwait(msgbox('ERROR: Please check the selected method(s) and if the filtered data are produced.','modal'));
    str1 = "Exported data process was not completed successfully.";    
    handles.NOTIFICATIONS_BOX.String = str1;
end

guidata(hObject, handles);


% --- Executes on button press in ExportSMolESY.
function ExportSMolESY_Callback(hObject, eventdata, handles)
% hObject    handle to ExportSMolESY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    if handles.MethodFLAG == 2 && handles.PASS_SMolESY == 1
        
        mkdir(fullfile(handles.Results_folder_path,'SMolESY_filter_spec_data'))
        D = fullfile(handles.Results_folder_path,'SMolESY_filter_spec_data');
        for i = 1:length(handles.Samples_titles1D)
            str1 = ['Please wait for exporting SMolESY-filter NMR spectrum: <' handles.Samples_titles1D{i} '> ...'];
            handles.NOTIFICATIONS_BOX.String = str1;                   
            DIKA = waitbar2a(i/size(handles.Samples_titles1D,1),handles.Progress,['Exporting SMolESY-filter data...'],'g');        
            temp_mat = [handles.X1D(i,:);handles.SMolESY_Processed_final(i,:)];
            for u = 1:length(handles.X1D(i,:))
                feature_names(1,u) = {num2str(u)};
            end
            temp_out = array2table(temp_mat,'RowNames',{'PPM' handles.Samples_titles1D{i}},'VariableNames',feature_names);
            temp_out.Properties.DimensionNames{1} = 'SMolESY Filter';
            mkdir(fullfile(D,handles.Samples_titles1D{i}))
            writetable(temp_out,fullfile(D,handles.Samples_titles1D{i},[handles.Samples_titles1D{i} '-SMolESY-filter_data.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
        end   
        if i == size(handles.Samples_titles1D,1)
            DIKA = waitbar2a(i/size(handles.Samples_titles1D,1),handles.Progress,['SMolESY-filter NMR spectra exporting is completed.'],'g');
        end

    elseif handles.MethodFLAG == 4 && handles.PASS_SMolESY == 1
        mkdir(fullfile(handles.Results_folder_path,'SMolESY_filter_spec_data'))
        D = fullfile(handles.Results_folder_path,'SMolESY_filter_spec_data');
        for i = 1:length(handles.Samples_titles1D)
            str1 = ['Please wait for exporting SMolESY-filter NMR spectrum: <' handles.Samples_titles1D{i} '> ...'];
            handles.NOTIFICATIONS_BOX.String = str1;                   
            DIKA = waitbar2a(i/size(handles.Samples_titles1D,1),handles.Progress,['Exporting SMolESY-filter data...'],'g');        
            temp_mat = [handles.X1D(i,:);handles.SMolESY_Processed_final(i,:)];
            for u = 1:length(handles.X1D(i,:))
                feature_names(1,u) = {num2str(u)};
            end
            temp_out = array2table(temp_mat,'RowNames',{'PPM' handles.Samples_titles1D{i}},'VariableNames',feature_names);
            temp_out.Properties.DimensionNames{1} = 'SMolESY Filter';
            mkdir(fullfile(D,handles.Samples_titles1D{i}))
            writetable(temp_out,fullfile(D,handles.Samples_titles1D{i},[handles.Samples_titles1D{i} '-SMolESY-filter_data.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
            figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
            close(figHandles);
        end    
        if i == size(handles.Samples_titles1D,1)
            DIKA = waitbar2a(i/size(handles.Samples_titles1D,1),handles.Progress,['SMolESY-filter NMR spectra exporting is completed.'],'g');
        end
    else
        uiwait(msgbox('ERROR: Please select SMolESY-filtering method or ALL methods (STEP 2) and if the SMolESY-filtered data are produced.','modal'));
        figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
        close(figHandles);
        str1 = "Exported data process was not completed successfully.";    
        handles.NOTIFICATIONS_BOX.String = str1; 
    end

    str1 = ['SMolESY-filter data exported successfully. Please check results at: [' D ']'];    
    handles.NOTIFICATIONS_BOX.String = str1; 

catch
    uiwait(msgbox('ERROR: Please select SMolESY-filtering method or ALL methods (STEP 2) and if the SMolESY-filtered data are produced.','modal'));
    figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
    close(figHandles);
    str1 = "Exported data process was not completed successfully.";    
    handles.NOTIFICATIONS_BOX.String = str1; 
end


guidata(hObject, handles);


function lb_factor_Callback(hObject, eventdata, handles)
% hObject    handle to lb_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lb_factor as text
%        str2double(get(hObject,'String')) returns contents of lb_factor as a double
lb_factor_str = get(handles.lb_factor, 'String');
try
    lb_factor_num = str2num(lb_factor_str);
catch 
    lb_factor_num = 8;
end
handles.lbfactor = lb_factor_num;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lb_factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DispTitleON.
function DispTitleON_Callback(hObject, eventdata, handles)
% hObject    handle to DispTitleON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%handles.TitlesStatus.String = 'Titles: ON';
%save('asas.mat','handles')
set(handles.DispTitleON,'ForegroundColor','green');
set(handles.DispTitleOFF,'ForegroundColor','black');
delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
delete(findall(handles.Standard1D_plot,'type','text'))
set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
set(handles.Standard1D_plot.Children,'LineWidth',0.5);
set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
TitleH2 = text('Parent',handles.SMolESY_processed_and_or_CPMG, 'Position',[0.01, 0.99], 'String','', 'Units', 'normalized', ...
'VerticalAlignment', 'top');
handles.TT2 = TitleH2; 
set (handles.SMolESY_processed_and_or_CPMG.Children, 'ButtonDownFcn', {@showTitle, handles.SMolESY_processed_and_or_CPMG.Children, handles.TT2,...
    handles.Standard1D_plot,handles.NCD_and_or_SMolESY_filtered,handles.plotFOLTERS_FLAG});


set (handles.NCD_and_or_SMolESY_filtered.Children, 'ButtonDownFcn', @showTitleOFF)
set (handles.Standard1D_plot.Children, 'ButtonDownFcn', @showTitleOFF)

set(handles.DispOnONE,'ForegroundColor','black');
set(handles.DispOFFOne,'ForegroundColor','green');
set(handles.DispONTHREE,'ForegroundColor','black');
set(handles.DispOFFTHree,'ForegroundColor','green');
guidata(hObject, handles);


% --- Executes on button press in DispTitleOFF.
function DispTitleOFF_Callback(hObject, eventdata, handles)
% hObject    handle to DispTitleOFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%handles.TitlesStatus.String = 'Titles: OFF';

set(handles.DispTitleON,'ForegroundColor','black');
set(handles.DispTitleOFF,'ForegroundColor','green');
set(handles.DispOnONE,'ForegroundColor','black');
set(handles.DispOFFOne,'ForegroundColor','green');
set(handles.DispONTHREE,'ForegroundColor','black');
set(handles.DispOFFTHree,'ForegroundColor','green');

delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
delete(findall(handles.Standard1D_plot,'type','text'))
set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
set(handles.Standard1D_plot.Children,'LineWidth',0.5);
set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
set (handles.SMolESY_processed_and_or_CPMG.Children, 'ButtonDownFcn', @showTitleOFF)

guidata(hObject, handles);


% --- Executes on button press in DispOFFOne.
function DispOFFOne_Callback(hObject, eventdata, handles)
% hObject    handle to DispOFFOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.DispTitleON,'ForegroundColor','black');
set(handles.DispTitleOFF,'ForegroundColor','green');
set(handles.DispOnONE,'ForegroundColor','black');
set(handles.DispOFFOne,'ForegroundColor','green');
set(handles.DispONTHREE,'ForegroundColor','black');
set(handles.DispOFFTHree,'ForegroundColor','green');

delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
delete(findall(handles.Standard1D_plot,'type','text'))
set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
set(handles.Standard1D_plot.Children,'LineWidth',0.5);
set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
set (handles.Standard1D_plot.Children, 'ButtonDownFcn', @showTitleOFF)

guidata(hObject, handles);


% --- Executes on button press in DispOnONE.
function DispOnONE_Callback(hObject, eventdata, handles)
% hObject    handle to DispOnONE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.DispOnONE,'ForegroundColor','green');
set(handles.DispOFFOne,'ForegroundColor','black');

delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
delete(findall(handles.Standard1D_plot,'type','text'))
set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
set(handles.Standard1D_plot.Children,'LineWidth',0.5);
set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
TitleH1 = text('Parent',handles.Standard1D_plot, 'Position',[0.01, 0.99], 'String','', 'Units', 'normalized', ...
'VerticalAlignment', 'top');
handles.TT1 = TitleH1;
set (handles.Standard1D_plot.Children, 'ButtonDownFcn', {@showTitle, handles.Standard1D_plot.Children, handles.TT1, handles.SMolESY_processed_and_or_CPMG, ...
        handles.NCD_and_or_SMolESY_filtered, handles.plotFOLTERS_FLAG});



set (handles.NCD_and_or_SMolESY_filtered.Children, 'ButtonDownFcn', @showTitleOFF)
set (handles.SMolESY_processed_and_or_CPMG.Children, 'ButtonDownFcn', @showTitleOFF)

set(handles.DispTitleON,'ForegroundColor','black');
set(handles.DispTitleOFF,'ForegroundColor','green');
set(handles.DispONTHREE,'ForegroundColor','black');
set(handles.DispOFFTHree,'ForegroundColor','green');

guidata(hObject, handles);


% --- Executes on button press in DispONTHREE.
function DispONTHREE_Callback(hObject, eventdata, handles)
% hObject    handle to DispONTHREE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.DispONTHREE,'ForegroundColor','green');
set(handles.DispOFFTHree,'ForegroundColor','black');

delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
delete(findall(handles.Standard1D_plot,'type','text'))
set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
set(handles.Standard1D_plot.Children,'LineWidth',0.5);
set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);

TitleH3 = text('Parent',handles.NCD_and_or_SMolESY_filtered, 'Position',[0.01, 0.99], 'String','', 'Units', 'normalized', ...
'VerticalAlignment', 'top');
handles.TT3 = TitleH3;
set (handles.NCD_and_or_SMolESY_filtered.Children, 'ButtonDownFcn', {@showTitle, handles.NCD_and_or_SMolESY_filtered.Children, handles.TT3, handles.SMolESY_processed_and_or_CPMG, ...
    handles.Standard1D_plot, handles.plotFOLTERS_FLAG});

set (handles.Standard1D_plot.Children, 'ButtonDownFcn', @showTitleOFF)
set (handles.SMolESY_processed_and_or_CPMG.Children, 'ButtonDownFcn', @showTitleOFF)

set(handles.DispTitleON,'ForegroundColor','black');
set(handles.DispTitleOFF,'ForegroundColor','green');
set(handles.DispOnONE,'ForegroundColor','black');
set(handles.DispOFFOne,'ForegroundColor','green');

guidata(hObject, handles);


% --- Executes on button press in DispOFFTHree.
function DispOFFTHree_Callback(hObject, eventdata, handles)
% hObject    handle to DispOFFTHree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
delete(findall(handles.Standard1D_plot,'type','text'))
set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
set(handles.Standard1D_plot.Children,'LineWidth',0.5);
set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);

set (handles.NCD_and_or_SMolESY_filtered.Children, 'ButtonDownFcn', @showTitleOFF)

set(handles.DispTitleON,'ForegroundColor','black');
set(handles.DispTitleOFF,'ForegroundColor','green');
set(handles.DispOnONE,'ForegroundColor','black');
set(handles.DispOFFOne,'ForegroundColor','green');
set(handles.DispONTHREE,'ForegroundColor','black');
set(handles.DispOFFTHree,'ForegroundColor','green');


guidata(hObject, handles);


% --- Executes on button press in ZOOM_First_ON.
function ZOOM_First_ON_Callback(hObject, eventdata, handles)
% hObject    handle to ZOOM_First_ON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.hZoom = [];
if isempty(handles.hZoom)
    handles.hZoom = zoom;
end

if ~strcmp(get(handles.hZoom,'Enable'), 'on')
    handles.axesLimitsStandard1D_plot = get(handles.Standard1D_plot,{'xlim','ylim'});
    guidata(hObject, handles);
    set(handles.hZoom, 'Enable', 'on');
    set(handles.ZOOM_First_ON,'ForegroundColor','green');   
    set(handles.ZOOM_first_OFF,'ForegroundColor','black');
    set(handles.ZOOM_Second_ON,'ForegroundColor','green');
    set(handles.ZOOM_Second_OFF,'ForegroundColor','black');
    set(handles.ZOOM_Third_ON,'ForegroundColor','green');
    set(handles.ZOOM_Third_OFF,'ForegroundColor','black');
end




guidata(hObject, handles);

% --- Executes on button press in ZOOM_first_OFF.
function ZOOM_first_OFF_Callback(hObject, eventdata, handles)
% hObject    handle to ZOOM_first_OFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.hZoom)
    set(handles.hZoom, 'Enable', 'off');
    set(handles.ZOOM_First_ON,'ForegroundColor','black');
    set(handles.ZOOM_first_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Second_ON,'ForegroundColor','black');
    set(handles.ZOOM_Second_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Third_ON,'ForegroundColor','black');
    set(handles.ZOOM_Third_OFF,'ForegroundColor','green');
    
end




% --- Executes on button press in ZOOM_Second_ON.
function ZOOM_Second_ON_Callback(hObject, eventdata, handles)
% hObject    handle to ZOOM_Second_ON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.hZoom = [];
if isempty(handles.hZoom)
    handles.hZoom = zoom;
end

if ~strcmp(get(handles.hZoom,'Enable'), 'on')
    handles.axesLimitsStandard1D_plot = get(handles.Standard1D_plot,{'xlim','ylim'});
    guidata(hObject, handles);
    set(handles.hZoom, 'Enable', 'on');
    set(handles.ZOOM_First_ON,'ForegroundColor','green');   
    set(handles.ZOOM_first_OFF,'ForegroundColor','black');
    set(handles.ZOOM_Second_ON,'ForegroundColor','green');
    set(handles.ZOOM_Second_OFF,'ForegroundColor','black');
    set(handles.ZOOM_Third_ON,'ForegroundColor','green');
    set(handles.ZOOM_Third_OFF,'ForegroundColor','black');
end




guidata(hObject, handles);

% --- Executes on button press in ZOOM_Second_OFF.
function ZOOM_Second_OFF_Callback(hObject, eventdata, handles)
% hObject    handle to ZOOM_Second_OFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.hZoom)
    set(handles.hZoom, 'Enable', 'off');
    set(handles.ZOOM_First_ON,'ForegroundColor','black');
    set(handles.ZOOM_first_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Second_ON,'ForegroundColor','black');
    set(handles.ZOOM_Second_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Third_ON,'ForegroundColor','black');
    set(handles.ZOOM_Third_OFF,'ForegroundColor','green');
    
end


% --- Executes on button press in ZOOM_Third_ON.
function ZOOM_Third_ON_Callback(hObject, eventdata, handles)
% hObject    handle to ZOOM_Third_ON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.hZoom = [];
if isempty(handles.hZoom)
    handles.hZoom = zoom;
end

if ~strcmp(get(handles.hZoom,'Enable'), 'on')
    handles.axesLimitsStandard1D_plot = get(handles.Standard1D_plot,{'xlim','ylim'});
    guidata(hObject, handles);
    set(handles.hZoom, 'Enable', 'on');
    set(handles.ZOOM_First_ON,'ForegroundColor','green');   
    set(handles.ZOOM_first_OFF,'ForegroundColor','black');
    set(handles.ZOOM_Second_ON,'ForegroundColor','green');
    set(handles.ZOOM_Second_OFF,'ForegroundColor','black');
    set(handles.ZOOM_Third_ON,'ForegroundColor','green');
    set(handles.ZOOM_Third_OFF,'ForegroundColor','black');
end

guidata(hObject, handles);

% --- Executes on button press in ZOOM_Third_OFF.
function ZOOM_Third_OFF_Callback(hObject, eventdata, handles)
% hObject    handle to ZOOM_Third_OFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.hZoom)
    set(handles.hZoom, 'Enable', 'off');
    set(handles.ZOOM_First_ON,'ForegroundColor','black');
    set(handles.ZOOM_first_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Second_ON,'ForegroundColor','black');
    set(handles.ZOOM_Second_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Third_ON,'ForegroundColor','black');
    set(handles.ZOOM_Third_OFF,'ForegroundColor','green');
    
end



% --- Executes on button press in RESETTWO.
function RESETTWO_Callback(hObject, eventdata, handles)
% hObject    handle to RESETTWO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.hZoom)
    set(handles.hZoom, 'Enable', 'off');
    set(handles.Standard1D_plot, {'xlim','ylim'}, handles.INITaxesLimitsStandard1D_plot);
    set(handles.ZOOM_First_ON,'ForegroundColor','black');
    set(handles.ZOOM_first_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Second_ON,'ForegroundColor','black');
    set(handles.ZOOM_Second_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Third_ON,'ForegroundColor','black');
    set(handles.ZOOM_Third_OFF,'ForegroundColor','green');
end



% --- Executes on button press in RESETTHREE.
function RESETTHREE_Callback(hObject, eventdata, handles)
% hObject    handle to RESETTHREE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.hZoom)
    set(handles.hZoom, 'Enable', 'off');
    set(handles.Standard1D_plot, {'xlim','ylim'}, handles.INITaxesLimitsStandard1D_plot);
    set(handles.ZOOM_First_ON,'ForegroundColor','black');
    set(handles.ZOOM_first_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Second_ON,'ForegroundColor','black');
    set(handles.ZOOM_Second_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Third_ON,'ForegroundColor','black');
    set(handles.ZOOM_Third_OFF,'ForegroundColor','green');
end


% --- Executes on button press in ResetONE.
function ResetONE_Callback(hObject, eventdata, handles)
% hObject    handle to ResetONE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.hZoom)
    set(handles.hZoom, 'Enable', 'off');
    set(handles.Standard1D_plot, {'xlim','ylim'}, handles.INITaxesLimitsStandard1D_plot);
    set(handles.ZOOM_First_ON,'ForegroundColor','black');
    set(handles.ZOOM_first_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Second_ON,'ForegroundColor','black');
    set(handles.ZOOM_Second_OFF,'ForegroundColor','green');
    set(handles.ZOOM_Third_ON,'ForegroundColor','black');
    set(handles.ZOOM_Third_OFF,'ForegroundColor','green');
end


% --- Executes on button press in CHECKPOINT.
function CHECKPOINT_Callback(hObject, eventdata, handles)
% hObject    handle to CHECKPOINT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    try
        [checkpoint_file, checkpoint_path] = uiputfile(fullfile(handles.Results_folder_path,'*.mat'));
    catch
        filter = {'*.mat'};
        [checkpoint_file, checkpoint_path] = uiputfile(filter);
    end
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for saving the checkpoint *.mat file...'],'windowstyle', 'alwaysontop');
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);    
    
    save(fullfile(checkpoint_path,checkpoint_file),'handles')
    close(wb)
    str1 = "Checkpoint file of the current session is successfully saved here: ";
    str2 = fullfile(checkpoint_path,checkpoint_file);
    str3 = "You could safely close NMRpQuant.";
    handles.NOTIFICATIONS_BOX.String = str1 + newline + str2 + newline + str3 ;
catch
    str1 = "ERROR: Checkpoint file was not saved. Something went wrong. Please check you hard disk space.";    
    handles.NOTIFICATIONS_BOX.String = str1;
end
handles.save_session_path = checkpoint_path;
guidata(hObject, handles);


% --- Executes on button press in LOAD_CHECKPOINT.
function LOAD_CHECKPOINT_Callback(hObject, eventdata, handles)
% hObject    handle to LOAD_CHECKPOINT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    try        
        [loadcheckpoint_file, loadcheckpoint_path] = uigetfile(fullfile(handles.save_session_path,'*.mat'));
    catch
        try
            [loadcheckpoint_file, loadcheckpoint_path] = uigetfile(fullfile(handles.Results_folder_path,'*.mat'));
        catch
            filter = {'*.mat'};
            [loadcheckpoint_file, loadcheckpoint_path] = uigetfile(filter);
        end
    end
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for loading the checkpoint *.mat file...'],'windowstyle', 'alwaysontop');
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);    
    
    load(fullfile(loadcheckpoint_path,loadcheckpoint_file))
    newStr = erase(loadcheckpoint_file,".mat");
    close_name_fig = handles.MAIN_PROT.Name;
    handles.MAIN_PROT.Name = ['NMRpQuant_' newStr];     
    drawnow;
    pause(6);
    close(wb) 
    str1 = "Checkpoint file is successfully loaded. You could proceed using NMRpQuant.";    
    handles.NOTIFICATIONS_BOX.String = str1;
    close(close_name_fig)
catch
    str1 = "Checkpoint file was not loaded.";    
    handles.NOTIFICATIONS_BOX.String = str1;
    close(wb)
end


% --- Executes on button press in Automated_Platform.
function Automated_Platform_Callback(hObject, eventdata, handles)
% hObject    handle to Automated_Platform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str1 =  sprintf('This option provides Total Urinary Protein quantification by one-click.\n\n >>> The selected filtering method is SMolESY-based filter <<< \n[no extra NMR spectra (e.g. CPMG or similar for NCD method) are needed].\n\n To complete quantification process, please select quantification method (enter 1 or 2). \n -—> Enter 1: For relative concentrations (a.u.)\n -—> Enter 2: For absolute concentrations (mg/mL)*\n*CAUTION: Option 2 requires ERETIC (Bruker Quantref at 12.0 ppm).\n\n');
prompt = {str1};
dlgtitle = 'Inputs for Automated Total Protein Quantification';
answer = inputdlg(prompt,dlgtitle);

wb = waitbar(0, ['\bf \fontsize{12} Please wait for Automated Total Protein Quantification and results exportation...'],'windowstyle', 'alwaysontop');
wbc = allchild(wb);
jp = wbc(1).JavaPeer;
wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
jp.setIndeterminate(1);   
handles.Int_REGION = [0.2 0.5; 0.2 0.7; 8.0 10.0];
if size(answer,1) == 0
    handles.MethodFLAG = 0;
    figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
    close(figHandles);
    uiwait(msgbox('You could proceed with the steps 2-5 in NMRpQuant GUI. Automated protein quantification is aborted.'));    
    return
else
    if str2num(answer{1,1}) == 2
        handles.UseBuiltInCurves.Value = 1;
        handles.AskNEWCurve.Value = 0;    
        handles.absfactors = [2.7 1.05 0.53];
        handles.absfactorsError = [0.028 0.062 0.033];
        handles.absIntregion = [11.9 12.1];    
        handles.absConRef = 10;
        handles.GoforABS = 1;
        handles.QREF_Int = [];
        for i = 1:length(handles.Samples_titles1D)
            handles.QREF_Int(i,1) = find_region_integrate(handles.X1D(i,:),handles.Y1D(i,:),handles.absIntregion);
        end  
        handles.MethodFLAG = 2;    
    elseif str2num(answer{1,1}) == 1
        handles.MethodFLAG = 2;
        handles.absfactors = 0;
        handles.absfactorsError = 0;
        handles.absIntregion = 0;    
        handles.absConRef = 0;
        handles.GoforABS = 0;
    else
        handles.MethodFLAG = 0;
        figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
        close(figHandles);
        uiwait(msgbox('You could proceed with the steps 2-5 in NMRpQuant GUI. Automated protein quantification is aborted.'));    
        return
    end
end

if handles.MethodFLAG == 2 && handles.PASS_SMolESY == 1
    try
        for i = 1:length(handles.Samples_titles1D)
            Integral_temp_SMolESYfiltered = NMRpQuant_NCD_SMolESY_method_integration(handles.X1D(i,:),handles.SMolESY_filtered1D(i,:), handles.Int_REGION);
            Integral_F_SMolESYfiltered(i,:) = transpose(Integral_temp_SMolESYfiltered);
        end  
        if handles.GoforABS == 0
            Region_names = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',Region_names);   
            handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;
            handles.Int_SMolESYfiltered_export_FLAG = 1;
        elseif handles.GoforABS == 1               
            Integral_F_SMolESYfiltered_F = (Integral_F_SMolESYfiltered*handles.absConRef.*handles.absfactors)./handles.QREF_Int; 
            Region_namesABS = {'Total Protein concentration (mg/mL): 0.2 - 0.5 ppm' 'Total Protein concentration (mg/mL): 0.2 - 0.7 ppm'...
                                'Total Protein concentration (mg/mL): 8.0 - 10.0 ppm' 'Total Protein concentration (mg/mL): All regions'};
            Region_namesAU = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
            ERROR_names = {'+/- Error (mg/mL): 0.2 - 0.5 ppm' '+/- Error (mg/mL): 0.2 - 0.7 ppm'...
                                '+/- Error (mg/mL): 8.0 - 10.0 ppm' '+/- Error (mg/mL): All regions'};
            [~,ii] = find(Integral_F_SMolESYfiltered_F == 0);                        
            if isempty(ii)
                [~,oo] = find(handles.absfactorsError == 0);
                clearvars a b ERROR
                ERROR = Integral_F_SMolESYfiltered_F.*handles.absfactorsError;
                ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                a = [Integral_F_SMolESYfiltered_F mean(Integral_F_SMolESYfiltered_F,2)];
                a = round(a,4);
                b = [ERROR mean(ERROR,2)];
                b = round(b,4);
                a = a';
                b = b';
                Integral_F_SMolESYfiltered_FF = reshape([a(:) b(:)]',2*size(a,1), [])';                            
                ca3 = [Region_namesABS,ERROR_names];
                idx = reshape(1:8,[],2)';
                ca3 = ca3(:,idx(1:end));
                Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
            else
                IND = unique(ii);
                Temp_Integral_F_SMolESYfiltered_F = Integral_F_SMolESYfiltered_F;
                Temp_Integral_F_SMolESYfiltered_F(:,IND) = [];
                TEMP_absfactorsError = handles.absfactorsError;
                
                TEMP_absfactorsError(:,IND) = [];
                [~,ooo] = find(TEMP_absfactorsError == 0);                            
                TEMP_absfactorsError(:,ooo) = NaN;
                Temp_ERROR = Temp_Integral_F_SMolESYfiltered_F.*TEMP_absfactorsError;                                                                                   
                
                [~,oo] = find(handles.absfactorsError == 0);
                clearvars a b ERROR ooo TEMP_absfactorsError
                
                ERROR = Integral_F_SMolESYfiltered_F.*handles.absfactorsError;
                ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                a = [Integral_F_SMolESYfiltered_F mean(Temp_Integral_F_SMolESYfiltered_F,2)];
                a = round(a,4);
                a(:,IND) = Integral_F_SMolESYfiltered(:,IND);
                b = [ERROR mean(Temp_ERROR,2)];
                b = round(b,4);                                                   
                a = a';
                b = b';
                Integral_F_SMolESYfiltered_FF = reshape([a(:) b(:)]',2*size(a,1), [])';     
                Region_namesABS(IND) = Region_namesAU(IND);
                ca3 = [Region_namesABS,ERROR_names];
                idx = reshape(1:8,[],2)';
                ca3 = ca3(:,idx(1:end));
                INDs = 2*IND;
                ca3(INDs) = [];
                Integral_F_SMolESYfiltered_FF(:,INDs) = [];
                Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
            end
             
            handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;
            handles.Int_SMolESYfiltered_export_FLAG = 1;
        end
        fig = uifigure('Name','SMolESY-filtering_based_protein_concentration','Position',[100 100 752 250]);
        fig.WindowStyle = 'alwaysontop';        
        RESULTS_TABLE = uitable('Parent',fig,'Position',[25 50 700 200]);
        D = handles.Int_SMolESYfiltered_export.Properties.VariableNames;
        Index = find(contains(D,':'));
        for i = 1:length(Index)
            K = D(Index(i));
            D(Index(i)) = {strrep(char(K{1}),':',':|')};
        end
        clearvars K Index
        Index = find(contains(D,'Protein'));
        for i = 1:length(Index)
            K = D(Index(i));
            D(Index(i)) = {strrep(char(K{1}),'Total Protein','Total Protein|')};
        end               
        set(RESULTS_TABLE,'ColumnName',[{'NMR Spectra / Total Protein| (a.u and/or mg/mL) per region -->'} D]);
        set(RESULTS_TABLE,'Data',[handles.Samples_titles1D table2cell(handles.Int_SMolESYfiltered_export)]);

        clearvars K D Index

        handles.Int_SMolESYfiltered_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';                
        writetable(handles.Int_SMolESYfiltered_export,fullfile(handles.Results_folder_path,['SMolESY-filtering_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
        %figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
        close(wb);
        str1 = ['Integration results are exported in the following file: ' fullfile(handles.Results_folder_path,'SMolESY-filtering_based_protein_concentration.csv')];    
        handles.NOTIFICATIONS_BOX.String = str1; 

    catch        
        handles.Int_SMolESYfiltered_export_FLAG = 0;
        figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
        close(figHandles);
        uiwait(msgbox('ERROR: Please check if the Standard 1D 1H NMR spectra are properly loaded (in STEP 1 of NMRpQUANT) and the SMolESY-filter(ed) data are successfully produced.','modal'));            
        str1 = "Integration process was not completed successfully.";    
        handles.NOTIFICATIONS_BOX.String = str1;
    end
    handles.MethodFLAG = 0;
    handles.absfactors = 0;
    handles.absfactorsError = 0;
    handles.absIntregion = 0;    
    handles.absConRef = 0;
    handles.GoforABS = 0;
    handles.UseBuiltInCurves.Value = 0;
    handles.AskNEWCurve.Value = 0; 
    handles.Int_NCD_export_FLAG = 0; 
    handles.Int_baseline_export_FLAG = 0;
    handles.Int_SMolESYfiltered_export_FLAG = 0;
    handles.Int_REGION = 0;
else
    handles.Int_REGION = 0;
    handles.MethodFLAG = 0;
    handles.Int_NCD_export_FLAG = 0; 
    handles.Int_baseline_export_FLAG = 0;
    handles.Int_SMolESYfiltered_export_FLAG = 0;
    figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
    close(figHandles);
    uiwait(msgbox('ERROR: Please check if the Standard 1D 1H NMR spectra are properly loaded (in STEP 1 of NMRpQUANT) and the SMolESY-filter(ed) data are successfully produced.','modal'));           
    str1 = "Integration process was not completed successfully.";    
    handles.NOTIFICATIONS_BOX.String = str1;
end
handles.MethodFLAG = 0;
handles.absfactors = 0;
handles.absfactorsError = 0;
handles.absIntregion = 0;    
handles.absConRef = 0;
handles.GoforABS = 0;
handles.UseBuiltInCurves.Value = 0;
handles.AskNEWCurve.Value = 0;  
handles.Int_NCD_export_FLAG = 0; 
handles.Int_baseline_export_FLAG = 0;
handles.Int_SMolESYfiltered_export_FLAG = 0;
handles.Int_REGION = 0;

figHandles = findobj('type', 'figure', '-not', 'name', handles.MAIN_PROT.Name);
close(figHandles);

guidata(hObject, handles);
