function [ CO3Coordinate ] = CorrelateCO3( coordinate,ONumber,CaNumber,CNumber,a1,b1,c1, cutoff )
%CORRELATECO3 Summary of this function goes here
%   Detailed explanation goes here
%[coordinate,ONumber,CaNumber,CNumber,a1,b1,c1]=loadPOSCAR(fileName);
CO3Coordinate=zeros(size(coordinate));
OSerial=1:ONumber;
CSerial=ONumber+CaNumber+1:ONumber+CaNumber+CNumber;
for i=CSerial
    k=1;
    for j=OSerial
        xDistance=abs(coordinate(i,1)-coordinate(j,1));
        xDistance=abs(xDistance-a1*round(xDistance/a1));
        yDistance=abs(coordinate(i,2)-coordinate(j,2));
        yDistance=abs(yDistance-b1*round(yDistance/b1));
        zDistance=abs(coordinate(i,3)-coordinate(j,3));
        zDistance=abs(zDistance-c1*round(zDistance/c1));
        CODistance=norm([xDistance,yDistance,zDistance]);
        if(CODistance < cutoff)
            CO3Coordinate(i,k)=j;
            k=k+1;
        end
    end
end

end

