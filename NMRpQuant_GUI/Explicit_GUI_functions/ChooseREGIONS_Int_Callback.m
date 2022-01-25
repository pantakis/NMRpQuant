% --- Executes on selection change in ChooseREGIONS_Int.
function ChooseREGIONS_Int_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseREGIONS_Int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChooseREGIONS_Int contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChooseREGIONS_Int


contents = cellstr(get(hObject,'String'));

if handles.MethodFLAG == 0 || handles.MethodFLAG == 3
    
    handles.Int_REGION_flag = 0;
    handles.Int_REGION = 0;
    
    uiwait(msgbox('NCD and/or SMolESY filtered NMR spectra are needed. Please be sure that you have selected either one of these or ALL methods in STEP 2.','modal')); 
    str1 = "ERROR: NCD and/or SMolESY filtered NMR spectra are needed. Please be sure that you have selected either one of these or ALL methods in STEP 2.";    
    handles.NOTIFICATIONS_BOX.String = str1;
    
else
    if isequal(contents{get(hObject,'Value')},'Select * spectrum region(s) for integration')

        handles.Int_REGION_flag = 0;
        handles.Int_REGION = 0;

    elseif isequal(contents{get(hObject,'Value')},'0.2 - 0.5 ppm')

        handles.Int_REGION_flag = 1;
        handles.Int_REGION = [0.2 0.5];
        
    elseif isequal(contents{get(hObject,'Value')},'0.2 - 0.7 ppm')

        handles.Int_REGION_flag = 2;
        handles.Int_REGION = [0.2 0.7];
        
% 
%     elseif isequal(contents{get(hObject,'Value')},'0.8 - 2.0 ppm')    
% 
%         handles.Int_REGION_flag = 3;
%         handles.Int_REGION = [0.8 2.0];
% 
%     elseif isequal(contents{get(hObject,'Value')},'6.3 - 7.0 ppm')    
% 
%         handles.Int_REGION_flag = 4;
%         handles.Int_REGION = [6.3 7.0];

    elseif isequal(contents{get(hObject,'Value')},'8.0 - 10.0 ppm')    

%         handles.Int_REGION_flag = 5;
        handles.Int_REGION_flag = 3;
        handles.Int_REGION = [8.0 10.0];
        

    elseif isequal(contents{get(hObject,'Value')},'All the above')

%         handles.Int_REGION_flag = 6;
        handles.Int_REGION_flag = 4;
        %handles.Int_REGION = [0.2 0.5; 0.2 0.7; 0.8 2.0; 6.3 7.0; 8.0 10.0];
        handles.Int_REGION = [0.2 0.5; 0.2 0.7; 8.0 10.0];
        
    else
        uiwait(msgbox('NCD and/or SMolESY filtered NMR spectra are needed. Please be sure that you have selected either one of these or ALL methods in STEP 2.','modal'));
        str1 = "ERROR: NCD and/or SMolESY filtered NMR spectra are needed. Please be sure that you have selected either one of these or ALL methods in STEP 2.";    
        handles.NOTIFICATIONS_BOX.String = str1;
        handles.Int_REGION_flag = 0;
        handles.Int_REGION = 0;
    end
    
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ChooseREGIONS_Int_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChooseREGIONS_Int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% set(hObject, 'String',[{'Select * spectrum region(s) for integration'};{'0.2 - 0.5 ppm'};{'0.2 - 0.7 ppm'};{'0.8 - 2.0 ppm'};{'6.3 - 7.0 ppm'};{'8.0 - 10.0 ppm'};{'All the above'}]);
set(hObject, 'String',[{'Select * spectrum region(s) for integration'};{'0.2 - 0.5 ppm'};{'0.2 - 0.7 ppm'};{'8.0 - 10.0 ppm'};{'All the above'}]);

guidata(hObject, handles);