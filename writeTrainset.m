function [ status ] =  writeTrainset(weight, structureName, energy)
%% generate trainset.in file
% [ status ] =  writeBGF(structure, energy)

% adjust weight
if(length(weight) == 1)
    weight = weight*ones(1,length(structureName));
end

%% test if file already exist
fileContent = [];
if(exist('trainset.in','file'))
    existFile = readList('trainset.in');
    existFile(1,:) = [];
    existFile(end,:) = [];
    fileContent = char(fileContent, existFile);
else
    fileContent = char(fileContent, 'ENERGY');
end


[minEnergy,minEnergyIdx] = min(energy);
minEnergyName = structureName(minEnergyIdx,:);
energy = energy - minEnergy;
for i = 1:length(structureName)
    if(i ~= minEnergy)
        fileContent = char(fileContent, [num2str(weight(i)) ' ' structureName(i,:) ' /1 -' minEnergyName '/1 ' num2str(energy(i),'%8.2f')]);
    end
end
fileContent = char(fileContent, 'ENDENERGY');
fileContent(1,:) = [];
writeList('trainset.in', fileContent);
status = 0;
