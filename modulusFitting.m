function [ currentFitPara,errorBarPara ] = modulusFitting( trueStrain,trueStress2,fitRegion )
%Fit the modulus from stress strain curve
%   [ currentFitPara,errorBarPara ] = modulusFitting( trueStrain,trueStress2,fitRegion )

allFitPara = zeros(size(fitRegion,1),2);
for k = 1:length(fitRegion)
    tempFitPara = polyfit(trueStrain(trueStrain<=fitRegion(k)),trueStress2(trueStrain<=fitRegion(k)),1);
    allFitPara(k,1) = tempFitPara(1);
    allFitPara(k,2) = tempFitPara(2);
    currentFitPara(1) = mean(allFitPara(:,1));
    currentFitPara(2) = mean(allFitPara(:,2));
end
%fitPara = currentFitPara(1);
errorBarPara = 0.5*(max(allFitPara(:,1))-min(allFitPara(:,1)));


end

