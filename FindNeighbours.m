function [ neighbourList ] = FindNeighbours( coordinate1, centralAtom, atomType, cutoff, a1, b1, c1 )
%FINDNEIGHBOURS Summary of this function goes here
%   Detailed explanation goes here
neighbourList=[];
distanceM=zeros(size(coordinate1,1),1);
for i=1:size(coordinate1,1)
    distanceM(i)=AtomDistance( coordinate1(i,1:3), coordinate1(centralAtom,1:3), a1, b1, c1 );
    if(distanceM(i)>=cutoff(1)&&distanceM(i)<=cutoff(2)&&coordinate1(i,4)==atomType&&i~=centralAtom)
        neighbourList=[neighbourList i];
    end
end

end

