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
        
        wb = waitbar(0, ['\bf \fontsize{12} Please wait for loading the excel file...']);
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
            figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
            close(figHandles);
            str1 = "ERROR: You have not provided any calibration factor for absolute quantification. Please check the template file provided with the software.";
            handles.NOTIFICATIONS_BOX.String = str1;
            handles.GoforABS = 0;
            handles.AskNEWCurve.Value = 0;
        elseif sum(abs(handles.absIntregion)) == 0
            figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
            close(figHandles);
            str1 = "ERROR: You have not provided correctly the region for reference signal integration. Please check the template file provided with the software.";
            handles.NOTIFICATIONS_BOX.String = str1;
            handles.GoforABS = 0;
            handles.AskNEWCurve.Value = 0;
        elseif sum(handles.absConRef) == 0
            figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
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
            figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
            close(figHandles);
            str1 = "Excel file is successfully loaded.";
            handles.NOTIFICATIONS_BOX.String = str1;            
        end
        
    catch
        figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
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