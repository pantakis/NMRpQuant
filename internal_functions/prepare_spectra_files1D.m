
function [list_of_spectra_1D,display_names] = prepare_spectra_files1D(Spectra_1D_folder)

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
% Collect list of unique NMR spectra folders to read
% 
% 
% Inputs
% Spectra_1D_folder: The parent folder containing all NMR spectra folders
%
% Outputs 
% list_of_spectra_1D: list of NMR spectral folders
%          
%
% Last Updated: 12/12/2022



    [list_of_spectra_1D,display_names] = Take_spectra_folders(Spectra_1D_folder);

end

function [Spectra_folders,display_names] = Take_spectra_folders(parentDir)

    files    = dir(parentDir);
    names    = {files.name};
    dirFlags = [files.isdir] & ~strcmp(names, '.') & ~strcmp(names, '..');
    Spectra_folders = transpose(names(dirFlags));
    Index = find(contains(Spectra_folders,'_'));
    display_names = Spectra_folders;
    for i = 1:length(Index)
        K = display_names(Index(i));
        display_names(Index(i)) = {strrep(char(K{1}),'_',' ')};
    end
end