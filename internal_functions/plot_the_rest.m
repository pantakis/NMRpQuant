function plot_the_rest(primary_tex,h1,h2,flag_for_filter)
    
    delete(findall(h1,'type','text'))
    delete(findall(h2,'type','text'))
    set(h1.Children,'LineWidth', 0.5)
    set(h2.Children,'LineWidth', 0.5)    
    title1 = text('Parent',h1,'Position',[0.01, 0.99],'String', primary_tex.String, 'Units', 'normalized',...
        'VerticalAlignment', 'top');
    title2 = text('Parent',h2,'Position',[0.01, 0.99],'String', primary_tex.String, 'Units', 'normalized',...
        'VerticalAlignment', 'top'); 
    D1 = findobj(h1.Children,'DisplayName',primary_tex.String);
    D2 = findobj(h2.Children,'DisplayName',primary_tex.String);
    IND1 = find(h1.Children == D1);
    IND2 = find(h2.Children == D2);
    set(h1.Children(IND1),'LineWidth', 1.5)
    uistack(h1.Children(IND1), 'top');
    set(h2.Children(IND2),'LineWidth', 1.5)
    uistack(h2.Children(IND2), 'top');
    if flag_for_filter == 0
        delete(findall(h1,'type','text'))
        delete(findall(h2,'type','text'))
    end

end
