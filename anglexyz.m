function [ angles ] = anglexyz( Coordinates )
%ANGLEXYZ calculates the angle between a vector and xyz axis
%   Input: [Xa,Ya,Za;Xb,Yb,Zb;]
%   Output: [angleYOZ,angleXOZ,angleXOY]
angles3=angle3([Coordinates(1,:);...
                Coordinates(2,:);...
                Coordinates(1,1),Coordinates(2,2),Coordinates(2,3)]);
anglesX=angles3(1)*(Coordinates(2,1)-Coordinates(1,1))./norm(Coordinates(2,1)-Coordinates(1,1));
angles3=angle3([Coordinates(1,:);...
                Coordinates(2,:);...
                Coordinates(2,1),Coordinates(1,2),Coordinates(2,3)]);
anglesY=angles3(1)*(Coordinates(2,2)-Coordinates(1,2))./norm(Coordinates(2,2)-Coordinates(1,2));
angles3=angle3([Coordinates(1,:);...
                Coordinates(2,:);...
                Coordinates(2,1),Coordinates(2,2),Coordinates(1,3)]);
anglesZ=angles3(1)*(Coordinates(2,3)-Coordinates(1,3))./norm(Coordinates(2,3)-Coordinates(1,3));
angles=[anglesX,anglesY,anglesZ];            

end

