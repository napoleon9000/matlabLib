function [ distance ] = AtomDistance1( coordinate1, coordinate2, a1, b1, c1 )
%ATOMDISTANCE Calculate atomic distance in PBC
%   [ distance ] = AtomDistance( coordinate1, coordinate2, a1, b1, c1 )
size1 = size(coordinate1,1);
distanceVector = coordinate1 - ones(size1,1)*coordinate2;
distanceVector = distanceVector - 2*distanceVector.*(ones(size1,1)*[1/a1 1/b1 1/c1]).*(ones(size1,1)*[a1 b1 c1]);
% distanceVector=bsxfun(@minus,coordinate1,coordinate2);
% distanceVector=distanceVector-bsxfun(@times,fix((bsxfun(@times,2*distanceVector,[1/a1 1/b1 1/c1]))),[a1 b1 c1]);
distance=sqrt(sum(distanceVector.^2,2));
end

