function [ vol ] =  calStructureVol(coordinate1, cellLength, atomElement, meshSize)
%% calculate true volume of a structure
% [ vol ] =  calStructureVol(coordinate1, cellLength, atomElement)
% 
plotFlag = 0;


% Set mesh grid size
% filename = 'AlO1.5_Kim_4000K_50ps_test_d2.612.data';
% filename = 'T1650p300_kim-Oxd-traj_AlO.data';
% frame = 0;


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
coordinate1(coordinate1 <= 0) = abs(coordinate1(coordinate1 <= 0))+0.01;
coordinate1(coordinate1(:,1) > cellLength(1),1) = cellLength(1)-0.01;
coordinate1(coordinate1(:,2) > cellLength(2),2) = cellLength(2)-0.01;
coordinate1(coordinate1(:,3) > cellLength(3),3) = cellLength(3)-0.01;
%%
% Generate mesh
% gridN = 40;
% devideDirection = 1;
isoSurface = 0.01;  
gridSize = meshSize;
% gridSize = cellLength(devideDirection,1)/gridN;
gridNumber = ceil(cellLength./gridSize);
gridSize3 = cellLength./gridNumber;
densityGrid = zeros(gridNumber(1),gridNumber(2),gridNumber(3));
gridPosition = ceil(bsxfun(@rdivide,coordinate1,gridSize3'));
%%
% Count atoms
atomIdx1 = (atomElement == 1);
atomIdx2 = (atomElement == 2);
for i = 1:size(gridPosition,1)
    currentIdx = sub2ind(size(densityGrid),gridPosition(i,1),gridPosition(i,2),gridPosition(i,3));
    densityGrid(currentIdx) =  densityGrid(currentIdx) + 1;
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
maxDensity = max(densityGrid(:));
totV = sum(sum(sum(densityGrid>0)))*V;
vol = totV;
%% Generate isosurface
isoGrid = densityGrid;
isoGrid(densityGrid >= isoSurface) = 1;
isoGrid(densityGrid < isoSurface) = -1;



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