% --- Executes on button press in loadCPMG.
function loadCPMG_Callback(hObject, eventdata, handles)
% hObject    handle to loadCPMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Check_CPMG_plot = 0;
handles.Int_NCD_export_FLAG = 0; 
handles.PASS_CPMG = 0;

if handles.MethodFLAG == 1 || handles.MethodFLAG == 4  
    [filepath,~,~] = fileparts(handles.Parent1D_folder);
    try
        if isempty(handles.ParentCPMG_folder)
            parentDir1D_NCD = uigetdir(filepath);
        else
            parentDir1D_NCD = uigetdir(handles.ParentCPMG_folder);
        end
    catch
        parentDir1D_NCD = uigetdir;        
    end
    handles.ParentCPMG_folder = parentDir1D_NCD;     
    [list_of_spectra_1D_CPMG,~] = prepare_spectra_files1D(parentDir1D_NCD);
    mkdir(fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.7 ppm'))
    mkdir(fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.5 ppm'))
    mkdir(fullfile(handles.Results_folder_path,'NCD_filter_figures','region 8.0-10.0 ppm'))
    if num2str(length(list_of_spectra_1D_CPMG)) > 1
        uiwait(msgbox(['The software found ' num2str(length(list_of_spectra_1D_CPMG)) ' spectra.'],'modal'));
    elseif num2str(length(list_of_spectra_1D_CPMG)) == 1
        uiwait(msgbox(['The software found ' num2str(length(list_of_spectra_1D_CPMG)) ' spectrum.'],'modal'));
    end
    
    try
       % read NMR data
        % check if the titles of CPMG and Standard1D are exactly the same!
        if length(list_of_spectra_1D_CPMG) == length(handles.Samples_titles1D)
            TEST_names = strcmpi(list_of_spectra_1D_CPMG,handles.Samples_titles1D);          
            if isempty(find(TEST_names == 0))
                handles.PASS_CPMG = 1;                
                for i = 1:length(list_of_spectra_1D_CPMG)
                    str1 = ['Loading/processing (i.e NCD filter production) of spectrum: <' list_of_spectra_1D_CPMG{i} '> started...'];
                    handles.NOTIFICATIONS_BOX.String = str1;
                    DIKA = waitbar2a(i/(size(list_of_spectra_1D_CPMG,1)-(0.01*size(list_of_spectra_1D_CPMG,1))),handles.Progress,['NMR spectra loading/processing (i.e NCD filter production)...'],'g');        
                    G1 = fullfile(parentDir1D_NCD,list_of_spectra_1D_CPMG{i},'pdata','1');
                    try
                        W(i,1) = getNMRdata(G1);
                        Y1D(i,:) = W(i,1).Data';                

                        % calibrate CPMG to the same reference as Standard1D (i.e.
                        % TSP etc.), in case of any minor shifting

                        CPMG_Y_cal(i,:) = Align_data(handles.X1D(i,:),Y1D(i,:),0,0.02);                

                        % end of calibration process
                        handles.NCDspectra(i,:) = handles.Y1D(i,:) - CPMG_Y_cal(i,:);
                        
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([0.2 0.5]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.5 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([0.2 0.7]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.7 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);    
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([8 10]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 8.0-10.0 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);

                    catch
                        G11 = fullfile(parentDir1D_NCD,list_of_spectra_1D_CPMG{i});
                        [Subfolders,~] = prepare_spectra_files1D(G11);
                        G2 = fullfile(G11,Subfolders{1},'pdata','1');
                        W(i,1) = getNMRdata(G2);
                        Y1D(i,:) = W(i,1).Data';                

                        % calibrate CPMG to the same reference as Standard1D (i.e.
                        % TSP etc.), in case of any minor shifting

                        CPMG_Y_cal(i,:) = Align_data(handles.X1D(i,:),Y1D(i,:),0,0.02);     
                        handles.NCDspectra(i,:) = handles.Y1D(i,:) - CPMG_Y_cal(i,:);
                        
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([0.2 0.5]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.5 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([0.2 0.7]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 0.2-0.7 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);    
                        f1 = figure('visible','off');
                        plot(handles.X1D(i,:),handles.Y1D(i,:));hold on;plot(handles.X1D(i,:),CPMG_Y_cal(i,:));hold on;plot(handles.X1D(i,:),handles.NCDspectra(i,:));set(gca,'xdir','reverse');xlim([8 10]);legend('Standard 1D ^1H NMR','NCD filter','Filtered Standard 1D ^1H NMR (i.e NCD)');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. NCD filter');xlabel('PPM');                               
                        saveas(gcf, fullfile(handles.Results_folder_path,'NCD_filter_figures','region 8.0-10.0 ppm',['Spectrum-' handles.Samples_titles1D{i} '-NCD-filtering']), 'tif');hold on;
                        close(f1);
                        
                    end   
                end
                handles.CPMG_Y1D = CPMG_Y_cal;
                handles.Samples_titles1D_CPMG = list_of_spectra_1D_CPMG; 
                if i == size(list_of_spectra_1D_CPMG,1)
                     DIKA = waitbar2a(i/size(list_of_spectra_1D_CPMG,1),handles.Progress,['NMR spectra Loading/Processing/Exporting is completed.'],'g');
                end
                str1 = "Macromolecular-filtered NMR spectra and the NCD data are successfully loaded/calculated.";
                handles.NOTIFICATIONS_BOX.String = str1 + newline + "Please proceed with plotting the spectra by selecting this option below." + newline + "You could check NCD results in 'OUTPUT FOLDER/NCD_filter_figures' folder.";   
            else
               waitbar2a(0,handles.Progress,' ','g');
               str11 = "ERROR: Macromolecules-filtered spectra do not match the TITLES of the Standard 1D 1H NMR spectra. Please check your spectral folders.";
               handles.NOTIFICATIONS_BOX.String = str11; 
               handles.PASS_CPMG = 0;

            end
        else
               str11 = "ERROR: Macromolecules-filtered spectra do not match the number of the Standard 1D 1H NMR spectra. Please check your spectral folders.";
               handles.NOTIFICATIONS_BOX.String = str11; 
               handles.PASS_CPMG = 0;
               
        end
 
    catch
       handles.ParentCPMG_folder = [];
       try
        DIKA = waitbar2a(i/size(list_of_spectra_1D_CPMG,1),handles.Progress,['Something went wrong with Spectrum ' list_of_spectra_1D_CPMG{i} '...'],'g');    
       catch
       end
        str1 = "ERROR: NMR data cannot be found or read correctly. Please check the structure of the NMR spectra containing folder, which should be as indicated in the User's Guide file.";
        handles.NOTIFICATIONS_BOX.String = str1;
        handles.PASS_CPMG = 0;
    end
else
    uiwait(msgbox('The selected method does not require macromolecules filtered NMR spectra.','modal'));    
end
guidata(hObject, handles);   