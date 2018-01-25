function [ status ] =  writeBGF(filename, description, newFilename)
%% Convert POSCAR to geo file
% [ status ] =  writeBGF(filename, description, newFilename)
% 

% clear
% filename = 'POSCAR';
% description = 'test1';
% newFilename = 'geo1';
elementNameStr = ['O ';'Al'];
[ commentLine,scallingFactor,cellLength,elementName,atomNum, coordinate1 ] = readPOSCAR( filename );
atomNum = cumsum(atomNum);
coordinate1 = bsxfun(@times,coordinate1,[cellLength(1,1),cellLength(2,2),cellLength(3,3)]);
ElementNameListNum = ones(size(coordinate1,1),1);
for i = 2:length(atomNum)
    ElementNameListNum((atomNum(i-1)+1):atomNum(i)) = i;
end
% write file
fid = fopen(newFilename,'a');
fprintf(fid, 'XTLGRF 200\n');
if(length(description) > 8)
    fprintf(fid, ['DESCRP ' description(1:8) '\n']);
else
    fprintf(fid, ['DESCRP ' description '\n']);
end
fprintf(fid, 'CRYSTX %11.5f%11.5f%11.5f   90.00000   90.00000   90.00000\n',cellLength(1,1),cellLength(2,2),cellLength(3,3));
coordiFormat = 'HETATM %5d %s              %11.5f%10.5f%10.5f    %s  0 0  0.00000\n';
for i = 1:size(coordinate1,1)
    fprintf(fid, coordiFormat,i,elementNameStr(ElementNameListNum(i),:),coordinate1(i,1),coordinate1(i,2),coordinate1(i,3),elementNameStr(ElementNameListNum(i),:));
end
fprintf(fid,'END\n');
fprintf(fid,'\n');
status = fclose(fid);