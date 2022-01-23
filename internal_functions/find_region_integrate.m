function [integral] = find_region_integrate(X,Y,spectrum_regions)


        [~,ii] = find(X > min(spectrum_regions) & X < max(spectrum_regions));
        integral = abs(trapz(X(1,ii),Y(1,ii)));
end