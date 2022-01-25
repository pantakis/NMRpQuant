% --- Executes on button press in CalcInt.
function CalcInt_Callback(hObject, eventdata, handles)
% hObject    handle to CalcInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    wb = waitbar(0, ['\bf \fontsize{12} Please wait for the integration process completion...']);
    wbc = allchild(wb);
    jp = wbc(1).JavaPeer;
    wbc(1).JavaPeer.setForeground(wbc(1).JavaPeer.getForeground.cyan);
    jp.setIndeterminate(1);    
    
    if handles.MethodFLAG == 3 && handles.PASS_Fitted_base == 1
        try 
            if handles.GoforABS == 0 || handles.absfactors(1,1) == 0 
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;
            elseif handles.GoforABS == 1 && handles.absfactors(1,1) > 0
                handles.Integrals_Baseline_fitF = (handles.Integrals_Baseline_fit*handles.absConRef*handles.absfactors(1,1))./handles.QREF_Int;
                handles.Integrals_Baseline_fitF = round(handles.Integrals_Baseline_fitF,4);
                if handles.absfactorsError(1,1) > 0
                    ERROR = handles.Integrals_Baseline_fitF*handles.absfactorsError(1,1);
                    ERROR = round(ERROR,4);
                else
                    ERROR(1:length(handles.Integrals_Baseline_fit),1) = NaN;
                end                
                handles.Integrals_Baseline_fitFF = [handles.Integrals_Baseline_fitF ERROR];
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fitFF,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (mg/mL): Prot. sig. extr. method' '+/- Error (mg/mL): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;                    
            else
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;
            end

        catch

            uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));
            handles.Int_baseline_export_FLAG = 0;
            figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
            close(figHandles);
            str1 = "Integration process was not completed successfully.";    
            handles.NOTIFICATIONS_BOX.String = str1;
        end

    elseif handles.MethodFLAG == 1 && handles.PASS_CPMG == 1
        try
            for i = 1:length(handles.Samples_titles1D)
                    Integral_temp_NCD = NMRpQuant_NCD_SMolESY_method_integration(handles.X1D(i,:),handles.NCDspectra(i,:), handles.Int_REGION);
                    Integrals_F_NCD(i,:) = transpose(Integral_temp_NCD);
            end  
            if handles.GoforABS == 0
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (a.u.): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                            Region_names = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',Region_names);
                end   
                handles.Int_NCD_export = Int_NCD_export;    
                handles.Int_NCD_export_FLAG = 1;
            elseif handles.GoforABS == 1
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (mg/mL): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Integrals_F_NCD_F = (Integrals_F_NCD*handles.absConRef*handles.absfactors(1,handles.Int_REGION_flag))./handles.QREF_Int; 
                        Integrals_F_NCD_F = round(Integrals_F_NCD_F,4);
                        if Integrals_F_NCD_F > 0
                            if handles.absfactorsError(1,handles.Int_REGION_flag) > 0
                                ERROR = Integrals_F_NCD_F*handles.absfactorsError(1,handles.Int_REGION_flag);
                                ERROR = round(ERROR,4);
                            else
                                ERROR(1:length(Integrals_F_NCD_F),1) = NaN;
                            end                
                            Integrals_F_NCD_FF = [Integrals_F_NCD_F ERROR];
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',{C ['+/- Error (mg/mL): ' A{1+handles.Int_REGION_flag}]});
                        else
                            A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                            B = 'Total Protein concentration (a.u.): ';            
                            C = [B A{1+handles.Int_REGION_flag}];                            
                            Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                        end
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Integrals_F_NCD_F = (Integrals_F_NCD*handles.absConRef.*handles.absfactors)./handles.QREF_Int; 
                        Region_namesABS = {'Total Protein concentration (mg/mL): 0.2 - 0.5 ppm' 'Total Protein concentration (mg/mL): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (mg/mL): 8.0 - 10.0 ppm' 'Total Protein concentration (mg/mL): All regions'};
                        Region_namesAU = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        ERROR_names = {'+/- Error (mg/mL): 0.2 - 0.5 ppm' '+/- Error (mg/mL): 0.2 - 0.7 ppm'...
                                            '+/- Error (mg/mL): 8.0 - 10.0 ppm' '+/- Error (mg/mL): All regions'};
                        [~,ii] = find(Integrals_F_NCD_F == 0);                        
                        if isempty(ii)
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR
                            ERROR = Integrals_F_NCD_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integrals_F_NCD_F mean(Integrals_F_NCD_F,2)];
                            a = round(a,4); 
                            b = [ERROR mean(ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integrals_F_NCD_FF = reshape([a(:) b(:)]',2*size(a,1), [])';                            
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        else
                            IND = unique(ii);
                            
                            Temp_Integrals_F_NCD_F = Integrals_F_NCD_F;
                            Temp_Integrals_F_NCD_F(:,IND) = [];
                            TEMP_absfactorsError = handles.absfactorsError;
                            
                            TEMP_absfactorsError(:,IND) = [];
                            [~,ooo] = find(TEMP_absfactorsError == 0);                            
                            TEMP_absfactorsError(:,ooo) = NaN;
                            Temp_ERROR = Temp_Integrals_F_NCD_F.*TEMP_absfactorsError; 
                            
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR ooo TEMP_absfactorsError

                            ERROR = Integrals_F_NCD_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integrals_F_NCD_F mean(Temp_Integrals_F_NCD_F,2)];
                            a = round(a,4);
                            a(:,IND) = Integrals_F_NCD(:,IND);
                            b = [ERROR mean(Temp_ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integrals_F_NCD_FF = reshape([a(:) b(:)]',2*size(a,1), [])';     
                            Region_namesABS(IND) = Region_namesAU(IND);
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            INDs = 2*IND;
                            ca3(INDs) = [];
                            Integrals_F_NCD_FF(:,INDs) = [];
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        end
                end   
                handles.Int_NCD_export = Int_NCD_export;    
                handles.Int_NCD_export_FLAG = 1;
            end
        catch
            handles.Int_NCD_export_FLAG = 0;
            uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));
            figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
            close(figHandles);
            str1 = "Integration process was not completed successfully.";    
            handles.NOTIFICATIONS_BOX.String = str1;
        end

    elseif handles.MethodFLAG == 2 && handles.PASS_SMolESY == 1
        try
            for i = 1:length(handles.Samples_titles1D)
                Integral_temp_SMolESYfiltered = NMRpQuant_NCD_SMolESY_method_integration(handles.X1D(i,:),handles.SMolESY_filtered1D(i,:), handles.Int_REGION);
                Integral_F_SMolESYfiltered(i,:) = transpose(Integral_temp_SMolESYfiltered);
            end  
            if handles.GoforABS == 0
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (a.u.): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',{C});                        
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Region_names = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',Region_names);
                end   
                handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;
                handles.Int_SMolESYfiltered_export_FLAG = 1;
            elseif handles.GoforABS == 1
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (mg/mL): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Integral_F_SMolESYfiltered_F = (Integral_F_SMolESYfiltered*handles.absConRef*handles.absfactors(1,handles.Int_REGION_flag))./handles.QREF_Int; 
                        Integral_F_SMolESYfiltered_F = round(Integral_F_SMolESYfiltered_F,4);
                        if Integral_F_SMolESYfiltered_F > 0
                            if handles.absfactorsError(1,handles.Int_REGION_flag) > 0
                                ERROR = Integral_F_SMolESYfiltered_F*handles.absfactorsError(1,handles.Int_REGION_flag);
                                ERROR = round(ERROR,4);
                            else
                                ERROR(1:length(Integral_F_SMolESYfiltered_F),1) = NaN;
                            end                
                            Integral_F_SMolESYfiltered_FF = [Integral_F_SMolESYfiltered_F ERROR];
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',{C ['+/- Error (mg/mL): ' A{1+handles.Int_REGION_flag}]});
                        else
                            A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                            B = 'Total Protein concentration (a.u.): ';            
                            C = [B A{1+handles.Int_REGION_flag}];                            
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                        end
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Integral_F_SMolESYfiltered_F = (Integral_F_SMolESYfiltered*handles.absConRef.*handles.absfactors)./handles.QREF_Int; 
                        Region_namesABS = {'Total Protein concentration (mg/mL): 0.2 - 0.5 ppm' 'Total Protein concentration (mg/mL): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (mg/mL): 8.0 - 10.0 ppm' 'Total Protein concentration (mg/mL): All regions'};
                        Region_namesAU = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        ERROR_names = {'+/- Error (mg/mL): 0.2 - 0.5 ppm' '+/- Error (mg/mL): 0.2 - 0.7 ppm'...
                                            '+/- Error (mg/mL): 8.0 - 10.0 ppm' '+/- Error (mg/mL): All regions'};
                        [~,ii] = find(Integral_F_SMolESYfiltered_F == 0);                        
                        if isempty(ii)
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR
                            ERROR = Integral_F_SMolESYfiltered_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integral_F_SMolESYfiltered_F mean(Integral_F_SMolESYfiltered_F,2)];
                            a = round(a,4);
                            b = [ERROR mean(ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integral_F_SMolESYfiltered_FF = reshape([a(:) b(:)]',2*size(a,1), [])';                            
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        else
                            IND = unique(ii);
                            Temp_Integral_F_SMolESYfiltered_F = Integral_F_SMolESYfiltered_F;
                            Temp_Integral_F_SMolESYfiltered_F(:,IND) = [];
                            TEMP_absfactorsError = handles.absfactorsError;
                            
                            TEMP_absfactorsError(:,IND) = [];
                            [~,ooo] = find(TEMP_absfactorsError == 0);                            
                            TEMP_absfactorsError(:,ooo) = NaN;
                            Temp_ERROR = Temp_Integral_F_SMolESYfiltered_F.*TEMP_absfactorsError;                                                                                   
                            
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR ooo TEMP_absfactorsError
                            
                            ERROR = Integral_F_SMolESYfiltered_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integral_F_SMolESYfiltered_F mean(Temp_Integral_F_SMolESYfiltered_F,2)];
                            a = round(a,4);
                            a(:,IND) = Integral_F_SMolESYfiltered(:,IND);
                            b = [ERROR mean(Temp_ERROR,2)];
                            b = round(b,4);                                                   
                            a = a';
                            b = b';
                            Integral_F_SMolESYfiltered_FF = reshape([a(:) b(:)]',2*size(a,1), [])';     
                            Region_namesABS(IND) = Region_namesAU(IND);
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            INDs = 2*IND;
                            ca3(INDs) = [];
                            Integral_F_SMolESYfiltered_FF(:,INDs) = [];
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        end
                end   
                handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;
                handles.Int_SMolESYfiltered_export_FLAG = 1;
            end
        catch        
            handles.Int_SMolESYfiltered_export_FLAG = 0;
            uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));
            figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
            close(figHandles);
            str1 = "Integration process was not completed successfully.";    
            handles.NOTIFICATIONS_BOX.String = str1;
        end

    elseif handles.MethodFLAG == 4 && handles.PASS_SMolESY == 1 && handles.PASS_CPMG == 1 && handles.PASS_Fitted_base == 1
        try 
            if handles.GoforABS == 0 || handles.absfactors(1,1) == 0 
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;
            elseif handles.GoforABS == 1 && handles.absfactors(1,1) > 0
                handles.Integrals_Baseline_fitF = (handles.Integrals_Baseline_fit*handles.absConRef*handles.absfactors(1,1))./handles.QREF_Int;
                handles.Integrals_Baseline_fitF = round(handles.Integrals_Baseline_fitF,4);
                if handles.absfactorsError(1,1) > 0
                    ERROR = handles.Integrals_Baseline_fitF*handles.absfactorsError(1,1);
                    ERROR = round(ERROR,4);
                else
                    ERROR(1:length(handles.Integrals_Baseline_fit),1) = NaN;
                end                
                handles.Integrals_Baseline_fitFF = [handles.Integrals_Baseline_fitF ERROR];
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fitFF,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (mg/mL): Prot. sig. extr. method' '+/- Error (mg/mL): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;                    
            else
                handles.Int_baseline_export = array2table(handles.Integrals_Baseline_fit,'RowNames',handles.Samples_titles1D,'VariableNames',{'Total Protein concentration (a.u.): Prot. sig. extr. method'});
                handles.Int_baseline_export_FLAG = 1;
            end


            for i = 1:length(handles.Samples_titles1D)
                Integral_temp_NCD = NMRpQuant_NCD_SMolESY_method_integration(handles.X1D(i,:),handles.NCDspectra(i,:), handles.Int_REGION);
                Integral_temp_SMolESYfiltered = NMRpQuant_NCD_SMolESY_method_integration(handles.X1D(i,:),handles.SMolESY_filtered1D(i,:), handles.Int_REGION);
                Integrals_F_NCD(i,:) = transpose(Integral_temp_NCD);
                Integral_F_SMolESYfiltered(i,:) = transpose(Integral_temp_SMolESYfiltered);
            end  

            if handles.GoforABS == 0
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (a.u.): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',{C});  
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Region_names = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',Region_names);
                        Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',Region_names);
                end   
                handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;
                handles.Int_SMolESYfiltered_export_FLAG = 1;
            elseif handles.GoforABS == 1
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (mg/mL): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Integral_F_SMolESYfiltered_F = (Integral_F_SMolESYfiltered*handles.absConRef*handles.absfactors(1,handles.Int_REGION_flag))./handles.QREF_Int; 
                        Integral_F_SMolESYfiltered_F = round(Integral_F_SMolESYfiltered_F,4);
                        if Integral_F_SMolESYfiltered_F > 0
                            if handles.absfactorsError(1,handles.Int_REGION_flag) > 0
                                ERROR = Integral_F_SMolESYfiltered_F*handles.absfactorsError(1,handles.Int_REGION_flag);
                                ERROR = round(ERROR,4);
                            else
                                ERROR(1:length(Integral_F_SMolESYfiltered_F),1) = NaN;
                            end                
                            Integral_F_SMolESYfiltered_FF = [Integral_F_SMolESYfiltered_F ERROR];
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',{C ['+/- Error (mg/mL): ' A{1+handles.Int_REGION_flag}]});
                        else
                            A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                            B = 'Total Protein concentration (a.u.): ';            
                            C = [B A{1+handles.Int_REGION_flag}];                            
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                        end
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Integral_F_SMolESYfiltered_F = (Integral_F_SMolESYfiltered*handles.absConRef.*handles.absfactors)./handles.QREF_Int;                         
                        Region_namesABS = {'Total Protein concentration (mg/mL): 0.2 - 0.5 ppm' 'Total Protein concentration (mg/mL): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (mg/mL): 8.0 - 10.0 ppm' 'Total Protein concentration (mg/mL): All regions'};
                        Region_namesAU = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        ERROR_names = {'+/- Error (mg/mL): 0.2 - 0.5 ppm' '+/- Error (mg/mL): 0.2 - 0.7 ppm'...
                                            '+/- Error (mg/mL): 8.0 - 10.0 ppm' '+/- Error (mg/mL): All regions'};
                        [~,ii] = find(Integral_F_SMolESYfiltered_F == 0);                        
                        if isempty(ii)
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR
                            ERROR = Integral_F_SMolESYfiltered_F.*handles.absfactorsError;                            
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integral_F_SMolESYfiltered_F mean(Integral_F_SMolESYfiltered_F,2)];
                            a = round(a,4);
                            b = [ERROR mean(ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integral_F_SMolESYfiltered_FF = reshape([a(:) b(:)]',2*size(a,1), [])';                            
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        else
                            IND = unique(ii);                            
                            Temp_Integral_F_SMolESYfiltered_F = Integral_F_SMolESYfiltered_F;
                            Temp_Integral_F_SMolESYfiltered_F(:,IND) = [];
                            TEMP_absfactorsError = handles.absfactorsError;
                            
                            TEMP_absfactorsError(:,IND) = [];
                            [~,ooo] = find(TEMP_absfactorsError == 0);                            
                            TEMP_absfactorsError(:,ooo) = NaN;
                            Temp_ERROR = Temp_Integral_F_SMolESYfiltered_F.*TEMP_absfactorsError;                                                                                   
                            
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR ooo TEMP_absfactorsError
                            ERROR = Integral_F_SMolESYfiltered_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;                                  
                            a = [Integral_F_SMolESYfiltered_F mean(Temp_Integral_F_SMolESYfiltered_F,2)];
                            a = round(a,4);
                            a(:,IND) = Integral_F_SMolESYfiltered(:,IND);
                            b = [ERROR mean(Temp_ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integral_F_SMolESYfiltered_FF = reshape([a(:) b(:)]',2*size(a,1), [])';     
                            Region_namesABS(IND) = Region_namesAU(IND);
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            INDs = 2*IND;
                            ca3(INDs) = [];
                            Integral_F_SMolESYfiltered_FF(:,INDs) = [];
                            
                            Int_SMolESYfiltered_export = array2table(Integral_F_SMolESYfiltered_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        end
                end   
                handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;
                handles.Int_SMolESYfiltered_export_FLAG = 1;
            end

            if handles.GoforABS == 0
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (a.u.): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                            Region_names = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',Region_names);
                end   
                handles.Int_NCD_export = Int_NCD_export;    
                handles.Int_NCD_export_FLAG = 1;
            elseif handles.GoforABS == 1
                switch handles.Int_REGION_flag
                    case {1,2,3}%,4,5}
                        A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                        B = 'Total Protein concentration (mg/mL): ';            
                        C = [B A{1+handles.Int_REGION_flag}];
                        Integrals_F_NCD_F = (Integrals_F_NCD*handles.absConRef*handles.absfactors(1,handles.Int_REGION_flag))./handles.QREF_Int; 
                        Integrals_F_NCD_F = round(Integrals_F_NCD_F,4);
                        if Integrals_F_NCD_F > 0
                            if handles.absfactorsError(1,handles.Int_REGION_flag) > 0
                                ERROR = Integrals_F_NCD_F*handles.absfactorsError(1,handles.Int_REGION_flag);
                                ERROR = round(ERROR,4);
                            else
                                ERROR(1:length(Integrals_F_NCD_F),1) = NaN;
                            end                
                            Integrals_F_NCD_FF = [Integrals_F_NCD_F ERROR];
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',{C ['+/- Error (mg/mL): ' A{1+handles.Int_REGION_flag}]});
                        else
                            A = cellstr(get(handles.ChooseREGIONS_Int,'String'));
                            B = 'Total Protein concentration (a.u.): ';            
                            C = [B A{1+handles.Int_REGION_flag}];                            
                            Int_NCD_export = array2table(Integrals_F_NCD,'RowNames',handles.Samples_titles1D,'VariableNames',{C});
                        end
                    case 4%6
    %                     Region_names = {'Total Protein Relative concentration: 0.2 - 0.5 ppm' 'Total Protein Relative concentration: 0.2 - 0.7 ppm'...
    %                         'Total Protein Relative concentration: 0.8 - 2.0 ppm' 'Total Protein Relative concentration: 6.3 - 7.0 ppm'...
    %                         'Total Protein Relative concentration: 8.0 - 10.0 ppm'};
                        Integrals_F_NCD_F = (Integrals_F_NCD*handles.absConRef.*handles.absfactors)./handles.QREF_Int; 
                        Region_namesABS = {'Total Protein concentration (mg/mL): 0.2 - 0.5 ppm' 'Total Protein concentration (mg/mL): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (mg/mL): 8.0 - 10.0 ppm' 'Total Protein concentration (mg/mL): All regions'};
                        Region_namesAU = {'Total Protein concentration (a.u.): 0.2 - 0.5 ppm' 'Total Protein concentration (a.u.): 0.2 - 0.7 ppm'...
                                            'Total Protein concentration (a.u.): 8.0 - 10.0 ppm'};
                        ERROR_names = {'+/- Error (mg/mL): 0.2 - 0.5 ppm' '+/- Error (mg/mL): 0.2 - 0.7 ppm'...
                                            '+/- Error (mg/mL): 8.0 - 10.0 ppm' '+/- Error (mg/mL): All regions'};
                        [i,ii] = find(Integrals_F_NCD_F == 0);                        
                        if isempty(ii)
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR
                            ERROR = Integrals_F_NCD_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integrals_F_NCD_F mean(Integrals_F_NCD_F,2)];
                            a = round(a,4); 
                            b = [ERROR mean(ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integrals_F_NCD_FF = reshape([a(:) b(:)]',2*size(a,1), [])';                            
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        else
                            IND = unique(ii);
                            Temp_Integrals_F_NCD_F = Integrals_F_NCD_F;
                            Temp_Integrals_F_NCD_F(:,IND) = [];
                            TEMP_absfactorsError = handles.absfactorsError;
                            
                            TEMP_absfactorsError(:,IND) = [];
                            [~,ooo] = find(TEMP_absfactorsError == 0);                            
                            TEMP_absfactorsError(:,ooo) = NaN;
                            Temp_ERROR = Temp_Integrals_F_NCD_F.*TEMP_absfactorsError; 
                            
                            [~,oo] = find(handles.absfactorsError == 0);
                            clearvars a b ERROR ooo TEMP_absfactorsError                                                        
                          
                            ERROR = Integrals_F_NCD_F.*handles.absfactorsError;
                            ERROR(1:length(handles.Samples_titles1D),oo) = NaN;
                            a = [Integrals_F_NCD_F mean(Temp_Integrals_F_NCD_F,2)];
                            a = round(a,4);
                            a(:,IND) = Integrals_F_NCD(:,IND);
                            b = [ERROR mean(Temp_ERROR,2)];
                            b = round(b,4);
                            a = a';
                            b = b';
                            Integrals_F_NCD_FF = reshape([a(:) b(:)]',2*size(a,1), [])';     
                            Region_namesABS(IND) = Region_namesAU(IND);
                            ca3 = [Region_namesABS,ERROR_names];
                            idx = reshape(1:8,[],2)';
                            ca3 = ca3(:,idx(1:end));
                            INDs = 2*IND;
                            ca3(INDs) = [];
                            Integrals_F_NCD_FF(:,INDs) = [];
                            Int_NCD_export = array2table(Integrals_F_NCD_FF,'RowNames',handles.Samples_titles1D,'VariableNames',ca3);
                        end
                end   
                handles.Int_NCD_export = Int_NCD_export;    
                handles.Int_NCD_export_FLAG = 1;
            end

            handles.Int_NCD_export = Int_NCD_export;
            handles.Int_SMolESYfiltered_export = Int_SMolESYfiltered_export;            
            handles.Int_NCD_export_FLAG = 1; 
            handles.Int_baseline_export_FLAG = 1;
            handles.Int_SMolESYfiltered_export_FLAG = 1;    
        catch
            handles.Int_NCD_export_FLAG = 0; 
            handles.Int_baseline_export_FLAG = 0;
            handles.Int_SMolESYfiltered_export_FLAG = 0;
            uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));       
            figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
            close(figHandles);
            str1 = "Integration process was not completed successfully.";    
            handles.NOTIFICATIONS_BOX.String = str1;
        end
    else
       handles.Int_NCD_export_FLAG = 0; 
       handles.Int_baseline_export_FLAG = 0;
       handles.Int_SMolESYfiltered_export_FLAG = 0;
       uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));       
       figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
       close(figHandles);
       str1 = "Integration process was not completed successfully.";    
       handles.NOTIFICATIONS_BOX.String = str1;
    end
    figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
    close(figHandles);
    str1 = "Integration process is completed successfully.";    
    handles.NOTIFICATIONS_BOX.String = str1;
        
catch
    
    uiwait(msgbox('ERROR: Please check the selected method and if the filtered data are produced.','modal'));       
    figHandles = findobj('type', 'figure', '-not', 'name', 'NMRpQuant');
    close(figHandles);
    str1 = "ERROR: Integration process cannot be completed. Please check the selected method and if the filtered data are produced.";    
    handles.NOTIFICATIONS_BOX.String = str1;
    
end


guidata(hObject, handles);