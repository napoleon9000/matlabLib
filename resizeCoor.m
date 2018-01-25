function [coordinates] = resizeCoor(coordinates, currentCellLength, newCellLength)
% [coordinates] = resizeCoor(coordinates, currentCellLength, newCellLength)
% Resize atomic structures with respect to the mass center 
% version 1.0

% [atomNum,atomIdx,atomElement,coordinates,cellLength,atomCharge] = readLammpsData(filename);
% currentCellLength = currentCellLength(:,2) - currentCellLength(:,1);
% newCellLength = currentCellLength(:).*[0.5 1 0.5]';
coordinates(1,:);
massCenter = mean(coordinates, 1);
% newMassCenter = newCellLength'/2;

coordinates = bsxfun(@minus, coordinates, massCenter);
ratio = newCellLength./currentCellLength;
newMassCenter = massCenter.*[ratio(1) ratio(2) 1];
coordinates = bsxfun(@times, coordinates, ratio');
coordinates = bsxfun(@plus, coordinates, newMassCenter);
% cellLength = bsxfun(@times, cellLength, ratio);
coordinates(1,:);
% writeLammpsData('Resize',atomNum,cellLength,0, coordinates, 'resize.data');
