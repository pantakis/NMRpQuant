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