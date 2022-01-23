function [SMolESY_original,SMolESY_Processed_final,SMolESY_filtered1D] = NMRpQuant_SMolESY(X,Y,Y_imag,X_processed,Y_imag_processed,ref_position,radius)


SMolESY_temp_Processed = gradient(Y_imag_processed,X_processed);
            
% align to zero in case of any drifting taking as reference TSP
% or any used reference in the sample
SMolESY_temp_Processed_aligned = Align_data(X,SMolESY_temp_Processed,ref_position,radius);                        
Y1D_temp = Align_data(X,Y,ref_position,radius);            
[~,ii] = find(X > -0.2 & X < 0.2);
mini = min(SMolESY_temp_Processed_aligned(:,ii));
maxi = max(SMolESY_temp_Processed_aligned(:,ii));            
mami = abs(mini) + maxi;
max_1D = max(Y1D_temp(:,ii));
SMolESY_Processed_final = abs(SMolESY_temp_Processed_aligned/(mami/max_1D));
SMolESY_original = gradient(Y_imag,X);
SMolESY_filtered1D = Y - SMolESY_Processed_final;

