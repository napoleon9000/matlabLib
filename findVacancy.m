function[vacancyRateAll,vacancySizeAll] = findVacancy(coordinate,cellLength,range)
% Calculate the vacancy in system
% [vacancyRateAll,vacancySizeAll] = findVacancy(coordinate,cellLength,range)

% clear
% filename = 'Al_liquid800K12.5ps.vasp';
% %filename = 'Al_liquid.700K12.5ps.vasp';
% [ commentLine,scallingFactor,cellLength,elementName,atomNum, coordinate ] = readPOSCAR( filename );
%%
%range = 10:40;
vacancySizeAll =zeros(size(range));
vacancyRateAll = vacancySizeAll;
for j=1:size(range,2)
    
    resolution = range(j);
    cubicSize = sum(cellLength,1)/resolution;
    count = zeros(resolution,resolution,resolution);
    atomRegion = bsxfun(@rdivide,coordinate,cubicSize);
    atomRegion(atomRegion(:)==0)=atomRegion(atomRegion(:)==0)+0.01;
    atomRegion(atomRegion(:)>resolution)=atomRegion(atomRegion(:)>resolution)-0.01;
    atomIdx = ceil(atomRegion);
    for i = 1:size(atomIdx,1)
        count(atomIdx(i,1),atomIdx(i,2),atomIdx(i,3)) = count(atomIdx(i,1),atomIdx(i,2),atomIdx(i,3))+1;
    end
%     count(:)=count(:)-size(coordinate,1)/(resolution.^3);

%     disp(['max number of atoms in one cubic:' num2str(max(count(:)))]);
    [meshX,meshY,meshZ] = meshgrid(1:resolution,1:resolution,1:resolution);
    meshX1 = reshape(meshX,resolution.^3,1);
    meshY1 = reshape(meshY,resolution.^3,1);
    meshZ1 = reshape(meshZ,resolution.^3,1);
    count1 = reshape(count,resolution.^3,1);
    zeroIdx = find(count1==0);

    scatter3(meshX1(zeroIdx),meshY1(zeroIdx),meshZ1(zeroIdx) ...
        ,(cubicSize(1).^0.9)*50,count1(zeroIdx),'filled');
    vacancyRate = sum(count(:)==0)/resolution.^3;
%     disp(['Vacancy size:' num2str(cubicSize)]);
%     disp(['Vacancy rate:' num2str(vacancyRate)]);
    %colorbar
    vacancySizeAll(j) = sum(cubicSize)/3;
    vacancyRateAll(j) = vacancyRate;
end
% plot(vacancySizeAll,vacancyRateAll)