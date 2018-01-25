function [ coordinate1 ] = boundaryCorrect( OrigCoor,coordinate1,move,cellLength )
%BOUNDARYCORRECT Summary of this function goes here
%   Detailed explanation goes here

diffCoor=coordinate1-OrigCoor;
for i=1:size(diffCoor,1)
    if(abs(diffCoor(i,2))<0.5)
        continue
    elseif(abs(diffCoor(i,2)+cellLength)<0.5)
        coordinate1(i,2)=coordinate1(i,2)+cellLength;
    elseif(abs(diffCoor(i,2)-cellLength)<0.5)
        coordinate1(i,2)=coordinate1(i,2)-cellLength;
    elseif(abs(diffCoor(i,2)+cellLength-move)<0.5)
        coordinate1(i,2)=coordinate1(i,2)+cellLength;
    elseif(abs(diffCoor(i,2)-cellLength-move)<0.5)
        coordinate1(i,2)=coordinate1(i,2)-cellLength;
    end
        
end

end

