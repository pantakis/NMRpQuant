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