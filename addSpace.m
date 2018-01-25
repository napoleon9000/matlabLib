function [ data ] = addSpace( data )
% Add space between two numbers

spacePosition = (data == ' ');
dotPosition = (data == '.');
posDiff = dotPosition-spacePosition;
for i = 2:size(posDiff,1)
    digit1 = 0;
    digit2 = 0;
    spaceLength = 0;
    digit1Pos = 0;
    for j = 1:size(posDiff,2)
        if(posDiff(i,j) ~= 0);
            digit2 = posDiff(i,j);
            if(digit1 == digit2&&(j-digit1Pos) > 1)
                data(i,j-4) = ' ';
                break
            else
                digit1 = digit2;
                digit1Pos = j;
            end
        end        
    end
end

end

