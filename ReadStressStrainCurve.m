function [ trueStrain, trueStress, tensileAxis ] = ReadStressStrainCurve( filename )
%READSTRESSSTRAINCURVE Read Stress - Strain curve from file
%  [ trueStrain, trueStress, tensileAxis ] = ReadStressStrainCurve( filename )

plotFlag = 1;
plotRawData = 0;
maxStrain = 0;   % 0:all data
averageMethod = 2; % 1:last frame  2: Average in a range
averageRange = 1;

try
    strData = readList(filename);
catch
    disp('Can not read data file');
end
% Convert to number
numData = str2num(strData(2:end,:));
% Read Strain
strainZ = (numData(:,11)-numData(1,11))/numData(1,11);
strainX = (numData(:,9)-numData(1,9))/numData(1,9);
strainY = (numData(:,10)-numData(1,10))/numData(1,10);
strain = [strainX';strainY';strainZ';zeros(3,length(numData))];
% Read stress
stressXX = numData(:,2);
stressYY = numData(:,3);
stressZZ = numData(:,4);
stressYZ = numData(:,5);
stressXZ = numData(:,6);
stressXY = numData(:,7);
stress = [stressXX';stressYY';stressZZ';stressYZ';stressXZ';stressXY'];

tensileAxis = find(strain(:,end) == max(strain(:,end)));

% plot raw data
if(plotRawData == 1)
    figure
    plot(strain(tensileAxis,:),stress(1,:),...
        strain(tensileAxis,:),stress(2,:),...
        strain(tensileAxis,:),stress(3,:),...
        strain(tensileAxis,:),stress(4,:),...
        strain(tensileAxis,:),stress(5,:),...
        strain(tensileAxis,:),stress(6,:))
    legend('xx','yy','zz','yz','xz','xy');
end

% calculate real strain (compress)
dStrain = diff(strain,1,2);
segement = find(abs(dStrain(tensileAxis,:))>0);
segement = [1 segement(1:end-1)+1];
trueStrain = zeros(6,length(segement));
trueStress = trueStrain;
trueStrain(tensileAxis,:) = strain(tensileAxis,segement);

% calculate real stress in different methods
switch(averageMethod)
    case 1
        trueStress = stress(:,segement(2:end)-1);
    case 2
        stress = [stress(:,1) stress(:,1:(end-1))];
        nEqStep = segement(end)-segement(end-1);
        for i = 1:size(strain,1)
            currentStress = reshape(stress(i,:),[nEqStep,length(stress)/nEqStep]);
            if(averageRange ~= 1)
                deleteFrame = round(nEqStep*(1-averageRange));
                currentStress(1:deleteFrame,:) = [];
            end
            trueStress(i,:) = mean(currentStress,1);
        end        
    otherwise
        disp('Wrong average method!');
end

% delete data in extra range
if(maxStrain ~=0)
    trueStress(:,trueStrain(tensileAxis,:) > maxStrain) = [];
    trueStrain(:,trueStrain(tensileAxis,:) > maxStrain) = [];
end
% plot the result
if(plotFlag == 1)
    figure
    hold on
    for i = 1:size(strain,1)
        plot(trueStrain(tensileAxis,:),trueStress(i,:),'*-');
    end
    legend('xx','yy','zz','yz','xz','xy');
end
end

