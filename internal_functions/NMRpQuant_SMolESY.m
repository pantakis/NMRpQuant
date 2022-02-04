function [SMolESY_original,SMolESY_Processed_final,SMolESY_filtered1D] = NMRpQuant_SMolESY(X,Y,Y_imag,X_processed,Y_imag_processed,ref_position,radius)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright to Dr. Panteleimon G. Takis, 2022                           % 
%                                                                       %
% National Phenome Centre and Imperial Clinical Phenotyping Centre,     %
% Department of Metabolism, Digestion and Reproduction, IRDB Building,  %
% Imperial College London, Hammersmith Campus,                          %
% London, W12 0NN, United Kingdom                                       %
%                                                                       %
% This program is distributed in the hope that it will be useful,       %
% but WITHOUT ANY WARRANTY; without even the implied warranty of        %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         %
% GNU General Public License for more details.                          %
%                                                                       %
% You should have received a copy of the GNU General Public License     %
% along with this program.  If not, see <https://www.gnu.org/licenses/>.%
%                                                                       %    
% Email: p.takis@imperial.ac.uk                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Applying SMolESY filtering and produce SMolESY filter (i.e. modified
% SMolESY)
% 
% 
% Inputs
% X: PPM vector
% Y: Original Intensity Real data vector
% Y_imag: Original Intensity Imaginary data vector
% X_processed: PPM vector from the reprocessed NMR data (by new lb_factor)
% Y_imag_processed: Intensity Imaginary data vector from Reprocessed NMR data (by new lb_factor)  
% ref_position: PPM value to align Original and Reprocessed NMR data (e.g. 0 when using TSP)
% radius: ±PPM value for searching/picking maximum peak (i.e. Ref Peak, e.g. TSP) to align NMR data
%
%
% Outputs 
% SMolESY_original: SMolESY data vector from the Original Imaginary data
%                   vector
% SMolESY_Processed_final: ABSOLUTE SMolESY data vector from the Re-processed 
%                          Imaginary data vector         
% SMolESY_filtered1D: Intensity data of the "SMolESY_Processed_final" vector subtraction 
%                     from Orignal Intensity data vector
%
%
% Last Updated: 12/01/2022  



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

