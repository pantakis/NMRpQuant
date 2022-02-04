function [integral] = find_region_integrate(X,Y,spectrum_regions)

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
% Finding spectral ppm region and integrate the corresponding intensity
% data
% 
% Inputs
% X: PPM vector
% Y: Intensity data
% spectrum_regions: vector with the min max ppm value of a specific
%                   spectral region
%
% Outputs 
% integral: Area (integral) of the defined spectral region
%
% Last Updated: 12/01/2022  

        [~,ii] = find(X > min(spectrum_regions) & X < max(spectrum_regions));
        integral = abs(trapz(X(1,ii),Y(1,ii)));
end