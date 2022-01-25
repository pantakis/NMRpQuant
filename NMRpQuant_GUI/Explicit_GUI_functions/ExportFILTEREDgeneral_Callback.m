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
        figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
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