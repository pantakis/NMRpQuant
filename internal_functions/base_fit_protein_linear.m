function [ycorr,yfit] = base_fit_protein_linear(y,varargin)

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
% Fitting spectral baseline by linear interpolation
% 
% Inputs
% y: Intensity data for each spectral region 
% varargin: 1) interpolation method (herein linear) 
%           2) index of points for linear fitting of y data
%
% Outputs
% ycorr: residuals data vector
% yfit: Fitted baseline data 
%
%
% Last Updated: 15/01/2022  
%
%

% Adapted from bf.m (Mirko Hrovat (2022). Baseline Fit (https://www.mathworks.com/matlabcentral/
% fileexchange/24916-baseline-fit), MATLAB Central File Exchange. Retrieved February 4, 2022.)
% Copyright 2009 Mirtech, Inc.
% Created by    Mirko Hrovat    08/01/2009  contact:mhrovat@email.com



def_method  = 'linear';
def_avgpts  = 3;

method = [];
avgpts = [];
pts    = [];

for n = 2:nargin
    f = varargin{n-1};
    if ischar(f)
        method = f;
    elseif isnumeric(f) && numel(f) == 1
        avgpts = f;
    elseif isnumeric(f) && numel(f) > 1
        pts = f;
    elseif isempty(f)
        continue
    end
end
if isempty(method)
    method = def_method;        
end
if isempty(avgpts)
    avgpts = def_avgpts;        
end
dimy = size(y);
lst = dimy(1);
newdimy = [dimy(1),prod(dimy(2:end))];
y = reshape(y,newdimy);
x = 1:lst;
ok = false;  
while ~ok
    pts = sort(pts);
    pts(diff(pts)==0) = [];         
    if pts(1)~=1
        pts = [1,pts];          
    end     
    if pts(end)~=lst
        pts = [pts,lst];
    end     
    npts = numel(pts);
    pss = zeros(npts,2);
    pss(:,1) = pts - floor(avgpts/2);
    pss(:,2) = pss(:,1) + avgpts;
    pss(pss < 1) = 1;
    pss(pss > lst) = lst;
    yavg = zeros([npts,newdimy(2)]);
    for n = 1:npts
        yavg(n,:) = mean(y(pss(n,1):pss(n,2),:),1);
    end
    yfit = interp1(pts,yavg,x,method);
    if size(yfit,1) ==1   
        yfit = shiftdim(yfit,1);  
    end
    ok = true;
end
ycorr = y - yfit;
ycorr = reshape(ycorr,dimy);
yfit = reshape(yfit,dimy);

end