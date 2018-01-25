function [surfaceCoor, surfaceSizeCorrect] = buildFCC111(surfaceSize, cellLength)
%% build 1 layer of atoms of FCC (111)
% [surfaceCoor, surfaceSizeCorrect] = buildFCC111(surfaceSize, cellLength)

% parameters
% surfaceSize = [130 30];
% cellLength = 3.524;
plotFlag = 0;

% inital
xUnitLength = sqrt(2)/2*cellLength;
yUnitLength = sqrt(6)/2*cellLength;

numRepeat = round(surfaceSize./[xUnitLength yUnitLength]);
surfaceSizeCorrect = numRepeat.*[xUnitLength yUnitLength];
priCellCoor = [0 0; 0 yUnitLength; 0.5*xUnitLength 0.5*yUnitLength]; 
[xRepeat, yRepeat] = meshgrid(1:numRepeat(1), 1:numRepeat(2));
xRepeatLength = (xRepeat - 1)*xUnitLength;
yRepeatLength = (yRepeat - 1)*yUnitLength;

surfaceCoor = zeros(size(priCellCoor,1)*length(xRepeat(:)),2);
for i = 1:size(priCellCoor,1)
    startIdx = (i-1)*length(xRepeat(:))+1;
    endIdx = i*length(xRepeat(:));
    surfaceCoor(startIdx:endIdx,:) = bsxfun(@plus,[xRepeatLength(:) yRepeatLength(:)],priCellCoor(i,:));
end
if(plotFlag)
    figure
    plot(surfaceCoor(:,1),surfaceCoor(:,2),'.')
    axis equal
    box on
    axis([0 surfaceSizeCorrect(1) 0 surfaceSizeCorrect(2)])
end