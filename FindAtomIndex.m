function [ atomIndex ] = FindAtomIndex( coordinate1,targetPosition, error )
%FINDATOMNUMBER Summary of this function goes here
%   Detailed explanation goes here
atomIndex=[];
for i=1:size(coordinate1,1)
    if(norm(coordinate1(i,:)-targetPosition)<error)
        atomIndex=[atomIndex,i];
    end
end

end

