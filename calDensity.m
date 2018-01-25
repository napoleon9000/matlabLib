function [ density ] = calDensity( vol, atomNum, atomWeight, mode )
%CALDENSITY calculate the density of a system
%   [ density ] = calDensity( vol, atomNum, atomWeight, mode )
%   mode: 1. vol in A^3, atomWeight in g/mol
switch mode
    case 1
        Na = 6.023E-1;
        density = sum(atomNum.*atomWeight)/Na/vol;
    otherwise
        disp('Wrong mode');
end

end

