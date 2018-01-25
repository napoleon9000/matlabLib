function [ fileContent ] = readListSlow( filename )
% Read files line by line as text
%   readList( filename )


fid = fopen(filename);
lineContent=0;
fileContent=[];
i=1;
while(isempty(lineContent)||lineContent(1) ~= -1)
    lineContent=fgetl(fid);
    fileContent=char(fileContent,num2str(lineContent));
    i=i+1;
end
fclose(fid);

fileContent(end,:) = '';
fileContent(1,:) = '';
end


