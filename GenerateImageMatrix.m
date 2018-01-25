function [ imageMove ] = GenerateImageMatrix( dimension )
%GENERATEIMAGEMATRIX Summary of this function goes here
%   Detailed explanation goes here
imageMove=zeros((dimension(1)*2+1)*(dimension(2)*2+1)*(dimension(3)*2+1),3);
n=1;
for i=-dimension(1):dimension(1)
    for j=-dimension(2):dimension(2)
        for k=-dimension(3):dimension(3)
            imageMove(n,:)=[i j k];
            n=n+1;
        end
    end
end

end

