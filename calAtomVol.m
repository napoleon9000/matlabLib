% function [ vol ] =  calAtomVol(coordinate1, cellLength, atomElement, meshSize, atomSize)
%% calculate true volume of a structure
% [ vol ] =  calStructureVol(coordinate1, cellLength, atomElement)
% 
clear
plotFlag = 0;
[timeStep,atomNum,atomIdx,atomElement,coordinate1,force,atomCharge,cellLength] = readLammpsTrajectory9('AlO_def111.xyz',1);
meshSize = 0.1;
atomSize = [1.43 0.74];
largeMeshSize = 3*max(atomSize);
initSearchListLength = 5;


% Read structure
% if(strcmp(filename(end-3:end),'.xyz'))
%     if(frame == 0)
%         readRange = 0;
%     else
%         readRange = 1:frame;
%     end
%     [timeStep,atomNum,atomIdx,atomElement,Coordinates,atomCharge,cellLength] = readLammpsTrajectory(filename,readRange);
%     coordinate1 = Coordinates(:,1:3,end);
%     atomElement = atomElement(:,end);
% elseif(strcmp(filename(end-3:end),'data'))
%      [atomNum,atomIdx,atomElement,Coordinates,cellLength,atomCharge] = readLammpsData(filename);
%     coordinate1 = Coordinates;
% end
%%

% Change negetive atom position
cellLength = cellLength(2:2:6)-cellLength(1:2:5); 
coordinate1(coordinate1(:,1) < 0,1) = coordinate1(coordinate1(:,1) < 0,1) + cellLength(1);
coordinate1(coordinate1(:,2) < 0,2) = coordinate1(coordinate1(:,2) < 0,2) + cellLength(2);
coordinate1(coordinate1(:,3) < 0,3) = coordinate1(coordinate1(:,3) < 0,3) + cellLength(3);
coordinate1(coordinate1(:,1) > cellLength(1),1) = coordinate1(coordinate1(:,1) > cellLength(1),1) - cellLength(1);
coordinate1(coordinate1(:,2) > cellLength(2),2) = coordinate1(coordinate1(:,2) > cellLength(2),2) - cellLength(2);
coordinate1(coordinate1(:,3) > cellLength(3),3) = coordinate1(coordinate1(:,3) > cellLength(3),3) - cellLength(3);
%%
% Generate mesh for neighbour list
isoSurface = 0.01;  
gridSize = largeMeshSize;
% gridSize = cellLength(devideDirection,1)/gridN;
gridNumber = ceil(cellLength./gridSize);
gridSize3 = cellLength./gridNumber;
densityGrid = zeros(gridNumber(1),gridNumber(2),gridNumber(3));
gridPosition = ceil(bsxfun(@rdivide,coordinate1,gridSize3'));
largeGridSize3 = gridSize3;
largeGridNumber = gridNumber;
%%
% Generate neighbour list
neighbourList = zeros(gridNumber(1),gridNumber(2),gridNumber(3),round(2*length(coordinate1)/(gridNumber(1)*gridNumber(2)*gridNumber(3))));
neighbourListPointer = ones(gridNumber(1),gridNumber(2),gridNumber(3));
atomIdx1 = (atomElement == 1);
atomIdx2 = (atomElement == 2);
for i = 1:size(gridPosition,1)
    currentIdx = sub2ind(size(densityGrid),gridPosition(i,1),gridPosition(i,2),gridPosition(i,3));
    densityGrid(currentIdx) =  densityGrid(currentIdx) + 1;
    pointer = neighbourListPointer(gridPosition(i,1),gridPosition(i,2),gridPosition(i,3));
    pointer = pointer + 1;
    neighbourListPointer(gridPosition(i,1),gridPosition(i,2),gridPosition(i,3)) = pointer;
    neighbourList(gridPosition(i,1),gridPosition(i,2),gridPosition(i,3),pointer-1) = i;
%     neighbourList(gridPosition(i,1),gridPosition(i,2),gridPosition(i,3),pointer)
%     disp(1);
end
% densityGrid(sub2ind(size(densityGrid),gridPosition(atomIdx1,1),gridPosition(atomIdx1,2),gridPosition(atomIdx1,3))) =...
%     densityGrid(sub2ind(size(densityGrid),gridPosition(atomIdx1,1),gridPosition(atomIdx1,2),gridPosition(atomIdx1,3)))+ atomMass(1);
% densityGrid(sub2ind(size(densityGrid),gridPosition(atomIdx2,1),gridPosition(atomIdx2,2),gridPosition(atomIdx2,3))) =...
%     densityGrid(sub2ind(size(densityGrid),gridPosition(atomIdx2,1),gridPosition(atomIdx2,2),gridPosition(atomIdx2,3)))+ atomMass(2);
% 
%%
% Convert to density
V = gridSize3(1)*gridSize3(2)*gridSize3(3);
densityGrid = densityGrid/6.023/V*10;

%% Generate isosurface
isoGrid = densityGrid;
isoGrid(densityGrid >= isoSurface) = 1;
isoGrid(densityGrid < isoSurface) = -1;

%% Generate fine mesh
gridSize = meshSize;
% gridSize = cellLength(devideDirection,1)/gridN;
gridNumber = ceil(cellLength./gridSize);
gridSize3 = cellLength./gridNumber;
densityGrid = zeros(gridNumber(1),gridNumber(2),gridNumber(3));
gridArrayX = (gridSize3(1)/2):gridSize3(1):cellLength(1);
gridArrayY = (gridSize3(2)/2):gridSize3(2):cellLength(2);
gridArrayZ = (gridSize3(3)/2):gridSize3(3):cellLength(3);
[xv, yv, zv] = meshgrid(gridArrayX,gridArrayY,gridArrayZ);
occupancy = zeros(size(xv));
neighbourListSize = size(neighbourList,4);
for i = 1:numel(xv)
    %%
    currentMeshPos = [xv(i) yv(i) zv(i)];
    largeMeshIdx = ceil(currentMeshPos./largeGridSize3');
    searchGrid = [largeMeshIdx-1;largeMeshIdx;largeMeshIdx+1];
    % Build the search region
    [searchX, searchY, searchZ] = meshgrid(searchGrid(:,1),searchGrid(:,2),searchGrid(:,3));
    searchX(searchX == 0) = largeGridNumber(1);   % PBC
    searchY(searchY == 0) = largeGridNumber(2);
    searchZ(searchZ == 0) = largeGridNumber(3);
    searchX(searchX > largeGridNumber(1)) = 1;
    searchY(searchY > largeGridNumber(2)) = 1;
    searchZ(searchZ > largeGridNumber(3)) = 1;
%     largeMeshIdx
%     searchX
%     searchY
%     searchZ
    % Bulid search list
    %%
    searchList = zeros(initSearchListLength,1);    
    pointer = 1;
    for j = 1:numel(searchX);                
%         [searchX(j),searchY(j),searchZ(j)]
%         squeeze(neighbourList(searchX(j),searchY(j),searchZ(j),:))
%         newNeighbour = squeeze(neighbourList(searchX(j),searchY(j),searchZ(j),:));
          newNeighbour = (neighbourList(searchX(j),searchY(j),searchZ(j),:));
          newNeighbour = reshape(newNeighbour,1,neighbourListSize);
%         newNeighbour(newNeighbour == 0) = [];
%         if(~isempty(newNeighbour))
        if(sum(newNeighbour == 0) ~= length(newNeighbour))
            searchList(pointer:(pointer+length(newNeighbour))) = newNeighbour;
        end
%         length(newNeighbour)
        pointer = pointer + length(newNeighbour);
%         disp(1)
    end
    searchList(searchList == 0) = []; 
    %%
    if(~isempty(searchList))
%         coordinate1(searchList,:)
%         currentMeshPos
        currentElement = atomElement(searchList);
        distance = AtomDistance(coordinate1(searchList,:), currentMeshPos,cellLength(1),cellLength(2),cellLength(3));
        coordinate1(searchList,:);
        currentMeshPos;
        atomDistanceBound = atomSize(currentElement)';
        compare = distance - atomDistanceBound;
        if(sum(compare<0) > 0)
            occupancy(i) = 1;
%             distance
        end
    end
end
Vsmall = gridSize3(1)*gridSize3(2)*gridSize3(3);
Vtot = sum(sum(sum(occupancy>0)))*Vsmall


%% Disp
if(plotFlag == 1);
    disp(['Mesh size(/A): ' num2str(gridSize3')]);
    disp(['Over all density: ' num2str(mean(densityGrid(:))) ' g/mc^3']);
    % figure
    % hist(densityGrid(:),50);
    %[xm,ym,zm] = meshgrid(X,Y,Z);
    figure
    hold on
    view(3)
    box on
    grid on
    axis equal
    X = [];
    Y = [];
    Z = [];
    for i = 1:size(isoGrid,1)
        for j = 1: size(isoGrid,2)
            for k = 1: size(isoGrid,3)
                if(isoGrid(i,j,k) == 1)
    %                 X = [X;(i-0.5)*gridSize3(1)];
    %                 Y = [Y;(j-0.5)*gridSize3(2)];
    %                 Z = [Z;(k-0.5)*gridSize3(3)];
                      %cubeColor = (densityGrid(i,j,k)-isoSurface)/(maxDensity-isoSurface);
                      cubeColor = densityGrid(i,j,k);
                      drawCube(gridSize3'.*([i j k]),gridSize3,cubeColor)
                end
            end
        end
    end

    % plot3(X(:),Y(:),Z(:),'.','Size')
    %mesh(xm,ym,zm)
    % scatter3(zm(:),xm(:),ym(:),100,densityGrid(:),'filled');
    H = colorbar;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    title(['Meshes with density  $\geq$ ' num2str(isoSurface)],'interpreter','latex');
end