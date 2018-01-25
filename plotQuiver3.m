function [ H ] = plotQuiver3( position, quiverArrow, atom1, atom2, atom3, a1, b1, c1, scalebar, scale1, scale2, scale3 )
%PLOTQUIVER3 Summary of this function goes here
%   Detailed explanation goes here
hold on
grid on
box on
axis equal
axis([0 a1 0 b1 0 c1]);

plot3(position(1:atom1,1),position(1:atom1,2),position(1:atom1,3),'ro');
plot3(position((atom1+1):(atom1+atom2),1),position((atom1+1):(atom1+atom2),2),position((atom1+1):(atom1+atom2),3),'go');
plot3(position((atom1+atom2+1):(atom1+atom2+atom3),1),position((atom1+atom2+1):(atom1+atom2+atom3),2),position((atom1+atom2+1):(atom1+atom2+atom3),3),'ko');

quiver3([position(1:atom1,1);0],[position(1:atom1,2);0],[position(1:atom1,3);0],[quiverArrow(1:atom1,1);scalebar],[quiverArrow(1:atom1,2);scalebar],[quiverArrow(1:atom1,3);scalebar],scale1,'r');
quiver3([position(atom1+1:atom1+atom2,1);1],[position(atom1+1:atom1+atom2,2);1],[position(atom1+1:atom1+atom2,3);1],[quiverArrow(atom1+1:atom1+atom2,1);scalebar],[quiverArrow(atom1+1:atom1+atom2,2);scalebar],[quiverArrow(atom1+1:atom1+atom2,3);scalebar],scale2,'g');
quiver3([position(atom1+atom2+1:atom1+atom2+atom3,1);2],[position(atom1+atom2+1:atom1+atom2+atom3,2);2],[position(atom1+atom2+1:atom1+atom2+atom3,3);2],[quiverArrow(atom1+atom2+1:atom1+atom2+atom3,1);scalebar],[quiverArrow(atom1+atom2+1:atom1+atom2+atom3,2);scalebar],[quiverArrow(atom1+atom2+1:atom1+atom2+atom3,3);scalebar],scale3,'k');
legend('O','Ca','C');


end

