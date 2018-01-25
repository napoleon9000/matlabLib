filename='POSCAR00';
[ commentLine,scallingFactor,cellLength,elementName,atomNum, coordinate1 ] = readPOSCAR( filename );
slippingPlane=[0.49 0 0];
burgersVector=[0 2.08 0];
slippingPlane=slippingPlane.*[norm(cellLength(1,:)) norm(cellLength(2,:)) norm(cellLength(3,:))];
for i=1:size(coordinate1,1)
    if(coordinate1(i,1)>slippingPlane(1)&&coordinate1(i,2)>slippingPlane(2)&&coordinate1(i,3)>slippingPlane(3))
        coordinate1(i,:)=coordinate1(i,:)+burgersVector;
        %disp('move');
    end
end
filenameOut='POSCAR01';
writePOSCAR(filenameOut,commentLine,scallingFactor,cellLength,elementName,atomNum, coordinate1 );