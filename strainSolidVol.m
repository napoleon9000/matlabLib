function [ trueStrain, trueStress, meanSolidVol, correctStress, meanTotVol,meanSurfaceVol ] = strainSolidVol(filename1, filename2, readRange, meshSize, atomSize )

[solidVol, totVol, Vsurface] = calTrajectoryAtomVol(filename2,readRange,meshSize,atomSize);
[ trueStrain, trueStress, tensileAxis ] = ReadStressStrainCurve( filename1 );


meanSolidVol = zeros(1,length(trueStress));
meanTotVol = meanSolidVol;
meanSurfaceVol = meanSolidVol;
for i = 1:length(trueStress)
    idx = (i-1)*10+1;
    if((idx+9)<=length(solidVol))
        meanSolidVol(i) = mean(solidVol(idx:idx+9));
        meanTotVol(i) = mean(totVol(idx:idx+9));
        meanSurfaceVol(i) = mean(Vsurface(idx:idx+9));
    else
        meanSolidVol(i) = mean(solidVol(idx:end));
        meanTotVol(i) = mean(totVol(idx:end));
        meanSurfaceVol(i) = mean(Vsurface(idx:end));
    end
end
%%
% figure
% plot(trueStrain,meanSolidVol)
% title('Solid volume');
% 
% %%
% figure
% plot(trueStrain,meanTotVol)
% title('Total volume');
% save('vol.mat','solidVol', 'totVol');

%%
correctStress = bsxfun(@rdivide,trueStress,meanSolidVol./meanTotVol);
rangeIdx = (trueStrain(tensileAxis,:) > range(1)) .* (trueStrain(tensileAxis,:) < range(2));
meanFlowStress = mean(trueStress(:,logical(rangeIdx)),2);
% save('results.mat');
% figure
% plot(trueStrain, correctStress(1,:));
% title('Corrected stress');
% save('alphaBulkSS.mat','trueStrain','correctStress');
% finishNotice(1);

%%
% figure
% grid on
% plotyy(trueStrain, trueStress(1,:),trueStrain,meanSolidVol)
% title('Stress(Left) and true solid volume(Right) of alpha at RT');


end

