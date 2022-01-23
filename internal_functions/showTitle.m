function showTitle(aLineH, eventdata, LineH, TitleH, LineH2, LineH3, flag_for_filter) 
    TitleH.String    = aLineH.DisplayName;
    set(LineH,'LineWidth',0.5);
    set(aLineH,'LineWidth',1.5)    
    uistack(aLineH, 'top');    
    plot_the_rest(TitleH,LineH2,LineH3,flag_for_filter)    
end