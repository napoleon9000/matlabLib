function [ energy ] = AtomicPotentialEnergy( distance, charge1, charge2 )
%ATOMICPOTENTIALENERGY Summary of this function goes here
%   Detailed explanation goes here
constK=9e-2;                                    % nN*A^2*C^-2
%constK=1;
energy=charge1*charge2*constK/distance;

end

