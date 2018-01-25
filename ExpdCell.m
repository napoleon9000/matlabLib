function [ expdCoordinate, a1, b1, c1 ] = ExpdCell( coordinate, a1, b1, c1, cutoff )
%EXPDCELL Expand the cell according to cutoff distance
%   input: coordinate, a1, b1, c1, cutOff
expdNum=[ceil(2*cutoff/a1),ceil(2*cutoff/b1),ceil(2*cutoff/c1)];
origAtomNum=size(coordinate,1);
expdCoordinate=repmat(coordinate,(expdNum(1)*expdNum(2)*expdNum(3)),1);
moveMatrix=expdCoordinate;
moveMatrix(:,:)=0;
pointer=1;
for i=1:expdNum(1)
    for j=1:expdNum(2)
        for k=1:expdNum(3)
            moveVector=[(i-1)*a1,(j-1)*b1,(k-1)*c1,0];
            repMoveVector=repmat(moveVector,origAtomNum,1);
            moveMatrix(pointer:(pointer+origAtomNum-1),:)=repMoveVector;
            pointer=pointer+origAtomNum;
        end
    end
end
expdCoordinate=expdCoordinate+moveMatrix;
a1=a1*expdNum(1);
b1=b1*expdNum(2);
c1=c1*expdNum(3);
end

