function [ coordinate1,atom1,atom2,atom3,a1,b1,c1 ] = loadPOSCAR( filename )
% Read small POSCAR file
file=fopen(filename,'r');
lineContent=0;
dataStr1='';
while(lineContent~=-1)                  %%Reading POSCAR1 File
    lineContent=fgetl(file);
    dataStr1=char(dataStr1,num2str(lineContent));
end
fclose(file);
dataStr1(dataStr1=='F')=' ';            %% Delete F and T
dataStr1(dataStr1=='T')=' ';

                                        %Extract data from POSCAR1
data1=zeros(size(dataStr1,1),3);
for i=1:size(dataStr1)
    if(~isempty(str2num(dataStr1(i,:))))
        data1(i,:)=str2num(dataStr1(i,:));
    end
end
data1(end,:)=[];
atom1=data1(8,1);
atom2=data1(8,2);
atom3=data1(8,3);
atomNum1=sum(data1(8,:));

a1=data1(4,1);                            % cell parameters
b1=data1(5,2);
c1=data1(6,3);
if(dataStr1(10)=='D')
    coordinate1=data1(11:10+atomNum1,:);              % extract coordinates of atoms that need to calculate
    coordinate1=[a1*coordinate1(:,1),b1*coordinate1(:,2),c1*coordinate1(:,3)];
elseif(dataStr1(9)=='D')
    coordinate1=data1(10:9+atomNum1,:);              % extract coordinates of atoms that need to calculate
    coordinate1=[a1*coordinate1(:,1),b1*coordinate1(:,2),c1*coordinate1(:,3)];
elseif(dataStr1(10)=='C')
    coordinate1=data1(11:10+atomNum1,:);              % extract coordinates of atoms that need to calculate
elseif(dataStr1(9)=='C')
    coordinate1=data1(10:9+atomNum1,:);              % extract coordinates of atoms that need to calculate   
else
    disp('Can not read POSCAR');
end



