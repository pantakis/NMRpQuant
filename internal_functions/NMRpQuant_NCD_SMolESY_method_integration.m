
function [protein_integral] = NMRpQuant_NCD_SMolESY_method_integration(X, Y, region)
       
    if size(region,1) == 1
        
        protein_integral = find_region_integrate(X,Y,region);
    else
        protein_integral(1:size(region,1),:) = zeros;
        for i = 1:size(region,1)
            protein_integral(i,1) = find_region_integrate(X,Y,region(i,:));
        end
    end
    

    
    
    