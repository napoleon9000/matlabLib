function [ newCooridinate ] = adjustBoundary( cooridinate,molecule_positons,a,b,c )
%ADJUSTBOUNDARY Adjust the atom postions to keep molecule as a whole part
%   Input: cooridinates of the system
%   Output: adjusted cooridinates
for i=1:size(cooridinate,1)
    if(molecule_positons(i,1)~=0)
        for k=1:3
            xDistance=(cooridinate(i,1)-cooridinate(molecule_positons(i,k),1));
            yDistance=(cooridinate(i,2)-cooridinate(molecule_positons(i,k),2));
            zDistance=(cooridinate(i,3)-cooridinate(molecule_positons(i,k),3));
            if(abs(xDistance)>a/2)
%                 disp('a')
%                 disp(cooridinate(i,1))
%                 disp(cooridinate(molecule_positons(i,k),1))
                cooridinate(molecule_positons(i,k),1)=cooridinate(molecule_positons(i,k),1)+a*(xDistance/abs(xDistance));
%                 disp(cooridinate(molecule_positons(i,k),1))
            end
            if(abs(yDistance)>b/2)
%                 disp('b')
%                 disp(cooridinate(i,2))
%                 disp(cooridinate(molecule_positons(i,k),2))
                cooridinate(molecule_positons(i,k),2)=cooridinate(molecule_positons(i,k),2)+b*(yDistance/abs(yDistance));
%                 disp(cooridinate(molecule_positons(i,k),2))
            end
            if(abs(zDistance)>c/2)
%                 disp('c')
%                 disp(cooridinate(i,3))
%                 disp(cooridinate(molecule_positons(i,k),3))
                cooridinate(molecule_positons(i,k),3)=cooridinate(molecule_positons(i,k),3)+c*(zDistance/abs(zDistance));
%                 disp(cooridinate(molecule_positons(i,k),3))
            end
        end
    end
end
newCooridinate=cooridinate;