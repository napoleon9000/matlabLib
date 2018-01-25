function [ distance ] = AtomDistance( coordinate1, coordinate2, a1, b1, c1 )
%ATOMDISTANCE Calculate atomic distance in PBC
%   [ distance ] = AtomDistance( coordinate1, coordinate2, a1, b1, c1 )
%   coordinte1 can be a matrix while coordinate2 is a vector.
%   Or coordinate1 and 2 be matrix of same size.
size1 = size(coordinate1,1);
size2 = size(coordinate2,1);
if(size2 == 1)
    distanceVector = abs(coordinate1 - ones(size1,1)*coordinate2);
elseif(size2 > 1 && size2 == size1)
    distanceVector = abs(coordinate1 - coordinate2);
end
if(any(distanceVector(:,1) > 0.5*a1)) || (any(distanceVector(:,2) > 0.5*b1)) || (any(distanceVector(:,3) > 0.5*c1))
    distanceVector = distanceVector - floor(2*distanceVector.*(ones(size1,1)*[1/a1 1/b1 1/c1])).*(ones(size1,1)*[a1 b1 c1]);
end
% distanceVector=bsxfun(@minus,coordinate1,coordinate2);
% distanceVector=distanceVector-bsxfun(@times,fix((bsxfun(@times,2*distanceVector,[1/a1 1/b1 1/c1]))),[a1 b1 c1]);
distance=sqrt(sum(distanceVector.^2,2));
end

