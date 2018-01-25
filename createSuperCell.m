function [ position, a1, b1, c1, atom1, atom2, atom3 ] = createSuperCell( filename, dimension ,position)
%CREATESUPERCELL Create a super cell
%   Detailed explanation goes here

    positionOverride=position;
    [ position,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename);
    if(~isempty(positionOverride))
        position=positionOverride;
        a1=0;
        b1=0;
        c1=0;
    end
    dupilicateNumber=(2*dimension+1)^3;
    p1=-dimension:dimension;
    shiftMatrix=[];
    for i=p1;
        for j=p1;
            for k=p1;
                shiftMatrix=[shiftMatrix;i,j,k];
            end
        end
    end

    atomNumber=atom1+atom2+atom3;
    supercellPosition=zeros(size(position,1)*dupilicateNumber,size(position,2));
    for i=1:dupilicateNumber;
        supercellPosition((i-1)*atomNumber+1:i*atomNumber,:)=position+ones(size(position,1),1)*[a1,b1,c1].*(ones(size(position,1),1)*shiftMatrix(i,:));
    end
    superAtom1=atom1*dupilicateNumber;
    superAtom2=atom2*dupilicateNumber;
    superAtom3=atom3*dupilicateNumber;
    sortedCell=zeros(size(supercellPosition));
    for i=1:dupilicateNumber;
        sortedCell(((i-1)*atom1+1):(i*atom1),:)=supercellPosition(((i-1)*(atomNumber)+1):((i-1)*(atomNumber)+atom1),:);
        sortedCell((superAtom1+(i-1)*atom2+1):(superAtom1+i*atom2),:)=supercellPosition(((i-1)*(atomNumber)+atom1+1):((i-1)*(atomNumber)+atom1+atom2),:);
        sortedCell((superAtom1+superAtom2+(i-1)*atom3+1):(superAtom1+superAtom2+i*atom3),:)=supercellPosition(((i-1)*(atomNumber)+atom1+atom2+1):((i-1)*(atomNumber)+atom1+atom2+atom3),:);
    end
    position=sortedCell;
    a1=a1*(2*dimension+1);
    b1=b1*(2*dimension+1);
    c1=c1*(2*dimension+1);
    atom1=superAtom1;
    atom2=superAtom2;
    atom3=superAtom3;