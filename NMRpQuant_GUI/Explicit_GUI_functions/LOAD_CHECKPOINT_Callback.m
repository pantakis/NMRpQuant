% --- Executes on button press in LOAD_CHECKPOINT.
function LOAD_CHECKPOINT_Callback(hObject, eventdata, handles)
% hObject    handle to LOAD_CHECKPOINT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    try        
        [loadcheckpoint_file, loadcheckpoint_path] = uigetfile(fullfile(handles.save_session_path,'*.mat'));
    catch
        try
            [loadcheckpoint_file, loadcheckpoint_path] = uigetfile(fullfile(handles.Results_folder_path,'*.mat'));
        catch
            filter = {'*.mat'};
            [loadcheckpoint_file, loadcheckpoint_path] = uigetfile(filter);
        end
    end
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for loading the checkpoint *.mat file...'],'windowstyle', 'alwaysontop');
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);    
    
    load(fullfile(loadcheckpoint_path,loadcheckpoint_file))
    newStr = erase(loadcheckpoint_file,".mat");
    close_name_fig = handles.MAIN_PROT.Name;
    handles.MAIN_PROT.Name = ['NMRpQuant_' newStr];     
    drawnow;
    pause(6);
    close(wb) 
    str1 = "Checkpoint file is successfully loaded. You could proceed using NMRpQuant.";    
    handles.NOTIFICATIONS_BOX.String = str1;
    close(close_name_fig)
catch
    str1 = "Checkpoint file was not loaded.";    
    handles.NOTIFICATIONS_BOX.String = str1;
    close(wb)
end