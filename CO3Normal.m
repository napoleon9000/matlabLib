function [ normalVector,averageDeviateAngle ] = CO3Normal( coordinate )
%CO3NORMAL Gives the normal vector of CO3 plane and its deviation with
%perfect plane
%   Input:[O_coordinate;C1-C3_coordinate]
%  Output:[Normal_vector,average_deviate_angle]
normalVector1=planeNormal([coordinate(1,:);coordinate(2,:);coordinate(3,:)]);
normalVector2=planeNormal([coordinate(1,:);coordinate(3,:);coordinate(4,:)]);
normalVector3=planeNormal([coordinate(1,:);coordinate(4,:);coordinate(2,:)]);
normalVector=(normalVector1+normalVector2+normalVector3)./3;
deviateAngle1=angle3([0 0 0;normalVector;normalVector1]);
deviateAngle2=angle3([0 0 0;normalVector;normalVector2]);
deviateAngle3=angle3([0 0 0;normalVector;normalVector3]);
averageDeviateAngle=(deviateAngle1(1)+deviateAngle2(1)+deviateAngle3(1))./3;
end

