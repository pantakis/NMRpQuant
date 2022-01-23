function [Tot_protein_Relative, X_fit, Y_fit, fitted_baseline, baseline_filtered1D] = NMRpQuant_Baseline_filter(X,Y)
        
   
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
%             baseline_filtered = fliplr(brushedDataR(:,2)-yfitR2);
%             baseline_filtered1D = Y_fit - baseline_filtered;
            
            baseline_filtered1D = fliplr(yfitR2);
end


function [ycorr,yfit] = base_fit_protein_linear(y,varargin)

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
                
    
    
    
    
    