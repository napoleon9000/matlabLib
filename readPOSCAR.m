function [ commentLine,scallingFactor,cellLength,elementName,atomNum, coordinate1 ] = readPOSCAR( filename )
% Read large POSCAR file 
%   [ commentLine,scallingFactor,cellLength,elementName,atomNum, coordinate1 ] = readPOSCAR( filename )

fileID = fopen(filename,'r');
dataStr='';
charCount=0;
delimiter = ' ';
endStr = fgets(fileID);
endStr = fgets(fileID);
if(double(endStr(end)) == 10 && double(endStr(end - 1)) == 13)
    formatSpec = '%f%f%f%s%s%s\r\n';
elseif(double(endStr(end)) == 10 && double(endStr(end - 1)) ~= 13)
    formatSpec = '%f%f%f%s%s%s\n';
elseif(double(endStr(end)) == 13)
    formatSpec = '%f%f%f%s%s%s\r';
end
frewind(fileID);
for i=1:8
    lineContent=fgetl(fileID);    
    charCount=charCount+size(lineContent,2);
    dataStr=char(dataStr,num2str(lineContent));
end



if(size(dataStr,2) < 10)
    disp('Empty file');
    commentLine = [];
    scallingFactor = [];
    cellLength = [];
    elementName = [];
    atomNum = [];
    coordinate1 = [];
    return
end
commentLine=dataStr(2,:);
scallingFactor=str2num(dataStr(3,:));
cellLength(1,:)=str2num(dataStr(4,:));
cellLength(2,:)=str2num(dataStr(5,:));
cellLength(3,:)=str2num(dataStr(6,:));
elementName=dataStr(7,:);
atomNum=str2num(dataStr(8,:));
switchLine=dataStr(9,:);

if(switchLine(1)=='D'||switchLine(1)=='C')
    startRow = 8;
elseif(switchLine(1)=='S'||switchLine(1)=='s')
   startRow = 9;
   formatSpec = '%f%f%f%s%s%s';
else
    disp('Can not read POSCAR');
end
frewind(fileID) 
dataArray = textscan(fileID, formatSpec,sum(atomNum), 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'HeaderLines' ,startRow, 'ReturnOnError', false);
fclose(fileID);
coordinate1 = cell2mat(dataArray(:,1:3));
coordinate1=coordinate1*scallingFactor;

if(~any(coordinate1 > 1))
    coordinate1 = coordinate1*cellLength;
end

end

