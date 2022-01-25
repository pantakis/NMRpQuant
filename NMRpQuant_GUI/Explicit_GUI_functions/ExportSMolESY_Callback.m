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
            figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
            close(figHandles);
        end    
        if i == size(handles.Samples_titles1D,1)
            DIKA = waitbar2a(i/size(handles.Samples_titles1D,1),handles.Progress,['SMolESY-filter NMR spectra exporting is completed.'],'g');
        end
    else
        uiwait(msgbox('ERROR: Please select SMolESY-filtering method or ALL methods (STEP 2) and if the SMolESY-filtered data are produced.','modal'));
        figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
        close(figHandles);
        str1 = "Exported data process was not completed successfully.";    
        handles.NOTIFICATIONS_BOX.String = str1; 
    end

    str1 = ['SMolESY-filter data exported successfully. Please check results at: [' D ']'];    
    handles.NOTIFICATIONS_BOX.String = str1; 

catch
    uiwait(msgbox('ERROR: Please select SMolESY-filtering method or ALL methods (STEP 2) and if the SMolESY-filtered data are produced.','modal'));
    figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
    close(figHandles);
    str1 = "Exported data process was not completed successfully.";    
    handles.NOTIFICATIONS_BOX.String = str1; 
end


guidata(hObject, handles);