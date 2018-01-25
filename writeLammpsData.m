function [ returnValue ] = writeLammpsData(commentLine,atomNum, cellLength,charge, coordinate1, filename)
% Write lammps data file in a slow way
% writeLammpsData(commentLine,atomNum,cellLength,charge, coordinate1, filename);

newFilename = filename;
fid = fopen(newFilename,'w');
fprintf(fid,'%s\n',['# ' commentLine]);
fprintf(fid,'%s\n',[num2str(sum(atomNum)),' ','atoms']);
fprintf(fid,'%s\n',[num2str(length(atomNum)),' ','atom types']);
if(size(cellLength,2) == 2)
    fprintf(fid,'%s\n',[ num2str(cellLength(1,:)),' xlo xhi']);
    fprintf(fid,'%s\n',[ num2str(cellLength(2,:)),' ylo yhi']);
    fprintf(fid,'%s\n',[ num2str(cellLength(3,:)),' zlo zhi']);
end
if(size(cellLength,2) == 3)
    fprintf(fid,'%s\n',['0 ' num2str(cellLength(1,1)),' xlo xhi']);
    fprintf(fid,'%s\n',['0 ' num2str(cellLength(2,2)),' ylo yhi']);
    fprintf(fid,'%s\n',['0 ' num2str(cellLength(3,3)),' zlo zhi']);
    if(sum(sum(abs(tril(cellLength,1)))) > 1e-6)
        fprintf(fid,'%s\n',[ num2str(cellLength(2,1)),' ',num2str(cellLength(3,1)),' ',num2str(cellLength(3,2)),' xy xz yz']);
    end
end
fprintf(fid,'%s\n',' ');
fprintf(fid,'%s\n','Atoms');
fprintf(fid,'%s\n',' ');
data = zeros(size(coordinate1,1),3);
data(:,1) = 1:size(coordinate1,1);
startIdx = 1;
endIdx = 0;
for i = 1:length(atomNum) 
    endIdx = endIdx+atomNum(i);
    data(startIdx:endIdx,2) = i;
    startIdx = startIdx+atomNum(i);
end
data(:,3) = charge;
data = [data coordinate1];
for i = 1:size(coordinate1,1)
    fprintf(fid,'%s\n',num2str(data(i,:)));
end
returnValue = fclose(fid);

end
