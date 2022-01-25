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
