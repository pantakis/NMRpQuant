% --- Executes on button press in Plot1D.
function Plot1D_Callback(hObject, eventdata, handles)
% hObject    handle to Plot1D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


delete(findall(handles.Standard1D_plot,'type','text'))
delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
set(handles.SpectraNAMESTABLE,'Data',handles.Samples_titles1D); % Use the set command to change the uitable properties.    
set (handles.SpectraNAMESTABLE, 'CellSelectionCallback', @cb_select)
if handles.PASS_Standard1D == 1
        axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
        set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
        set(handles.Standard1D_plot.Children,'LineWidth',0.5);        
else
    uiwait(msgbox('There are no Standard 1D 1H NMR spectra.','modal'));    
    handles.NOTIFICATIONS_BOX.String = "ERROR: The Standard 1D 1H NMR spectra cannot be plotted. Please try loading them.";   
end
%handles.MAX_Y_ALL = max(handles.Y1D(:));
guidata(hObject, handles);