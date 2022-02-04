function YOutput = Align_data(X,Y,center,radius)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright to Dr. Panteleimon G. Takis, 2022                           % 
%                                                                       %
% National Phenome Centre and Imperial Clinical Phenotyping Centre,     %
% Department of Metabolism, Digestion and Reproduction, IRDB Building,  %
% Imperial College London, Hammersmith Campus,                          %
% London, W12 0NN, United Kingdom                                       %     
% This program is free software: you can redistribute it and/or modify  %
% it under the terms of the GNU General Public License as published by  %
% the Free Software Foundation, either version 3 of the License, or     %
% (at your option) any later version.                                   %
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
% Peak Calibration algorithm of processed 1D NMR spectra to a reference
% value taking into account the highest intesity peak in hte defined
% spectra region.
% 
% Inputs
% X: PPM data vector
% Y: Intenstity data vector
% center: PPM value for calibrating ref. peak 
% Radius: ± PPM value for searching the max intensity peak from the center
%
% Outputs
% YOutput: Calibrated Intensity data vector at a ref. PPM position
%
%

Spectra = size(Y,1);

for i = 1:Spectra    
   
    try
        [~,ii] = find(X(i,:) > (center-radius) & X(i,:) < (center+radius));
        mikos = length(X(i,:));
        elaxisto = min(X(i,:));
        %elaxisto = abs(elaxisto);
        megisto = max(X(i,:));
        X1 = X(i,ii);
    catch
        [~,ii] = find(X(1,:) > (center-radius) & X(1,:) < (center+radius));
        mikos = length(X(1,:));
        elaxisto = min(X(1,:));
        %elaxisto = abs(elaxisto);
        megisto = max(X(1,:));
        X1 = X(1,ii);
    end
        RRR = Y(i,ii);        
        ola = megisto - elaxisto;
        ena_ppm(i,1) = mikos/ola;        
        clearvars  mikos ola megisto elaxisto ii
        MAX1 = max(nonzeros(RRR(1,:)));
        [~,col1]=find(RRR(1,:)==MAX1(1,1));
        MAXES(i,1) = X1(:,col1(1,1));
        E(i,:) = abs(center - MAXES(i,1));
        E1(i,:) = E(i,1) * ena_ppm(i,1);
        clearvars X2 row1 col1 row2 col2 RRR22 RRR
        D = MAXES(i,1);
        if (D < center)
            Y_align(i,:) = Circulate_shiftNMR(Y(i,:),-E1(i,:));            
        elseif (D > center)
            Y_align(i,:) = Circulate_shiftNMR(Y(i,:),+E1(i,:));            
        elseif (D == center)
            Y_align(i,:) = Circulate_shiftNMR(Y(i,:),0);            
        end % shifting
        clearvars D 

end


YOutput = Y_align;
end


function y_data = Circulate_shiftNMR(x_data,ppm_points)

% Adapted by Dr. Panteleimon G. Takis from:
%
% FSHIFT Fractional circular shift
%   Syntax:
%
%       >> y = fshift(x,s)
%
%   FSHIFT circularly shifts the elements of vector x by a (possibly
%   non-integer) number of elements s. FSHIFT works by applying a linear
%   phase in the spectrum domain and is equivalent to CIRCSHIFT for integer
%   values of argument s (to machine precision).

% Author:   François Bouffard
%           fbouffard@gmail.com



    existing_test = 0; 
    if size(x_data,1) == 1
        x_data = x_data(:); 
        existing_test = 1; 
    end
    N = size(x_data,1); 
    Round_closest = floor(N/2)+1; 
    f = ((1:N)-Round_closest)/(N/2); 
    p = exp(-1j*ppm_points*pi*f).'; 
    y_data = ifft(fft(x_data).*ifftshift(p)); 
    if isreal(x_data)
        y_data = real(y_data); 
    end
    if existing_test
        y_data = y_data.'; 
    end
end