function [ VsolidTot, Vsurface ] =  calAtomVolFast(coordinate1, cellLength, atomElement, meshSize, atomSize)
%% calculate atomic volume of a structure
% [ vol ] =  calStructureVol(coordinate1, cellLength, atomElement)
% 
% clear
plotFlag = 0;
% [timeStep,atomNum,atomIdx,atomElement,coordinate1,force,atomCharge,cellLength] = readLammpsTrajectory9('AlO_def11.xyz',1);
% meshSize = 0.1;
% atomSize = [1.43 0.74];
atomMeshSize = round(atomSize/meshSize*1.1);

% Change negetive atom position
cellLength = cellLength(2:2:6)-cellLength(1:2:5); 
coordinate1(coordinate1(:,1) < 0,1) = coordinate1(coordinate1(:,1) < 0,1) + cellLength(1);
coordinate1(coordinate1(:,2) < 0,2) = coordinate1(coordinate1(:,2) < 0,2) + cellLength(2);
coordinate1(coordinate1(:,3) < 0,3) = coordinate1(coordinate1(:,3) < 0,3) + cellLength(3);
coordinate1(coordinate1(:,1) > cellLength(1),1) = coordinate1(coordinate1(:,1) > cellLength(1),1) - cellLength(1);
coordinate1(coordinate1(:,2) > cellLength(2),2) = coordinate1(coordinate1(:,2) > cellLength(2),2) - cellLength(2);
coordinate1(coordinate1(:,3) > cellLength(3),3) = coordinate1(coordinate1(:,3) > cellLength(3),3) - cellLength(3);

%% Generate fine mesh
gridSize = meshSize;
% gridSize = cellLength(devideDirection,1)/gridN;
gridNumber = ceil(cellLength./gridSize);
gridSize3 = cellLength./gridNumber;
densityGrid = zeros(gridNumber(1),gridNumber(2),gridNumber(3));
gridArrayX = (gridSize3(1)/2):gridSize3(1):cellLength(1);
gridArrayY = (gridSize3(2)/2):gridSize3(2):cellLength(2);
gridArrayZ = (gridSize3(3)/2):gridSize3(3):cellLength(3);
% gridArray = [gridArrayX;gridArrayY;gridArrayZ];
occupancy = zeros(length(gridArrayX),length(gridArrayY),length(gridArrayZ));
sizOcc = size(occupancy);
%% Find local meshes
for i = 1:size(coordinate1,1)
%     if(mod(i,20) == 0)
%         disp(i/size(coordinate1,1))
%     end
    CentralMeshIdx = ceil(coordinate1(i,:)./gridSize3');
    currentAtomMeshSize = atomMeshSize(atomElement(i));
    searchGrid = [(CentralMeshIdx(1)-currentAtomMeshSize):(CentralMeshIdx(1)+currentAtomMeshSize);...
                  (CentralMeshIdx(2)-currentAtomMeshSize):(CentralMeshIdx(2)+currentAtomMeshSize);...
                  (CentralMeshIdx(3)-currentAtomMeshSize):(CentralMeshIdx(3)+currentAtomMeshSize)];
    searchGrid(1,searchGrid(1,:)<1) = searchGrid(1,searchGrid(1,:)<1)+gridNumber(1);   % PBC
    searchGrid(2,searchGrid(2,:)<1) = searchGrid(2,searchGrid(2,:)<1)+gridNumber(2);
    searchGrid(3,searchGrid(3,:)<1) = searchGrid(3,searchGrid(3,:)<1)+gridNumber(3);
    searchGrid(1,searchGrid(1,:)>gridNumber(1)) = searchGrid(1,searchGrid(1,:)>gridNumber(1))-gridNumber(1);
    searchGrid(2,searchGrid(2,:)>gridNumber(2)) = searchGrid(2,searchGrid(2,:)>gridNumber(2))-gridNumber(2);
    searchGrid(3,searchGrid(3,:)>gridNumber(3)) = searchGrid(3,searchGrid(3,:)>gridNumber(3))-gridNumber(3);
    [searchX, searchY, searchZ] = meshgrid(searchGrid(1,:),searchGrid(2,:),searchGrid(3,:));
%     for j = 1:numel(searchX)
%         currentIdx = [searchX(j) searchY(j) searchZ(j)];
%         meshCoordiante = [gridArrayX(currentIdx(1)) gridArrayY(currentIdx(2)) gridArrayZ(currentIdx(3))];
    meshCoordinate = zeros(numel(searchX),3);
    meshCoordinate(:,1) = gridArrayX(searchX(:))';
    meshCoordinate(:,2) = gridArrayY(searchY(:))';
    meshCoordinate(:,3) = gridArrayZ(searchZ(:))';
    distance = AtomDistance(meshCoordinate,coordinate1(i,:),cellLength(1),cellLength(2),cellLength(3));
%     for j = 1:length(distance)
%          if(distance < atomSize(atomElement(i)))
%             occupancy(searchX(j),searchY(j),searchZ(j)) = 1;
%          end
%     end
    labelIdx = distance < atomSize(atomElement(i));
    occupancyIdx = sub2indFast(size(occupancy),searchX(labelIdx),searchY(labelIdx),searchZ(labelIdx));
%     occupancyIdx = sum(bsxfun(@times,([searchX(labelIdx),searchY(labelIdx),searchZ(labelIdx)]-1),[1, sizOcc(1), sizOcc(2)*sizOcc(1)]),2)+1;
    occupancy(occupancyIdx) = 1;
%     if(distance < atomSize(atomElement(i)))
%         occupancy(currentIdx(1),currentIdx(2),currentIdx(3)) = 1;
%     end
%     end
end

Vsmall = gridSize3(1)*gridSize3(2)*gridSize3(3);
VsolidTot = sum(sum(sum(occupancy>0)))*Vsmall;

%% Surface volume
atomThickness = sum(occupancy,3);
emptyIdx = atomThickness == 0;
[~, topIdx] = max(occupancy,[],3);
% topIdx = find(occupancy,1,3,'first');
flipOccu = flip(occupancy,3);
% flipOccu = occupancy(:,:,end:-1:1);
[~, bottomIdx] = max(flipOccu,[],3);
bottomIdx = size(occupancy,3)+1-bottomIdx;
thickness = bottomIdx-topIdx+1;
thickness(emptyIdx) = 0;
Vsurface = sum(sum(thickness))*Vsmall;


%% Disp
isoGrid = occupancy;
if(plotFlag == 1);
    disp(['Mesh size(/A): ' num2str(gridSize3')]);
%     disp(['Over all density: ' num2str(mean(densityGrid(:))) ' g/mc^3']);
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
                      cubeColor = 1;
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
%     title(['Meshes with density  $\geq$ ' num2str(isoSurface)],'interpreter','latex');
end