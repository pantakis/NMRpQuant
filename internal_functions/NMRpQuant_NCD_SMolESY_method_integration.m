
function [protein_integral] = NMRpQuant_NCD_SMolESY_method_integration(X, Y, region)
       
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
% Function to integrate specific spectral region 
% 
% 
% 
% Inputs
% X: PPM vector
% Y: Intensity data vector
% region: Min - Max PPM value of the region to be integtrated
%
% Outputs  
% protein_integral: integral of specified spectral region corresponding 
%                   Intensity data vector
%
%
% Last Updated: 12/01/2022  




    if size(region,1) == 1
        
        protein_integral = find_region_integrate(X,Y,region);
    else
        protein_integral(1:size(region,1),:) = zeros;
        for i = 1:size(region,1)
            protein_integral(i,1) = find_region_integrate(X,Y,region(i,:));
        end
    end
    

    
    
    