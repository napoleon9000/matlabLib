function plotMDSSCurve(filename, style)
zeroInitial = 1;
plotFig = 2;  % 1:plot All 2: plot xx only
maxPlotStrain = 4;
% Read data
[ trueStrain, trueStress, tensileAxis ] = ReadStressStrainCurve( filename );
stress = trueStress;
strain = trueStrain;
% set intial point to 0
if(zeroInitial == 1)
    stress = bsxfun(@minus,stress,stress(:,1));
end
% get stiffness tensor
% C = StiffTensor( parameters );
% calculate stress from parameter
% calStress = C*strain;
% plot data
if(plotFig == 1)
    figure
    hold on
    box on
    grid on
    tensileStrain = strain(tensileAxis,:);
    plotIdx = tensileStrain<maxPlotStrain;
    for i = 1:size(strain,1)
        plot(strain(tensileAxis,plotIdx),stress(i,plotIdx),style);
%        plot(strain(tensileAxis,:),calStress(i,:),'-');
    end
    legend('XX','YY','ZZ','YZ','XZ','XY','Location','NorthEast');
    title(filename,'Interpreter', 'none');
end
if(plotFig == 2)
    hold on
    box on
    grid on
    tensileStrain = strain(tensileAxis,:);
    plotIdx = tensileStrain<maxPlotStrain;
    plot(strain(tensileAxis,plotIdx),stress(1,plotIdx),style);
%        plot(strain(tensileAxis,:),calStress(i,:),'-');
    %legend('XX','YY','ZZ','YZ','XZ','XY','Location','NorthEast');
    title(filename,'Interpreter', 'none');
end
% calculate difference
% diff = abs(calStress-stress);
% diff = sum(diff(:));


end