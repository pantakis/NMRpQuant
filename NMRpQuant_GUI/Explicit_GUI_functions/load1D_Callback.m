% --- Executes on button press in load1D.
function load1D_Callback(hObject, eventdata, handles)
% hObject    handle to load1D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plotFOLTERS_FLAG = 0;
handles.NCDspectra = [];
handles.Check_Baseline_plot = 0;
handles.Check_CPMG_plot = 0;
handles.Check_SMolESY_processed_plot = 0;
handles.MethodFLAG = 0;
handles.Int_REGION_flag = 0;
handles.PASS_SMolESY = 0;
handles.PASS_Fitted_base = 0;
handles.PASS_Standard1D = 0;
handles.Int_NCD_export_FLAG = 0; 
handles.Int_baseline_export_FLAG = 0;
handles.Int_SMolESYfiltered_export_FLAG = 0;
handles.PASS_CPMG = 0;
handles.Int_REGION = 0;
handles.BaselineFiltersplot.Value = 0;
handles.ChooseSMolESYdata.Value = 0;
handles.ChooseCPMGdata.Value = 0;
handles.AskNEWCurve.Value = 0;
handles.UseBuiltInCurves.Value = 0;
handles.GoforABS = 0;
axes(handles.Standard1D_plot);cla
axes(handles.SMolESY_processed_and_or_CPMG);cla
axes(handles.NCD_and_or_SMolESY_filtered);cla
set(handles.Method,'Value',1);
set(handles.ChooseREGIONS_Int,'Value',1);
set(handles.ChooseSMolESYdata,'Value',0);
set(handles.ChooseCPMGdata,'Value',0);
set(handles.BaselineFiltersplot,'Value',0);
handles.QREF_Int = [];

try
    try
        if isempty(handles.Parent1D_folder)
            parentDir1D = uigetdir;
        else
            parentDir1D = uigetdir(handles.Parent1D_folder);
        end     
    catch
        parentDir1D = uigetdir;
    end
    handles.Parent1D_folder = parentDir1D;
    [list_of_spectra_1D,display_names] = prepare_spectra_files1D(parentDir1D);    
    if num2str(length(list_of_spectra_1D)) > 1
        uiwait(msgbox(['The software found ' num2str(length(list_of_spectra_1D)) ' spectra.'],'modal'));
    elseif num2str(length(list_of_spectra_1D)) == 1
        uiwait(msgbox(['The software found ' num2str(length(list_of_spectra_1D)) ' spectrum.'],'modal'));
    end
    mkdir(fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.7 ppm'))
    mkdir(fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.5 ppm'))
    mkdir(fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 8.0-10.0 ppm'))
    mkdir(fullfile(handles.Results_folder_path,'Protein signal extraction from 0.2-0.5 ppm_filter_figures'))
    
    TF = isnumeric(handles.lbfactor);
    if isempty(handles.lbfactor) || TF == 0
        handles.lbfactor = 8; % lb_factor = 8.0 [i.e. 8.0 * (the real processing lb) the default]   
    end
   
    % read real and imaginary NMR data
    for i = 1:length(list_of_spectra_1D)
        str1 = ['Loading/processing (i.e SMolESY/Protein signal extraction filters production) of spectrum: <' list_of_spectra_1D{i} '> started...'];
        handles.NOTIFICATIONS_BOX.String = str1;
        DIKA = waitbar2a(i/(size(list_of_spectra_1D,1)-(0.01*size(list_of_spectra_1D,1))),handles.Progress,['NMR spectra loading (SMolESY/Protein signals filters production)...'],'g');
        G1 = fullfile(parentDir1D,list_of_spectra_1D{i},'pdata','1');
        try
            W(i,1) = getNMRdata(G1);
            Y1D(i,:) = W(i,1).Data';
            X1D(i,:) = W(i,1).XAxis';
            Yim1D(i,:) = W(i,1).IData';
            W_Processed(i,1) = Process_lb_NMRdata(G1,handles.lbfactor); % lb_factor = 8.0 [i.e. 8.0 * (the real processing lb) the default]           
            Y1D_Processed(i,:) = W_Processed(i,1).Data';
            X1D_Processed(i,:) = W_Processed(i,1).XAxis';
            Yim1D_Processed(i,:) = W_Processed(i,1).IData';
            
            % preparing SMolESY and SMolESY processed data (regardless of
            % the chosen Qauntififcation method afterwards)
            try
                [SMolESY_original(i,:),SMolESY_Processed_final(i,:),SMolESY_filtered1D(i,:)] = NMRpQuant_SMolESY(X1D(i,:),Y1D(i,:),Yim1D(i,:),X1D_Processed(i,:),Yim1D_Processed(i,:),0,0.025);                
                f1 = figure('visible','off');
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([0.2 0.5]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                               
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.5]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([0.2 0.5]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.5]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.5 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);
                f1 = figure('visible','off'); 
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([0.2 0.7]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.7]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([0.2 0.7]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.7]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.7 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);
                f1 = figure('visible','off');    
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([8 10]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([8 10]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([8 10]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([8 10]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 8.0-10.0 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);                
                PASS_SMolESY_test(i,1) = 1;
            catch
                PASS_SMolESY_test(i,1) = 0;                
            end
            % end of SMolESY processing production process
            
            % Fitting spectrum baseline at 0.2-0.5 for the removal of any
            % sharp signals of metabolites
            try
                [Tot_protein_Relative(i,1), X_fit(i).data, Y_fit(i).data, fitted_baseline(i).data, baseline_filtered1D(i).data] = NMRpQuant_Baseline_filter(X1D(i,:),Y1D(i,:));
                
                f1 = figure('visible','off');                                    
                plot(X_fit(i).data,Y_fit(i).data);hold on;plot(X_fit(i).data,fitted_baseline(i).data);hold on;plot(X_fit(i).data,baseline_filtered1D(i).data);set(gca,'xdir','reverse');legend('Standard 1D ^1H NMR','Residuals','Protein signal extraction');title('Standard 1D ^1H NMR vs. Protein signal extraction vs. residuals');xlabel('PPM');                               
                saveas(gcf, fullfile(handles.Results_folder_path,'Protein signal extraction from 0.2-0.5 ppm_filter_figures',['Spectrum-' list_of_spectra_1D{i} '-Protein-signal-extraction']), 'tif');hold on;
                close(f1);                                 
                
                PASS_Fitted_base_test(i,1) = 1;                
            catch
                PASS_Fitted_base_test(i,1) = 0;
            end
            
            %end of fitting process
            
        catch
            G11 = fullfile(parentDir1D,list_of_spectra_1D{i});
            [Subfolders,~] = prepare_spectra_files1D(G11);
            G2 = fullfile(G11,Subfolders{1},'pdata','1');
            W(i,1) = getNMRdata(G2);
            Y1D(i,:) = W(i,1).Data';
            X1D(i,:) = W(i,1).XAxis';
            Yim1D(i,:) = W(i,1).IData';  
            W_Processed(i,1) = Process_lb_NMRdata(G2,handles.lbfactor); % lb_factor = 8 [i.e. 8 * (the real processing lb) the default]
            Y1D_Processed(i,:) = W_Processed(i,1).Data';
            X1D_Processed(i,:) = W_Processed(i,1).XAxis';
            Yim1D_Processed(i,:) = W_Processed(i,1).IData';
            
            % preparing SMolESY and SMolESY processed data (regardless of
            % the chosen Qauntififcation method afterwards)
            try
                [SMolESY_original(i,:),SMolESY_Processed_final(i,:),SMolESY_filtered1D(i,:)] = NMRpQuant_SMolESY(X1D(i,:),Y1D(i,:),Yim1D(i,:),X1D_Processed(i,:),Yim1D_Processed(i,:),0,0.025);                
                f1 = figure('visible','off');
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([0.2 0.5]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                               
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.5]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([0.2 0.5]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.5]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.5 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);
                f1 = figure('visible','off'); 
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([0.2 0.7]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.7]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([0.2 0.7]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([0.2 0.7]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 0.2-0.7 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);
                f1 = figure('visible','off');    
                plot(X1D(i,:),Y1D(i,:));hold on;plot(X1D(i,:),SMolESY_Processed_final(i,:));hold on;plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');xlim([8 10]);legend('Standard 1D ^1H NMR','SMolESY filter','Filtered Standard 1D ^1H NMR');title('Standard 1D ^1H NMR vs. Filtered Standard 1D ^1H NMR vs. SMolESY filter');xlabel('PPM');                
%                 subplot(3,1,1);plot(X1D(i,:),Y1D(i,:));set(gca,'xdir','reverse');title('Standard 1D ^1H NMR');xlabel('PPM');xlim([8 10]);hold on;
%                 subplot(3,1,2);plot(X1D(i,:),SMolESY_Processed_final(i,:));set(gca,'xdir','reverse');title('SMolESY filter');xlabel('PPM');xlim([8 10]);hold on;
%                 subplot(3,1,3);plot(X1D(i,:),SMolESY_filtered1D(i,:));set(gca,'xdir','reverse');title('Filtered Standard 1D ^1H NMR');xlabel('PPM');xlim([8 10]);hold on;                               
                saveas(gcf, fullfile(handles.Results_folder_path,'SMolESY_filter_figures','region 8.0-10.0 ppm',['Spectrum-' list_of_spectra_1D{i} '-SMolESY-filtering']), 'tif');hold on;
                close(f1);                
                PASS_SMolESY_test(i,1) = 1;
            catch
                PASS_SMolESY_test(i,1) = 0;                
            end
            % end of SMolESY processing production process
            
            % Fitting spectrum baseline at 0.2-0.5 for the removal of any
            % sharp signals of metabolites
            try
                [Tot_protein_Relative(i,1), X_fit(i).data, Y_fit(i).data, fitted_baseline(i).data,baseline_filtered1D(i).data] = NMRpQuant_Baseline_filter(X1D(i,:),Y1D(i,:));
                
                f1 = figure('visible','off');                                    
                plot(X_fit(i).data,Y_fit(i).data);hold on;plot(X_fit(i).data,fitted_baseline(i).data);hold on;plot(X_fit(i).data,baseline_filtered1D(i).data);set(gca,'xdir','reverse');legend('Standard 1D ^1H NMR','Residuals','Protein signal extraction');title('Standard 1D ^1H NMR vs. Protein signal extraction vs. residuals');xlabel('PPM');                               
                saveas(gcf, fullfile(handles.Results_folder_path,'Protein signal extraction from 0.2-0.5 ppm_filter_figures',['Spectrum-' list_of_spectra_1D{i} '-Protein-signal-extraction']), 'tif');hold on;
                close(f1);                                                
                PASS_Fitted_base_test(i,1) = 1;
            catch
                PASS_Fitted_base_test(i,1) = 0;
            end
                        
            %end of fitting process
            
        end

    end

    
    handles.Y1D = Y1D;        
    handles.X1D = X1D;       
    handles.Samples_titles1D = list_of_spectra_1D; 
    handles.DISP_NAMES = display_names;
    handles.PASS_Standard1D = 1;
    
    % test_the_spectra Quality - production
    if isempty(find(PASS_SMolESY_test == 0)) && isempty(find(PASS_Fitted_base_test == 0))
        
        handles.PASS_SMolESY = 1;
        handles.PASS_Fitted_base = 1;
        
        handles.Yim1D = Yim1D;
        handles.SMolESY_Processed_final = abs(SMolESY_Processed_final);
        handles.SMolESY_original = SMolESY_original; 
        handles.SMolESY_filtered1D = SMolESY_filtered1D;
        
        handles.X_fit = X_fit;
        handles.Y_fit = Y_fit;
        handles.fitted_baseline = fitted_baseline;
        handles.baseline_filtered1D = baseline_filtered1D;
        handles.Integrals_Baseline_fit = Tot_protein_Relative;

        str1 = "NMR Standard 1D & SMolESY & Protein signal extraction from 0.2-0.5 ppm data are successfully read/produced and loaded on the software.";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + "Please proceed with the next STEPS." + newline + "You could check fitting results in 'OUTPUT FOLDER/..._filter_figures' folders.";
    
    elseif ~isempty(find(PASS_SMolESY_test == 0)) && ~isempty(find(PASS_Fitted_base_test == 0))
    
        handles.PASS_SMolESY = 0;
        handles.PASS_Fitted_base = 0;
        
        str1 = "NMR Standard 1D data is successfully read and loaded on the software.";
        str22 = "ERROR: SMolESY & Protein signal extraction from 0.2-0.5 ppm data could not be produced.";
        str33 = "If you want to proceed with the next STEPS, you can select ONLY NCD filtering method, which requires additional type of NMR spectra (e.g. CPMG).";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + str22 + newline + str33;
    
    elseif ~isempty(find(PASS_SMolESY_test == 0)) && isempty(find(PASS_Fitted_base_test == 0))
        
        handles.PASS_SMolESY = 0;
        handles.PASS_Fitted_base = 1;
        
        handles.X_fit = X_fit;
        handles.Y_fit = Y_fit;
        handles.fitted_baseline = fitted_baseline;
        handles.baseline_filtered1D = baseline_filtered1D;
        handles.Integrals_Baseline_fit = Tot_protein_Relative;
        
        str1 = "NMR Standard 1D & Protein signal extraction from 0.2-0.5 ppm data are successfully read/produced and loaded on the software.";
        str22 = "ERROR: SMolESY data could not be produced.";
        str33 = "If you want to proceed with the next STEPS, you cannot select SMolESY or All methods filtering.";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + str22 + newline + str33;
    
    elseif isempty(find(PASS_SMolESY_test == 0)) && ~isempty(find(PASS_Fitted_base_test == 0))
               
        handles.Yim1D = Yim1D;
        handles.SMolESY_Processed_final = abs(SMolESY_Processed_final);
        handles.SMolESY_original = SMolESY_original; 
        handles.SMolESY_filtered1D = SMolESY_filtered1D;    
        handles.PASS_SMolESY = 1;
        handles.PASS_Fitted_base = 0;
        
        str1 = "NMR Standard 1D & Protein signal extraction from 0.2-0.5 ppm data are successfully read/produced and loaded on the software.";
        str22 = "ERROR: Protein signal extraction from 0.2-0.5 ppm data could not be produced.";
        str33 = "If you want to proceed with the next STEPS, you cannot select Protein signal extraction from 0.2-0.5 ppm or All methods filtering.";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + str22 + newline + str33;

    end
    if i == size(list_of_spectra_1D,1)
        DIKA = waitbar2a(i/size(list_of_spectra_1D,1),handles.Progress,['NMR spectra Loading/Processing is completed.'],'g');
    end
    
    delete(findall(handles.Standard1D_plot,'type','text'))
    delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
    delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
    set(handles.SpectraNAMESTABLE,'Data',handles.Samples_titles1D); % Use the set command to change the uitable properties.    
    set (handles.SpectraNAMESTABLE, 'CellSelectionCallback', @cb_select)

    if handles.PASS_Standard1D == 1
        axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
        set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.DISP_NAMES(:)))
        set(handles.Standard1D_plot.Children,'LineWidth',0.5);
        handles.INITaxesLimitsStandard1D_plot = get(handles.Standard1D_plot,{'xlim','ylim'});
    else
        uiwait(msgbox('There are no Standard 1D 1H NMR spectra.','modal'));    
        handles.NOTIFICATIONS_BOX.String = "ERROR: The Standard 1D 1H NMR spectra cannot be plotted. Please try loading them.";   
    end

    
catch
    handles.Parent1D_folder = [];
    handles.PASS_SMolESY = 0;
    handles.PASS_Standard1D = 0;
    handles.PASS_Fitted_base = 0;
    try
        DIKA = waitbar2a(i/size(list_of_spectra_1D,1),handles.Progress,['Something went wrong with Spectrum ' list_of_spectra_1D{i} '...'],'g');   
        str1 = "ERROR: Output folder is not defined AND/OR NMR real and/or imaginary data cannot be found or read correctly. Please check the structure of the NMR spectra containing folder, which should be as indicated in the User's Guide file.";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + "Reminder: Imaginary/FID spectral data is needed to run the SMolESY method of the software.";
    catch
        str1 = "ERROR: Output folder is not defined AND/OR NMR real and/or imaginary data cannot be found or read correctly. Please check the structure of the NMR spectra containing folder, which should be as indicated in the User's Guide file.";
        handles.NOTIFICATIONS_BOX.String = str1 + newline + "Reminder: Imaginary/FID spectral data is needed to run the SMolESY method of the software.";
    end
    
end

guidata(hObject, handles);