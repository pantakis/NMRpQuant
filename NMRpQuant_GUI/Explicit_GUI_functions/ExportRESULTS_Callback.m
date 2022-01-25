% --- Executes on button press in ExportRESULTS.
function ExportRESULTS_Callback(hObject, eventdata, handles)
% hObject    handle to ExportRESULTS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


try
    
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for exporting results...']);
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);    
    
    switch handles.MethodFLAG
        case 0
            uiwait(msgbox('ERROR: There is no data to be exported, select an appropriate method in STEP 2 and proceed accordingly.','modal'));
        case 1
            if handles.Int_NCD_export_FLAG == 1                
                handles.Int_NCD_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';                                
                writetable(handles.Int_NCD_export,fullfile(handles.Results_folder_path,['NCD_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
                close(figHandles);
                str1 = ['Integration results are exported in the following folder: ' handles.Results_folder_path];    
                handles.NOTIFICATIONS_BOX.String = str1;            
            else
                figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
                close(figHandles);
                uiwait(msgbox('ERROR: There is no data to be exported. Please select NCD or ALL methods in STEP 2 and load the mandatory spectra.','modal'));
                str1 = "ERROR: There is no data to be exported. Please select NCD or ALL methods in STEP 2 and load the mandatory spectra.";    
                handles.NOTIFICATIONS_BOX.String = str1;
            end
        case 2
            if handles.Int_SMolESYfiltered_export_FLAG == 1                
                handles.Int_SMolESYfiltered_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';                
                writetable(handles.Int_SMolESYfiltered_export,fullfile(handles.Results_folder_path,['SMolESY-filtering_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
                close(figHandles);
                str1 = ['Integration results are exported in the following folder: ' handles.Results_folder_path];    
                handles.NOTIFICATIONS_BOX.String = str1;            
            else
                figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
                close(figHandles);
                uiwait(msgbox('ERROR: There is no data to be exported. Please select SMolESY-filtering or ALL methods in STEP 2.','modal'));
                str1 = "ERROR: There is no data to be exported. Please select SMolESY-filtering or ALL methods in STEP 2 or check if SMolESY data are successfully produced in STEP 1.";    
                handles.NOTIFICATIONS_BOX.String = str1;
            end
        case 3
            if handles.Int_baseline_export_FLAG == 1
                handles.Int_baseline_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';                
                writetable(handles.Int_baseline_export,fullfile(handles.Results_folder_path,['Protein_signal_extraction_(0.2-0.5ppm)_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
                close(figHandles);
                str1 = ['Integration results are exported in the following folder: ' handles.Results_folder_path];    
                handles.NOTIFICATIONS_BOX.String = str1;
            else
                figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
                close(figHandles);
                uiwait(msgbox('ERROR: There is no data to be exported. Please select Protein signal extraction from 0.2-0.5 ppm or ALL methods in STEP 2.','modal'));
                str1 = "ERROR: There is no data to be exported. Please select Protein signal extraction from 0.2-0.5 ppm or ALL methods in STEP 2 or check if Protein signal extraction from 0.2-0.5 ppm was successfully produced in STEP 1.";    
                handles.NOTIFICATIONS_BOX.String = str1;
            end 
        case 4
            if handles.Int_NCD_export_FLAG == 1 && handles.Int_baseline_export_FLAG == 1 && handles.Int_SMolESYfiltered_export_FLAG == 1
                
                handles.Int_NCD_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';
                handles.Int_SMolESYfiltered_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';                
                handles.Int_baseline_export.Properties.DimensionNames{1} = 'NMR Spectra / Total Protein (a.u and/or mg/mL) per region -->';                
                
                writetable(handles.Int_NCD_export,fullfile(handles.Results_folder_path,['NCD_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                writetable(handles.Int_baseline_export,fullfile(handles.Results_folder_path,['Protein_signal_extraction_(0.2-0.5ppm)_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                writetable(handles.Int_SMolESYfiltered_export,fullfile(handles.Results_folder_path,['SMolESY-filtering_based_protein_concentration.csv']),'WriteVariableNames',true,'WriteRowNames',true); 
                figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
                close(figHandles);
                str1 = ['Integration results are exported in the following folder: ' handles.Results_folder_path];    
                handles.NOTIFICATIONS_BOX.String = str1;
            else
                figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
                close(figHandles);
                uiwait(msgbox('ERROR: There is no data to be exported. Please select ALL methods in STEP 2.','modal'));
                str1 = "ERROR: There is no data to be exported. Please select ALL methods in STEP 2 or check all filtering methods data are successfully produced. ";    
                handles.NOTIFICATIONS_BOX.String = str1;
            end             
    end
catch
    
    uiwait(msgbox('ERROR: There is no data to be exported. Please calculate integrals and/or absolute concentrations.','modal'));
    figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
    close(figHandles);
    str1 = "ERROR: There is no data to be exported. Please calculate integrals and/or absolute concentrations.";    
    handles.NOTIFICATIONS_BOX.String = str1;
    
end