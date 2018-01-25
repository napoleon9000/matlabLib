function [ newCooridinate, newCellLength ] = adjustDensity( coordinate,cellLength,ratio )
%ADJUSTBOUNDARY Adjust the atom postions according to density change
%   [ newCooridinate, newCellLength ] = adjustDensity( cooridinate,cellLength,ratio )
resizeFactor = 1/ratio.^(1/3);
if(cellLength(1,1) == 0&&cellLength(2,1) == 0&&cellLength(2,1) == 0)
    newCellLength = resizeFactor*cellLength;
    newCooridinate = resizeFactor*coordinate;    
else
    disp('Cell not start from origin')
end
end