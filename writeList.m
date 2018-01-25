function [ retureValue ] = writeList( filename, fileContent )
% Write files line by line as text
%   writeList( filename, fileContent );
fid = fopen(filename,'w');
if(fid == -1)
    disp(['Can not create file with name: ' filename]);
    return
end
for i = 1:size(fileContent,1)
    fprintf(fid,'%s\n',fileContent(i,:));
end
retureValue = fclose(fid);

end

