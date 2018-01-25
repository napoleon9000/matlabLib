function [ angle ] = angle3( Coordinates )
%ANGLE3 calculates each angle of a triangle
%   Input: [Xa,Ya,Za;Xb,Yb,Zb;Xc,Yc,Zc;]
%   Output: [angleA;angleB;angleC]
vectorA=Coordinates(3,:)-Coordinates(2,:);
vectorB=Coordinates(3,:)-Coordinates(1,:);
vectorC=Coordinates(2,:)-Coordinates(1,:);
a=norm(vectorA);
b=norm(vectorB);
c=norm(vectorC);
angleA=360./2./pi*(acos((c^2+b^2-a^2)/2./b./c));
angleB=360./2./pi*(acos((a^2+c^2-b^2)/2./a./c));
angleC=360./2./pi*(acos((a^2+b^2-c^2)/2./a./b));
if(a==0)
    angleA=0;
    angleB=90;
    angleC=90;
end
if(b==0)
    angleA=90;
    angleB=0;
    angleC=90;
end
if(c==0)
    angleA=90;
    angleB=90;
    angleC=0;
end
angle=[angleA,angleB,angleC];
end

