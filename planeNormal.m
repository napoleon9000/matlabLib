function [ normal ] = planeNormal( Points )
%PLANENORMAL Calculate the plane normal
%   Input: [Point1;Point2;Point3]
%  Output: [vPlaneNormal]

Vector1=Points(2,:)-Points(1,:);
Vector2=Points(3,:)-Points(1,:);
normal=cross(Vector1,Vector2)./norm(cross(Vector1,Vector2));

end

