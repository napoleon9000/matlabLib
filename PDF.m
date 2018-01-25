function [ scale ] = PDF(coord1, coord2, cellLength, maxLength, interval, isPlot )
%RDF Calculate the RDF of structure
%   [ scale ] = PDF(coord1, coord2, cellLength, maxLength, interval, isPlot )
%   cellLength = [x, y, z];

%interval=0.02;
%maxLength=15;
selectAtom = 0;
%%
scale=0:interval:maxLength;
scale(2,:)=zeros(1,size(scale,2));

cellVol = cellLength(1)*cellLength(2)*cellLength(3);
if(selectAtom == 0)
    overallDensity = size([coord1;coord2],1)/cellVol;
else
    overallDensity = sum(atomElement == selectAtom);
end
%%
scaleSize = size(scale,2);
 for i = 1:size(coord1,1)
    for j = 1:size(coord2,1)
        R = AtomDistance( coord1(i,:), coord2(j,:), cellLength(1), cellLength(2), cellLength(3) );
        if(R > 0.02)
            scaleNum=(floor(R/interval)+1);
            if(scaleNum <= scaleSize)
                scale(2,scaleNum)=scale(2,scaleNum)+1;
            end
        end
    end
end
%%
vol = (4/3*3.1415)*((scale(1,:)+interval).^3-(scale(1,:)).^3);
scale(2,:) = scale(2,:)./(vol*overallDensity)/size([coord1;coord2],1)*2;
% for i=1:size(scale,2)
%     vol=(4/3*3.1415)*power(scale(1,i)+interval,3)-power(scale(1,i),3);
%     scale(2,i)=scale(2,i)/vol/overallDensity;
% end
if(isPlot == 1)
    figure
    plot(scale(1,:),scale(2,:));
end

end

