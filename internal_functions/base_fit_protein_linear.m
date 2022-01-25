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