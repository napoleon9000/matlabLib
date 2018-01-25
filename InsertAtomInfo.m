function [ coordinate1 ] = InsertAtomInfo( coordinate1, atom1, atom2, atom3 )
%INSERTATOMINFO Summary of this function goes here
%   Detailed explanation goes here
coordinate1(1:atom1,4)=1;
coordinate1((atom1+1):(atom1+atom2),4)=2;
coordinate1((atom1+atom2+1):(atom1+atom2+atom3),4)=3;

end

