% --- Executes on button press in PlotFilters.
function PlotFilters_Callback(hObject, eventdata, handles)
% hObject    handle to PlotFilters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plotFOLTERS_FLAG = 1;


delete(findall(handles.SMolESY_processed_and_or_CPMG,'type','text'))
delete(findall(handles.NCD_and_or_SMolESY_filtered,'type','text'))
delete(findall(handles.Standard1D_plot,'type','text'))

set (handles.Standard1D_plot, 'ButtonDownFcn', @showTitleOFF)
set (handles.SMolESY_processed_and_or_CPMG, 'ButtonDownFcn', @showTitleOFF)
set (handles.NCD_and_or_SMolESY_filtered, 'ButtonDownFcn', @showTitleOFF)

set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
set(handles.Standard1D_plot.Children,'LineWidth',0.5);
set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);

handles.TitlesStatus.String = 'Titles: OFF';
handles.TitlesStatusONE.String = 'Titles: OFF';
handles.TitlesStatusTHREE.String = 'Titles: OFF';


if handles.MethodFLAG == 0
    
    cla(handles.SMolESY_processed_and_or_CPMG,'reset');
    cla(handles.NCD_and_or_SMolESY_filtered,'reset');
    uiwait(msgbox('Choose one method from STEP2 menu.','modal'));   

elseif handles.MethodFLAG == 4 
      try
        if handles.Check_CPMG_plot == 1 && handles.PASS_CPMG == 0 
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('Macromolecules filtered NMR spectra are not loaded, please load the spectra and see if any ERROR occurs.','modal'));  
        elseif handles.Check_CPMG_plot == 1 && handles.PASS_CPMG == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            axes(handles.SMolESY_processed_and_or_CPMG); plot(handles.X1D',handles.CPMG_Y1D');set(gca,'xdir','reverse');
            axes(handles.NCD_and_or_SMolESY_filtered); plot(handles.X1D',handles.NCDspectra');set(gca,'xdir','reverse')
            
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)));
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)));
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.Standard1D_plot.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
            
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'xy')
            
        elseif handles.Check_SMolESY_processed_plot == 1 && handles.PASS_SMolESY == 0
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('SMolESY data is not successfully produced, please reload Standard1D spectra and see if any ERROR occurs.','modal'));  
        elseif handles.Check_SMolESY_processed_plot == 1 && handles.PASS_SMolESY == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            axes(handles.SMolESY_processed_and_or_CPMG); plot(handles.X1D',handles.SMolESY_Processed_final');set(gca,'xdir','reverse')
            axes(handles.NCD_and_or_SMolESY_filtered); plot(handles.X1D',handles.SMolESY_filtered1D');set(gca,'xdir','reverse')
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'xy')                        
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)));
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)));
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
            set(handles.Standard1D_plot.Children,'LineWidth',0.5);
        elseif handles.Check_Baseline_plot == 1 && handles.PASS_Fitted_base == 0
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('Protein signal extraction from 0.2-0.5 ppm is not successfully performed, please reload Standard1D spectra and see if any ERROR occurs.','modal'));              
        elseif handles.Check_Baseline_plot == 1 && handles.PASS_Fitted_base == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            axes(handles.SMolESY_processed_and_or_CPMG);
            for i = 1:length(handles.Samples_titles1D)                
                plot(handles.X_fit(i).data,handles.fitted_baseline(i).data);set(gca,'xdir','reverse');hold on;
            end
            xlim([0.2 0.5]);
            %hold off

            axes(handles.NCD_and_or_SMolESY_filtered); 
            for i = 1:length(handles.Samples_titles1D)
                plot(handles.X_fit(i).data,handles.baseline_filtered1D(i).data);set(gca,'xdir','reverse');hold on;
            end        
            xlim([0.2 0.5]);
            %hold off
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'x');           
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
        else
            uiwait(msgbox('Data of one or more filtering method(s) ','modal'));  
        end
      catch          
          uiwait(msgbox('Either Macromolecules filtered NMR spectra are not loaded or you did not select the corresponding filtering method (i.e. NCD method or All methods) in STEP 2.','modal'));  
      end
    
    
elseif handles.MethodFLAG == 1 
    try
        if handles.Check_CPMG_plot == 1 && handles.PASS_CPMG == 0 
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('Macromolecules filtered NMR spectra are not loaded, please load the spectra and see if any ERROR occurs.','modal'));  
        elseif handles.Check_CPMG_plot == 1 && handles.PASS_CPMG == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            axes(handles.SMolESY_processed_and_or_CPMG); plot(handles.X1D',handles.CPMG_Y1D');set(gca,'xdir','reverse')
            axes(handles.NCD_and_or_SMolESY_filtered); plot(handles.X1D',handles.NCDspectra');set(gca,'xdir','reverse')
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'xy')
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
            set(handles.Standard1D_plot.Children,'LineWidth',0.5);
        else
            uiwait(msgbox('Either Macromolecules filtered NMR spectra are not loaded or you did not select the corresponding filtering method (i.e. NCD method or All methods) in STEP 2.','modal'));  
        end
    catch
        uiwait(msgbox('Either Macromolecules filtered NMR spectra are not loaded or you did not select the corresponding filtering method (i.e. NCD method or All methods) in STEP 2.','modal'));  
    end
    
elseif handles.MethodFLAG == 2
    try
        if handles.Check_SMolESY_processed_plot == 1 && handles.PASS_SMolESY == 0
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('SMolESY data is not successfully produced, please reload Standard1D spectra and see if any ERROR occurs.','modal'));  
        elseif handles.Check_SMolESY_processed_plot == 1 && handles.PASS_SMolESY == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            axes(handles.SMolESY_processed_and_or_CPMG); plot(handles.X1D',handles.SMolESY_Processed_final');set(gca,'xdir','reverse');
            axes(handles.NCD_and_or_SMolESY_filtered); plot(handles.X1D',handles.SMolESY_filtered1D');set(gca,'xdir','reverse')
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'xy')
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
            set(handles.Standard1D_plot.Children,'LineWidth',0.5);
        else
            uiwait(msgbox('Either SMolESY data were not successfully produced or you did not select the corresponding filtering method (i.e. SMolESY-filtering or All methods) in STEP 2.','modal'));  
        end     
    catch
        uiwait(msgbox('Either SMolESY data were not successfully produced or you did not select the corresponding filtering method (i.e. SMolESY-filtering or All methods) in STEP 2.','modal'));  
    end
    
elseif handles.MethodFLAG == 3    
    try
        if handles.Check_Baseline_plot == 1 && handles.PASS_Fitted_base == 0
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            uiwait(msgbox('Protein signal extraction from 0.2-0.5 ppm is not successfully performed, please reload Standard1D spectra and see if any ERROR occurs.','modal'));  
        elseif handles.Check_Baseline_plot == 1 && handles.PASS_Fitted_base == 1
            cla(handles.SMolESY_processed_and_or_CPMG,'reset');
            cla(handles.NCD_and_or_SMolESY_filtered,'reset');
            cla(handles.Standard1D_plot,'reset');
            axes(handles.Standard1D_plot);plot(handles.X1D',handles.Y1D');set(gca,'XDir','reverse');
            set (handles.Standard1D_plot.Children(:), {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            axes(handles.SMolESY_processed_and_or_CPMG);
            for i = 1:length(handles.Samples_titles1D)
                plot(handles.X_fit(i).data,handles.fitted_baseline(i).data);set(gca,'xdir','reverse');hold on;
            end
            
            axes(handles.NCD_and_or_SMolESY_filtered); 
            for i = 1:length(handles.Samples_titles1D)
                plot(handles.X_fit(i).data,handles.baseline_filtered1D(i).data);set(gca,'xdir','reverse');hold on;
            end        
            
            %hold off
            linkaxes([handles.SMolESY_processed_and_or_CPMG handles.Standard1D_plot handles.NCD_and_or_SMolESY_filtered], 'x');xlim([0.2 0.5]);
            set (handles.SMolESY_processed_and_or_CPMG.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            set (handles.NCD_and_or_SMolESY_filtered.Children, {'DisplayName'}, flipud(handles.Samples_titles1D(:)))
            set(handles.SMolESY_processed_and_or_CPMG.Children,'LineWidth',0.5);
            set(handles.NCD_and_or_SMolESY_filtered.Children,'LineWidth',0.5);
            set(handles.Standard1D_plot.Children,'LineWidth',0.5);
        else
            uiwait(msgbox('Either Protein signal extraction from 0.2-0.5 ppm was not successfully performed or you did not select the corresponding filtering method (i.e. Protein signal extraction from 0.2-0.5 ppm or All methods) in STEP 2.','modal'));  
        end    
    catch
        uiwait(msgbox('Either Protein signal extraction from 0.2-0.5 ppm was not successfully performed or you did not select the corresponding filtering method (i.e. Baseline fit for 0.2-0.5 ppm or All methods) in STEP 2.','modal'));  
    end
    
end    

guidata(hObject, handles); 