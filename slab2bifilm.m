%% Build bifilm from slab structure
% 20170214
%

clear;clc
filename = 'F:\bifilm\OH_terminate\relaxSlab\50\fa-al-HT-half-p0-half-RT-addOH50-50ps.data';
outputFilename = 'fa-al-HT-half-p0-half-RT-addOH50-50ps-bifilmR.data';
gap = 2;
rotate = 1;


%% read structure
[atomNum,atomIdx,atomElement,coordinates,cellLength,atomCharge] = readLammpsData(filename);

%% flip
coordinates2 = coordinates;
maxZ = max(coordinates(:,3));
minZ = min(coordinates(:,3));
zLength = maxZ - minZ;
coordinates2(:,3) = 2*maxZ + gap - coordinates2(:,3);
if(rotate)
    coordinates2(:,1) = cellLength(1,2) - coordinates2(:,1);
    coordinates2(:,2) = cellLength(2,2) - coordinates2(:,2);
    
end



%% write data file
writeLammpsDataDirect('', atomNum*2, 3, [atomElement;atomElement], cellLength, 0, [coordinates;coordinates2], outputFilename);
