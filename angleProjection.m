function [ angles ] = angleProjection( Coordinates )
%ANGLEPROJECTION Project the angle into difference plane and calculate the
%angle with axis.
%   Input: [Xa,Ya,Za;Xb,Yb,Zb;]
%   Output: [angleYZY,angleXZX,angleXYX]
pointVector=Coordinates(2,:)-Coordinates(1,:);

xSign=pointVector(1)/abs(pointVector(1));
ySign=pointVector(2)/abs(pointVector(2));
zSign=pointVector(3)/abs(pointVector(3));
anglesYZY3=angle3([0 0 0;0,pointVector(2),pointVector(3);0,pointVector(2),0]);
% anglesYZY=(180*(-pointVector(2)/abs(pointVector(2))/2+1/2)+...
%     angle3([0 0 0;0,pointVector(2),pointVector(3);0,pointVector(2),0])...
%     *pointVector(2)/abs(pointVector(2)))*...
%     (pointVector(3)/abs(pointVector(3)));
anglesYZY=(180*(-ySign/2+0.5)+anglesYZY3(1)*ySign)*zSign;

anglesXZX3=angle3([0 0 0;pointVector(1),0,pointVector(3);pointVector(1),0,0]);
% anglesXZX=(180*(-pointVector(1)/abs(pointVector(1))/2+1/2)+...
%     angle3([0 0 0;pointVector(1),0,pointVector(3);pointVector(1),0,0])...
%     *pointVector(1)/abs(pointVector(1)))*...
%     (pointVector(3)/abs(pointVector(3))); 
anglesXZX=(180*(-xSign/2+0.5)+anglesXZX3(1)*xSign)*zSign;

anglesXYX3=angle3([0 0 0;pointVector(1),pointVector(2),0;pointVector(1),0,0]);
% anglesXYX=(180*(-pointVector(1)/abs(pointVector(1))/2+1/2)+...
%     angle3([0 0 0;pointVector(1),pointVector(2),0;pointVector(1),0,0])...
%     *pointVector(1)/abs(pointVector(1)))*...
%     (pointVector(2)/abs(pointVector(2)));
anglesXYX=(180*(-xSign/2+0.5)+anglesXYX3(1)*xSign)*ySign;

angles=[anglesYZY(1),anglesXZX(1),anglesXYX(1)];
end

