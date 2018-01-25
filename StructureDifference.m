clear
clc
fileName1='F:\SPG\LiCoO2\cluster\K1-re\clusterLi37Co6O26_3+U5.2\CONTCAR';
fileName2='F:\SPG\LiCoO2\cluster\K1-re\clusterLi37Co6O26_3+\CONTCAR';

scale1=1;
scale2=0.6;
scale3=0.6;

file=fopen(fileName1,'r');
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


file=fopen(fileName2,'r');
lineContent=0;
dataStr2='';
while(lineContent~=-1)                  %%Reading POSCAR2 File
    lineContent=fgetl(file);
    dataStr2=char(dataStr2,num2str(lineContent));
end
fclose(file);
dataStr2(dataStr2=='F')=' ';
dataStr2(dataStr2=='T')=' ';
                                        %Extract data from POSCAR2
data2=zeros(size(dataStr2,1),3);
for i=1:size(dataStr2,1)
    if(~isempty(str2num(dataStr2(i,:))))
        data2(i,:)=str2num(dataStr2(i,:));
    end
end
data2(end,:)=[];
atomNum2=sum(data2(8,:));
%coordinate2=data2(11:10+atomNum2,:);             % extract coordinates of atoms that need to calculate
a2=data2(4,1);                            % cell parameters
b2=data2(5,2);
c2=data2(6,3);

if(dataStr2(10)=='D')
    coordinate2=data2(11:10+atomNum2,:);              % extract coordinates of atoms that need to calculate
    coordinate2=[a2*coordinate2(:,1),b2*coordinate2(:,2),c2*coordinate2(:,3)];
elseif(dataStr2(9)=='D')
    coordinate2=data2(10:9+atomNum2,:);              % extract coordinates of atoms that need to calculate
    coordinate2=[a2*coordinate2(:,1),b2*coordinate2(:,2),c2*coordinate2(:,3)];
elseif(dataStr2(10)=='C')
    coordinate2=data2(11:10+atomNum2,:);              % extract coordinates of atoms that need to calculate
elseif(dataStr2(9)=='C')
    coordinate2=data2(10:9+atomNum2,:);              % extract coordinates of atoms that need to calculate   
else
    disp('Can not read POSCAR');
end




if(a1~=a2||b1~=b2||c1~=c2||atomNum1~=atomNum2)
    disp('The cell parameters does not match');
end
dcoordinate=coordinate2-coordinate1;
hold on;
grid on;
axis equal

quiver3([coordinate1(1:atom1,1);0],[coordinate1(1:atom1,2);0],[coordinate1(1:atom1,3);0],[dcoordinate(1:atom1,1);.1],[dcoordinate(1:atom1,2);.1],[dcoordinate(1:atom1,3);.1],scale1,'r');
quiver3([coordinate1(atom1+1:atom1+atom2,1);1],[coordinate1(atom1+1:atom1+atom2,2);1],[coordinate1(atom1+1:atom1+atom2,3);1],[dcoordinate(atom1+1:atom1+atom2,1);.1],[dcoordinate(atom1+1:atom1+atom2,2);.1],[dcoordinate(atom1+1:atom1+atom2,3);.1],scale2,'g');
quiver3([coordinate1(atom1+atom2+1:atom1+atom2+atom3,1);2],[coordinate1(atom1+atom2+1:atom1+atom2+atom3,2);2],[coordinate1(atom1+atom2+1:atom1+atom2+atom3,3);2],[dcoordinate(atom1+atom2+1:atom1+atom2+atom3,1);.1],[dcoordinate(atom1+atom2+1:atom1+atom2+atom3,2);.1],[dcoordinate(atom1+atom2+1:atom1+atom2+atom3,3);.1],scale3,'k');
legend('O','Ca','C');

plot3(coordinate2(1:data2(8,1),1),coordinate2(1:data2(8,1),2),coordinate2(1:data2(8,1),3),'ro');
plot3(coordinate2(data2(8,1)+1:data2(8,1)+data2(8,2),1),coordinate2(data2(8,1)+1:data2(8,1)+data2(8,2),2),coordinate2(data2(8,1)+1:data2(8,1)+data2(8,2),3),'go');
plot3(coordinate2(data2(8,2)+data2(8,1)+1:data2(8,2)+data2(8,1)+data2(8,3),1),coordinate2(data2(8,2)+data2(8,1)+1:data2(8,2)+data2(8,1)+data2(8,3),2),coordinate2(data2(8,2)+data2(8,1)+1:data2(8,2)+data2(8,1)+data2(8,3),3),'ko');
%{
%}
plot3(coordinate1(1:data1(8,1),1),coordinate1(1:data1(8,1),2),coordinate1(1:data1(8,1),3),'r*');
plot3(coordinate1(data1(8,1)+1:data1(8,1)+data1(8,2),1),coordinate1(data1(8,1)+1:data1(8,1)+data1(8,2),2),coordinate1(data1(8,1)+1:data1(8,1)+data1(8,2),3),'g*');
plot3(coordinate1(data1(8,2)+data1(8,1)+1:data1(8,2)+data1(8,1)+data1(8,3),1),coordinate1(data1(8,2)+data1(8,1)+1:data1(8,2)+data1(8,1)+data1(8,3),2),coordinate1(data1(8,2)+data1(8,1)+1:data1(8,2)+data1(8,1)+data1(8,3),3),'k*');


title('The difference of SFE slab with full relaxtion and X Y axis constrains');
axis([0 a1 0 b1 0 c1]);