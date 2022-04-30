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