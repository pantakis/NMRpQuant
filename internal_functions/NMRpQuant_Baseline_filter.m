function [Tot_protein_Relative, X_fit, Y_fit, fitted_baseline, baseline_filtered1D] = NMRpQuant_Baseline_filter(X,Y)
        
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
% Finding 0.2 - 0.5 ppm spectral region and fit spectral data by linear
% function
% 
% Inputs
% X: PPM vector
% Y: Intensity data
%
% Outputs 
% Tot_protein_Relative: Area (integral) under the fitted baseline
% X_fit: PPM vector of the fitted region         
% Y_fit: Intensity data of the to be fitted region vector       
% fitted_baseline: Fitted baseline data vector
% baseline_filtered1D: Residuals data of the fitting vector
%
%
% Last Updated: 12/01/2022  


            X = X';
            Y = Y';
            [p,~] = find(X(:,1) > 0.2 & X(:,1) < 0.5);
            brushedDataR(:,1) = X(p,1);
            brushedDataR(:,2) = Y(p,1);
            AAR = brushedDataR(:,2)';
            MIKOS = length(brushedDataR(:,2));
            CV1 = [1:1:4];
            CV2 = [MIKOS-5:20:MIKOS];
            CV = [CV1 CV2];
           
            [~,yfitR_1] = base_fit_protein_linear(AAR',CV,'linear');
            TEMP_RESIDUAL = fliplr(brushedDataR(:,2)-yfitR_1);
            [pks1,locs1,~,~] = findpeaks(-TEMP_RESIDUAL);
            NOI1 = std(-TEMP_RESIDUAL);
            [n,~] = find(pks1>0.3*NOI1);
            locs2 = locs1(n,1);    
            CVF = sort([CV locs2']);     
            [~,yfitR2] = base_fit_protein_linear(AAR',CVF,'linear');                                   
            Tot_protein_Relative = abs(trapz(brushedDataR(:,1)',yfitR2));
            X_fit = brushedDataR(:,1)';
            Y_fit = brushedDataR(:,2)';
            fitted_baseline = fliplr(brushedDataR(:,2)-yfitR2);                        
            baseline_filtered1D = fliplr(yfitR2);
end
                
    
    
    
    
    