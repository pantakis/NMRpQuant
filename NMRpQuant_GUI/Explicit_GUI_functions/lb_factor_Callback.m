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