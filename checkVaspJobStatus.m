function [ status, energy ] = checkVaspJobStatus( folderName )
%CHECKVASPJOBSTATUS Check the vasp job status in a folder
%   [ status, energy ] = checkVaspJobStatus( folderName )
% status: 1 = finished correctly;
%         0 = didn't finish correctly;

status = 0;

% Read OUTCAR
OUTCAR_filepath = [folderName 'OUTCAR'];
if(~exist(OUTCAR_filepath,'file'))
    status = 0;
    energy = NaN;
    return
else
    OUTCAR_file = readList(OUTCAR_filepath);
    OUTCAR_row = OUTCAR_file';
    OUTCAR_row = OUTCAR_row(:)';
    if(strfind(OUTCAR_row,'reached required accuracy'));
        status = 1;
    else
        status = 0;
        energy = NaN;
    end
end

% Read OSZICAR
OSZICAR_filepath = [folderName 'OSZICAR'];
if(status)
    OSZICAR_file = readList(OSZICAR_filepath);
    expr = 'F= ([-+.E\d]*)';
    OSZICAR_sparse = regexp(OSZICAR_file(end,:),expr, 'tokens');
    energy = str2num(OSZICAR_sparse{1}{1});
end


end

