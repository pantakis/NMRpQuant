function showTitle(aLineH, eventdata, LineH, TitleH, LineH2, LineH3, flag_for_filter) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright to Dr. Panteleimon G. Takis, 2022                           % 
%                                                                       %
% National Phenome Centre and Imperial Clinical Phenotyping Centre,     %
% Department of Metabolism, Digestion and Reproduction, IRDB Building,  %
% Imperial College London, Hammersmith Campus,                          %
% London, W12 0NN, United Kingdom                                       %
%                                                                       %
%                                                                       %
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
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Internal function of NMRpQuant.m (GUI) : managing plot axes for       
%                                          highlighting selected line   
%                                          by mouse click and display   
%                                          its title on the plot        
% Last Updated: 12/01/2022                                                                                                                     


    TitleH.String    = aLineH.DisplayName;
    set(LineH,'LineWidth',0.5);
    set(aLineH,'LineWidth',1.5)    
    uistack(aLineH, 'top');    
    plot_the_rest(TitleH,LineH2,LineH3,flag_for_filter)    
end