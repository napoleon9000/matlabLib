function [ returnValue ] = writePOSCAR(filename,commentLine,scallingFactor,cellLength,elementName,atomNum, coordinate1 )
%WRITE POSCAR file
%   [ returnValue ] =
%   writePOSCAR(filename,commentLine,scallingFactor,cellLength,elementName,atomNum, coordinate1 );
fid=fopen(filename,'w');
if(fid == -1)
    disp('Can not create file')
    pause
end
fprintf(fid,'%s\n',commentLine);
fprintf(fid,'%s\n',num2str(scallingFactor));
for i=1:size(cellLength,1)
    fprintf(fid,'%s\n',num2str(cellLength(i,:)));
end
fprintf(fid,'%s\n',elementName);
fprintf(fid,'%s\n',num2str(atomNum));
fprintf(fid,'Cartesian\n');
%tic
for i=1:size(coordinate1,1)
    fprintf(fid,'%s\n',num2str(coordinate1(i,:)));
end
fclose(fid);
%toc
returnValue=0;
end

