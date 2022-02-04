function plot_the_rest(primary_tex,h1,h2,flag_for_filter)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright to Dr. Panteleimon G. Takis, 2022                           % 
%                                                                       %
% National Phenome Centre and Imperial Clinical Phenotyping Centre,     %
% Department of Metabolism, Digestion and Reproduction, IRDB Building,  %
% Imperial College London, Hammersmith Campus,                          %
% London, W12 0NN, United Kingdom                                       %
%                                                                       $
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

% Internal function of NMRpQuant.m (GUI) : managing plot axes for selecting
%                                          specific lines to plot by mouse
%                                          selecting spectra titles from the
%                                          UI_table
% Last Updated: 12/01/2022  

    
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
