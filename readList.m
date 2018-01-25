function [ fileContent ] = readList( varargin )
% Read files line by line as text
%   readList( filename )
% Read last nEndStr string in text
%   readList( filename, nEndStr )
% Read file and add a blank line at top
%   readList( filename, 0 )
% Read file in the slow way but keep all blank lines
%   readList(filename, -1)
filename = varargin{1};
addLine = 0;
fid = fopen(filename,'r');
if(length(varargin) == 2)
    nEndStr = varargin{2};
    if(nEndStr == 0)
        addLine = 1;
    elseif(nEndStr == -1)
        % The old slow method
        lineContent=0;
        fileContent=[];
        i=1;
        while(isempty(lineContent)||lineContent(1) ~= -1)
            lineContent=fgetl(fid);
            fileContent=char(fileContent,num2str(lineContent));
            i=i+1;
        end
        fclose(fid);

        fileContent(end,:) = [];
        fileContent(1,:) = [];
        return
    else
    fseek(fid, -nEndStr, 'eof');
    end
elseif(length(varargin) > 2)
    disp('Wrong number of arg');
end

% row = 0;
% while ~feof(fid)
%     row = row + sum(fread(fid,10000,'*char')==char(10));
% end
% 

% while(isempty(lineContent)||lineContent(1) ~= -1)
%     lineContent=fgetl(fid);
%     fileContent=char(fileContent,num2str(lineContent));
%     i=i+1;
% end

delimiter = '';
formatSpec = '%s';
dataArray = textscan(fid, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fileContent = char(dataArray{1});
if(addLine == 1)
    fileContent = char('   ',fileContent);
end

fclose(fid);
end

