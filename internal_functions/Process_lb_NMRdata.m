function [NMRdata_Processed] = Process_lb_NMRdata(Folder1r1iprocs,lb_factor)
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
% Reading the real and inaginary part of processed 1D NMR spectra and 
% re-process with a different resolution
% 
% Inputs
% Folder1r1iprocs: The NMR folder containing the '1r', '1i', 'procs' files
%                  for each spectrum. 
% lb_factor: Line broadening mulitplication factor of the original lb value
%            read from the loaded NMR spectrum raw data 
%
% Outputs 
% NMRdata_Processed: Structure containing PPM vector (NMRdata_Processed.XAxis), 
%          and reprocessed Intensity Real (NMRdata_Processed.Data),
%          Imaginary data vectors (NMRdata_Processed.IData)
%          
%
% Last Updated: 21/02/2023  
%
% Algorithm contains also adapted parts from rbnmr.m function:
%
% Nils Nyberg, Copenhagen University, nn@sund.ku.dk
%
% 

    [NMRdata,Procs,ACQUS,filepath2] = readNMR_real_imag(Folder1r1iprocs);
    fa = fopen(fullfile(filepath2,'fid'),'r');
    switch ACQUS.BYTORDA
        case 0 
            read_bytes='l';
        case 1
            read_bytes='b';        
    end
    switch ACQUS.DTYPA
        case 0
            precision='int32';
        case 1
            precision='double';
        case 2
            precision='double';
    end   
    [fid] = fread(fa,precision,read_bytes);   
    fidreal = fid(1:2:length(fid)).*(2^(Procs.NC_proc));
    fidimag = fid(2:2:length(fid)).*(2^(Procs.NC_proc));
    FID  = complex(fidreal,fidimag);
    zf = length(NMRdata.Data)-length(FID);
    FID = [FID;zeros(zf,1)];
    xx = (0:length(FID)-1)/ACQUS.SW;
    lbf = (Procs.LB*lb_factor)/ACQUS.BF1 * pi;
    FID = FID.* exp(-lbf.*(xx)');
    FID = FID / exp(-lbf.*(xx(ACQUS.GRPDLY+1))');
    GrDel = (FID(1:ACQUS.GRPDLY));
    FID = [FID( (ACQUS.GRPDLY+1):length(FID))' GrDel']';
    ImagS = fftshift(fft(FID));
    ImagS = [ImagS(2:end);ImagS(1);];
    ImagS = ImagS.*exp(-Procs.PHC0/180*sqrt(-1)*pi - Procs.PHC1/180*sqrt(-1)*pi*flipud((0:length(FID)-1)')/length(FID));
    ImagD = -1*(flipud(imag(ImagS)));
    ImagD = (ImagD/(2^-Procs.NC_proc));%(1^Procs.NC_proc);
    REAL = (flipud(real(ImagS)))/(2^-Procs.NC_proc);
    IMAG = ImagD;
    NMRdata_Processed.XAxis = NMRdata.XAxis;
    NMRdata_Processed.IData = IMAG;%/RAT;
    NMRdata_Processed.Data = REAL;      
end



function [NMRdata,Procs,ACQUS,filepath2] = readNMR_real_imag(Folder1r1iprocs)

r1path = fullfile(Folder1r1iprocs,'1r');
i1path = fullfile(Folder1r1iprocs,'1i');
[filepath,~,~] = fileparts(Folder1r1iprocs);
[filepath2,~,~] = fileparts(filepath);
ACQUS = readnmrpar2(filepath2);
Procs = readnmrpar(Folder1r1iprocs);
%% Open and read file
if Procs.BYTORDP == 0
    endian = 'l';
else
    endian = 'b';
end

[FID, MESSAGE] = fopen(r1path,'r',endian);
if FID == -1
	disp(MESSAGE);
	error(['Error opening file (',r1path,').']);
end

A.Data = fread(FID,'int32');
fclose(FID);

%% Read imaginary data if the file 1i exists
if (exist(i1path,'file')==2)
    [FID, MESSAGE] = fopen(i1path,'r',endian);
    if FID == -1
        % Do nothing
    end
    A.IData = fread(FID,'int32');
    fclose(FID);
end    

%% Correct data for NC_proc-parameter
A.Data = A.Data/(2^-Procs.NC_proc);
if (isfield(A,'IData'))
    A.IData = A.IData/(2^-Procs.NC_proc);
end

%% Calculate x-axis
A.XAxis = linspace( Procs.OFFSET,Procs.OFFSET-Procs.SW_p./Procs.SF,Procs.SI)';
NMRdata = A;
end 


function Procs = readnmrpar(Folder1r1iprocs)
% Read file
Procs_file = fullfile(Folder1r1iprocs,'procs');

try
    A = textread(Procs_file,'%s','whitespace','\n');
    A{125} = '##$TI= <>';
    % Det. the kind of entry
    TypeOfRow = cell(length(A),2);

    R = {   ...
        '^##\$*(.+)=\ \(\d\.\.\d+\)(.+)', 'ParVecVal' ; ...
        '^##\$*(.+)=\ \(\d\.\.\d+\)$'   , 'ParVec'    ; ...
        '^##\$*(.+)=\ (.+)'             , 'ParVal'    ; ...
        '^([^\$#].*)'                   , 'Val'       ; ...
        '^\$\$(.*)'                     , 'Stamp'     ; ...
        '^##\$*(.+)='                   , 'EmptyPar'  ; ...
        '^(.+)'							, 'Anything'	...
        };

    for i = 1:length(A)
        for j=1:size(R,1)
            [s,t]=regexp(A{i},R{j,1},'start','tokens');
            if (~isempty(s))
                TypeOfRow{i,1}=R{j,2};
                TypeOfRow{i,2}=t{1};
            break;
            end
        end
    end
catch
    A = textread(Procs_file,'%s','whitespace','\n');
    
    % Det. the kind of entry
    TypeOfRow = cell(length(A),2);

    R = {   ...
        '^##\$*(.+)=\ \(\d\.\.\d+\)(.+)', 'ParVecVal' ; ...
        '^##\$*(.+)=\ \(\d\.\.\d+\)$'   , 'ParVec'    ; ...
        '^##\$*(.+)=\ (.+)'             , 'ParVal'    ; ...
        '^([^\$#].*)'                   , 'Val'       ; ...
        '^\$\$(.*)'                     , 'Stamp'     ; ...
        '^##\$*(.+)='                   , 'EmptyPar'  ; ...
        '^(.+)'							, 'Anything'	...
        };

    for i = 1:length(A)
        for j=1:size(R,1)
            [s,t]=regexp(A{i},R{j,1},'start','tokens');
            if (~isempty(s))
                TypeOfRow{i,1}=R{j,2};
                TypeOfRow{i,2}=t{1};
            break;
            end
        end
    end
end
    
    
% Set up the struct
i=0;
while i < length(TypeOfRow)
    i=i+1;
    switch TypeOfRow{i,1}
        case 'ParVal'
            LastParameterName = TypeOfRow{i,2}{1};
            Procs.(LastParameterName)=TypeOfRow{i,2}{2};
        case {'ParVec','EmptyPar'}
            LastParameterName = TypeOfRow{i,2}{1};
            Procs.(LastParameterName)=[];
        case 'ParVecVal'
            LastParameterName = TypeOfRow{i,2}{1};
            Procs.(LastParameterName)=TypeOfRow{i,2}{2};
        case 'Stamp'
            if ~isfield(Procs,'Stamp') 
                Procs.Stamp=TypeOfRow{i,2}{1};
            else
                Procs.Stamp=[Procs.Stamp ' ## ' TypeOfRow{i,2}{1}];
            end
        case 'Val'
			if isempty(Procs.(LastParameterName))
				Procs.(LastParameterName) = TypeOfRow{i,2}{1};
			else
				Procs.(LastParameterName) = [Procs.(LastParameterName),' ',TypeOfRow{i,2}{1}];
			end
        case {'Empty','Anything'}
            % Do nothing
    end
end
    

% Convert strings to values
Fields = fieldnames(Procs);

for i=1:length(Fields)
    DDD = Procs.(Fields{i});
    if isempty(DDD)
    else
        DDDD = str2num(DDD);
        if isempty(DDDD)
        else
            Procs.(Fields{i}) = DDDD;
        end
    end
end

end



function Acqus = readnmrpar2(Folder1r1iprocs)
% Read file
Acqus_file = fullfile(Folder1r1iprocs,'acqus');

try
    A = textread(Acqus_file,'%s','whitespace','\n');
    A{125} = '##$TI= <>';
    % Det. the kind of entry
    TypeOfRow = cell(length(A),2);

    R = {   ...
        '^##\$*(.+)=\ \(\d\.\.\d+\)(.+)', 'ParVecVal' ; ...
        '^##\$*(.+)=\ \(\d\.\.\d+\)$'   , 'ParVec'    ; ...
        '^##\$*(.+)=\ (.+)'             , 'ParVal'    ; ...
        '^([^\$#].*)'                   , 'Val'       ; ...
        '^\$\$(.*)'                     , 'Stamp'     ; ...
        '^##\$*(.+)='                   , 'EmptyPar'  ; ...
        '^(.+)'							, 'Anything'	...
        };

    for i = 1:length(A)
        for j=1:size(R,1)
            [s,t]=regexp(A{i},R{j,1},'start','tokens');
            if (~isempty(s))
                TypeOfRow{i,1}=R{j,2};
                TypeOfRow{i,2}=t{1};
            break;
            end
        end
    end
catch
    A = textread(Acqus_file,'%s','whitespace','\n');
    
    % Det. the kind of entry
    TypeOfRow = cell(length(A),2);

    R = {   ...
        '^##\$*(.+)=\ \(\d\.\.\d+\)(.+)', 'ParVecVal' ; ...
        '^##\$*(.+)=\ \(\d\.\.\d+\)$'   , 'ParVec'    ; ...
        '^##\$*(.+)=\ (.+)'             , 'ParVal'    ; ...
        '^([^\$#].*)'                   , 'Val'       ; ...
        '^\$\$(.*)'                     , 'Stamp'     ; ...
        '^##\$*(.+)='                   , 'EmptyPar'  ; ...
        '^(.+)'							, 'Anything'	...
        };

    for i = 1:length(A)
        for j=1:size(R,1)
            [s,t]=regexp(A{i},R{j,1},'start','tokens');
            if (~isempty(s))
                TypeOfRow{i,1}=R{j,2};
                TypeOfRow{i,2}=t{1};
            break;
            end
        end
    end
end
    
    
% Set up the struct
i=0;
while i < length(TypeOfRow)
    i=i+1;
    switch TypeOfRow{i,1}
        case 'ParVal'
            LastParameterName = TypeOfRow{i,2}{1};
            Acqus.(LastParameterName)=TypeOfRow{i,2}{2};
        case {'ParVec','EmptyPar'}
            LastParameterName = TypeOfRow{i,2}{1};
            Acqus.(LastParameterName)=[];
        case 'ParVecVal'
            LastParameterName = TypeOfRow{i,2}{1};
            Acqus.(LastParameterName)=TypeOfRow{i,2}{2};
        case 'Stamp'
            if ~isfield(Acqus,'Stamp') 
                Acqus.Stamp=TypeOfRow{i,2}{1};
            else
                Acqus.Stamp=[Acqus.Stamp ' ## ' TypeOfRow{i,2}{1}];
            end
        case 'Val'
			if isempty(Acqus.(LastParameterName))
				Acqus.(LastParameterName) = TypeOfRow{i,2}{1};
			else
				Acqus.(LastParameterName) = [Acqus.(LastParameterName),' ',TypeOfRow{i,2}{1}];
			end
        case {'Empty','Anything'}
            % Do nothing
    end
end
    

% Convert strings to values
Fields = fieldnames(Acqus);

for i=1:length(Fields)
    DDD = Acqus.(Fields{i});
    if isempty(DDD)
    else
        DDDD = str2num(DDD);
        if isempty(DDDD)
        else
            Acqus.(Fields{i}) = DDDD;
        end
    end
end

end
