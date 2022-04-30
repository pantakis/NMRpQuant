% --- Executes on button press in CHECKPOINT.
function CHECKPOINT_Callback(hObject, eventdata, handles)
% hObject    handle to CHECKPOINT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    try
        [checkpoint_file, checkpoint_path] = uiputfile(fullfile(handles.Results_folder_path,'*.mat'));
    catch
        filter = {'*.mat'};
        [checkpoint_file, checkpoint_path] = uiputfile(filter);
    end
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for saving the checkpoint *.mat file...'],'windowstyle', 'alwaysontop');
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);    
    
    save(fullfile(checkpoint_path,checkpoint_file),'handles')
    close(wb)
    str1 = "Checkpoint file of the current session is successfully saved here: ";
    str2 = fullfile(checkpoint_path,checkpoint_file);
    str3 = "You could safely close NMRpQuant.";
    handles.NOTIFICATIONS_BOX.String = str1 + newline + str2 + newline + str3 ;
catch
    str1 = "ERROR: Checkpoint file was not saved. Something went wrong. Please check you hard disk space.";    
    handles.NOTIFICATIONS_BOX.String = str1;
end
handles.save_session_path = checkpoint_path;
guidata(hObject, handles);