function [ curve ] = curveSmoothAve( oriCurve, smoothRadius )
%CURVESMOOTH smooth a curve by averaging the local domain
%   [ curve ] = curveSmoothAve( oriCurve, smoothRadius )
if(any(size(oriCurve) == 1))
    oriCurveX = 1:length(oriCurve);
    oriCurveY = oriCurve;
    smoothIdxInterval = smoothRadius;
elseif(min(size(oriCurve) > 2))
    disp('Multiple input curve')
    return
else
    [~, direction] = max(size(oriCurve));
    switch direction
        case 1
            oriCurveX = oriCurve(:,1);
            oriCurveY = oriCurve(:,2);
        case 2
            oriCurveX = oriCurve(1,:);
            oriCurveY = oriCurve(2,:);
        otherwise
            disp('Input data demension is higher than 2')
            return
    end
%     [~ ,smoothIdxRight] = find(oriCurveX > smoothRadius, 1);
%     [~ ,smoothIdxLeft] = find(oriCurveX > 0, 1);
    [~, smoothIdxInterval] = find(oriCurveX > min(oriCurveX) + smoothRadius, 1);
end


addMatIdx = bsxfun(@plus, repmat(1:length(oriCurveX), smoothIdxInterval, 1), [1:smoothIdxInterval]') - round(0.5*smoothIdxInterval);
addMatIdx(addMatIdx <= 0) = 1;
addMatIdx(addMatIdx > length(oriCurveX)) = length(oriCurveX);
addMat = oriCurveY(addMatIdx);
curve = sum(addMat)/size(addMat,1);


end

