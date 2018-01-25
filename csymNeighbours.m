region=[18 20 1 2 0 c1];
atomNumber=0;
hold on
axis equal
grid on
axis([0 a1 0 b1 0 c1]);
colorStr=['k' 'g' 'b' 'y'];
if(region==zeros(1,6))
    region=[0 a1 0 b1 0 c1];
end
if(atomNumber==0)
    for i=1:size(coordinate1,1)
        if((coordinate1(i,1)>region(1))&&(coordinate1(i,1)<region(2))&&(coordinate1(i,2)>region(3))&&(coordinate1(i,2)<region(4))&&(coordinate1(i,3)>region(5))&&(coordinate1(i,3)<region(6)))
            atomNumber=i;
        end
    end
    if(atomNumber==0)
        disp('No atom found in this region')
        region
        
    end
end

h1=scatter3(coordinate1(atomNumber,1),coordinate1(atomNumber,2),coordinate1(atomNumber,3),'filled','o');
set(h1,'MarkerFaceColor','r');
originalNumber=pickAtoms(atomNumber);
neighbourListIndex=find(neighbourList(:,1)==originalNumber);
for i=1:(size(neighbourList,2)-1)/2
    h1=scatter3(oriCoordinate(pairNeighbourList(neighbourListIndex,2*i),1),oriCoordinate(pairNeighbourList(neighbourListIndex,2*i),2),oriCoordinate(pairNeighbourList(neighbourListIndex,2*i),3),'filled','o');
    set(h1,'MarkerFaceColor',colorStr(i));
    h1=scatter3(oriCoordinate(pairNeighbourList(neighbourListIndex,2*i+1),1),oriCoordinate(pairNeighbourList(neighbourListIndex,2*i+1),2),oriCoordinate(pairNeighbourList(neighbourListIndex,2*i+1),3),'filled','o');
    set(h1,'MarkerFaceColor',colorStr(i));
end
atomNumber
concsym(atomNumber)