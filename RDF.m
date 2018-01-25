function [ scale ] = RDF( maxLength, interval, isPlot, filename, coord, cellLength )
%RDF Calculate the RDF of structure
%   [ scale ] = RDF( maxLength, interval, isPlot, filename)
%   [ scale ] = RDF( maxLength, interval, isPlot, [], coord, cellLength )
%   filename can be .data or .xyz file

%interval=0.02;
%maxLength=15;
selectAtom=0;       %1 means 1 to 1, 2 means 2 to 2, 0 means 1 to 2
% filename = 'T1300_KH_test.data';
% filename = 'T1300_KH.data';
%filename = '1.data';
if(nargin <= 4)
    if(strcmp(filename((end-4):end),'data'))
        [atomNum,atomIdx,atomElement,Coordinates,cellLength,atomCharge] = readLammpsData(filename);
        coord=[atomElement Coordinates];
        cellLength = cellLength(:,2)-cellLength(:,1);
    elseif(strcmp(filename((end-4):end),'.xyz'))
        [timeStep,atomNum,atomIdx,atomElement,Coordinates,atomCharge,cellLength] = readLammpsTrajectory(filename,readRange);
        coord=[atomElement(:,end) Coordinates(:,:,end)];
        cellLength = cellLength(:,2,end)-cellLength(:,1,end);
    end
end
%%
scale=0:interval:maxLength;
scale(2,:)=zeros(1,size(scale,2));

cellVol = cellLength(1)*cellLength(2)*cellLength(3);
if(selectAtom == 0)
    overallDensity = size(coord,1)/cellVol;
else
    overallDensity = sum(atomElement == selectAtom);
end
%%
scaleSize = size(scale,2);
 for i=1:size(coord,1)
%for i=1
    for j=(i+1):size(coord,1)
        if (coord(i,1)==selectAtom&&i~=j)||selectAtom==0
            R = AtomDistance( coord(i,2:end), coord(j,2:end), cellLength(1), cellLength(2), cellLength(3) );
            scaleNum=(floor(R/interval)+1);
            if(scaleNum <= scaleSize)
%                 while(scaleNum(end) <=scaleSize)
%                     scaleNum = [scaleNum scaleNum(end)+scaleNum(1)];
%                 end
%                 scaleNum(end) = [];
                scale(2,scaleNum)=scale(2,scaleNum)+1;
            end
        end
    end
end
%%
vol = (4/3*3.1415)*((scale(1,:)+interval).^3-(scale(1,:)).^3);
scale(2,:) = scale(2,:)./(vol*overallDensity)/size(coord,1)*2;
% for i=1:size(scale,2)
%     vol=(4/3*3.1415)*power(scale(1,i)+interval,3)-power(scale(1,i),3);
%     scale(2,i)=scale(2,i)/vol/overallDensity;
% end
if(isPlot == 1)
    plot(scale(1,:),scale(2,:));
end

end

